//
//  BluetoothNotificationListener.m
//  MacDroidNotifier
//
//  Copyright 2010 Rodrigo Damazio <rodrigo@damazio.org>
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//  1. Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BluetoothNotificationListener.h"
#import "Preferences.h"

#import <IOBluetooth/objc/IOBluetoothDevice.h>

@interface BluetoothNotificationListener (Private)

- (void)rfcommChannelData:(IOBluetoothRFCOMMChannel*)channel
                     data:(void *)dataPointer
                   length:(size_t)dataLength;
- (void)rfcommChannelClosed:(IOBluetoothRFCOMMChannel*)channel;
- (void)newRFCOMMChannelOpened:(IOBluetoothUserNotification *)inNotification
                       channel:(IOBluetoothRFCOMMChannel *)newChannel;
- (void)publishService;
- (void)unpublishService;
- (NSString *)localDeviceName;

@end

@implementation BluetoothNotificationListener

- (id)init {
  if (self = [super init]) {
    openChannels = [[NSMutableSet setWithCapacity:5] retain];
  }
  return self;
}

- (void)dealloc {
  [openChannels release];
  [super dealloc];
}

- (void)startWithCallback:(NSObject<NotificationListenerCallback> *)callbackParam {
  [openChannels removeAllObjects];
  callback = callbackParam;

  [self publishService];
}

- (void)stop {
  [self unpublishService];

  @synchronized (openChannels) {
    for (IOBluetoothRFCOMMChannel *channel in openChannels) {
      // Close the channel
      [channel closeChannel];

      // And closes the connection with the device
      [[channel getDevice] closeConnection];
    }

    [openChannels removeAllObjects];
  }
}

- (void)rfcommChannelData:(IOBluetoothRFCOMMChannel*)channel
                     data:(void *)dataPointer
                   length:(size_t)dataLength {
	NSData *data = [NSData dataWithBytes:dataPointer length:dataLength];
  // TODO: Don't even listen for rfcomm if disabled
  if ([[NSUserDefaults standardUserDefaults] boolForKey:kPreferencesListenBluetoothKey]) {
    [callback handleRawNotification:data];
  }
}

- (void)rfcommChannelClosed:(IOBluetoothRFCOMMChannel*)channel {
  @synchronized (openChannels) {
    [openChannels removeObject:channel];
  }
}

- (void) newRFCOMMChannelOpened:(IOBluetoothUserNotification *)inNotification
                        channel:(IOBluetoothRFCOMMChannel *)newChannel {
  // Make sure the channel is an incoming channel on the right channel ID.
  // This isn't strictly necessary since we only registered a notification for this case,
  // but it can't hurt to double-check.
  if (newChannel != nil && [newChannel isIncoming] && [newChannel getChannelID] == serverChannelID) {
    @synchronized (openChannels) {
      // Set self as the channel's delegate: THIS IS THE VERY FIRST THING TO DO FOR A SERVER !!!!
      if ([newChannel setDelegate:self] == kIOReturnSuccess) {
        [openChannels addObject:newChannel];
      }
    }
  }
}

- (void)publishService {
  // Builds a string with the service name we wish to offer
  NSString *serviceName = [NSString stringWithFormat:@"%@ AndroidNotifierService", [self localDeviceName]];

  // Get the path for the dictonary we wish to publish.
  NSString *dictionaryPath = [[NSBundle mainBundle] pathForResource:@"BluetoothService" ofType:@"plist"];

  if (dictionaryPath != nil && serviceName != nil) {
    // Loads the dictionary from the path:
    NSMutableDictionary	*sdpEntries = [NSMutableDictionary dictionaryWithContentsOfFile:dictionaryPath];

    if (sdpEntries != nil) {
      IOBluetoothSDPServiceRecordRef serviceRecordRef;

      [sdpEntries setObject:serviceName forKey:@"0100 - ServiceName*"];

      // Add SDP dictionary, the rfcomm channel assigned to this service comes back in mServerChannelID.
      // While mServerHandle is going to be the record handle assigned to this service.
      if (IOBluetoothAddServiceDict((CFDictionaryRef) sdpEntries, &serviceRecordRef) == kIOReturnSuccess) {
        IOBluetoothSDPServiceRecord *serviceRecord =
            [IOBluetoothSDPServiceRecord withSDPServiceRecordRef:serviceRecordRef];

        [serviceRecord getRFCOMMChannelID:&serverChannelID];
        [serviceRecord getServiceRecordHandle:&serverHandle];

				IOBluetoothObjectRelease(serviceRecordRef);

        // Register a notification so we get notified when an incoming RFCOMM channel is opened
				// to the channel assigned to our chat service.
        incomingChannelNotification = [IOBluetoothRFCOMMChannel
            registerForChannelOpenNotifications:self
                                       selector:@selector(newRFCOMMChannelOpened:channel:)
                                  withChannelID:serverChannelID
                                      direction:kIOBluetoothUserNotificationChannelDirectionIncoming];

        NSLog(@"Started listening for Bluetooth notifications");
      } else {
        NSLog(@"Couldn't register bluetooth service dictionary");
      }
    }
  }
}

- (void)unpublishService {
  if (serverHandle != 0){
    // Removes the service:
    IOBluetoothRemoveServiceWithRecordHandle(serverHandle);
  }

  // Unregisters the notification:
  if (incomingChannelNotification != nil) {
    [incomingChannelNotification unregister];
		incomingChannelNotification = nil;
	}

	serverChannelID = 0;

  NSLog(@"No longer listening on Bluetooth");
}

// Returns the name of the local bluetooth device
- (NSString *)localDeviceName {
  BluetoothDeviceName localDeviceName;
  if (IOBluetoothLocalDeviceReadName(localDeviceName, NULL, NULL, NULL) == kIOReturnSuccess) {
    return [NSString stringWithUTF8String:(const char*)localDeviceName];
  }

  return nil;
}

@end
