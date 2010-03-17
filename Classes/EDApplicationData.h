//
//  EDApplicationData.h
//
//  Created by Oliver Michel on 20.02.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#define EDAPPLICATIONDATA_FILENAME @"EDApplicationData.archive"

@interface EDApplicationData : NSObject {

	// conforms to <NSKeyValueCoding> informal protocol
	
	NSMutableDictionary *_dataDictionary;
}

+ (EDApplicationData *)sharedApplicationData;

- (BOOL)keyExists:(NSString *)key;
- (BOOL)dataFileExists;

- (void)save;
- (void)restore;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (BOOL)booleanForKey:(NSString *)key;
- (void)setBoolean:(BOOL)value forKey:(NSString *)key;
- (int)integerForKey:(NSString *)key;
- (void)setInteger:(int)integer forKey:(NSString *)key;

- (void)removeEntryWithKey:(NSString *)key;
- (NSArray *)allKeys;

@end
