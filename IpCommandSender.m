//
//  IpCommandSender.m
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

#import "IpCommandSender.h"

#import "AsyncSocket.h"
#import "Commands.pb.h"

static const int kCommandPort = 10601;
static const int kWriteTimeout = 10000;

@implementation IpCommandSender

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
  // TODO
  return YES;
}

- (void)sendCommandData:(NSData *)cmd toAddresses:(DeviceAddresses *)addresses {
  NSArray *ipAddresses = [addresses ipAddressList];
  if ([ipAddresses count] == 0) {
    NSLog(@"No IP addresses to send to");
    return;
  }

  // TODO: Try all of them
  NSData *ipAddress = [ipAddresses objectAtIndex:0];
  unsigned char *ipBytes = (unsigned char*) [ipAddress bytes];
  NSString *address =
      [NSString stringWithFormat:@"%u.%u.%u.%u",
       ipBytes[0], ipBytes[1], ipBytes[2], ipBytes[3]];

  // Enqueue command, associated with the IP address
  long ipLong = ipBytes[0] << 24 |
                ipBytes[1] << 16 |
                ipBytes[2] << 8 |
                ipBytes[3];

  @synchronized (pendingCommandMap) {
    NSNumber *ipLongNumber = [NSNumber numberWithLong:ipLong];
    NSMutableArray *pendingCommands =
        [pendingCommandMap objectForKey:ipLongNumber];
    if (!pendingCommands) {
      pendingCommands = [NSMutableArray arrayWithCapacity:5];
      [pendingCommandMap setObject:pendingCommands forKey:ipLongNumber];
    }
    [pendingCommands addObject:cmd];
  }

  // Start the connection
  NSError *err;
  AsyncSocket *socket =
      [[[AsyncSocket alloc] initWithDelegate:self
                                    userData:ipLong] autorelease];
  [socket connectToHost:address onPort:kCommandPort error:&err];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
  // Connected, fetch the pending commands
  long ipLong = [sock userData];
  NSArray *pendingCommands;

  @synchronized (pendingCommandMap) {
    NSNumber *ipLongNumber = [NSNumber numberWithLong:ipLong];
    pendingCommands = [pendingCommandMap objectForKey:ipLongNumber];
    [pendingCommandMap removeObjectForKey:ipLongNumber];
  }

  // Use decrementing tags so we know when to close the connection
  // (after tag 0 is sent).
  NSUInteger tag = [pendingCommands count];
  for (NSData *cmd in pendingCommands) {
    [sock writeData:cmd withTimeout:kWriteTimeout tag:--tag];
    NSLog(@"Wrote one IP command");
  }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
  // TODO
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
  if (tag == 0) {
    // Done writing all pending commands
    NSLog(@"Wrote all IP commands");
    [sock disconnect];
  }
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock
 shouldTimeoutWriteWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(CFIndex)length {
  return 0;
}

@end
