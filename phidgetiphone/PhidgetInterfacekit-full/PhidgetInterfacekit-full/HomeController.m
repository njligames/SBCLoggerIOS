//
//  HomeController.m
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import "HomeController.h"

@implementation HomeController

@synthesize scrollView;

@synthesize attach, name, serial, version, digitalInputs, digitalOutputs, analogInputs;

@synthesize attachTxt, nameTxt, serialTxt, versionTxt, digitalInputsTxt, digitalOutputsTxt, analogInputsTxt;

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
    [scrollView release];
    [attach release];
    [attachTxt release];
    [name release];
    [nameTxt release];
    [serialTxt release];
    [versionTxt release];
    [digitalInputsTxt release];
    [digitalOutputsTxt release];
    [analogInputsTxt release];
    
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
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 430)];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    scrollView = nil;
    attach = nil;
    attachTxt = nil;
    name = nil;
    nameTxt = nil;
    serialTxt = nil;
    versionTxt = nil;
    digitalInputsTxt = nil;
    digitalOutputsTxt = nil;
    analogInputsTxt = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setAttach:(NSString*) msg{ 
    attach = [NSString stringWithFormat:@"%@", msg];
    attachTxt.text = attach;
}

-(void)setName:(NSString *)msg{
    name = [NSString stringWithFormat:@"%@", msg];
    nameTxt.text = name;
}


-(void)setSerial:(int)aSerial{
    serial = [[NSNumber numberWithInt:aSerial] intValue];
    serialTxt.text = [NSString stringWithFormat:@"%d", serial];
}

-(void)setVersion:(int)aVersion{
    version = [[NSNumber numberWithInt:aVersion] intValue];
    versionTxt.text = [NSString stringWithFormat:@"%d", version];
}

-(void)setDigitalInputs:(int)aDigitalInputs{
    digitalInputs = [[NSNumber numberWithInt:aDigitalInputs] intValue];
    digitalInputsTxt.text = [NSString stringWithFormat:@"%d", digitalInputs];
}

-(void)setDigitalOutputs:(int)aDigitalOutputs{
    digitalOutputs = [[NSNumber numberWithInt:aDigitalOutputs] intValue];
    digitalOutputsTxt.text = [NSString stringWithFormat:@"%d", digitalOutputs];
}

-(void)setAnalogInputs:(int)aAnalogInputs{
    analogInputs = [[NSNumber numberWithInt:aAnalogInputs] intValue];
    analogInputsTxt.text = [NSString stringWithFormat:@"%d", analogInputs];
 }

@end