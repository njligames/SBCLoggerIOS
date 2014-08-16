//
//  JLI_PlotViewController.h
//  GreenEnergyResearch
//
//  Created by James Folk on 3/12/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JLI_PhidgetHardwareDevice.h"
#import <MessageUI/MessageUI.h>
#import "SplitViewButtonHandler.h"

@interface JLI_PlotViewController : UIViewController <
//UIAlertViewDelegate,
MFMailComposeViewControllerDelegate,
SplitViewButtonHandler>

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *scatterPlotView;

//@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) JLI_PhidgetHardwareDevice *phidgetHardware;
@property (nonatomic, assign) NSTimeInterval phidgetPollInterval;
@property (nonatomic, assign) NSTimeInterval phidgetGraphDrawInterval;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end
