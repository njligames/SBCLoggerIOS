//
//  ServerDetailsController.h
//  PhidgetInterfacekit-full
//
//  Created by Phidgets.
//  Copyright 2011 Phidgets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerDetailsController : UIViewController {
    IBOutlet UILabel *introTxt;
    IBOutlet UITextField *IPAddressTxt;
    IBOutlet UITextField *portTxt;
    IBOutlet UITextField *passwordTxt;
    NSString *serverConnectError;
    IBOutlet UILabel *serverConnectErrorLabel;
    IBOutlet UIButton *connectBtn;
    IBOutlet UILabel *connectStatus;  
    BOOL connecting;
    NSTimer *timer;
}

-(IBAction)keyboardRemove:(id) sender;
-(IBAction)tapBackground: (id) sender;
    
-(IBAction)connectToServer;

@property (nonatomic, retain) IBOutlet UITextField *IPAddressTxt;
@property (nonatomic, retain) IBOutlet UITextField *portTxt;
@property (nonatomic, retain) IBOutlet UITextField *passwordTxt;
@property (nonatomic, retain) IBOutlet NSString *serverConnectError;
@property (nonatomic, retain) IBOutlet UILabel *serverConnectErrorLabel;
@property (nonatomic, retain) IBOutlet UIButton *connectBtn;
@property (nonatomic, retain) IBOutlet UILabel *connectStatus;   

@property (nonatomic, retain) NSTimer *timer;
@property(nonatomic) BOOL connecting;

-(void)serverStatusChanged:(NSString*)msg;

@end