//
//  JLI_ServerChooseViewController.m
//  GreenEnergyResearch
//
//  Created by James Folk on 3/10/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_ServerChooseViewController.h"
#import "JLI_AppDelegate.h"

@interface JLI_ServerChooseViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serverTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *pollTextField;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation JLI_ServerChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_serverTextField setDelegate:(id)self];
    [_portTextField setDelegate:(id)self];
    [_passwordTextField setDelegate:(id)self];
    [_pollTextField setDelegate:(id)self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(IBAction)dismissKeyboardOnTap:(id)sender
{
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _serverTextField
        || textField == _portTextField
        || textField == _passwordTextField
        || textField == _pollTextField)
    {
        NSInteger nextTag = textField.tag + 1;
        // Try to find next responder
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        
        if (nextResponder)
        {
            // Found next responder, so set it.
            [nextResponder becomeFirstResponder];
        }
        else
        {
            // Not found, so remove keyboard.
            [textField resignFirstResponder];
            [self connect];
            NSLog(@"connect");
        }
        
        return NO;
    }
    return YES;
}

-(void)connect
{
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    int poll = [[_pollTextField text] intValue];
    NSNumber *number = [NSNumber numberWithInt:[[_pollTextField text] intValue]];
    [appDelegate setPollInterval:number];
    
//    [appDelegate setHardwareLister];
    [appDelegate connectToServer:[_serverTextField text]
                            port:[_portTextField text]
                        password:[_passwordTextField text]];
}

- (IBAction)connect:(id)sender
{
    [self connect];
    
}

- (IBAction)connect_ipad:(id)sender
{
    [self connect];
}
@end
