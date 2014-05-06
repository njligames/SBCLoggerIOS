//
//  ServerDetailsController.m
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import "ServerDetailsController.h"

#import "PhidgetInterfacekit_fullAppDelegate.h" 

@implementation ServerDetailsController

@synthesize IPAddressTxt, portTxt, passwordTxt;
@synthesize serverConnectError, serverConnectErrorLabel;
@synthesize connectBtn, connectStatus, timer, connecting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [IPAddressTxt release];
    [portTxt release];
    [passwordTxt release];
    [serverConnectError release];
    [serverConnectErrorLabel release];
    [connectBtn release];
    [connectStatus release];
    [timer release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    connecting = NO;
    [IPAddressTxt setPlaceholder:@"e.g, 192.168.2.163"];
    [IPAddressTxt setKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
    
    [portTxt setPlaceholder:@"e.g, 5001"];
    [portTxt setKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
    
    [passwordTxt setPlaceholder:@"Optional - e.g, pw"];
    
    serverConnectErrorLabel.text = serverConnectError;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    IPAddressTxt = nil;
    portTxt = nil;
    passwordTxt = nil;
    serverConnectError = nil;
    serverConnectErrorLabel = nil;
    connectBtn = nil;
    connectStatus = nil;
    timer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)keyboardRemove:(id) sender{
    [sender resignFirstResponder];
}

-(IBAction) tapBackground: (id) sender{
    [IPAddressTxt resignFirstResponder];
    [portTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
}


-(IBAction)connectToServer{
        
    PhidgetInterfacekit_fullAppDelegate * app = (PhidgetInterfacekit_fullAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [app connectToPhidget:IPAddressTxt.text: portTxt.text: passwordTxt.text];

    if(!connecting){
        timer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(hideLabel) userInfo:nil repeats: YES];
        connecting = YES;        
    }
}


-(void)serverStatusChanged:(NSString*)msg{ 

    if([msg length] == 0){ 
        [serverConnectErrorLabel setHidden:YES];
        [timer invalidate];
        timer = nil; 
        connecting = NO;
        [connectStatus setHidden:YES];
    }else{ 
        [serverConnectErrorLabel setHidden:NO];
        
        serverConnectErrorLabel.text = msg;
        serverConnectError = msg;  //makes a copy of the error message so that this view can use it when the view loads
    }
}

-(void)hideLabel{
    [connectStatus setHidden:!connectStatus.hidden];
}

@end
