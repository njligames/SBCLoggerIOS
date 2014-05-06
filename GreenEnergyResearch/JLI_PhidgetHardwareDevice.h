//
//  JLI_PhidgetHardwareDevice.h
//  GreenEnergyResearch
//
//  Created by James Folk on 3/13/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLI_PhidgetHardwareDevice : NSObject
{
    NSValue *_phidValue;
    
    CPhidget_DeviceClass _deviceClass;
    CPhidget_DeviceID _deviceId;
    NSString *_deviceLabel;
    NSString *_deviceName;
    int _deviceStatus;
    NSString *_deviceType;
    int _deviceVersion;
    int _serialNumber;
    NSString *_serverAddress;
    int _serverPort;
    NSString *_serverID;
    int _serverStatus;
    
    NSMutableArray *mutableArray;
    NSMutableArray *recordedMutableArray;
    BOOL recording;
    
    NSString *_serverPassword;
    
    NSDate *startDate;
}

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password;

-(NSValue*)getPhidget;
-(CPhidget_DeviceClass) getDeviceClass;
-(CPhidget_DeviceID) getDeviceId;
-(NSString*) getDeviceLabel;
-(NSString*) getDeviceName;
-(int) getDeviceStatus;
-(NSString*) getDeviceType;
-(int) getDeviceVersion;
-(int) getSerialNumber;
-(NSString*) getServerAddress;
-(int) getServerPort;
-(NSString*) getServerID;
-(int) getServerStatus;
-(NSString*)getServerPassword;

-(int)numValues;

-(NSNumber*)yRecordedValue:(int)index identifier:(NSString*)identifier;
-(NSNumber*)xRecordedValue:(int)index;

-(NSNumber*)yValue:(int)index identifier:(NSString*)identifier;
-(NSNumber*)xValue:(int)index;

-(void)addValue:(NSNumber*)time values:(NSDictionary*)values;

-(void)pollPhidget;
-(void)configurePlot:(CPTGraphHostingView*)hostView;
-(void)updatePlot:(CPTGraphHostingView*)hostView;

-(CPTScatterPlot *)addLinePlot:(NSString*)identifier;

-(NSString*)getCSVFileContent;
-(BOOL)hasRecordedData;
-(void)startRecording;
-(void)stopRecording;

@end
