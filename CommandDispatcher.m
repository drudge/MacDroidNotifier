//
//  CommandDispatcher.m
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

#import "CommandDispatcher.h"

#import "CodedOutputStream.h"
#import "Commands.pb.h"
#import "CommandSender.h"
#import "BluetoothCommandSender.h"
#import "IpCommandSender.h"
#import "TargetDeviceMapper.h"
#import "UsbCommandSender.h"

@implementation CommandDispatcher

- (id)init {
  if (self = [super init]) {
    senders = [[NSArray arrayWithObjects:
        [[[BluetoothCommandSender alloc] init] autorelease],
        [[[IpCommandSender alloc] init] autorelease],
        [[[UsbCommandSender alloc] init] autorelease],
        nil] retain];
    deviceMapper = [[TargetDeviceMapper alloc] init];
  }
  return self;
}

- (void)dealloc {
  [senders release];
  [deviceMapper release];
  [super dealloc];
}

- (NSData*)serializeCommand:(CommandRequest*)cmd {
  NSOutputStream *stream = [NSOutputStream outputStreamToMemory];
  [stream open];

  PBCodedOutputStream* codedStream = [PBCodedOutputStream streamWithOutputStream:stream];
  [codedStream writeMessageNoTag:cmd];
  [codedStream flush];

  NSData *data = [stream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
  [stream close];
  return data;
}

- (void)sendCommand:(CommandRequest *)cmd toAddresses:(DeviceAddresses *)addresses {
  NSData* serialized = [self serializeCommand:cmd];
  NSLog(@"Dispatching command: %@", serialized);
  for (id<CommandSender> sender in senders) {
    if ([sender isEnabled]) {
      [sender sendCommandData:serialized
                  toAddresses:addresses];
    }
  }
}

- (void)discoverAddressesFor:(int64_t)deviceId thenSendCommand:(CommandRequest *)cmd {
  // TODO: Non-fake data
  NSString* addressStr = @"00:23:76:f5:b4:d0";
  BluetoothDeviceAddress deviceAddress;
  IOBluetoothNSStringToDeviceAddress(addressStr, &deviceAddress);
  
  DeviceAddresses_Builder *addrBuilder = [DeviceAddresses builder];
  [addrBuilder setBluetoothMac:[NSData dataWithBytes:deviceAddress.data length:6]];
  DeviceAddresses *addr = [addrBuilder build];

  [self sendCommand:cmd toAddresses:addr];
}

- (void)dispatchCommand:(CommandRequest *)cmd {
  int64_t deviceId = [cmd deviceId];
  DeviceAddresses* addresses = [deviceMapper addressesForDevice:deviceId];
  if (!addresses) {
    [self discoverAddressesFor:deviceId thenSendCommand:cmd];
  } else {
    [self sendCommand:cmd toAddresses:addresses];
  }
}

@end
