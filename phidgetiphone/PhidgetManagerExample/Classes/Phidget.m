//
//  Phidget.m
//  PhidgetManager
//
//  Created by Patrick Mcneil on 06/07/09.
//  Copyright 2009 Phidgets Inc.. All rights reserved.
//

#import "Phidget.h"


@implementation Phidget

- (NSString *)name
{
	const char *cname;
	CPhidget_getDeviceName(phid, &cname);
	return [NSString stringWithCString:cname encoding:NSASCIIStringEncoding];
}

- (int)serialNumber
{
	int serial;
	CPhidget_getSerialNumber(phid, &serial);
	return serial;
}

- (int)version
{
	int version;
	CPhidget_getDeviceVersion(phid, &version);
	return version;
}

- (CPhidget_DeviceID)id
{
	CPhidget_DeviceID id;
	CPhidget_getDeviceID(phid, &id);
	return id;
}

- (CPhidget_DeviceClass)class
{
	CPhidget_DeviceClass class;
	CPhidget_getDeviceClass(phid, &class);
	return class;
}

- (NSString *)serverID
{
	const char *serverID;
	CPhidget_getServerID(phid, &serverID);
	return [NSString stringWithCString:serverID encoding:NSASCIIStringEncoding];
}

- (id)initWithPhidgetHandle:(CPhidgetHandle)handle
{
	if(self = [super init])
	{
		phid = handle;
	}
	return self;
}

- (BOOL)isEqual:(id)anObject
{
	Phidget *otherPhidget = (Phidget *)anObject;
	if([self.name isEqual:otherPhidget.name] && self.serialNumber == otherPhidget.serialNumber)
		return YES;
	else
		return NO;
}

- (NSComparisonResult)caseInsensitiveCompare:(Phidget *)aPhidget
{
	NSComparisonResult res = [self.name caseInsensitiveCompare:aPhidget.name];
	if(res ==  NSOrderedSame)
	{
		if(self.serialNumber > aPhidget.serialNumber)
			res = NSOrderedDescending;
		else if(self.serialNumber < aPhidget.serialNumber)
			res = NSOrderedAscending;
	}
	return res;
}

- (NSString *)productID
{
	switch([self id])
	{
		//Current
		case PHIDID_ACCELEROMETER_3AXIS:
			return @"1059";
		case PHIDID_ADVANCEDSERVO_1MOTOR:
			return @"1066";
		case PHIDID_ADVANCEDSERVO_8MOTOR:
			return @"1061";
		case PHIDID_ANALOG_4OUTPUT:
			return @"1002";
		case PHIDID_BIPOLAR_STEPPER_1MOTOR:
			return @"1063";
		case PHIDID_BRIDGE_4INPUT:
			return @"1046";
		case PHIDID_ENCODER_1ENCODER_1INPUT:
			return @"1052";
		case PHIDID_ENCODER_HS_1ENCODER:
			return @"1057";
		case PHIDID_ENCODER_HS_4ENCODER_4INPUT:
			return @"1047";
		case PHIDID_FREQUENCYCOUNTER_2INPUT:
			return @"1054";
		case PHIDID_GPS:
			return @"1040";
		case PHIDID_INTERFACEKIT_0_0_4:
			return @"1014";
		case PHIDID_INTERFACEKIT_0_0_8:
			return @"1017";
		case PHIDID_INTERFACEKIT_0_16_16:
			return @"1012";
		case PHIDID_INTERFACEKIT_2_2_2:
			return @"1011";
		case PHIDID_INTERFACEKIT_8_8_8:
			return @"1018";
		case PHIDID_INTERFACEKIT_8_8_8_w_LCD:
			return @"1200";
		case PHIDID_IR:
			return @"1055";
		case PHIDID_LED_64_ADV:
			return @"1031";
		case PHIDID_LINEAR_TOUCH:
			return @"1015";
		case PHIDID_MOTORCONTROL_1MOTOR:
			return @"1065";
		case PHIDID_MOTORCONTROL_HC_2MOTOR:
			return @"1064";
		case PHIDID_RFID_2OUTPUT:
			return @"1023";
		case PHIDID_ROTARY_TOUCH:
			return @"1016";
		case PHIDID_SPATIAL_ACCEL_3AXIS:
			return @"1049";
		case PHIDID_SPATIAL_ACCEL_GYRO_COMPASS:
			return @"1056";
		case PHIDID_TEMPERATURESENSOR:
			return @"1051";
		case PHIDID_TEMPERATURESENSOR_4:
			return @"1048";
		case PHIDID_TEMPERATURESENSOR_IR:
			return @"1045";
		case PHIDID_TEXTLCD_2x20_w_8_8_8:
			return @"1203";
		case PHIDID_TEXTLCD_ADAPTER:
			return @"1204";
		case PHIDID_UNIPOLAR_STEPPER_4MOTOR:
			return @"1062";
			
		//Old
		case PHIDID_ACCELEROMETER_2AXIS:
			return @"1053";
		case PHIDID_LED_64:
			return @"1030";
		case PHIDID_MOTORCONTROL_LV_2MOTOR_4INPUT:
			return @"1060";
		case PHIDID_PHSENSOR:
			return @"1058";
		case PHIDID_SERVO_1MOTOR:
			return @"1000";
		case PHIDID_SERVO_4MOTOR:
			return @"1001";
		
		//Really Old
		case PHIDID_INTERFACEKIT_0_8_8_w_LCD:
		case PHIDID_INTERFACEKIT_4_8_8:
		case PHIDID_RFID:
		case PHIDID_SERVO_1MOTOR_OLD:
		case PHIDID_SERVO_4MOTOR_OLD:
		case PHIDID_TEXTLCD_2x20:
		case PHIDID_TEXTLCD_2x20_w_0_8_8:
		case PHIDID_TEXTLED_1x8:
		case PHIDID_TEXTLED_4x8:
		case PHIDID_WEIGHTSENSOR:
		default:
			return @"0000";
	}
}

@end
