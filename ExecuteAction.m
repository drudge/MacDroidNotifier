//
//  ExecuteAction.m
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

#import "ExecuteAction.h"
#import "Notification.h"
#import "Preferences.h"

NSString *const kNotificationEnvironmentVar = @"ANDROID_NOTIFICATION";
NSString *const kOpenCommand = @"/usr/bin/open";

@implementation ExecuteAction

- (void)openExternalFile:(NSString *)filePath
           forNotification:(Notification *)notification {
  NSLog(@"Opening file %@", filePath);

  NSFileManager *fm = [NSFileManager defaultManager];
  BOOL isDir;
  if (![fm fileExistsAtPath:filePath isDirectory:&isDir]) {
    NSLog(@"Target executable not found");
    return;
  }

  // Set the notification as an environment variable for the other app
  // We pass it this way to satisfy:
  // 1. Any app can be run without having to understand the notification
  //    (so it can be just ignored)
  // 2. Applescript can be run and still read it
  NSMutableDictionary *environment =
      [[NSMutableDictionary alloc]
          initWithDictionary:[[NSProcessInfo processInfo] environment]];
  [environment setObject:[notification rawNotificationString]
                  forKey:kNotificationEnvironmentVar];

  NSTask *externalAction = [[NSTask alloc] init];
  [externalAction setEnvironment:environment];

  if (!isDir && [fm isExecutableFileAtPath:filePath]) {
    // Directly executable
    [externalAction setLaunchPath:filePath];
  } else {
    // Ask finder to open it
    [externalAction setLaunchPath:kOpenCommand];
    [externalAction setArguments:[NSArray arrayWithObject:filePath]];
  }

  [externalAction launch];

  [environment release];
  [externalAction release];
}

- (void)executeForNotification:(Notification *)notification {
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  NSString *targetName = [ud objectForKey:kPreferencesExecuteActionKey];
  if (targetName != nil) {
    [self openExternalFile:targetName forNotification:notification];
  }
}

@end
