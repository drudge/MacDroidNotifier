// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

@class CommandDiscoveryReply;
@class CommandDiscoveryReply_Builder;
@class CommandDiscoveryRequest;
@class CommandDiscoveryRequest_Builder;
@class CommandRequest;
@class CommandRequest_Builder;
@class CommandRequest_CallOptions;
@class CommandRequest_CallOptions_Builder;
@class CommandRequest_QueryOptions;
@class CommandRequest_QueryOptions_Builder;
@class CommandRequest_SmsOptions;
@class CommandRequest_SmsOptions_Builder;
@class CommandResponse;
@class CommandResponse_Builder;
@class CommandResponse_SearchResults;
@class CommandResponse_SearchResults_Builder;
@class Contact;
@class Contact_Builder;
@class DeviceAddresses;
@class DeviceAddresses_Builder;
typedef enum {
  Contact_TypeHome = 0,
  Contact_TypeMobile = 1,
  Contact_TypeWork = 2,
  Contact_TypeOther = 3,
} Contact_Type;

BOOL Contact_TypeIsValidValue(Contact_Type value);

typedef enum {
  CommandRequest_CommandTypeCall = 1,
  CommandRequest_CommandTypeAnswer = 2,
  CommandRequest_CommandTypeHangUp = 3,
  CommandRequest_CommandTypeSendSms = 4,
  CommandRequest_CommandTypeSendMms = 5,
  CommandRequest_CommandTypeQuery = 6,
  CommandRequest_CommandTypeDiscover = 7,
} CommandRequest_CommandType;

BOOL CommandRequest_CommandTypeIsValidValue(CommandRequest_CommandType value);


@interface CommandsRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface Contact : PBGeneratedMessage {
@private
  BOOL hasName_:1;
  BOOL hasNumber_:1;
  BOOL hasOtherType_:1;
  BOOL hasType_:1;
  NSString* name;
  NSString* number;
  NSString* otherType;
  Contact_Type type;
}
- (BOOL) hasName;
- (BOOL) hasNumber;
- (BOOL) hasType;
- (BOOL) hasOtherType;
@property (readonly, retain) NSString* name;
@property (readonly, retain) NSString* number;
@property (readonly) Contact_Type type;
@property (readonly, retain) NSString* otherType;

+ (Contact*) defaultInstance;
- (Contact*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (Contact_Builder*) builder;
+ (Contact_Builder*) builder;
+ (Contact_Builder*) builderWithPrototype:(Contact*) prototype;

+ (Contact*) parseFromData:(NSData*) data;
+ (Contact*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Contact*) parseFromInputStream:(NSInputStream*) input;
+ (Contact*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (Contact*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (Contact*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface Contact_Builder : PBGeneratedMessage_Builder {
@private
  Contact* result;
}

- (Contact*) defaultInstance;

- (Contact_Builder*) clear;
- (Contact_Builder*) clone;

- (Contact*) build;
- (Contact*) buildPartial;

- (Contact_Builder*) mergeFrom:(Contact*) other;
- (Contact_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (Contact_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasName;
- (NSString*) name;
- (Contact_Builder*) setName:(NSString*) value;
- (Contact_Builder*) clearName;

- (BOOL) hasNumber;
- (NSString*) number;
- (Contact_Builder*) setNumber:(NSString*) value;
- (Contact_Builder*) clearNumber;

- (BOOL) hasType;
- (Contact_Type) type;
- (Contact_Builder*) setType:(Contact_Type) value;
- (Contact_Builder*) clearType;

- (BOOL) hasOtherType;
- (NSString*) otherType;
- (Contact_Builder*) setOtherType:(NSString*) value;
- (Contact_Builder*) clearOtherType;
@end

@interface DeviceAddresses : PBGeneratedMessage {
@private
  BOOL hasBluetoothMac_:1;
  NSData* bluetoothMac;
  NSMutableArray* mutableIpAddressList;
}
- (BOOL) hasBluetoothMac;
@property (readonly, retain) NSData* bluetoothMac;
- (NSArray*) ipAddressList;
- (NSData*) ipAddressAtIndex:(int32_t) index;

+ (DeviceAddresses*) defaultInstance;
- (DeviceAddresses*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (DeviceAddresses_Builder*) builder;
+ (DeviceAddresses_Builder*) builder;
+ (DeviceAddresses_Builder*) builderWithPrototype:(DeviceAddresses*) prototype;

+ (DeviceAddresses*) parseFromData:(NSData*) data;
+ (DeviceAddresses*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (DeviceAddresses*) parseFromInputStream:(NSInputStream*) input;
+ (DeviceAddresses*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (DeviceAddresses*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (DeviceAddresses*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface DeviceAddresses_Builder : PBGeneratedMessage_Builder {
@private
  DeviceAddresses* result;
}

- (DeviceAddresses*) defaultInstance;

- (DeviceAddresses_Builder*) clear;
- (DeviceAddresses_Builder*) clone;

- (DeviceAddresses*) build;
- (DeviceAddresses*) buildPartial;

- (DeviceAddresses_Builder*) mergeFrom:(DeviceAddresses*) other;
- (DeviceAddresses_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (DeviceAddresses_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) ipAddressList;
- (NSData*) ipAddressAtIndex:(int32_t) index;
- (DeviceAddresses_Builder*) replaceIpAddressAtIndex:(int32_t) index with:(NSData*) value;
- (DeviceAddresses_Builder*) addIpAddress:(NSData*) value;
- (DeviceAddresses_Builder*) addAllIpAddress:(NSArray*) values;
- (DeviceAddresses_Builder*) clearIpAddressList;

- (BOOL) hasBluetoothMac;
- (NSData*) bluetoothMac;
- (DeviceAddresses_Builder*) setBluetoothMac:(NSData*) value;
- (DeviceAddresses_Builder*) clearBluetoothMac;
@end

@interface CommandRequest : PBGeneratedMessage {
@private
  BOOL hasDeviceId_:1;
  BOOL hasCommandId_:1;
  BOOL hasCallOptions_:1;
  BOOL hasSmsOptions_:1;
  BOOL hasQueryOptions_:1;
  BOOL hasCommandType_:1;
  int64_t deviceId;
  int64_t commandId;
  CommandRequest_CallOptions* callOptions;
  CommandRequest_SmsOptions* smsOptions;
  CommandRequest_QueryOptions* queryOptions;
  CommandRequest_CommandType commandType;
}
- (BOOL) hasDeviceId;
- (BOOL) hasCommandId;
- (BOOL) hasCommandType;
- (BOOL) hasCallOptions;
- (BOOL) hasSmsOptions;
- (BOOL) hasQueryOptions;
@property (readonly) int64_t deviceId;
@property (readonly) int64_t commandId;
@property (readonly) CommandRequest_CommandType commandType;
@property (readonly, retain) CommandRequest_CallOptions* callOptions;
@property (readonly, retain) CommandRequest_SmsOptions* smsOptions;
@property (readonly, retain) CommandRequest_QueryOptions* queryOptions;

+ (CommandRequest*) defaultInstance;
- (CommandRequest*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommandRequest_Builder*) builder;
+ (CommandRequest_Builder*) builder;
+ (CommandRequest_Builder*) builderWithPrototype:(CommandRequest*) prototype;

+ (CommandRequest*) parseFromData:(NSData*) data;
+ (CommandRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandRequest*) parseFromInputStream:(NSInputStream*) input;
+ (CommandRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommandRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommandRequest_CallOptions : PBGeneratedMessage {
@private
  BOOL hasPhoneNumber_:1;
  NSString* phoneNumber;
}
- (BOOL) hasPhoneNumber;
@property (readonly, retain) NSString* phoneNumber;

+ (CommandRequest_CallOptions*) defaultInstance;
- (CommandRequest_CallOptions*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommandRequest_CallOptions_Builder*) builder;
+ (CommandRequest_CallOptions_Builder*) builder;
+ (CommandRequest_CallOptions_Builder*) builderWithPrototype:(CommandRequest_CallOptions*) prototype;

+ (CommandRequest_CallOptions*) parseFromData:(NSData*) data;
+ (CommandRequest_CallOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandRequest_CallOptions*) parseFromInputStream:(NSInputStream*) input;
+ (CommandRequest_CallOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandRequest_CallOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommandRequest_CallOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommandRequest_CallOptions_Builder : PBGeneratedMessage_Builder {
@private
  CommandRequest_CallOptions* result;
}

- (CommandRequest_CallOptions*) defaultInstance;

- (CommandRequest_CallOptions_Builder*) clear;
- (CommandRequest_CallOptions_Builder*) clone;

- (CommandRequest_CallOptions*) build;
- (CommandRequest_CallOptions*) buildPartial;

- (CommandRequest_CallOptions_Builder*) mergeFrom:(CommandRequest_CallOptions*) other;
- (CommandRequest_CallOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommandRequest_CallOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasPhoneNumber;
- (NSString*) phoneNumber;
- (CommandRequest_CallOptions_Builder*) setPhoneNumber:(NSString*) value;
- (CommandRequest_CallOptions_Builder*) clearPhoneNumber;
@end

@interface CommandRequest_SmsOptions : PBGeneratedMessage {
@private
  BOOL hasPhoneNumber_:1;
  BOOL hasSmsMessage_:1;
  NSString* phoneNumber;
  NSString* smsMessage;
}
- (BOOL) hasPhoneNumber;
- (BOOL) hasSmsMessage;
@property (readonly, retain) NSString* phoneNumber;
@property (readonly, retain) NSString* smsMessage;

+ (CommandRequest_SmsOptions*) defaultInstance;
- (CommandRequest_SmsOptions*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommandRequest_SmsOptions_Builder*) builder;
+ (CommandRequest_SmsOptions_Builder*) builder;
+ (CommandRequest_SmsOptions_Builder*) builderWithPrototype:(CommandRequest_SmsOptions*) prototype;

+ (CommandRequest_SmsOptions*) parseFromData:(NSData*) data;
+ (CommandRequest_SmsOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandRequest_SmsOptions*) parseFromInputStream:(NSInputStream*) input;
+ (CommandRequest_SmsOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandRequest_SmsOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommandRequest_SmsOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommandRequest_SmsOptions_Builder : PBGeneratedMessage_Builder {
@private
  CommandRequest_SmsOptions* result;
}

- (CommandRequest_SmsOptions*) defaultInstance;

- (CommandRequest_SmsOptions_Builder*) clear;
- (CommandRequest_SmsOptions_Builder*) clone;

- (CommandRequest_SmsOptions*) build;
- (CommandRequest_SmsOptions*) buildPartial;

- (CommandRequest_SmsOptions_Builder*) mergeFrom:(CommandRequest_SmsOptions*) other;
- (CommandRequest_SmsOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommandRequest_SmsOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasPhoneNumber;
- (NSString*) phoneNumber;
- (CommandRequest_SmsOptions_Builder*) setPhoneNumber:(NSString*) value;
- (CommandRequest_SmsOptions_Builder*) clearPhoneNumber;

- (BOOL) hasSmsMessage;
- (NSString*) smsMessage;
- (CommandRequest_SmsOptions_Builder*) setSmsMessage:(NSString*) value;
- (CommandRequest_SmsOptions_Builder*) clearSmsMessage;
@end

@interface CommandRequest_QueryOptions : PBGeneratedMessage {
@private
  BOOL hasQuery_:1;
  NSString* query;
}
- (BOOL) hasQuery;
@property (readonly, retain) NSString* query;

+ (CommandRequest_QueryOptions*) defaultInstance;
- (CommandRequest_QueryOptions*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommandRequest_QueryOptions_Builder*) builder;
+ (CommandRequest_QueryOptions_Builder*) builder;
+ (CommandRequest_QueryOptions_Builder*) builderWithPrototype:(CommandRequest_QueryOptions*) prototype;

+ (CommandRequest_QueryOptions*) parseFromData:(NSData*) data;
+ (CommandRequest_QueryOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandRequest_QueryOptions*) parseFromInputStream:(NSInputStream*) input;
+ (CommandRequest_QueryOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandRequest_QueryOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommandRequest_QueryOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommandRequest_QueryOptions_Builder : PBGeneratedMessage_Builder {
@private
  CommandRequest_QueryOptions* result;
}

- (CommandRequest_QueryOptions*) defaultInstance;

- (CommandRequest_QueryOptions_Builder*) clear;
- (CommandRequest_QueryOptions_Builder*) clone;

- (CommandRequest_QueryOptions*) build;
- (CommandRequest_QueryOptions*) buildPartial;

- (CommandRequest_QueryOptions_Builder*) mergeFrom:(CommandRequest_QueryOptions*) other;
- (CommandRequest_QueryOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommandRequest_QueryOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasQuery;
- (NSString*) query;
- (CommandRequest_QueryOptions_Builder*) setQuery:(NSString*) value;
- (CommandRequest_QueryOptions_Builder*) clearQuery;
@end

@interface CommandRequest_Builder : PBGeneratedMessage_Builder {
@private
  CommandRequest* result;
}

- (CommandRequest*) defaultInstance;

- (CommandRequest_Builder*) clear;
- (CommandRequest_Builder*) clone;

- (CommandRequest*) build;
- (CommandRequest*) buildPartial;

- (CommandRequest_Builder*) mergeFrom:(CommandRequest*) other;
- (CommandRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommandRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDeviceId;
- (int64_t) deviceId;
- (CommandRequest_Builder*) setDeviceId:(int64_t) value;
- (CommandRequest_Builder*) clearDeviceId;

- (BOOL) hasCommandId;
- (int64_t) commandId;
- (CommandRequest_Builder*) setCommandId:(int64_t) value;
- (CommandRequest_Builder*) clearCommandId;

- (BOOL) hasCommandType;
- (CommandRequest_CommandType) commandType;
- (CommandRequest_Builder*) setCommandType:(CommandRequest_CommandType) value;
- (CommandRequest_Builder*) clearCommandType;

- (BOOL) hasCallOptions;
- (CommandRequest_CallOptions*) callOptions;
- (CommandRequest_Builder*) setCallOptions:(CommandRequest_CallOptions*) value;
- (CommandRequest_Builder*) setCallOptionsBuilder:(CommandRequest_CallOptions_Builder*) builderForValue;
- (CommandRequest_Builder*) mergeCallOptions:(CommandRequest_CallOptions*) value;
- (CommandRequest_Builder*) clearCallOptions;

- (BOOL) hasSmsOptions;
- (CommandRequest_SmsOptions*) smsOptions;
- (CommandRequest_Builder*) setSmsOptions:(CommandRequest_SmsOptions*) value;
- (CommandRequest_Builder*) setSmsOptionsBuilder:(CommandRequest_SmsOptions_Builder*) builderForValue;
- (CommandRequest_Builder*) mergeSmsOptions:(CommandRequest_SmsOptions*) value;
- (CommandRequest_Builder*) clearSmsOptions;

- (BOOL) hasQueryOptions;
- (CommandRequest_QueryOptions*) queryOptions;
- (CommandRequest_Builder*) setQueryOptions:(CommandRequest_QueryOptions*) value;
- (CommandRequest_Builder*) setQueryOptionsBuilder:(CommandRequest_QueryOptions_Builder*) builderForValue;
- (CommandRequest_Builder*) mergeQueryOptions:(CommandRequest_QueryOptions*) value;
- (CommandRequest_Builder*) clearQueryOptions;
@end

@interface CommandResponse : PBGeneratedMessage {
@private
  BOOL hasSuccess_:1;
  BOOL hasDeviceId_:1;
  BOOL hasCommandId_:1;
  BOOL hasErrorMessage_:1;
  BOOL hasSearchResults_:1;
  BOOL hasDiscoveryResult_:1;
  BOOL success_:1;
  int64_t deviceId;
  int64_t commandId;
  NSString* errorMessage;
  CommandResponse_SearchResults* searchResults;
  DeviceAddresses* discoveryResult;
}
- (BOOL) hasDeviceId;
- (BOOL) hasCommandId;
- (BOOL) hasSuccess;
- (BOOL) hasErrorMessage;
- (BOOL) hasSearchResults;
- (BOOL) hasDiscoveryResult;
@property (readonly) int64_t deviceId;
@property (readonly) int64_t commandId;
- (BOOL) success;
@property (readonly, retain) NSString* errorMessage;
@property (readonly, retain) CommandResponse_SearchResults* searchResults;
@property (readonly, retain) DeviceAddresses* discoveryResult;

+ (CommandResponse*) defaultInstance;
- (CommandResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommandResponse_Builder*) builder;
+ (CommandResponse_Builder*) builder;
+ (CommandResponse_Builder*) builderWithPrototype:(CommandResponse*) prototype;

+ (CommandResponse*) parseFromData:(NSData*) data;
+ (CommandResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandResponse*) parseFromInputStream:(NSInputStream*) input;
+ (CommandResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommandResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommandResponse_SearchResults : PBGeneratedMessage {
@private
  NSMutableArray* mutableContactsList;
}
- (NSArray*) contactsList;
- (Contact*) contactsAtIndex:(int32_t) index;

+ (CommandResponse_SearchResults*) defaultInstance;
- (CommandResponse_SearchResults*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommandResponse_SearchResults_Builder*) builder;
+ (CommandResponse_SearchResults_Builder*) builder;
+ (CommandResponse_SearchResults_Builder*) builderWithPrototype:(CommandResponse_SearchResults*) prototype;

+ (CommandResponse_SearchResults*) parseFromData:(NSData*) data;
+ (CommandResponse_SearchResults*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandResponse_SearchResults*) parseFromInputStream:(NSInputStream*) input;
+ (CommandResponse_SearchResults*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandResponse_SearchResults*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommandResponse_SearchResults*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommandResponse_SearchResults_Builder : PBGeneratedMessage_Builder {
@private
  CommandResponse_SearchResults* result;
}

- (CommandResponse_SearchResults*) defaultInstance;

- (CommandResponse_SearchResults_Builder*) clear;
- (CommandResponse_SearchResults_Builder*) clone;

- (CommandResponse_SearchResults*) build;
- (CommandResponse_SearchResults*) buildPartial;

- (CommandResponse_SearchResults_Builder*) mergeFrom:(CommandResponse_SearchResults*) other;
- (CommandResponse_SearchResults_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommandResponse_SearchResults_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) contactsList;
- (Contact*) contactsAtIndex:(int32_t) index;
- (CommandResponse_SearchResults_Builder*) replaceContactsAtIndex:(int32_t) index with:(Contact*) value;
- (CommandResponse_SearchResults_Builder*) addContacts:(Contact*) value;
- (CommandResponse_SearchResults_Builder*) addAllContacts:(NSArray*) values;
- (CommandResponse_SearchResults_Builder*) clearContactsList;
@end

@interface CommandResponse_Builder : PBGeneratedMessage_Builder {
@private
  CommandResponse* result;
}

- (CommandResponse*) defaultInstance;

- (CommandResponse_Builder*) clear;
- (CommandResponse_Builder*) clone;

- (CommandResponse*) build;
- (CommandResponse*) buildPartial;

- (CommandResponse_Builder*) mergeFrom:(CommandResponse*) other;
- (CommandResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommandResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDeviceId;
- (int64_t) deviceId;
- (CommandResponse_Builder*) setDeviceId:(int64_t) value;
- (CommandResponse_Builder*) clearDeviceId;

- (BOOL) hasCommandId;
- (int64_t) commandId;
- (CommandResponse_Builder*) setCommandId:(int64_t) value;
- (CommandResponse_Builder*) clearCommandId;

- (BOOL) hasSuccess;
- (BOOL) success;
- (CommandResponse_Builder*) setSuccess:(BOOL) value;
- (CommandResponse_Builder*) clearSuccess;

- (BOOL) hasErrorMessage;
- (NSString*) errorMessage;
- (CommandResponse_Builder*) setErrorMessage:(NSString*) value;
- (CommandResponse_Builder*) clearErrorMessage;

- (BOOL) hasSearchResults;
- (CommandResponse_SearchResults*) searchResults;
- (CommandResponse_Builder*) setSearchResults:(CommandResponse_SearchResults*) value;
- (CommandResponse_Builder*) setSearchResultsBuilder:(CommandResponse_SearchResults_Builder*) builderForValue;
- (CommandResponse_Builder*) mergeSearchResults:(CommandResponse_SearchResults*) value;
- (CommandResponse_Builder*) clearSearchResults;

- (BOOL) hasDiscoveryResult;
- (DeviceAddresses*) discoveryResult;
- (CommandResponse_Builder*) setDiscoveryResult:(DeviceAddresses*) value;
- (CommandResponse_Builder*) setDiscoveryResultBuilder:(DeviceAddresses_Builder*) builderForValue;
- (CommandResponse_Builder*) mergeDiscoveryResult:(DeviceAddresses*) value;
- (CommandResponse_Builder*) clearDiscoveryResult;
@end

@interface CommandDiscoveryRequest : PBGeneratedMessage {
@private
  BOOL hasDeviceId_:1;
  int64_t deviceId;
}
- (BOOL) hasDeviceId;
@property (readonly) int64_t deviceId;

+ (CommandDiscoveryRequest*) defaultInstance;
- (CommandDiscoveryRequest*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommandDiscoveryRequest_Builder*) builder;
+ (CommandDiscoveryRequest_Builder*) builder;
+ (CommandDiscoveryRequest_Builder*) builderWithPrototype:(CommandDiscoveryRequest*) prototype;

+ (CommandDiscoveryRequest*) parseFromData:(NSData*) data;
+ (CommandDiscoveryRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandDiscoveryRequest*) parseFromInputStream:(NSInputStream*) input;
+ (CommandDiscoveryRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandDiscoveryRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommandDiscoveryRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommandDiscoveryRequest_Builder : PBGeneratedMessage_Builder {
@private
  CommandDiscoveryRequest* result;
}

- (CommandDiscoveryRequest*) defaultInstance;

- (CommandDiscoveryRequest_Builder*) clear;
- (CommandDiscoveryRequest_Builder*) clone;

- (CommandDiscoveryRequest*) build;
- (CommandDiscoveryRequest*) buildPartial;

- (CommandDiscoveryRequest_Builder*) mergeFrom:(CommandDiscoveryRequest*) other;
- (CommandDiscoveryRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommandDiscoveryRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDeviceId;
- (int64_t) deviceId;
- (CommandDiscoveryRequest_Builder*) setDeviceId:(int64_t) value;
- (CommandDiscoveryRequest_Builder*) clearDeviceId;
@end

@interface CommandDiscoveryReply : PBGeneratedMessage {
@private
  BOOL hasDeviceId_:1;
  BOOL hasAddresses_:1;
  int64_t deviceId;
  DeviceAddresses* addresses;
}
- (BOOL) hasDeviceId;
- (BOOL) hasAddresses;
@property (readonly) int64_t deviceId;
@property (readonly, retain) DeviceAddresses* addresses;

+ (CommandDiscoveryReply*) defaultInstance;
- (CommandDiscoveryReply*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (CommandDiscoveryReply_Builder*) builder;
+ (CommandDiscoveryReply_Builder*) builder;
+ (CommandDiscoveryReply_Builder*) builderWithPrototype:(CommandDiscoveryReply*) prototype;

+ (CommandDiscoveryReply*) parseFromData:(NSData*) data;
+ (CommandDiscoveryReply*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandDiscoveryReply*) parseFromInputStream:(NSInputStream*) input;
+ (CommandDiscoveryReply*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (CommandDiscoveryReply*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (CommandDiscoveryReply*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface CommandDiscoveryReply_Builder : PBGeneratedMessage_Builder {
@private
  CommandDiscoveryReply* result;
}

- (CommandDiscoveryReply*) defaultInstance;

- (CommandDiscoveryReply_Builder*) clear;
- (CommandDiscoveryReply_Builder*) clone;

- (CommandDiscoveryReply*) build;
- (CommandDiscoveryReply*) buildPartial;

- (CommandDiscoveryReply_Builder*) mergeFrom:(CommandDiscoveryReply*) other;
- (CommandDiscoveryReply_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (CommandDiscoveryReply_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasDeviceId;
- (int64_t) deviceId;
- (CommandDiscoveryReply_Builder*) setDeviceId:(int64_t) value;
- (CommandDiscoveryReply_Builder*) clearDeviceId;

- (BOOL) hasAddresses;
- (DeviceAddresses*) addresses;
- (CommandDiscoveryReply_Builder*) setAddresses:(DeviceAddresses*) value;
- (CommandDiscoveryReply_Builder*) setAddressesBuilder:(DeviceAddresses_Builder*) builderForValue;
- (CommandDiscoveryReply_Builder*) mergeAddresses:(DeviceAddresses*) value;
- (CommandDiscoveryReply_Builder*) clearAddresses;
@end

