//
//  EDHTTPRequestTestEnvironment.m
//  EDCocoaTools
//
//  Created by Oliver Michel on 08.03.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#import "EDHTTPRequestTestEnvironment.h"


@implementation EDHTTPRequestTestEnvironment

- (void)performTests {
	
	EDHTTPRequest *request = [EDHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.editum.de"] delegate:self];

	request.method = EDHTTPRequestMethodGet;
	
	[request start];
}

- (void)request:(EDHTTPRequest *)request didFailWithError:(EDHTTPRequestError)error status:(NSUInteger)statusCode {
	
	NSLog(@"did fail with error");
}

- (void)request:(EDHTTPRequest *)request finishedSucessfullyWithStatus:(NSUInteger)statusCode data:(NSData *)returnData {
	
	NSLog(@"finished sucessfully");
}

@end
