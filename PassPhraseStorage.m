//
//  PassPhraseStorage.m
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

#import "PassPhraseStorage.h"
#import <Security/Security.h>

static const char kServiceName[] = "MacDroidNotifier";
static const char kAccountName[] = "passphrase";

@implementation PassPhraseStorage

- (NSString *)passPhrase {
  void* password;
  UInt32 passwordLength;

  OSStatus status;
  status = SecKeychainFindGenericPassword(NULL,
                                          strlen(kServiceName), kServiceName,
                                          strlen(kAccountName), kAccountName,
                                          &passwordLength, &password,
                                          NULL);
  if (status != 0) return @"";
  
  NSString *passwordStr = [[[NSString alloc] initWithBytes:password
                                                    length:passwordLength
                                                  encoding:NSUTF8StringEncoding]
                           autorelease];
  SecKeychainItemFreeContent(NULL, password);
  return passwordStr;
}

- (void)setPassPhrase:(NSString *)passPhrase {
  NSData* passPhraseData = [passPhrase dataUsingEncoding:NSUTF8StringEncoding];
  const char* utf8pass = [passPhraseData bytes];
  UInt32 len = (UInt32) [passPhraseData length];
  OSStatus status;

  SecKeychainItemRef itemRef;
  status = SecKeychainFindGenericPassword(NULL,
                                         strlen(kServiceName), kServiceName,
                                         strlen(kAccountName), kAccountName,
                                         NULL, NULL,
                                         &itemRef);

  if (status == errSecItemNotFound) {
    // Doesn't exist yet, create it
    status = SecKeychainAddGenericPassword(NULL,
                                           strlen(kServiceName),
                                           kServiceName,
                                           strlen(kAccountName),
                                           kAccountName,
                                           len,
                                           utf8pass,
                                           NULL);
  } else if (status == 0) {
    // Exists and was successfully read
    status = SecKeychainItemModifyAttributesAndData(itemRef,
                                                    NULL,
                                                    len,
                                                    utf8pass);
  }  // else some other error occurred

  if (status != 0) {
    CFStringRef err = SecCopyErrorMessageString(status, NULL);
    NSLog(@"Error while saving pass phrase: %@", err);
    CFRelease(err);
  }

  if (itemRef) CFRelease(itemRef);
}

@end
