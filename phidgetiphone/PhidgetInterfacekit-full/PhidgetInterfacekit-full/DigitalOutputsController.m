//
//  DigitalOutputsController.m
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import "DigitalOutputsController.h"
#import "PhidgetInterfacekit_fullAppDelegate.h" 

@implementation DigitalOutputsController

@synthesize scrollView;
@synthesize digitalOutputCount;

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
    [outputArray release];
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
    [scrollView setContentSize:CGSizeMake(320, 80 + digitalOutputCount*45)];
    //the size should depend on the number of digital outputs available
    
    [self setupControls];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    scrollView = nil;
    outputArray = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setDigitalOutputCount:(int)count{
    digitalOutputCount = [[NSNumber numberWithInt:count] intValue];
}

-(void)setupControls{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    for(int i=0; i< digitalOutputCount; i++){   
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, i*40 + 65, 100, 27)];
        aLabel.text = [NSString stringWithFormat:@"%d", i];
         
        UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(130, i*40 + 65, 0, 0)];
        [aSwitch setTag:DO_SWITCH_TAG+i];
        
        [aSwitch addTarget:self action:@selector(outputSwitchChange:) forControlEvents: UIControlEventValueChanged];
    
        BOOL outputValue = [[outputArray objectAtIndex:i] boolValue];
        [aSwitch setOn:outputValue animated:NO];
    
        [self.scrollView addSubview:aLabel];
        [self.scrollView addSubview:aSwitch];
        
    }    
    
    [pool release];
    
}

-(void)setOutputIndexValue:(int)outputIndex : (int)outputValue{
    
    if(outputArray == nil){
        outputArray = [[NSMutableArray alloc] init];
        
        for(int i=0; i<digitalOutputCount; i++){
            [outputArray insertObject:[NSNumber numberWithBool:NO] atIndex:i];
        }
    }    

    [outputArray replaceObjectAtIndex:outputIndex withObject:[NSNumber numberWithBool:outputValue]];
    
    //update the switch only if it has been created
    UISwitch *temp = (UISwitch*)[self.scrollView viewWithTag:(DO_SWITCH_TAG + outputIndex)];
    if(temp != nil){
        [temp setOn:outputValue animated:NO];
    }
    
}

-(void)outputSwitchChange:(id)sender{
    
    UISwitch *aSwitch = (UISwitch*)[self.view viewWithTag:[sender tag]];
    
    BOOL outputState = aSwitch.isOn;
    
    PhidgetInterfacekit_fullAppDelegate * app = (PhidgetInterfacekit_fullAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    CPhidgetInterfaceKit_setOutputState([app getPhid], [sender tag] - DO_SWITCH_TAG, (int)outputState);  
    
}


@end
