//
//  main.m
//  PhidgetInterfacekit-full
//
//  This example demonstrates the usage of Phidgets in iOS programming. The WebService must be started on the computer that is hosting the Phidget.
//  First, the user inputs the WebService information in order for the application to connect to the 
//  server. Upon detection of an attached PhidgetInterfaceKit, its details, as well as digital inputs, digital outputs, analog inputs information will be displayed.
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//



#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
