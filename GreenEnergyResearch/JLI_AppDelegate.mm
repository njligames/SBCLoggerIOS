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
#import "JLI_PhidgetHardwareSpatial.h"
#import "TestFlight.h"
#import "JLI_DeviceCollectionViewController.h"
#import "JLI_ServerChooseViewController.h"

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

//int gotAttach(CPhidgetHandle phid, void *context)
//{
//    [(__bridge id)context performSelector:@selector(deviceAttach:)
//                               withObject:[NSValue valueWithPointer:phid]];
//    
//    return 0;
//}
//
//int gotDetach(CPhidgetHandle phid, void *context)
//{
//    [(__bridge id)context performSelector:@selector(deviceRemoved:)
//                               withObject:[NSValue valueWithPointer:phid]];
//    
//    return 0;
//}

int deviceAttachedCallback(CPhidgetHandle handle, void *ctx)
{
    id context = (__bridge id)ctx;
    
    if([context respondsToSelector:@selector(deviceAttached:)])
    {
        [context performSelectorOnMainThread:@selector(deviceAttached:)
                                               withObject:[NSValue valueWithPointer:handle]
                                            waitUntilDone:NO];
    }
    
    return 0;
}

int deviceDetachedCallback(CPhidgetHandle handle, void *ctx)
{
    id context = (__bridge id)ctx;
    
    if([context respondsToSelector:@selector(deviceDetached:)])
    {
        [context performSelectorOnMainThread:@selector(deviceDetached:)
                                  withObject:[NSValue valueWithPointer:handle]
                               waitUntilDone:NO];
    }
    
    return 0;
}

int serverConnectCallback(CPhidgetManagerHandle handle, void *ctx)
{
    id context = (__bridge id)ctx;
    
    if([context respondsToSelector:@selector(serverConnected:)])
    {
        [context performSelectorOnMainThread:@selector(serverConnected:)
                                  withObject:[NSValue valueWithPointer:handle]
                               waitUntilDone:NO];
    }
    
    return 0;
}

int serverDisconnectCallback(CPhidgetManagerHandle handle, void *ctx)
{
    id context = (__bridge id)ctx;
    
    if([context respondsToSelector:@selector(serverDisconnected:)])
    {
        [context performSelectorOnMainThread:@selector(serverDisconnected:)
                                  withObject:[NSValue valueWithPointer:handle]
                               waitUntilDone:NO];
    }
    
    return 0;
}

int errorEventHandler (CPhidgetHandle device, void *usrptr, int errorCode, const char *errorDescription)
{
    NSLog(@"(%d) - %s", errorCode, errorDescription);
    
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    [appDelegate setStatusLabelText:[NSString stringWithUTF8String:errorDescription]];
    
//    [appDelegate.statusLabel setText:[NSString stringWithUTF8String:errorDescription]];
    
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
    
    JLI_DeviceCollectionViewController *collectionViewController;
    JLI_ServerChooseViewController *serverViewController;
}



@end

@implementation JLI_AppDelegate

//@synthesize phidgetHardwareArray;
@synthesize phidgetHardwareDictionary;
@synthesize pollInterval;
@synthesize startDate;


- (CGRect)updateViewRatio
{
    return [self updateViewRatio:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (CGRect)updateViewRatio:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGFloat windowWidth = self.window.bounds.size.width;
    CGFloat windowHeight = self.window.bounds.size.height;
    
    CGFloat viewWidth = _webView.bounds.size.width;
    CGFloat viewHeight = _webView.bounds.size.height;
    
    
    BOOL isPortrait = YES;
    
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        isPortrait = NO;
    }
    
    CGFloat scaleRatio = 1.0f;
    
    if(isPortrait)
    {
        scaleRatio = windowWidth / viewWidth;
    }
    else
    {
        scaleRatio = windowWidth / viewWidth;
    }
    
    
    
    
    NSLog(@"\n\nWindow width %f\nWindow height %f\nFrame width %f\nFrame height %f\nPortrait %s\nRatio %f\n",
          windowWidth, windowHeight, viewWidth, viewHeight, (isPortrait)?"yes":"no", scaleRatio);
    
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
    
    windowWidth = self.window.bounds.size.width;
    windowHeight = self.window.bounds.size.height;
    
    viewWidth = _webView.bounds.size.width;
    viewHeight = _webView.bounds.size.height;
    
    
    
    
    
    
    return webFrame;
}

- (void) initWebCam
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1280, 960)];
    _webView.userInteractionEnabled = NO;
    
    CGRect webFrame = [self updateViewRatio];
    
    NSURL *url = [NSURL URLWithString:@"http://phidgetsbc.local.:81/?action=stream"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    _imageView = [[MotionJpegImageView alloc] initWithFrame:webFrame];
    
    _imageView.url = url;
    [_imageView play];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"3081811f-0ddf-48aa-8b1a-b4b87bbeb140"];
    // The rest of your application:didFinishLaunchingWithOptions method// ...
    
    startDate = [NSDate date];
//
//    [self initWebCam];
//    
    self.masterIsHidden = YES;
    
    
    
    UIViewController *currentViewController = ((UINavigationController*)self.window.rootViewController).visibleViewController;
    
    serverViewController = [currentViewController.storyboard instantiateViewControllerWithIdentifier:@"server_chooser"];
    collectionViewController = [currentViewController.storyboard instantiateViewControllerWithIdentifier:@"hardware_chooser"];
    
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

//- (void)deviceAttach:(NSValue *)phid
//{
//    CPhidget_DeviceClass deviceClass;
//    CPhidget_getDeviceClass((CPhidgetHandle)[phid pointerValue], &deviceClass);
//    
//    if(PHIDCLASS_INTERFACEKIT == deviceClass)
//    {
////        for(int i = 0; i < 8; ++i)
////            [self addHardware:phid index:[NSNumber numberWithInt:i]];
//    }
//    else
//    {
////        [self addHardware:phid index:0];
//    }
//    
//    
//}
//
//- (void)deviceRemoved:(NSValue *)phid
//{
////    [self removeHardware:phid];
//}

#pragma mark Phidget server connect

- (void)connectToServer:(NSString*)server port:(NSString*)port password:(NSString*)password
{
    LocalErrorCatcher(CPhidgetManager_create(&phidMan));

	LocalErrorCatcher(CPhidgetManager_set_OnAttach_Handler(phidMan, deviceAttachedCallback, (__bridge void*)self));
	LocalErrorCatcher(CPhidgetManager_set_OnDetach_Handler(phidMan, deviceDetachedCallback, (__bridge void*)self));
	
    LocalErrorCatcher(CPhidgetManager_set_OnServerConnect_Handler(phidMan, serverConnectCallback, (__bridge void*)self));
    LocalErrorCatcher(CPhidgetManager_set_OnServerDisconnect_Handler(phidMan, serverDisconnectCallback, (__bridge void*)self));
    
    LocalErrorCatcher(CPhidget_set_OnError_Handler((CPhidgetHandle) phidMan, errorEventHandler, (__bridge void*)self));
    
    
    const char *_server = [server UTF8String];
    int _port = [port intValue];
    const char *_password = [password UTF8String];
    
    
	LocalErrorCatcher(CPhidgetManager_openRemoteIP(phidMan, _server, _port, _password));
    
    
    activityIndicator.hidden = NO;
    
    [activityIndicator startAnimating];
    
    [statusLabel setText:@"Connecting..."];
}


- (void)deviceAttached:(NSValue *)handle
{
    id phidget = [JLI_AppDelegate createPhidget:handle];
    
    if(phidget != nil)
    {
        NSNumber *index = @0;
        
        [phidget setValue:index forKey:@"currentIndex"];
        
        NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[handle hash]];
        [phidgetHardwareDictionary setValue:phidget forKey:key];
    }
}

- (void)deviceDetached:(NSValue *)handle
{
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[handle hash]];
    [phidgetHardwareDictionary removeObjectForKey:key];
    
//    JLI_PhidgetHardwareDevice *p = [[JLI_PhidgetHardwareDevice alloc] initWithPhidget:handle password:@"admin"];
//    
//    [phidgetHardwareArray removeObject:p];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.jamesfolk.greenenergyresearch.deviceDetached" object:self];
}

-(void)serverConnected:(NSValue *)phidHandle
{
    phidgetHardwareDictionary = [NSMutableDictionary new];
    
    [self.window setRootViewController:collectionViewController];
}

-(void)serverDisconnected:(NSValue *)phidHandle
{
    phidgetHardwareDictionary = nil;
    
    [self.window setRootViewController:serverViewController];
}

-(NSUInteger)getHardwareCount
{
    return [phidgetHardwareDictionary count];
}

-(JLI_PhidgetHardwareDevice*)getPhidgetHardwareIndex:(NSInteger)index
{
    NSArray* allKeys = [phidgetHardwareDictionary allKeys];
    return [phidgetHardwareDictionary objectForKey:[allKeys objectAtIndex:index]];
}

-(JLI_PhidgetHardwareDevice*)getPhidgetHardwareHandle:(NSValue*)handle
{
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[handle hash]];
    return [phidgetHardwareDictionary objectForKey:key];
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
            phidgetHardwareDevice = [[JLI_PhidgetHardwareSpatial alloc] initWithPhidget:phid password:@"admin"];
        }
            break;
        case PHIDCLASS_STEPPER:
        {
            phidgetHardwareDevice = nil;
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
    
    if(phidgetHardwareDevice)
    {
        [phidgetHardwareDevice setValue:[NSNumber numberWithInt:deviceClass]
                                 forKey:@"deviceClass"];
    }
    
    return phidgetHardwareDevice;
}

-(void)addToViewController:(UIView*)v
{
    [v addSubview:_webView];
    [v addSubview:_imageView];
}










































-(void)toggleHideMaster:(void(^)(void))completionBlock
{
    __weak JLI_AppDelegate  *delegate = self;
    __weak UISplitViewController *splitView = (UISplitViewController*)self.window.rootViewController;
    
    // Adjust the detailView frame to hide/show the masterview
    [UIView animateWithDuration:0.0020f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void)
     {
         CGRect selfFrame = splitView.view.frame;
         
         // Get the masterViewController's frame's width for reference.
         // Note that masterNavigationController is stored as a property on my delegate
         // when the application finishes launching.
         CGFloat deltaWidth = 0.001;//delegate.masterNavigationController.topViewController.view.frame.size.width;
         
         // masterIsHidden is a BOOL property used to track hidden state.
         if(!delegate.masterIsHidden)
         {
             // Frame is turned on it's side for Landscape view (Only view supported in the app I am building. if supporting portrait - don't call this and let the default functionality happen.)
             // To simulate hiding master, increase the width and move the origin by the width of the master.
             // The frame is treated as though you are in portrait - adjust height and y origin.
             selfFrame.size.height += deltaWidth;
             
             // y origin only needs adjustment in landscape right.
             if (splitView.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
             {
                 selfFrame.origin.y -= deltaWidth;
             }
         }
         else
         {
             // Reverse for showing again.
             selfFrame.size.height -= deltaWidth;
             if (splitView.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
             {
                 selfFrame.origin.y += deltaWidth;
             }
         }
         
         // No set the new adjusted frame to be the frame of the splitview
         [splitView.view setFrame:selfFrame];
         
     }completion:^(BOOL finished){
         if (finished)
         {
             // Now just finish up and call the completion block if provided.
             delegate.masterIsHidden = !delegate.masterIsHidden;
             
             if (completionBlock)
             {
                 completionBlock();
             }
         }
     }];
}

// Since the different rotations of landscape have to be treated differently, this method needs to be called
// whenever a rotation occurs so the frame can be updated appropriately (rotations reset the splitview frame which will leave your state tracking incorrect.). Additional conditions may exist to reset for portrait, since this system will be by-passed.
//
- (void)updateHideMasterOnRotation
{
    if (self.masterIsHidden)
    {
        self.masterIsHidden = NO;
        [self toggleHideMaster:nil];
    }
}

- (NSString*)phidgetHardwareName:(NSInteger)index
{
    JLI_PhidgetHardwareDevice *device = [self getPhidgetHardwareIndex:index];
    NSString *str = [device getDeviceName];
    
    return [str stringByReplacingOccurrencesOfString:@"Phidget "
                                          withString:@""];
}

- (UIImage *)phidgetHardwareIcon:(NSInteger)index
{
    JLI_PhidgetHardwareDevice *device = [self getPhidgetHardwareIndex:index];
    
    switch([device getDeviceId])
    {
            //Current
        case PHIDID_ACCELEROMETER_3AXIS:
            return [UIImage imageNamed:@"1059.png"];
        case PHIDID_ADVANCEDSERVO_1MOTOR:
            return [UIImage imageNamed:@"1066.png"];
        case PHIDID_ADVANCEDSERVO_8MOTOR:
            return [UIImage imageNamed:@"1061.png"];
        case PHIDID_ANALOG_4OUTPUT:
            return [UIImage imageNamed:@"1002.png"];
        case PHIDID_BIPOLAR_STEPPER_1MOTOR:
            return [UIImage imageNamed:@"1063.png"];
        case PHIDID_BRIDGE_4INPUT:
            return [UIImage imageNamed:@"1046.png"];
        case PHIDID_ENCODER_1ENCODER_1INPUT:
            return [UIImage imageNamed:@"1052.png"];
        case PHIDID_ENCODER_HS_1ENCODER:
            return [UIImage imageNamed:@"1057.png"];
        case PHIDID_ENCODER_HS_4ENCODER_4INPUT:
            return [UIImage imageNamed:@"1047.png"];
        case PHIDID_FREQUENCYCOUNTER_2INPUT:
            return [UIImage imageNamed:@"1054.png"];
        case PHIDID_GPS:
            return [UIImage imageNamed:@"1040.png"];
        case PHIDID_INTERFACEKIT_0_0_4:
            return [UIImage imageNamed:@"1014.png"];
        case PHIDID_INTERFACEKIT_0_0_8:
            return [UIImage imageNamed:@"1017.png"];
        case PHIDID_INTERFACEKIT_0_16_16:
            return [UIImage imageNamed:@"1012.png"];
        case PHIDID_INTERFACEKIT_2_2_2:
            return [UIImage imageNamed:@"1011.png"];
        case PHIDID_INTERFACEKIT_8_8_8:
            return [UIImage imageNamed:@"1018.png"];
        case PHIDID_INTERFACEKIT_8_8_8_w_LCD:
            return [UIImage imageNamed:@"1200.png"];
        case PHIDID_IR:
            return [UIImage imageNamed:@"1055.png"];
        case PHIDID_LED_64_ADV:
            return [UIImage imageNamed:@"1031.png"];
        case PHIDID_LINEAR_TOUCH:
            return [UIImage imageNamed:@"1015.png"];
        case PHIDID_MOTORCONTROL_1MOTOR:
            return [UIImage imageNamed:@"1065.png"];
        case PHIDID_MOTORCONTROL_HC_2MOTOR:
            return [UIImage imageNamed:@"1064.png"];
        case PHIDID_RFID_2OUTPUT:
            return [UIImage imageNamed:@"1023.png"];
        case PHIDID_ROTARY_TOUCH:
            return [UIImage imageNamed:@"1016.png"];
        case PHIDID_SPATIAL_ACCEL_3AXIS:
            return [UIImage imageNamed:@"1049.png"];
        case PHIDID_SPATIAL_ACCEL_GYRO_COMPASS:
            return [UIImage imageNamed:@"1056.png"];
        case PHIDID_TEMPERATURESENSOR:
            return [UIImage imageNamed:@"1051.png"];
        case PHIDID_TEMPERATURESENSOR_4:
            return [UIImage imageNamed:@"1048.png"];
        case PHIDID_TEMPERATURESENSOR_IR:
            return [UIImage imageNamed:@"1045.png"];
        case PHIDID_TEXTLCD_2x20_w_8_8_8:
            return [UIImage imageNamed:@"1203.png"];
        case PHIDID_TEXTLCD_ADAPTER:
            return [UIImage imageNamed:@"1204.png"];
        case PHIDID_UNIPOLAR_STEPPER_4MOTOR:
            return [UIImage imageNamed:@"1062.png"];
            
            //Old
        case PHIDID_ACCELEROMETER_2AXIS:
            return [UIImage imageNamed:@"1053.png"];
        case PHIDID_LED_64:
            return [UIImage imageNamed:@"1030.png"];
        case PHIDID_MOTORCONTROL_LV_2MOTOR_4INPUT:
            return [UIImage imageNamed:@"1060.png"];
        case PHIDID_PHSENSOR:
            return [UIImage imageNamed:@"1058.png"];
        case PHIDID_SERVO_1MOTOR:
            return [UIImage imageNamed:@"1000.png"];
        case PHIDID_SERVO_4MOTOR:
            return [UIImage imageNamed:@"1001.png"];
            
            //Really Old
        case PHIDID_INTERFACEKIT_0_8_8_w_LCD:
        case PHIDID_INTERFACEKIT_4_8_8:
        case PHIDID_RFID:
        case PHIDID_SERVO_1MOTOR_OLD:
        case PHIDID_SERVO_4MOTOR_OLD:
        case PHIDID_TEXTLCD_2x20:
        case PHIDID_TEXTLCD_2x20_w_0_8_8:
        case PHIDID_TEXTLED_1x8:
        case PHIDID_TEXTLED_4x8:
        case PHIDID_WEIGHTSENSOR:
        default:
            return [UIImage imageNamed:@"0000.png"];
    }
}


@end
