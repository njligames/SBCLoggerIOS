//
//  PhidgetManagerAppDelegate.h
//  PhidgetManager
//
//  Created by Patrick Mcneil on 05/07/09.
//  Copyright Phidgets Inc. 2009. All rights reserved.
//

#import "RootViewController.h"

@interface PhidgetManagerAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    RootViewController *tableController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *tableController;

@end

