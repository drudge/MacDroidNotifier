//
//  StartupItem.m
//  BuildStatusItem
//
//  Copyright 2010 Rodrigo Damazio <rodrigo@damazio.org>
//  Pieces of code from http://rhult.github.com/preference-to-launch-on-login.html
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

#import "StartupItem.h"

@implementation StartupItem

@dynamic startAtLogin;

- (NSURL *)appURL {
  return [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
}

#pragma mark Initialization

- (id)init {
  if (self = [super init]) {
    loginItemsRef = LSSharedFileListCreate(kCFAllocatorDefault,
                                           kLSSharedFileListSessionLoginItems,
                                           NULL);
  }
  return self;
}

- (void)dealloc {
  CFRelease(loginItemsRef);

  [super dealloc];
}

# pragma mark Login item list manipulation

// Get an NSArray with the items.
- (NSArray *)loginItems {
  CFArrayRef snapshotRef = LSSharedFileListCopySnapshot(loginItemsRef, NULL);

  // Use toll-free bridging to get an NSArray with nicer API
  // and memory management.
  return [NSMakeCollectable(snapshotRef) autorelease];
}

// Return a CFRetained item for the app's bundle, if there is one.
- (LSSharedFileListItemRef)findLoginItem {
  NSArray *loginItems = [self loginItems];
  NSURL *bundleURL = [self appURL];

  for (id item in loginItems) {
    LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef) item;
    CFURLRef itemURLRef;

    if (LSSharedFileListItemResolve(itemRef, 0, &itemURLRef, NULL) == noErr) {
      NSURL *itemURL = (NSURL *) [NSMakeCollectable(itemURLRef) autorelease];
      if ([itemURL isEqual:bundleURL]) {
        return itemRef;
      }
    }
  }

  return NULL;
}

- (void)addToLoginItems {
  // We use the URL to the app itself (i.e. the main bundle).
  NSURL *bundleURL = [self appURL];

  // Ask to be hidden on launch. The key name to use was a bit hard to find, but can
  // be found by inspecting the plist ~/Library/Preferences/com.apple.loginwindow.plist
  // and looking at some existing entries. Thanks to Anders for the hint!
  NSDictionary *properties =
  [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                              forKey:@"com.apple.loginitem.HideOnLaunch"];

  LSSharedFileListItemRef itemRef =
      LSSharedFileListInsertItemURL(loginItemsRef,
                                    kLSSharedFileListItemLast,
                                    NULL,
                                    NULL,
                                    (CFURLRef) bundleURL,
                                    (CFDictionaryRef) properties,
                                    NULL);

  if (itemRef) {
    CFRelease(itemRef);
  }
}

- (void)removeFromLoginItems {
  LSSharedFileListItemRef itemRef = [self findLoginItem];
  if (!itemRef)
    return;

  LSSharedFileListItemRemove(loginItemsRef, itemRef);
}

#pragma mark Property accessor methods

- (BOOL)startAtLogin {
  LSSharedFileListItemRef itemRef = [self findLoginItem];
  return (itemRef != NULL);
}

- (void)setStartAtLogin:(BOOL)value {
  if (!value) {
    [self removeFromLoginItems];
  } else {
    [self addToLoginItems];
  }
}

#pragma mark Update

- (void)forceValueUpdate {
  [self willChangeValueForKey:@"startAtLogin"];
  [self didChangeValueForKey:@"startAtLogin"];
}

@end