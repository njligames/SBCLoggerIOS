//
//  PhidgetInterfacekit_fullAppDelegate.h
//  PhidgetInterfacekit-full
//
//  Created by Phidgets 
//  Copyright 2011 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServerDetailsController.h"
#import "HomeController.h"
#import "DigitalInputsController.h"
#import "DigitalOutputsController.h"
#import "AnalogInputsController.h"

#import "phidget21.h"

@interface PhidgetInterfacekit_fullAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
    IBOutlet UITabBarController *rootController;
    
    CPhidgetInterfaceKitHandle ifkit;
    
    IBOutlet ServerDetailsController *serverDetailsTab;
    IBOutlet HomeController *homeTab;
    IBOutlet DigitalInputsController *digitalInputsTab;
    IBOutlet DigitalOutputsController *digitalOutputsTab;
    IBOutlet AnalogInputsController *analogInputsTab;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet ServerDetailsController *serverDetailsTab;
@property (nonatomic, retain) IBOutlet HomeController *homeTab;
@property (nonatomic, retain) IBOutlet DigitalInputsController *digitalInputsTab;
@property (nonatomic, retain) IBOutlet DigitalOutputsController *digitalOutputsTab;
@property (nonatomic, retain) IBOutlet AnalogInputsController *analogInputsTab;

- (void)connectToPhidget:(NSString*)NSIPAddress:(NSString*)NSPort:(NSString*)NSPassword;

-(CPhidgetInterfaceKitHandle)getPhid;

@end
