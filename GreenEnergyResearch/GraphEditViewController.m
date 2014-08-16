//
//  GraphEditViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "GraphEditViewController.h"

@implementation GraphEditViewController

@synthesize phidgetHardwareDevice;

- (IBAction)saveTouchUpInside:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    id value = [self.textField text];
    
    [defaults setValue:value forKey:[self.phidgetHardwareDevice getUserDefaultsKey]];
    
    [defaults synchronize];
    
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(saveButtonClicked:)])
    {
        [self.delegate saveButtonClicked:self];
    }
    
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *val = [defaults valueForKey:[self.phidgetHardwareDevice getUserDefaultsKey]];
    [self.textField setText:val];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}
@end

//@implementation GraphEditViewController
//
//@synthesize delegate;
////@synthesize textField;
//
//- (IBAction)savePressed:(id)sender
//{
//    if (self.delegate &&
//        [self.delegate respondsToSelector:@selector(saveButtonClicked:)])
//    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        
//        
////        [defaults setValue:textField.text forKey:[self.phidgetHardwareDevice getUserDefaultsKey]];
//        
//        [defaults synchronize];
//        
//        [self.delegate saveButtonClicked:self];
//    }
//}
//
//@end
