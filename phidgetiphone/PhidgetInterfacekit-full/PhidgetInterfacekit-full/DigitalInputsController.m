//
//  DigitalInputsController.m
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import "DigitalInputsController.h"

#import "PhidgetInterfacekit_fullAppDelegate.h" 

@implementation DigitalInputsController

@synthesize scrollView;
@synthesize digitalInputCount;

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
    [inputArray release];
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
    [scrollView setContentSize:CGSizeMake(320, 80 + digitalInputCount*45)];
    
    [self setupControls];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    scrollView = nil;
    inputArray = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)setDigitalInputCount:(int)count{
    digitalInputCount = [[NSNumber numberWithInt:count] intValue];
}

-(void)setupControls{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    for(int i=0; i< digitalInputCount; i++){   
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, i*40 + 65, 100, 27)];
        aLabel.text = [NSString stringWithFormat:@"%d", i];
        
        UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(130, i*40 + 65, 0, 0)];
        [aSwitch setTag:DI_SWITCH_TAG+i];
        [aSwitch setEnabled:NO];
        
        BOOL inputValue = [[inputArray objectAtIndex:i] boolValue];
        [aSwitch setOn:inputValue animated:NO];
        
        [self.scrollView addSubview:aLabel];
        [self.scrollView addSubview:aSwitch];
        
    }    
    
    [pool release];
    
}

-(void)setInputIndexValue:(int)inputIndex : (int)inputValue{
    if(inputArray == nil){
        inputArray = [[NSMutableArray alloc] init];
        
        for(int i=0; i<digitalInputCount; i++){
            [inputArray insertObject:[NSNumber numberWithBool:NO] atIndex:i];
        }
    }    
    
    [inputArray replaceObjectAtIndex:inputIndex withObject:[NSNumber numberWithBool:inputValue]];
    
    //update the switch only if it has been created
    UISwitch *temp = (UISwitch*)[self.scrollView viewWithTag:(DI_SWITCH_TAG + inputIndex)];
    if(temp != nil){ 
        [temp setOn:inputValue animated:NO];
    }
    
}

@end
