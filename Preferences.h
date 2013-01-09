//
//  Preferences.h
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

// Constants for preference keys.
extern NSString *const kPreferencesPairedDevicesKey;
extern NSString *const kPreferencesPairingRequiredKey;
extern NSString *const kPreferencesListenUdpKey;
extern NSString *const kPreferencesListenTcpKey;
extern NSString *const kPreferencesListenBluetoothKey;
extern NSString *const kPreferencesListenUsbKey;
extern NSString *const kPreferencesRingKey;
extern NSString *const kPreferencesSmsKey;
extern NSString *const kPreferencesMmsKey;
extern NSString *const kPreferencesBatteryKey;
extern NSString *const kPreferencesVoicemailKey;
extern NSString *const kPreferencesPingKey;
extern NSString *const kPreferencesUserKey;
extern NSString *const kPreferencesDisplayKey;
extern NSString *const kPreferencesMuteKey;
extern NSString *const kPreferencesExecuteKey;
extern NSString *const kPreferencesExecuteActionKey;
extern NSString *const kPreferencesCopyKey;

// Constants for preference values.
extern const NSInteger kPairingNotRequired;
extern const NSInteger kPairingRequired;

@class Notification;
@class StartupItem;

// Object which wrapps handling of the app's preferences, including its UI.
@interface Preferences : NSObject {
 @private
  IBOutlet NSWindow *prefsWindow;
  IBOutlet NSWindow *pairingSheet;
  IBOutlet NSMatrix *pairingRadioGroup;
  IBOutlet NSTableView *pairedDevicesView;
  IBOutlet NSArrayController *pairedDevicesModel;
  IBOutlet NSButton *addPairedDeviceButton;
  IBOutlet NSButton *removePairedDeviceButton;
  IBOutlet NSTextField *executedName;
  IBOutlet NSMenu *mainMenu;
  IBOutlet NSMenu *deviceMenuTemplate;
  IBOutlet StartupItem *startupItem;

  BOOL isPairing;
}

// Shows the preferences dialog.
- (IBAction)showDialog:(id)sender;

// Callback for when the "pairing required" option is changed
- (IBAction)pairingRequiredToggled:(id)sender;

// Callback when the user wants to add a paired device
- (IBAction)addPairedDeviceClicked:(id)sender;

// Callback when a pairing notification is received, even if not currently in
// pairing mode.
- (void)handlePairingNotification:(Notification *)notification;

// Callback for when the user cancels pairing
- (IBAction)cancelPairing:(id)sender;

// Callback to select what to execute
- (IBAction)selectExecuteAction:(id)sender;

- (void)updateDevicesMenuWithDefaults:(NSUserDefaults *)defaults;

@end
