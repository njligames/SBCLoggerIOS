//
//  HomeController.h
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController : UIViewController {
    
    IBOutlet UIScrollView *scrollView;

    NSString* attach;
    IBOutlet UITextField *attachTxt;
    
    NSString* name;
    IBOutlet UITextView *nameTxt;
    
    NSInteger serial;
    IBOutlet UITextField *serialTxt;
    
    NSInteger version;
    IBOutlet UITextField *versionTxt;
    
    NSInteger digitalInputs;
    IBOutlet UITextField *digitalInputsTxt;
    
    NSInteger digitalOutputs;
    IBOutlet UITextField *digitalOutputsTxt;
    
    NSInteger analogInputs;
    IBOutlet UITextField *analogInputsTxt;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property(nonatomic, retain) NSString* attach;
@property (nonatomic, retain) IBOutlet UITextField *attachTxt;
-(void)setAttach:(NSString*)msg;

@property(nonatomic, retain) NSString* name;
@property (nonatomic, retain) IBOutlet UITextView *nameTxt;
-(void)setName:(NSString*)msg;

@property(nonatomic) NSInteger serial; 
@property (nonatomic, retain) IBOutlet UITextField *serialTxt;
-(void)setSerial:(int)aSerial;

@property(nonatomic) NSInteger version; 
@property (nonatomic, retain) IBOutlet UITextField *versionTxt;
-(void)setVersion:(int)aVersion;

@property(nonatomic) NSInteger digitalInputs; 
@property (nonatomic, retain) IBOutlet UITextField *digitalInputsTxt;
-(void)setDigitalInputs:(int)aDigitalInputs;

@property(nonatomic) NSInteger digitalOutputs; 
@property (nonatomic, retain) IBOutlet UITextField *digitalOutputsTxt;
-(void)setDigitalOutputs:(int)aDigitalOutputs;

@property(nonatomic) NSInteger analogInputs; 
@property (nonatomic, retain) IBOutlet UITextField *analogInputsTxt;
-(void)setAnalogInputs:(int)aAnalogInputs;

@end