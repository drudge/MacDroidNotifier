//
//  Notification.h
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

// Enum for the type of notification.
typedef enum {
  RING,
  BATTERY,
  SMS,
  MMS,
  VOICEMAIL,
  PING,
  USER
} NotificationType;

// Class which keeps data about a single notification.
@interface Notification : NSObject {
 @private
  NSString *deviceId;
  NSString *notificationId;
  NotificationType type;
  NSString *contents;
  NSString *data;
}

// The unique ID for the device that sent the notification
@property (nonatomic,readonly) NSString *deviceId;

// The unique ID for the notification
@property (nonatomic,readonly) NSString *notificationId;

// The type of notification
@property (nonatomic,readonly) NotificationType type;

// The textual (human-readable) contents of the notification
@property (nonatomic,readonly) NSString *contents;

// The non-human-readable data about the notification
@property (nonatomic,readonly) NSString *data;

// Parse a serialized notification string into a new notification object.
+ (Notification *)notificationFromString:(NSString *)serialized;

// Compares this notification to another and tells if they're equal.
- (BOOL)isEqualToNotification:(Notification *)notification;

// Returns the raw encoded form of the notification.
- (NSString *)rawNotificationString;

// Returns the string equivalent of the type enum.
+ (NSString *)stringFromNotificationType:(NotificationType)type;

// Sets the given type to the equivalent of the given string.
// Returns YES if the string was a valid type, NO otherwise.
+ (BOOL)setNotificationType:(NotificationType *)type
                 fromString:(NSString *)typeStr;

@end
