//
//  EDTools.h
//  tupaloiPhoneApp
//
//  Created by Oliver Michel on 05.11.09.
//  Copyright 2009 Tupalo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CommonCrypto/CommonDigest.h>

@interface EDTools : NSObject {

}

+ (NSString *)documentDirectory;
+ (BOOL)fileExistsInDocumentDirectory:(NSString *)fileName;

+ (BOOL)writeCollection:(id)collection toFile:(NSString *)fileName;
+ (id)decodeCollectionFromFile:(NSString *)fileName;

+ (BOOL)writeData:(NSData *)data toFile:(NSString *)fileName;
+ (NSData *)readDataFromFile:(NSString *)fileName;

+ (NSString *)urlEncode:(NSString *)url;

+ (BOOL)networkConnectionAvailableForURL:(NSString *)url;

+ (NSUInteger)currentTimeStamp;
+ (NSString *)md5HashFromString:(NSString *)string;

@end

@interface NSString (EDTools)
- (BOOL)isEmpty;
@end