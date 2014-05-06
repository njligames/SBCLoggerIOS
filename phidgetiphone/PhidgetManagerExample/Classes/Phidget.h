//
//  Phidget.h
//  PhidgetManager
//
//  Created by Patrick Mcneil on 06/07/09.
//  Copyright 2009 Phidgets Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "phidget21.h"

@interface Phidget : NSObject {
	CPhidgetHandle phid;
}

@property (readonly) NSString * name;
@property (readonly) int serialNumber;
@property (readonly) CPhidget_DeviceID id;
@property (readonly) NSString *productID;
@property (readonly) int version;
@property (readonly) CPhidget_DeviceClass class;
@property (readonly) NSString *serverID;

- (id)initWithPhidgetHandle:(CPhidgetHandle)handle;
- (BOOL)isEqual:(id)anObject;
- (NSComparisonResult)caseInsensitiveCompare:(Phidget *)aPhidget;

@end
