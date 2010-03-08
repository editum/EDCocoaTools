//
//  EDHTTPRequestTestEnvironment.h
//  EDCocoaTools
//
//  Created by Oliver Michel on 08.03.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDHTTPRequest.h"

@interface EDHTTPRequestTestEnvironment : NSObject <EDHTTPRequestDelegate> {

}

- (void)performTests;

@end
