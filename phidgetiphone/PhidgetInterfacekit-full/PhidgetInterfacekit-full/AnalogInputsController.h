//
//  AnalogInputsController.h
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AI_SlIDER_TAG 3000
#define AI_LABEL_TAG 4000

@interface AnalogInputsController : UIViewController {
    IBOutlet UIScrollView *scrollView;
    
    NSInteger analogInputCount;
    
    NSMutableArray *analogInputArray;
    
    IBOutlet UISwitch *ratiometricSwitch;
    
    IBOutlet UISlider *sensitivitySlider;
    IBOutlet UILabel *sensitivityLabel;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UISwitch *ratiometricSwitch;

@property (nonatomic, retain) IBOutlet UISlider *sensitivitySlider;
@property (nonatomic, retain) IBOutlet UILabel *sensitivityLabel;

@property (nonatomic) NSInteger analogInputCount; 
-(void)setAnalogInputCount:(int)count;

-(void)setupControls;

-(void)setAnalogIndexValue:(int)sensorIndex: (int)sensorValue;

-(IBAction)setPhidgetRatiometric:(id)sender;

-(IBAction)setPhidgetSensitivity:(id)sender;

@end