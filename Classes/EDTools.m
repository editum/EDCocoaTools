//
//  EDTools.m
//  tupaloiPhoneApp
//
//  Created by Oliver Michel on 05.11.09.
//  Copyright 2009 Tupalo.com. All rights reserved.
//

#import "EDTools.h"

@implementation EDTools

+ (NSString *)documentDirectory {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (BOOL)fileExistsInDocumentDirectory:(NSString *)fileName {
	
	NSFileManager *fm = [[NSFileManager alloc] init];
	BOOL result = [fm fileExistsAtPath:[[self documentDirectory] stringByAppendingPathComponent:fileName]];
	[fm release];
	
	return result;
}

+ (BOOL)writeCollection:(id)collection toFile:(NSString *)fileName {
	
	NSLog(@"EDTools: writing Collection: %@", [collection description]);
	
	NSString *writePath = [[self documentDirectory] stringByAppendingPathComponent:fileName];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	if([fm fileExistsAtPath:writePath]) {
		[fm removeItemAtPath:writePath error:NULL];
	}
	
	if([NSKeyedArchiver archiveRootObject:collection toFile:writePath]) {
		return TRUE;
	} else {
		return FALSE;
	}
}

+ (id)decodeCollectionFromFile:(NSString *)fileName {
	
	NSString *readPath = [[self documentDirectory] stringByAppendingPathComponent:fileName];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	if([fm fileExistsAtPath:readPath]) {

		return [NSKeyedUnarchiver unarchiveObjectWithFile:readPath];
	}
	return nil;
}

+ (BOOL)writeData:(NSData *)data toFile:(NSString *)fileName {
	
	NSString *writePath = [[self documentDirectory] stringByAppendingPathComponent:fileName];
	
	if([data writeToFile:writePath atomically:YES]) {
		return TRUE;
	} else {
		return FALSE;
	}
}

+ (NSData *)readDataFromFile:(NSString *)fileName {
	
	NSString *readPath = [[self documentDirectory] stringByAppendingPathComponent:fileName];	
	return [NSData dataWithContentsOfFile:readPath];
}

+ (NSString *)urlEncode:(NSString *)url {
    
	NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":", @"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]", @"#", @"!", @"'", @"(", 
							@")", @"*",@" ", @"ä", @"Ä", @"ö", @"Ö", @"ü", @"Ü", nil];
	
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F", @"%3A" , @"%40" , @"%26",
							 @"%3D" , @"%2B" , @"%24" ,@"%2C" , @"%5B" , @"%5D", @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A",@"%20", @"%E4", @"%C4", @"%F6", @"%D6", @"%FC", @"%DC", nil];
	
    NSMutableString *temp = [[url mutableCopy] autorelease];
	
    for(int i = 0; i < [escapeChars count]; i++) {
		
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
    }
	
    return [NSString stringWithString:temp];
}

+ (BOOL)networkConnectionAvailableForURL:(NSString *)url {
	
	const char *host_name = [url cStringUsingEncoding:NSUTF8StringEncoding];

	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
	
	SCNetworkReachabilityFlags flags;
	bool success = SCNetworkReachabilityGetFlags(reachability, &flags);
	
	bool isDataSourceAvailable = 
		success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	
	return (BOOL) isDataSourceAvailable;
}

+ (NSUInteger)currentTimeStamp {
	
	return (NSUInteger) [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)md5HashFromString:(NSString *)string {
	
	// md5 -q -s "string"
	const char *cStr = [string UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
	NSString *returnStr =  [NSString  stringWithFormat:
							@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
							result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
							result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
	
	return [returnStr lowercaseString];
}

@end

@implementation NSString (EDTools)

- (BOOL)isEmpty {
	
	if([self isEqualToString:@""]) {
		return YES;
	}
	return NO;
}

@end

