//
//  JLI_GraphEditorViewController.h
//  GreenEnergyResearch
//
//  Created by James Folk on 7/13/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLI_PhidgetHardwareDevice.h"

@interface JLI_GraphEditorViewController : UIViewController

@property (strong, nonatomic) NSString *labelValue;
@property (strong, nonatomic) NSString *textFieldValue;

@property (weak, nonatomic) JLI_PhidgetHardwareDevice *phidgetHardwareDevice;

@end
