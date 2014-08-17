//
//  JLI_AppDelegate.h
//  GreenEnergyResearch
//
//  Created by James Folk on 3/10/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

extern NSString *LocalErrorCatcher (int errorCode);

#ifndef ERROR_LOGGER
#define ERROR_LOGGER


#endif

#import <UIKit/UIKit.h>
#import "JLI_PhidgetHardwareDevice.h"
#import "MotionJpegImageView.h"


@interface JLI_AppDelegate : UIResponder <UIApplicationDelegate>
{
@private
    MotionJpegImageView *_imageView;
    UIWebView *_webView;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *phidgetHardwareArray;
@property (strong, nonatomic) NSNumber *pollInterval;
@property (strong, nonatomic) NSDate *startDate;
@property ( nonatomic) BOOL masterIsHidden;

- (void)connectToServer:(NSString*)server port:(NSString*)port password:(NSString*)password;

-(void)setServerChooser:(NSValue *)phidHandle;
-(void)setHardwareLister:(NSValue *)phidHandle;

-(void)addHardware:(NSValue*)phid;
-(void)removeHardware:(NSValue*)phid;
-(NSUInteger)getHardwareCount;
-(JLI_PhidgetHardwareDevice*)getPhidgetHardware:(NSInteger)index;

+(JLI_PhidgetHardwareDevice*)createPhidget:(NSValue*)phid;

//-(int)getSerialNumber:(NSInteger)index;
//-(NSString*)getDeviceName:(NSInteger)index;

-(void)addToViewController:(UIView*)v;

- (CGRect)updateViewRatio;

- (void)updateHideMasterOnRotation;

@end
