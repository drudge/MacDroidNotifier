//
//  BluetoothCommandSender.m
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

#import "BluetoothCommandSender.h"
#import "Commands.pb.h"
#import <IOBluetooth/IOBluetooth.h>

// Our UUID: E8D515B4-47C1-4813-B6D6-3EAB32F8953E
static const char kCommandUuidBytes[] = {
    0xE8, 0xD5, 0x15, 0xB4, 0x47, 0xC1, 0x48, 0x13,
    0xB6, 0xD6, 0x3E, 0xAB, 0x32, 0xF8, 0x95, 0x3E };
static const int kCommandUuidSize = 16;

@interface BluetoothCommandSender (Private)
- (IOBluetoothSDPServiceRecord *)findRemoteServiceInDevice:(IOBluetoothDevice*) device;
- (BOOL)openChannelToService:(IOBluetoothSDPServiceRecord*)service
                    onDevice:(IOBluetoothDevice*)device;
- (void)sendPendingCommandsToAddress:(BluetoothDeviceAddress)address;
@end

@implementation BluetoothCommandSender

- (id)init {
  if (self = [super init]) {
    pendingCommandMap = [[NSMutableDictionary dictionaryWithCapacity:5] retain];
  }
  return self;
}

- (void)dealloc {
  [pendingCommandMap release];
  [super dealloc];
}

- (BOOL)isEnabled {
  // TODO: From preferences
  return YES;
}

- (void)sendCommandData:(NSData *)cmd toAddresses:(DeviceAddresses *)addresses {
  // Get the bluetooth address in the proper format
  NSData *btMac = [addresses bluetoothMac];
  if ([btMac length] != 6) {
    NSLog(@"Bad bluetooth address: %@", btMac);
    return;
  }
  BluetoothDeviceAddress btAddress;
  memcpy(btAddress.data, [btMac bytes], 6);

  // Enqueue the command
  @synchronized (pendingCommandMap) {
    NSMutableArray *pendingCommands =
        [pendingCommandMap objectForKey:btMac];
    if (!pendingCommands) {
      pendingCommands = [NSMutableArray array];
      [pendingCommandMap setObject:pendingCommands forKey:btMac];
    }
    [pendingCommands addObject:cmd];
  }

  [self sendPendingCommandsToAddress:btAddress];
}

- (void)sendPendingCommandsToAddress:(BluetoothDeviceAddress)address {
  // Find the device to send to
  IOBluetoothDevice* device = [IOBluetoothDevice withAddress:&address];
  if (!device) {
    NSLog(@"Couldn't find device");
    return;
  }

  // Look up the service, if we don't find it try updating SDP
  IOBluetoothSDPServiceRecord *service = [self findRemoteServiceInDevice:device];
  if (!service) {
    NSLog(@"No service, querying SDP");
    [device performSDPQuery:self];
    return;
  }

  // If we can't open the channel, it could be because SDP is outdated (e.g. channel ID changed)
  if (![self openChannelToService:service onDevice:device]) {
    NSLog(@"No channel, querying SDP");
    [device performSDPQuery:self];
  }
}

- (void)sdpQueryComplete:(IOBluetoothDevice *)device status:(IOReturn)status {
  if (status != kIOReturnSuccess) {
    NSLog(@"SDP query got status %d", status);
    return;
  }

  // After updating the SDP records, we either know the service, or it's not there
  IOBluetoothSDPServiceRecord *service = [self findRemoteServiceInDevice:device];
  if (service) {
    [self openChannelToService:service onDevice:device];
  } else {
    NSLog(@"Couldn't find service");
  }
}

- (IOBluetoothSDPServiceRecord *)findRemoteServiceInDevice:(IOBluetoothDevice*) device {
  IOBluetoothSDPUUID* uuid = [IOBluetoothSDPUUID uuidWithBytes:kCommandUuidBytes
                                                        length:kCommandUuidSize];
  return [device getServiceRecordForUUID:uuid];
}

- (BOOL)openChannelToService:(IOBluetoothSDPServiceRecord*)service
                    onDevice:(IOBluetoothDevice*)device {
  BluetoothRFCOMMChannelID channelId;
  if ([service getRFCOMMChannelID:&channelId] != kIOReturnSuccess) {
    NSLog(@"Couldn't get channel ID");
    return NO;
  }

  IOBluetoothRFCOMMChannel *channel;
  if ([device openRFCOMMChannelAsync:&channel withChannelID:channelId delegate:self] != kIOReturnSuccess) {
    NSLog(@"Couldn't open channel");
    return NO;
  }

  [channel closeChannel];
  return YES;
}

- (void)rfcommChannelOpenComplete:(IOBluetoothRFCOMMChannel*)rfcommChannel
                           status:(IOReturn)error {
  if (error != kIOReturnSuccess) {
    NSLog(@"Failed to open channel, error %d", error);
    return;
  }

  IOBluetoothDevice *device = [rfcommChannel getDevice];
  const BluetoothDeviceAddress *address = [device getAddress];
  NSData *addressData = [NSData dataWithBytes:address->data length:6];

  NSArray *pendingCommands;
  @synchronized (pendingCommandMap) {
    pendingCommands = [[pendingCommandMap objectForKey:addressData] retain];
    [pendingCommandMap removeObjectForKey:addressData];
  }

  if (pendingCommands) {
    NSLog(@"Commands channel open, mtu=%d, pending=%d",
        [rfcommChannel getMTU], [pendingCommands count]);
    for (NSData* serialized in pendingCommands) {
      void* bytes = (void*) [serialized bytes];
      size_t len = [serialized length];
      [rfcommChannel writeSync:bytes length:len];
      NSLog(@"Sent one command");
    }
  }

  // TODO: Keep the channel for a few seconds in case there are more commands to send
  NSLog(@"Closing channel");
  [rfcommChannel closeChannel];
  [pendingCommands release];
}

- (void)rfcommChannelClosed:(IOBluetoothRFCOMMChannel*)rfcommChannel {
}

// Not yet needed
//- (void)rfcommChannelData:(IOBluetoothRFCOMMChannel*)rfcommChannel data:(void *)dataPointer length:(size_t)dataLength;

- (void)rfcommChannelWriteComplete:(IOBluetoothRFCOMMChannel*)rfcommChannel
                            refcon:(void*)refcon
                            status:(IOReturn)error {
}


@end
