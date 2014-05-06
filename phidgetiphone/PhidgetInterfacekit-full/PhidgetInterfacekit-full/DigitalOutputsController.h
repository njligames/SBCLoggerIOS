//
//  DigitalOutputsController.h
//  PhidgetInterfacekit-full
//
//  Created by Phidgets
//  Copyright 2011 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DO_SWITCH_TAG 2000

@interface DigitalOutputsController : UIViewController {
  
    IBOutlet UIScrollView *scrollView;
  
    NSInteger digitalOutputCount;

    NSMutableArray *outputArray;
    
}


@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property(nonatomic) NSInteger digitalOutputCount; 
-(void)setDigitalOutputCount:(int)count;

-(void)setupControls;

-(void)setOutputIndexValue:(int)outputIndex: (int)outputValue;

@end
