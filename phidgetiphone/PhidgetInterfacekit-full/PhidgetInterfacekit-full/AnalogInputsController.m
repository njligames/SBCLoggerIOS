//
//  AnalogInputsController.m
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import "AnalogInputsController.h"

#import "PhidgetInterfacekit_fullAppDelegate.h" 

@implementation AnalogInputsController

@synthesize scrollView;
@synthesize analogInputCount;

@synthesize ratiometricSwitch;
@synthesize sensitivitySlider, sensitivityLabel;

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
    [analogInputArray release];
    [ratiometricSwitch release];
    [sensitivityLabel release];
    [sensitivityLabel release];
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
    [scrollView setContentSize:CGSizeMake(320, 120 + analogInputCount*45)];
    
    [self setupControls];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    scrollView = nil;
    analogInputArray = nil;
    ratiometricSwitch = nil;
    sensitivityLabel = nil;
    sensitivitySlider = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)setAnalogInputCount:(int)count{
    analogInputCount = [[NSNumber numberWithInt:count] intValue];
 
}

-(void)setupControls{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int defaultSensitivity = 10;
    for(int i=0; i< analogInputCount; i++){   
  
        UILabel *sensorIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, i*40+153, 100, 27)];
        sensorIndexLabel.text = [NSString stringWithFormat:@"%d", i];
        
        UISlider *aSlider = [[UISlider alloc] initWithFrame:CGRectMake(140, i*40 + 145, 118, 40)];
        [aSlider setTag:AI_SlIDER_TAG+i];
        [aSlider setMinimumValue:0.00];
        [aSlider setMaximumValue:1000.00];
        [aSlider setContinuous:YES];
        [aSlider setEnabled:NO];
        
        PhidgetInterfacekit_fullAppDelegate * app = (PhidgetInterfacekit_fullAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        for(int j=0; j<analogInputCount; j++){
            CPhidgetInterfaceKit_setSensorChangeTrigger([app getPhid], j,  defaultSensitivity);
        }

        CPhidgetInterfaceKit_setRatiometric([app getPhid], NO);
        
        UILabel *sensorValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(264, i*40+153, 100, 27)];
        [sensorValueLabel setTag:AI_LABEL_TAG+i];
        sensorValueLabel.text = [NSString stringWithFormat:@"%d", defaultSensitivity];
        
        int sensorValue = [[analogInputArray objectAtIndex:i] intValue];
     
      
        [aSlider setValue:sensorValue];
         sensorValueLabel.text = [NSString stringWithFormat:@"%d", sensorValue];
        
        [self.scrollView addSubview:sensorIndexLabel];
        [self.scrollView addSubview:aSlider];
        [self.scrollView addSubview:sensorValueLabel];
        
        
    }
    
    [pool release];
    
}

-(void)setAnalogIndexValue:(int)sensorIndex: (int)sensorValue{

    if(analogInputArray == nil){
        analogInputArray = [[NSMutableArray alloc] init];
        
        for(int i=0; i<analogInputCount; i++){
            [analogInputArray insertObject:[NSNumber numberWithInt:0] atIndex:i];
        }
    }    
    
    [analogInputArray replaceObjectAtIndex:sensorIndex withObject:[NSNumber numberWithInt:sensorValue]];
    
    //update the switch only if it has been created
    UISlider *sensorValueSlider = (UISlider*)[self.scrollView viewWithTag:(AI_SlIDER_TAG + sensorIndex)];
    UILabel *sensorValueLabel = (UILabel*)[self.scrollView viewWithTag:(AI_LABEL_TAG + sensorIndex)];
    if(sensorValueSlider != nil){  
         [sensorValueSlider setValue:sensorValue];
          sensorValueLabel.text = [NSString stringWithFormat:@"%d", sensorValue];
    }
    
}

-(IBAction)setPhidgetRatiometric:(id)sender{
    UISwitch *aSwitch = (UISwitch*)sender;
    
    BOOL ratiometricState = aSwitch.isOn;
    
    PhidgetInterfacekit_fullAppDelegate * app = (PhidgetInterfacekit_fullAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    CPhidgetInterfaceKit_setRatiometric([app getPhid], (int)ratiometricState);
}


-(IBAction)setPhidgetSensitivity:(id)sender{
    UISlider *aSlider = (UISlider*)sender;
    
    int sensitivityValue = (int)aSlider.value;
    
    sensitivityLabel.text = [NSString stringWithFormat:@"%d", sensitivityValue];
                           
    PhidgetInterfacekit_fullAppDelegate * app = (PhidgetInterfacekit_fullAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    for(int i=0; i<analogInputCount; i++){
        
        
        CPhidgetInterfaceKit_setSensorChangeTrigger([app getPhid], i , sensitivityValue);
    }
    
}


@end
