//
//  EDApplicationData.m
//
//  Created by Oliver Michel on 20.02.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#import "EDApplicationData.h"

static EDApplicationData *gAppDataInstance = nil;

@implementation EDApplicationData

- (id)init {
	
	self = [super init];
	
	if([self dataFileExists]) {
		[self restore];
	} else {
		_dataDictionary = [[NSMutableDictionary alloc] init];
	}

	return self;
}

+ (EDApplicationData *)sharedApplicationData {
	
	@synchronized(self) {
		
		if(!gAppDataInstance) {
			NSLog(@"EDApplicationData: will alloc EDApplicationData");
			gAppDataInstance = [[EDApplicationData alloc] init];
		}
	}
	return gAppDataInstance;
}

- (id)retain {
	return self;
}

- (NSUInteger)retainCount {
	return 1;
}

- (oneway void)release {
	// do nothing
}

- (id)autorelease {
	return self;
}

#pragma mark -
#pragma mark Checks

- (BOOL)dataFileExists {
	
	NSFileManager *fm = [[NSFileManager alloc] init];
	NSString *documentDirectory = 
		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	BOOL result = [fm fileExistsAtPath:[documentDirectory stringByAppendingPathComponent:EDAPPLICATIONDATA_FILENAME]];
	[fm release];
	
	return result;
}

- (BOOL)keyExists:(NSString *)key {
	
	return [[_dataDictionary allKeys] containsObject:key];
}

#pragma mark -
#pragma mark reading/setting values

- (id)valueForKey:(NSString *)key {

	id value = [_dataDictionary valueForKey:key];
	
	if(!value || value == [NSNull null]) {
		return nil;
	}
	return value;
}

- (void)setValue:(id)value forKey:(NSString *)key {

	if(!value) {
		[_dataDictionary setValue:[NSNull null] forKey:key];
	} else {
		[_dataDictionary setValue:value forKey:key];
	}
}

- (id)objectForKey:(NSString *)key {
	
	return [self valueForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
	
	[self setValue:object forKey:key];
}

- (BOOL)booleanForKey:(NSString *)key {
	
	return [(NSNumber *)[self valueForKey:key] boolValue];
}

- (void)setBoolean:(BOOL)value forKey:(NSString *)key {
	
	[self setValue:[NSNumber numberWithBool:value] forKey:key];
}

- (int)integerForKey:(NSString *)key {

	return [[self valueForKey:key] intValue];
}

- (void)setInteger:(int)integer forKey:(NSString *)key {
	
	[self setValue:[NSNumber numberWithInt:integer] forKey:key];
}

- (void)removeEntryWithKey:(NSString *)key {

	[_dataDictionary removeObjectForKey:key];
}

- (NSArray *)allKeys {
	
	return [_dataDictionary allKeys];
}

#pragma mark -
#pragma mark Archiving/Unarchiving

- (void)save {
	
	NSMutableData *writeData = [NSMutableData data];
	NSString *documentDirectory = 
		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [documentDirectory stringByAppendingPathComponent:EDAPPLICATIONDATA_FILENAME];
	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:writeData];
	
	[archiver setOutputFormat:NSPropertyListBinaryFormat_v1_0];
	[archiver encodeObject:[_dataDictionary retain] forKey:@"dataDictionary"];
	[archiver finishEncoding];
	
	if([writeData writeToFile:path atomically:YES]) {
		NSLog(@"EDApplicationData: saved ApplicationData");
	} else {
		NSLog(@"EDApplicationData: failed saving ApplicationData");
	}
	
	[archiver release];
}

- (void)restore {
	
	NSString *documentDirectory = 
	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *path = [documentDirectory stringByAppendingPathComponent:EDAPPLICATIONDATA_FILENAME];
	
	NSData *readData = [NSData dataWithContentsOfFile:path];
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
	_dataDictionary = [(NSMutableDictionary *) [unarchiver decodeObjectForKey:@"dataDictionary"] retain];
	[unarchiver finishDecoding];
	
	[unarchiver release];
	
	if(_dataDictionary) {
		NSLog(@"EDApplicationData: restored ApplicationData");
	} else {
		NSLog(@"EDApplicationData: failed restoring ApplicationData");
	}
}

#pragma mark -

- (NSString *)description {
	
	NSString *returnString = [NSString stringWithFormat:@"EDApplicationData: (%i elements) {\n", [_dataDictionary count]];
	
	for(NSString *key in [_dataDictionary allKeys]) {
		
		if([[_dataDictionary objectForKey:key] isKindOfClass:[NSArray class]]) {
			int arrCount = [[_dataDictionary objectForKey:key] count];
			returnString = [returnString stringByAppendingFormat:@"\t%@ => NSArray: (%i elements) \n", key, arrCount];
		} else if([[_dataDictionary objectForKey:key] isKindOfClass:[NSDictionary class]]) {
			int dictCount = [[_dataDictionary objectForKey:key] count];	
			returnString = [returnString stringByAppendingFormat:@"\t%@ => NSDictionary: (%i elements) \n", key, dictCount];
		} else {
			NSString *className = [[[_dataDictionary objectForKey:key] class] description];
			returnString = [returnString stringByAppendingFormat:@"\t%@ => %@: %@ \n", 
							key, className, [_dataDictionary objectForKey:key]];
		}
	}
	
	return returnString = [returnString stringByAppendingString:@"}"];
}

- (void)dealloc {
	
	[_dataDictionary release], _dataDictionary = nil;
	[super dealloc];
}

@end
