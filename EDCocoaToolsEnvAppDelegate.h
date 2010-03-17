//
//  EDCocoaToolsEnvAppDelegate.h
//  EDCocoaToolsEnv
//
//  Created by Oliver Michel on 08.03.10.
//  Copyright 2010 :editum.internet solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EDHTTPRequestTestEnvironment.h"
#import "EDApplicationDataTestEnvironment.h"

@interface EDCocoaToolsEnvAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
