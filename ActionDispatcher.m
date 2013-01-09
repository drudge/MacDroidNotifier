//
//  ActionDispatcher.m
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

#import "ActionDispatcher.h"

#import "Action.h"
#import "CopyAction.h"
#import "DisplayAction.h"
#import "ExecuteAction.h"
#import "MuteAction.h"
#import "Notification.h"
#import "Preferences.h"

@implementation ActionDispatcher

- (void)awakeFromNib {
  actions = [[NSDictionary dictionaryWithObjectsAndKeys:
                 [[[DisplayAction alloc] init] autorelease], kPreferencesDisplayKey,
                 [[[MuteAction alloc] init] autorelease], kPreferencesMuteKey,
                 [[[ExecuteAction alloc] init] autorelease], kPreferencesExecuteKey,
                 [[[CopyAction alloc] init] autorelease], kPreferencesCopyKey,
                 nil] retain];
}

- (void)dealloc {
  [actions release];
  [super dealloc];
}

- (BOOL)isAction:(NSString *)actionKey enabledForNotificationType:(NotificationType)type
      inDefaults:(NSUserDefaults *)defaults {
  NSString *typeKey = [[Notification stringFromNotificationType:type] lowercaseString];
  NSString *fullKey = [NSString stringWithFormat:@"%@.%@", typeKey, actionKey];
  return [defaults boolForKey:fullKey];
}

- (void)actOnNotification:(Notification *)notification {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  for (NSString *key in actions) {
    if ([self isAction:key enabledForNotificationType:[notification type] inDefaults:defaults]) {
      NSObject<Action> *action = [actions objectForKey:key];
      [action executeForNotification:notification];
    }
  }
}

@end
