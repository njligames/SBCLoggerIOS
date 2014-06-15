//
//  JLI_AppDelegate.m
//  GreenEnergyResearch
//
//  Created by James Folk on 3/10/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_AppDelegate.h"
#import "JLI_HardwareListTableViewController.h"
#import "JLI_PhidgetHardwareDevice.h"
#import "JLI_PhidgetHardwareTemperatureSensor.h"
#import "JLI_PhidgetHardwareAccelerometer.h"
#import "JLI_PhidgetHardwareInterfaceKit.h"

NSString *LocalErrorCatcher (int errorCode)
{
    NSString *ret = @"SUCCESS";
    
    if (errorCode != 0)
    {
        switch (errorCode)
        {
            case EPHIDGET_NOTFOUND:
                ret = @"Phidget not found exception. “A Phidget matching the type and or serial number could not be found.”\
                This exception is not currently used externally.";
                break;
            case EPHIDGET_NOMEMORY:
                ret = @"No memory exception. “Memory could not be allocated.”\
                This exception is thrown when a memory allocation (malloc) call fails in the c library.";
                break;
            case EPHIDGET_UNEXPECTED:
                ret = @"Unexpected exception. “Unexpected Error. Contact Phidgets Inc. for support.”\
                This exception is thrown when something unexpected happens (more unexpected than another exception). This generally points to a bug or bad code in the C library, and hopefully won’t even be seen.";
                break;
            case EPHIDGET_INVALIDARG:
                ret = @"Invalid argument exception. “Invalid argument passed to function.”\
                This exception is thrown whenever a function receives an unexpected null pointer, or a value that is out of range. ie setting a motor’s speed to 101 when the maximum is 100.";
                break;
            case EPHIDGET_NOTATTACHED:
                ret = @"Phidget not attached exception. “Phidget not physically attached.”\
                This exception is thrown when a method is called on a device that is not attached, and the method requires the device to be attached. ie trying to read the serial number, or the state of an output.";
                break;
            case EPHIDGET_INTERRUPTED:
                ret = @"Interrupted exception. “Read/Write operation was interrupted.”\
                This exception is not currently used externally.";
                break;
            case EPHIDGET_INVALID:
                ret = @"Invalid error exception. “The Error Code is not defined.”\
                This exception is thrown when trying to get the string description of an undefined error code.";
                break;
            case EPHIDGET_NETWORK:
                ret = @"Network exception. “Network Error.”\
                This exception is usually only seen in the Error event. It will generally be accompanied by a specific Description of the network problem.";
                break;
            case EPHIDGET_UNKNOWNVAL:
                ret = @"Value unknown exception. “Value is Unknown (State not yet received from device, or not yet set by user).”\
                This exception is thrown when a device that is set to unknown is read (e.g., trying to read the position of a servo before setting its position).\
                Every effort is made in the library to fill in as much of a device’s state before the attach event gets thrown, however, many there are some states that cannot be filled in automatically (e.g., older interface kits do not return their output states, so these will be unknown until they are set).\
                This is a quite common exception for some devices, and so should always be caught.";
                break;
            case EPHIDGET_BADPASSWORD:
                ret = @"Authorization exception. “Authorization Failed.”\
                This exception is thrown during the Error event. It means that a connection could not be authenticated because of a password miss match.";
                break;
            case EPHIDGET_UNSUPPORTED:
                ret = @"Unsupported exception. “Not Supported.”\
                This exception is thrown when a method is called that is not supported, either by that device, or by the system (e.g., calling setRatiometric on an InterfaceKit that does not have sensors).";
                break;
            case EPHIDGET_DUPLICATE:
                ret = @"Duplicate request exception. “Duplicated request.”\
                This exception is not currently used.";
                break;
            case EPHIDGET_TIMEOUT:
                ret = @"Timeout exception. “Given timeout has been exceeded.”\
                This exception is thrown by waitForAttachment(int) if the provided time out expires before an attach happens. This may also be thrown by a device set request, if the set times out (though this should not happen, and would generally mean a problem with the device).";
                break;
            case EPHIDGET_OUTOFBOUNDS:
                ret = @"Out of bounds exception. “Index out of Bounds.”\
                This exception is thrown anytime an indexed set or get method is called with an out of bounds index.";
                break;
            case EPHIDGET_EVENT:
                ret = @"Event exception. “A non-null error code was returned from an event handler.”\
                This exception is not currently used.";
                break;
            case EPHIDGET_NETWORK_NOTCONNECTED:
                ret = @"Network not connected exception. “A connection to the server does not exist.”\
                This exception is thrown when a network specific method is called on a device that was opened remotely, but there is no connection to a server (e.g., getServerID).";
                break;
            case EPHIDGET_WRONGDEVICE:
                ret = @"Wrong device exception. “Function is not applicable for this device.”\
                This exception is thrown when a method from device is called by another device. ie casting an InterfaceKit to a Servo and calling setPosition.";
                break;
            case EPHIDGET_CLOSED:
                ret = @"Phidget closed exception. “Phidget handle was closed.”\
                This exception is thrown by waitForAttachment() if the handle it is waiting on is closed.";
                break;
            case EPHIDGET_BADVERSION:
                ret = @"Version mismatch exception. “Webservice and Client protocol versions don’t match. Update to newest release.”\
                This exception is thrown in the error event when connection to a Phidget Webservice that uses a different protocol version then the client library.";
                break;
            default:
                ret = @"No error specified.";
                break;
        }
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"GreenEnergy Research"
                                                          message:ret
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    
    return ret;
}

int gotAttach(CPhidgetHandle phid, void *context)
{
    [(__bridge id)context performSelectorOnMainThread:@selector(deviceAttach:)
                                           withObject:[NSValue valueWithPointer:phid]
                                        waitUntilDone:YES];
    return 0;
}

int gotDetach(CPhidgetHandle phid, void *context)
{
    [(__bridge id)context performSelectorOnMainThread:@selector(deviceRemoved:)
                                           withObject:[NSValue valueWithPointer:phid]
                                        waitUntilDone:YES];
    return 0;
}

int serverConnectCallback(CPhidgetManagerHandle handle, void *userPtr)
{
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setHardwareLister];
    
    return 0;
}

int serverDisconnectCallback(CPhidgetManagerHandle handle, void *userPtr)
{
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setServerChooser];
    
    return 0;
}

int errorEventHandler (CPhidgetHandle device, void *usrptr, int errorCode, const char *errorDescription)
{
//    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UIViewController *currentViewController = ((UINavigationController*)appDelegate.window.rootViewController).visibleViewController;
//    
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"GreenEnergy Research"
//                                                      message:[NSString stringWithFormat:@"%s", errorDescription]
//                                                     delegate:currentViewController
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//    
//    [message show];
    
    return 0;
}

@interface JLI_AppDelegate ()
{
    CPhidgetManagerHandle phidMan;
    UIViewController *viewController;
}



@end

@implementation JLI_AppDelegate

@synthesize phidgetHardwareArray;
@synthesize pollInterval;
@synthesize startDate;

- (CGRect)updateViewRatio
{
    CGFloat windowWidth = self.window.bounds.size.width;
    CGFloat viewWidth = _webView.bounds.size.width;
    CGFloat scaleRatio = self.window.bounds.size.width / _webView.bounds.size.width;
    CGAffineTransform scalingTransform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                                scaleRatio,
                                                                scaleRatio);
    [_webView setTransform:scalingTransform];
    CGRect webFrame = _webView.frame;
    webFrame.origin.y = 0.0;
    webFrame.origin.x = 0.0;
    _webView.frame = webFrame;
    
    if(_imageView)
        [_imageView setFrame:webFrame];
    
    return webFrame;
}

- (void) initWebCam
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 640.0, 480.0)];
    _webView.userInteractionEnabled = NO;
    
    CGRect webFrame = [self updateViewRatio];
    
    NSURL *url = [NSURL URLWithString:@"http://iris.not.iac.es/axis-cgi/mjpg/video.cgi?resolution=320x240"];
//    NSURL *url = [NSURL URLWithString:@"http://phidgetsbc.local.:81/?action=stream"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    _imageView = [[MotionJpegImageView alloc] initWithFrame:webFrame];
    
    _imageView.url = url;
    [_imageView play];
    
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    startDate = [NSDate date];
    
    [self initWebCam];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [_webView stopLoading];
    [_imageView pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [_webView reload];
    [_imageView play];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

#pragma mark Phidget Event Handling Functions

- (void)deviceAttach:(NSValue *)phid
{
    CPhidget_DeviceClass deviceClass;
    CPhidget_getDeviceClass((CPhidgetHandle)[phid pointerValue], &deviceClass);
    
    if(PHIDCLASS_INTERFACEKIT == deviceClass)
    {
        [self addHardware:phid];
        [self addHardware:phid];
        [self addHardware:phid];
        [self addHardware:phid];
        [self addHardware:phid];
        [self addHardware:phid];
        [self addHardware:phid];
        [self addHardware:phid];
    }
    else
    {
        [self addHardware:phid];
    }
    
    
}

- (void)deviceRemoved:(NSValue *)phid
{
    [self removeHardware:phid];
}

#pragma mark Phidget server connect

- (void)connectToServer:(NSString*)server port:(NSString*)port password:(NSString*)password
{
    LocalErrorCatcher(CPhidgetManager_create(&phidMan));
	
	LocalErrorCatcher(CPhidgetManager_set_OnAttach_Handler(phidMan, gotAttach, (__bridge void*)self));
	LocalErrorCatcher(CPhidgetManager_set_OnDetach_Handler(phidMan, gotDetach, (__bridge void*)self));
	
    LocalErrorCatcher(CPhidgetManager_set_OnServerConnect_Handler(phidMan, serverConnectCallback, NULL));
    LocalErrorCatcher(CPhidgetManager_set_OnServerDisconnect_Handler(phidMan, serverDisconnectCallback, NULL));
    
    LocalErrorCatcher(CPhidget_set_OnError_Handler((CPhidgetHandle) phidMan,
                                                   errorEventHandler, NULL));
    
	LocalErrorCatcher(CPhidgetManager_openRemoteIP(phidMan, [server UTF8String], [port intValue], [password UTF8String]));
    
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"GreenEnergy Research"
//                                                      message:@"WHATUP"
//                                                     delegate:self
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//    
//    [message show];
}

-(void)setServerChooser
{
    phidgetHardwareArray = nil;
    
    UIViewController *currentViewController = ((UINavigationController*)self.window.rootViewController).visibleViewController;
    
    [self.window setRootViewController:[currentViewController.storyboard instantiateViewControllerWithIdentifier:@"server_chooser"]];
}

-(void)setHardwareLister
{
    phidgetHardwareArray = [[NSMutableArray alloc] init];
    
    UIViewController *currentViewController = ((UINavigationController*)self.window.rootViewController).visibleViewController;
    
    [self.window setRootViewController:[currentViewController.storyboard instantiateViewControllerWithIdentifier:@"hardware_chooser"]];
}

-(void)addHardware:(NSValue*)phid
{
//    JLI_PhidgetHardwareDevice *p = [[JLI_PhidgetHardwareDevice alloc] initWithPhidget:phid password:@"admin"];
    JLI_PhidgetHardwareDevice *p = [JLI_AppDelegate createPhidget:phid];
    
    if(p != nil)
    {
        [phidgetHardwareArray addObject:p];
        
        UIViewController *currentViewController = ((UINavigationController*)self.window.rootViewController).visibleViewController;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.jamesfolk.greenenergyresearch.updatehardware" object:currentViewController];
    }
}

-(void)removeHardware:(NSValue*)phid
{
    JLI_PhidgetHardwareDevice *p = [[JLI_PhidgetHardwareDevice alloc] initWithPhidget:phid password:@"admin"];
    
    [phidgetHardwareArray removeObject:p];
    
    UIViewController *currentViewController = ((UINavigationController*)self.window.rootViewController).visibleViewController;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.jamesfolk.greenenergyresearch.updatehardware" object:currentViewController];
}

-(NSUInteger)getHardwareCount
{
    return [phidgetHardwareArray count];
}

-(JLI_PhidgetHardwareDevice*)getPhidgetHardware:(NSInteger)index
{
    return [phidgetHardwareArray objectAtIndex:index];
}


+(JLI_PhidgetHardwareDevice*)createPhidget:(NSValue*)phid
{
    JLI_PhidgetHardwareDevice *phidgetHardwareDevice = nil;
    
    CPhidget_DeviceClass deviceClass;
    
    CPhidget_getDeviceClass((CPhidgetHandle)[phid pointerValue], &deviceClass);
    
    switch (deviceClass)
    {
        case PHIDCLASS_ACCELEROMETER:
        {
            phidgetHardwareDevice = [[JLI_PhidgetHardwareAccelerometer alloc] initWithPhidget:phid password:@"admin"];
        }
            break;
        case PHIDCLASS_ADVANCEDSERVO:
        {
        }
            break;
        case PHIDCLASS_ANALOG:
        {
        }
            break;
        case PHIDCLASS_BRIDGE:
        {
        }
            break;
        case PHIDCLASS_ENCODER:
        {
        }
            break;
        case PHIDCLASS_FREQUENCYCOUNTER:
        {
        }
            break;
        case PHIDCLASS_GPS:
        {
        }
            break;
        case PHIDCLASS_INTERFACEKIT:
        {
            phidgetHardwareDevice = [[JLI_PhidgetHardwareInterfaceKit alloc] initWithPhidget:phid password:@"admin"];
            
            //TODO
            //
//            CPhidgetInterfaceKitHandle h;
        }
            break;
        case PHIDCLASS_IR:
        {
        }
            break;
        case PHIDCLASS_LED:
        {
        }
            break;
        case PHIDCLASS_MOTORCONTROL:
        {
        }
            break;
        case PHIDCLASS_PHSENSOR:
        {
        }
            break;
        case PHIDCLASS_RFID:
        {
        }
            break;
        case PHIDCLASS_SERVO:
        {
        }
            break;
        case PHIDCLASS_SPATIAL:
        {
        }
            break;
        case PHIDCLASS_STEPPER:
        {
        }
            break;
        case PHIDCLASS_TEMPERATURESENSOR:
        {
            phidgetHardwareDevice = [[JLI_PhidgetHardwareTemperatureSensor alloc] initWithPhidget:phid password:@"admin"];
        }
            break;
        case PHIDCLASS_TEXTLCD:
        {
        }
            break;
        case PHIDCLASS_TEXTLED:
        {
        }
            break;
        case PHIDCLASS_WEIGHTSENSOR:
        {
        }
            break;
        default:
            break;
    }
    
    return phidgetHardwareDevice;
}

-(void)addToViewController:(UIView*)v
{
    [v addSubview:_webView];
    [v addSubview:_imageView];
}
@end
