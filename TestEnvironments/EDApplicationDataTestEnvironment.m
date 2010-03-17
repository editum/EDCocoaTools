//
//  EDApplicationDataTestEnvironment.m
//  EDCocoaToolsEnv
//
//  Created by Oliver Michel on 17.03.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#import "EDApplicationDataTestEnvironment.h"


@implementation EDApplicationDataTestEnvironment

- (void)performTests {
	
	EDApplicationData *sharedAppData = [EDApplicationData sharedApplicationData];
	
	NSArray *testArray = [NSMutableArray arrayWithObjects:@"hello", @"hola", @"hallo", @"buon giorno", @"grias di", nil];
	
	[sharedAppData setObject:testArray forKey:@"arr1"];
	[sharedAppData setObject:@"hello" forKey:@"hellokey"];
	[sharedAppData setObject:[NSNumber numberWithInt:23] forKey:@"zwoelf"];
	[sharedAppData save];
	
	NSLog(@"%@", sharedAppData);
}
@end
