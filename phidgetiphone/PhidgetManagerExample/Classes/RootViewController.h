//
//  RootViewController.h
//  PhidgetManager
//
//  Created by Patrick Mcneil on 05/07/09.
//  Copyright Phidgets Inc. 2009. All rights reserved.
//

#import <phidget21.h>
#import "Phidget.h"

@interface RootViewController : UITableViewController {
	CPhidgetManagerHandle phidMan;
	NSMutableArray *phidgetList;
	BOOL initialWaitOver;
}

@property (nonatomic, assign, readwrite) BOOL initialWaitOver;

- (void)initialWaitOver:(NSTimer*)timer;
- (void)sortAndUpdateUI;

- (void)phidgetRemoved:(Phidget *)phidget;
- (void)phidgetAdded:(Phidget *)phidget;

@end
