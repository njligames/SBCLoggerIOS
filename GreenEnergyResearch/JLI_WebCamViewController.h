//
//  JLI_WebCamViewController.h
//  GreenEnergyResearch
//
//  Created by James Folk on 6/14/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewButtonHandler.h"

@interface JLI_WebCamViewController : UIViewController <SplitViewButtonHandler>
{
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end
