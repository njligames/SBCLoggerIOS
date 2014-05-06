//
//  DigitalInputsController.h
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DI_SWITCH_TAG 1000

@interface DigitalInputsController : UIViewController {
 
    IBOutlet UIScrollView *scrollView;
    
    NSInteger digitalInputCount;
    
    NSMutableArray *inputArray;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property(nonatomic) NSInteger digitalInputCount; 

-(void)setDigitalInputCount:(int)count;

-(void)setupControls;

-(void)setInputIndexValue:(int)inputIndex: (int)inputValue;


@end
