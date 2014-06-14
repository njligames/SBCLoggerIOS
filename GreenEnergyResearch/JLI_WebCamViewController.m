//
//  JLI_WebCamViewController.m
//  GreenEnergyResearch
//
//  Created by James Folk on 6/14/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_WebCamViewController.h"
#import "JLI_AppDelegate.h"

@interface JLI_WebCamViewController ()

@end

@implementation JLI_WebCamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate addToViewController:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateViewRatio];
}

- (void)viewWillAppear:(BOOL)animated
{
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateViewRatio];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
