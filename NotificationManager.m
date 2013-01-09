//
//  NotificationManager.m
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

#import "NotificationManager.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#import "ActionDispatcher.h"
#import "BluetoothNotificationListener.h"
#import "Notification.h"
#import "PassPhraseStorage.h"
#import "Preferences.h"
#import "TcpNotificationListener.h"
#import "UdpNotificationListener.h"

const NSUInteger kLastNotificationCount = 10;

@implementation NotificationManager

- (id)init {
  if (self = [super init]) {
    lastNotifications =
        [[NSMutableArray arrayWithCapacity:kLastNotificationCount] retain];
    notificationCount = 0;

    listeners = [[NSArray arrayWithObjects:
                  [[[TcpNotificationListener alloc] init] autorelease],
                  [[[UdpNotificationListener alloc] init] autorelease],
                  [[[BluetoothNotificationListener alloc] init] autorelease],
                  nil] retain];
    for (id<NotificationListener> listener in listeners) {
      // TODO: Only start if enabled in preferences
      [listener startWithCallback:self];
    }
  }
  return self;
}

- (void)dealloc {
  for (id<NotificationListener> listener in listeners) {
    [listener stop];
  }
  [listeners release];
  [lastNotifications release];

  [super dealloc];
}

- (BOOL)isNotificationDuplicate:(Notification *)notification {
  for (Notification *lastNotification in lastNotifications) {
    if ([notification isEqualToNotification:lastNotification]) {
      return YES;
    }
  }

  if ([lastNotifications count] < kLastNotificationCount) {
    [lastNotifications addObject:notification];
  } else {
    NSUInteger position = (notificationCount % kLastNotificationCount);
    [lastNotifications replaceObjectAtIndex:position withObject:notification];
  }

  notificationCount++;
  return NO;
}

- (BOOL)isDevicePaired:(NSString *)deviceId {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSInteger pairingRequiredValue = [defaults integerForKey:kPreferencesPairingRequiredKey];
  BOOL pairingRequired = (pairingRequiredValue == kPairingRequired) ? YES : NO;

  if (!pairingRequired) {
    return YES;
  }

  NSArray *pairedDevices = [defaults arrayForKey:kPreferencesPairedDevicesKey];
  for (NSDictionary *pairedDevice in pairedDevices) {
    NSString *pairedDeviceId = [pairedDevice objectForKey:@"deviceId"];
    if ([deviceId isEqualToString:pairedDeviceId]) {
      return YES;
    }
  }

  return NO;
}

- (NSData*)decryptNotificationData:(NSData*)encryptedData {
  // Try decrypting it
  NSString* passPhrase = [passPhraseStorage passPhrase];
  if ([passPhrase length] == 0) return nil;

  // Hash the passphrase multiple times to get the key
  // There's no need to store the hashed version since the system keychain
  // is already assumed secure.
  NSData* keyData = [passPhrase dataUsingEncoding:NSUTF8StringEncoding];
  unsigned char keyHash[CC_MD5_DIGEST_LENGTH];
  CC_MD5([keyData bytes], (CC_LONG) [keyData length], keyHash);
  unsigned char newKeyHash[CC_MD5_DIGEST_LENGTH];
  for (int i = 0; i < 9; i++) {
    CC_MD5(keyHash, CC_MD5_DIGEST_LENGTH, newKeyHash);
    memcpy(keyHash, newKeyHash, CC_MD5_DIGEST_LENGTH);
  }

  // Initialization vector, also based on the key
  unsigned char iv[CC_MD5_DIGEST_LENGTH];
  CC_MD5(keyHash, CC_MD5_DIGEST_LENGTH, iv);

  // Prepare output
  size_t resultSize;
  char outBuffer[4096];

  // Decrypt
  CCCryptorStatus ccStatus;
  ccStatus = CCCrypt(kCCDecrypt,
                     kCCAlgorithmAES128,
                     kCCOptionPKCS7Padding,
                     keyHash, CC_MD5_DIGEST_LENGTH,
                     iv,
                     [encryptedData bytes], [encryptedData length],
                     (void*) outBuffer, 4096,
                     &resultSize);
  if (ccStatus != kCCSuccess) {
    NSLog(@"Failed to decrypt: %d", ccStatus);
    return nil;
  }

  return [NSData dataWithBytes:outBuffer length:resultSize];
}

- (BOOL)handlePlainNotificationData:(NSData *)data {
  // Discard the ending marker if present
  NSUInteger len = [data length];
  char* contents = (char *) [data bytes];
  if (contents[len - 1] == 0) len--;

  // Convert to a string
  NSString *notificationStr = [[NSString alloc] initWithBytes:contents
                                                       length:len
                                                     encoding:NSUTF8StringEncoding];
  if (notificationStr == nil) {
    return NO;
  }

  Notification *notification = [Notification notificationFromString:notificationStr];
  [notificationStr release];
  if (notification == nil) {
    return NO;
  }

  NSLog(@"Received notification %@", notification);

  @synchronized(self) {
    // Dispatch for regular handling
    if (![self isNotificationDuplicate:notification] &&
        [self isDevicePaired:[notification deviceId]]) {
      [dispatcher actOnNotification:notification];
    }

    // Dispatch for pairing handling
    if ([notification type] == PING) {
      [preferences handlePairingNotification:notification];
    }
  }
  return YES;
}

- (void)handleRawNotification:(NSData *)data {
  // First try handling the notification directly
  if (![self handlePlainNotificationData:data]) {
    // Didn't work, try decrypting it if enabled
    NSData *decryptedData = [self decryptNotificationData:data];
    if (decryptedData != nil) {
      NSLog(@"Got encrypted notification");
      [self handlePlainNotificationData:decryptedData];
    }
  }
}

@end
