//
//  CommandController.m
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

#import "CommandController.h"

#include <stdlib.h>

#import "Commands.pb.h"
#import "CommandDispatcher.h"

@implementation CommandController

- (void)awakeFromNib {
  srand((int) time(NULL));
}

- (IBAction)showStartCallDialog:(id)sender {
  NSMenuItem *item = sender;
  lastDialDeviceId = [item representedObject];
  [NSApp activateIgnoringOtherApps:YES];
  [dialWindow makeKeyAndOrderFront:sender];
}

- (IBAction)showSendSmsDialog:(id)sender {
  NSMenuItem *item = sender;
  lastSmsDeviceId = [item representedObject];

  [NSApp activateIgnoringOtherApps:YES];
  [sendSmsWindow makeKeyAndOrderFront:sender];
}

- (CommandRequest_Builder*)commandWithDeviceId:(NSString*) deviceId {
  // Parse the device ID
  uint64_t deviceIdNumber;
  NSScanner* deviceIdScanner = [NSScanner scannerWithString:deviceId];
  [deviceIdScanner scanHexLongLong:&deviceIdNumber];

  CommandRequest_Builder* builder = [CommandRequest builder];
  [builder setCommandId:(((uint64_t) rand()) << 32 | rand())];
  [builder setDeviceId:deviceIdNumber];
  return builder;
}

- (IBAction)startCall:(id)sender {
  NSString *number = [dialNumber stringValue];
  [dialWindow close];

  CommandRequest_CallOptions_Builder* callOptionsBuilder =
  [CommandRequest_CallOptions builder];
  [callOptionsBuilder setPhoneNumber:number];

  CommandRequest_Builder* builder = [self commandWithDeviceId:lastDialDeviceId];
  [builder setCommandType:CommandRequest_CommandTypeCall];
  [builder setCallOptionsBuilder:callOptionsBuilder];

  [dispatcher dispatchCommand:[builder build]];
}

- (IBAction)answerCall:(id)sender {
  NSMenuItem *item = sender;
  NSString *deviceId = [item representedObject];

  CommandRequest_Builder* builder = [self commandWithDeviceId:deviceId];
  [builder setCommandType:CommandRequest_CommandTypeAnswer];
  
  [dispatcher dispatchCommand:[builder build]];
}

- (IBAction)hangUp:(id)sender {
  NSMenuItem *item = sender;
  NSString *deviceId = [item representedObject];

  CommandRequest_Builder* builder = [self commandWithDeviceId:deviceId];
  [builder setCommandType:CommandRequest_CommandTypeHangUp];
  
  [dispatcher dispatchCommand:[builder build]];
}

- (IBAction)sendSms:(id)sender {
  NSString *number = [sendSmsNumber stringValue];
  NSString *contents = [sendSmsContents stringValue];
  [sendSmsWindow close];

  CommandRequest_SmsOptions_Builder* smsOptionsBuilder =
      [CommandRequest_SmsOptions builder];
  [smsOptionsBuilder setPhoneNumber:number];
  [smsOptionsBuilder setSmsMessage:contents];

  CommandRequest_Builder* builder = [self commandWithDeviceId:lastSmsDeviceId];
  [builder setCommandType:CommandRequest_CommandTypeSendSms];
  [builder setSmsOptionsBuilder:smsOptionsBuilder];

  [dispatcher dispatchCommand:[builder build]];
}

@end
