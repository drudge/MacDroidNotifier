//
//  WifiNotificationListener.m
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

#import "TcpNotificationListener.h"

#import "AsyncSocket.h"
#import "Preferences.h"

static const UInt16 kPortNumber = 10600;
static const NSTimeInterval kReadTimeout = 10.0;

@implementation TcpNotificationListener

- (void)startWithCallback:(NSObject<NotificationListenerCallback> *)callbackParam {
  if (socket) {
    NSLog(@"Tried to start service twice");
    return;
  }
  
  callback = [callbackParam retain];
  
  NSLog(@"started listening for TCP notifications");
  socket = [[AsyncSocket alloc] initWithDelegate:self];
  
  // Advanced options - enable the socket to contine operations even during modal dialogs, and menu browsing
  [socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

  NSError *err;
  BOOL bound = [socket acceptOnPort:kPortNumber error:&err];
  if (bound != YES) {
    NSLog(@"Error when listening on socket: %@", err);
  }
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket {
  if ([[NSUserDefaults standardUserDefaults] boolForKey:kPreferencesListenTcpKey]) {
    [newSocket readDataToData:[AsyncSocket ZeroData]
                  withTimeout:kReadTimeout
                          tag:1L];
  } else {
    [newSocket disconnect];
  }
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(CFIndex)length {
  [sock disconnectAfterReading];
  return 0;
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
  [callback handleRawNotification:data];
}

- (void)stop {
  if (!socket) {
    return;
  }
  
  [socket disconnect];
  [socket release];
  socket = nil;
  [callback release];
  callback = nil;
}

- (void)dealloc {
  [self stop];
  [super dealloc];
}

@end
