//
//  DisplayAction.m
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

#import "DisplayAction.h"
#import "Notification.h"

@implementation DisplayAction

- (void)executeForNotification:(Notification *)notification {
    NSUserNotification *note = [[NSUserNotification alloc] init];

    
    NSString *title = nil;
    NSString *name = nil;
    NSString *sound = nil;
    NSString *text  = [notification contents];
    int priority = 0;
    
    switch ([notification type]) {
        case RING:
            title = NSLocalizedString(@"Phone is ringing", @"Phone ring title");
            name = @"PhoneRing";
            sound = @"Ringer.aiff";
            priority = 1;
            break;
        case BATTERY:
            title = NSLocalizedString(@"Phone battery state", @"Battery state title");
            name = @"PhoneBattery";
           // iconName = [self batteryIconNameFromDescription:description andData:data];
            priority = -1;
            break;
        case SMS:
            title = NSLocalizedString(@"Phone received an SMS", @"SMS received title");
            name = @"PhoneSMS";
            sound = NSUserNotificationDefaultSoundName;
            text = [text stringByReplacingOccurrencesOfString:@"SMS from " withString:@""];
            break;
        case MMS:
            title = NSLocalizedString(@"Phone received an MMS", @"MMS received title");
            name = @"PhoneMMS";
            text = [text stringByReplacingOccurrencesOfString:@"MMS from " withString:@""];
            sound = NSUserNotificationDefaultSoundName;
            break;
        case VOICEMAIL:
            title = NSLocalizedString(@"New voicemail", @"New voicemail title");
            name = @"PhoneVoicemail";
            break;
        case PING:
            title = NSLocalizedString(@"Phone sent a ping", @"Ping title");
            name = @"PhonePing";
            break;
        case USER:
            title = [notification data];
            name = @"PhoneThirdParty";
            break;
    }
    
    note.title = title;
    note.informativeText = text;

    note.soundName = sound;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:note];
}

@end
