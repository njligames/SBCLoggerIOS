//
//  JLI_GraphEditorViewController.m
//  GreenEnergyResearch
//
//  Created by James Folk on 7/13/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_GraphEditorViewController.h"

@interface JLI_GraphEditorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end


@implementation JLI_GraphEditorViewController

@synthesize labelValue;
@synthesize textFieldValue;
@synthesize phidgetHardwareDevice;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _label.text = labelValue;
    _textField.text = textFieldValue;
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

- (IBAction)saveButtonPressed:(id)sender
{
//    [[self phidgetHardwareDevice] setYAxisTitle:_textField.text];
    [self.navigationController popViewControllerAnimated:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    /*
     [phidgetHardwareDevice setValue:[NSNumber numberWithInt:deviceClass]
     forKey:@"deviceClass"];currentIndex
     */
//    NSNumber *deviceClass = [self.phidgetHardwareDevice valueForKey:@"deviceClass"];
//    NSNumber *currentIndex = [self.phidgetHardwareDevice valueForKey:@"currentIndex"];
    
    
    [defaults setValue:_textField.text forKey:[self.phidgetHardwareDevice getUserDefaultsKey]];
    
    [defaults synchronize];
}



@end
