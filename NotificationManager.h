//
//  NotificationManager.h
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
#import "NotificationListener.h"

@class ActionDispatcher;
@class Notification;
@class PassPhraseStorage;
@class Preferences;

// Notification manager, which receives raw notifications from the listeners,
// decodes them, and forwards them to the given notification callback.
@interface NotificationManager : NSObject<NotificationListenerCallback> {
 @private
  // Dispatcher which takes action on notifications
  IBOutlet ActionDispatcher *dispatcher;

  // Preferences, for pairing with new devices
  IBOutlet Preferences *preferences;

  // Keychain storage of the pass phrase
  IBOutlet PassPhraseStorage *passPhraseStorage;

  // Listeners which receive notifications and pass them to this object
  NSArray *listeners;

  // Last few received notifications, for eliminating duplicates
  NSMutableArray *lastNotifications;

  // Total count of received notifications
  NSUInteger notificationCount;
}

@end
