//
//  PhidgetManagerAppDelegate.m
//  PhidgetManager
//
//  Created by Patrick Mcneil on 05/07/09.
//  Copyright Phidgets Inc. 2009. All rights reserved.
//

#import "PhidgetManagerAppDelegate.h"
#import "RootViewController.h"


@implementation PhidgetManagerAppDelegate

@synthesize window;
@synthesize tableController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[tableController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[tableController release];
	[window release];
	[super dealloc];
}

@end
