//
//  Command.m
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

#import "Command.h"


@implementation Command

@synthesize deviceId;
@synthesize commandId;
@synthesize type;
@synthesize data1;
@synthesize data2;

- (void)updateCommandId {
  unsigned long long timestamp =
      [NSDate timeIntervalSinceReferenceDate] * 1000.0;
  unsigned long long hashCode = [deviceId hash];
  hashCode = hashCode * 31 + timestamp;
  hashCode = hashCode * 31 + type;
  if (data1) {
    hashCode = hashCode * 31 + [data1 hash];

    if (data2) {
      hashCode = hashCode * 31 + [data2 hash];
    }
  }
  commandId = [NSString stringWithFormat:@"%qx", hashCode];
}

- (id)initWithDeviceId:(NSString *)deviceIdParam
                  type:(CommandType)typeParam
                 data1:(NSString *)data1Param
                 data2:(NSString *)data2Param {
  if (self = [super init]) {
    deviceId = deviceIdParam;
    type = typeParam;
    data1 = data1Param;
    data2 = data2Param;
    
    [self updateCommandId];
  }
  return self;
}

+ (Command *)commandWithDeviceId:(NSString *)deviceId
                            type:(CommandType)type
                           data1:(NSString *)data1
                           data2:(NSString *)data2 {
  return [[[Command alloc] initWithDeviceId:deviceId
                                       type:type
                                      data1:data1
                                      data2:data2] autorelease];
}

- (NSString *)typeString {
  switch (type) {
    case DIAL:
      return @"DIAL";
    case HANGUP:
      return @"HANGUP";
    case SEND_SMS:
      return @"SEND_SMS";
    case QUERY:
      return @"QUERY";
    default:
      return @"UNKNOWN";
  }
}

- (NSString *)serialized {
  NSMutableString *result = [NSMutableString stringWithCapacity:256];
  [result appendFormat:@"v2/%@/%@/%@", deviceId, commandId, [self typeString]];

  if (data1) {
    [result appendFormat:@"/%@", data1];

    if (data2) {
      [result appendFormat:@"/%@", data2];
    }
  }

  return result;
}

- (NSString *)description {
  NSString *typeStr = [self typeString];
  return [NSString stringWithFormat:@"Id=%@; DeviceId=%@; Type=%@; Data1=%@; Data2=%@",
          commandId, deviceId, typeStr, data1, data2];
  
}

@end
