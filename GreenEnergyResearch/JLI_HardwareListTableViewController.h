//
//  JLI_HardwareListTableViewController.h
//  GreenEnergyResearch
//
//  Created by James Folk on 3/12/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class JLI_PlotViewController;
@class JLI_WebCamViewController;

@interface JLI_HardwareListTableViewController : UITableViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) JLI_PlotViewController *plotViewController;
@property (strong, nonatomic) JLI_WebCamViewController *webcamViewController;

-(void)reloadTable;

@end

