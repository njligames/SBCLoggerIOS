//
//  PhidgetInterfacekit_fullAppDelegate.m
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import "PhidgetInterfacekit_fullAppDelegate.h"



int gotServerConnect(CPhidgetHandle phid, void *context) {
	[(id)context performSelectorOnMainThread:@selector(ServerConnected:)
								  withObject:nil
							   waitUntilDone:NO];
	return 0;
}

int gotServerDisconnect(CPhidgetHandle phid, void *context) {
	[(id)context performSelectorOnMainThread:@selector(ServerDisconnected:)
								  withObject:nil
							   waitUntilDone:NO];
	return 0;
}



int gotAttach(CPhidgetHandle phid, void *context) {
 
	[(id)context performSelectorOnMainThread:@selector(Attached:)
								  withObject:nil
							   waitUntilDone:NO];
	return 0;
}

int gotDetach(CPhidgetHandle phid, void *context) {
  
	[(id)context performSelectorOnMainThread:@selector(Detached:)
								  withObject:nil
							   waitUntilDone:NO];
	return 0;
}

int gotError(CPhidgetHandle phid, void *context, int Code, const char *Description) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[(id)context performSelectorOnMainThread:@selector(ErrorChange:)
								  withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:Code]     ,[NSString stringWithFormat:@"%s", Description], nil]
     
                               waitUntilDone:NO];
    
	[pool release];
	return 0;
}
 

int gotInputChange(CPhidgetInterfaceKitHandle phid, void *context, int ind, int val) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[(id)context performSelectorOnMainThread:@selector(InputChange:)
								  withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:ind], 
                                              [NSNumber numberWithInt:val], nil]
     
							   waitUntilDone:NO];
	[pool release];
	return 0;
}

int gotOutputChange(CPhidgetInterfaceKitHandle phid, void *context, int ind, int val) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[(id)context performSelectorOnMainThread:@selector(OutputChange:)
								  withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:ind], 
                                              [NSNumber numberWithInt:val], nil]
     
							   waitUntilDone:NO];
	[pool release];
	return 0;
}

int gotSensorChange(CPhidgetInterfaceKitHandle phid, void *context, int ind, int val) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[(id)context performSelectorOnMainThread:@selector(SensorChange:)
								  withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:ind], 
                                              [NSNumber numberWithInt:val], nil]
     
							   waitUntilDone:NO];
	[pool release];
	return 0;
}

@implementation PhidgetInterfacekit_fullAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize serverDetailsTab;
@synthesize homeTab;
@synthesize digitalInputsTab;
@synthesize digitalOutputsTab;
@synthesize analogInputsTab;

- (void)ServerConnected:(id)nothing
{
    const char *addr;
    int port;
    CPhidget_getServerAddress((CPhidgetHandle)ifkit, &addr, &port);
    NSString *str = [NSString stringWithFormat:@"Connected to \nServer: %@ \nPort: %d", [NSString stringWithCString:addr encoding:NSASCIIStringEncoding], port];
        
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Server Status"
                                                   message:str
                                                  delegate:nil
                                         cancelButtonTitle:@"Done"
                                         otherButtonTitles:nil];
    
        
    [alert show];
    [alert release];
  
    [serverDetailsTab serverStatusChanged: @""];
    
    [[[[[self rootController] viewControllers] objectAtIndex:1] tabBarItem] setEnabled:TRUE];
    self.rootController.selectedIndex = 1;
    
}

- (void)ServerDisconnected:(id)nothing
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Server Status"
                                                   message:@"Server Disconnected"
                                                  delegate:nil
                                         cancelButtonTitle:@"Done"
                                         otherButtonTitles:nil];
    
    [serverDetailsTab serverStatusChanged: @"Disconnected"];
    
    [[[[[self rootController] viewControllers] objectAtIndex:1] tabBarItem] setEnabled:FALSE];
    [[[[[self rootController] viewControllers] objectAtIndex:2] tabBarItem] setEnabled:FALSE];
    [[[[[self rootController] viewControllers] objectAtIndex:3] tabBarItem] setEnabled:FALSE];
    [[[[[self rootController] viewControllers] objectAtIndex:4] tabBarItem] setEnabled:FALSE];  
        
    [alert show];
    [alert release];
    
    self.rootController.selectedIndex = 0;
}


- (void)Attached:(id)nothing
{
    int serialNum, version, digitalInputCount, digitalOutputCount, analogInputCount;
    const char *ptr;
    
    [homeTab setAttach: [NSString stringWithFormat:@"Yes"]];
    
    CPhidget_getDeviceName((CPhidgetHandle)ifkit, &ptr);
    [homeTab setName: [NSString stringWithCString:ptr encoding:NSASCIIStringEncoding]];
    
    CPhidget_getSerialNumber((CPhidgetHandle)ifkit, &serialNum);
    [homeTab setSerial: serialNum];

    CPhidget_getDeviceVersion((CPhidgetHandle)ifkit, &version);
    [homeTab setVersion:version];
    
    CPhidgetInterfaceKit_getInputCount(ifkit, &digitalInputCount);
    [homeTab setDigitalInputs:digitalInputCount];
    [digitalInputsTab setDigitalInputCount: digitalInputCount];
    if(digitalInputCount > 0){
        [[[[[self rootController] viewControllers] objectAtIndex:2] tabBarItem] setEnabled:TRUE];
    }
    
    CPhidgetInterfaceKit_getOutputCount(ifkit, &digitalOutputCount);
    [homeTab setDigitalOutputs:digitalOutputCount];
    [digitalOutputsTab setDigitalOutputCount: digitalOutputCount];
    if(digitalOutputCount > 0){
        [[[[[self rootController] viewControllers] objectAtIndex:3] tabBarItem] setEnabled:TRUE];
    }
    
    CPhidgetInterfaceKit_getSensorCount(ifkit, &analogInputCount);
    [homeTab setAnalogInputs:analogInputCount];
    [analogInputsTab setAnalogInputCount: analogInputCount];
    if(analogInputCount > 0){
        [[[[[self rootController] viewControllers] objectAtIndex:4] tabBarItem] setEnabled:TRUE];    
    }
}

- (void)Detached:(id)nothing
{

    [[[[[self rootController] viewControllers] objectAtIndex:2] tabBarItem] setEnabled:FALSE];
    [[[[[self rootController] viewControllers] objectAtIndex:3] tabBarItem] setEnabled:FALSE];
    [[[[[self rootController] viewControllers] objectAtIndex:4] tabBarItem] setEnabled:FALSE]; 
    
    [homeTab setAttach: [NSString stringWithFormat:@"No"]];
    
    [homeTab setName: [NSString stringWithFormat:@""]];
    
    [homeTab setSerial: 0];
    
    [homeTab setVersion:0];
    
    [homeTab setDigitalInputs:0];
    
    [homeTab setDigitalOutputs:0];
    
    [homeTab setAnalogInputs:0];
    
    self.rootController.selectedIndex = 1;
    
    }

- (void)ErrorChange:(NSArray *)errorData
{
    NSString *str = [NSString stringWithFormat:@"Error: %@", [errorData objectAtIndex:1]];
    
   [serverDetailsTab serverStatusChanged: str];

}


- (void)InputChange:(NSArray *)inputChangeData
{
	int inputValue, inputIndex;
	
	inputIndex = [[inputChangeData objectAtIndex:0] intValue];
	inputValue = [[inputChangeData objectAtIndex:1] intValue];
    [digitalInputsTab setInputIndexValue: inputIndex : inputValue];
}

- (void)OutputChange:(NSArray *)outputChangeData
{
	int outputValue, outputIndex;
	
	outputIndex = [[outputChangeData objectAtIndex:0] intValue];
	outputValue = [[outputChangeData objectAtIndex:1] intValue];
    [digitalOutputsTab setOutputIndexValue: outputIndex : outputValue];
}

- (void)SensorChange:(NSArray *)sensorChangeData
{
	int sensorValue, sensorIndex;
	
	sensorIndex = [[sensorChangeData objectAtIndex:0] intValue];
	sensorValue = [[sensorChangeData objectAtIndex:1] intValue];
    
    [analogInputsTab setAnalogIndexValue: sensorIndex : sensorValue];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   [window addSubview:rootController.view];
   
    self.rootController.selectedIndex = 1;  //preload the tab at index 1
    self.rootController.selectedIndex = 0;
    
    [[[[[self rootController] viewControllers] objectAtIndex:1] tabBarItem] setEnabled:FALSE];
    [[[[[self rootController] viewControllers] objectAtIndex:2] tabBarItem] setEnabled:FALSE]; 
    [[[[[self rootController] viewControllers] objectAtIndex:3] tabBarItem] setEnabled:FALSE];
    [[[[[self rootController] viewControllers] objectAtIndex:4] tabBarItem] setEnabled:FALSE];
   
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{

    CPhidget_close((CPhidgetHandle)ifkit);
    CPhidget_delete((CPhidgetHandle)ifkit);
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [window release];
    [rootController release];
    [serverDetailsTab release];
    [homeTab release];
    [digitalInputsTab release];
    [digitalOutputsTab release];
    [analogInputsTab release];
    
    [super dealloc];
}

- (void)connectToPhidget:(NSString*)NSIPAddress:(NSString*)NSPort:(NSString*)NSPassword{
 
    const char *CIPAddress = [NSIPAddress cStringUsingEncoding:NSASCIIStringEncoding];
    int CPort = [NSPort intValue];
    const char *CPassword = [NSPassword cStringUsingEncoding:NSASCIIStringEncoding];
    
    if(ifkit == nil){ 
        CPhidgetInterfaceKit_create(&ifkit);
    }
    else{
        //close the current handle
        CPhidget_close((CPhidgetHandle)ifkit);
        CPhidget_delete((CPhidgetHandle)ifkit);
        ifkit = nil;
        
        //create a new handle
        CPhidgetInterfaceKit_create(&ifkit);
    }
    
    CPhidget_set_OnServerConnect_Handler((CPhidgetHandle)ifkit, gotServerConnect, self);
    CPhidget_set_OnServerDisconnect_Handler((CPhidgetHandle)ifkit, gotServerDisconnect, self);
    CPhidget_set_OnAttach_Handler((CPhidgetHandle)ifkit, gotAttach, self);
    CPhidget_set_OnDetach_Handler((CPhidgetHandle)ifkit, gotDetach, self);
    CPhidget_set_OnError_Handler((CPhidgetHandle)ifkit, gotError, self);
    //error
    
    CPhidgetInterfaceKit_set_OnInputChange_Handler(ifkit, gotInputChange, self);    
    CPhidgetInterfaceKit_set_OnOutputChange_Handler(ifkit, gotOutputChange, self);  
    CPhidgetInterfaceKit_set_OnSensorChange_Handler(ifkit, gotSensorChange, self);
    
    CPhidget_openRemoteIP((CPhidgetHandle)ifkit, -1, CIPAddress, CPort, CPassword);

    
}

-(CPhidgetInterfaceKitHandle)getPhid{
    return(ifkit);
}
@end
