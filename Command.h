//
//  Command.h
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

#import <Cocoa/Cocoa.h>

typedef enum {
  DIAL,
  HANGUP,
  SEND_SMS,
  QUERY
} CommandType;

@interface Command : NSObject {
 @private
  NSString *deviceId;
  NSString *commandId;
  CommandType type;
  NSString *data1;
  NSString *data2;
}

// The unique ID for the device that sent the notification
@property (nonatomic,readonly) NSString *deviceId;

// The unique ID for the command
@property (nonatomic,readonly) NSString *commandId;

// The type of notification
@property (nonatomic,readonly) CommandType type;

// The textual (human-readable) contents of the notification
@property (nonatomic,readonly) NSString *data1;

// The non-human-readable data about the notification
@property (nonatomic,readonly) NSString *data2;

- (NSString *)serialized;

+ (Command *)commandWithDeviceId:(NSString *)deviceId
                            type:(CommandType)type
                           data1:(NSString *)data1
                           data2:(NSString *)data2;

@end
