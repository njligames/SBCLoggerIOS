//
//  JLI_PhidgetHardwareDevice.m
//  GreenEnergyResearch
//
//  Created by James Folk on 3/13/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareDevice.h"
#import "JLI_AppDelegate.h"

@implementation JLI_PhidgetHardwareDevice

@synthesize currentIndex;
//@synthesize yAxisTitle;

- (BOOL)isEqual:(id)object
{
    int serialNumber = -1;
    
    // JLI_PhidgetHardwareDevice allows a comparison to NSNumber
    if ([object isKindOfClass:[NSNumber class]])
    {
        NSNumber *other = object;
        serialNumber = [other intValue];
    }
    if ([object isKindOfClass:[NSValue class]]) {
        NSValue * other = object;
        return [self getPhidget] == other;
    }
    else if (![object isKindOfClass:self.class])
    {
        return NO;
    }
    else
    {
        JLI_PhidgetHardwareDevice * other = object;
        serialNumber = [other getSerialNumber];
    }
    
    return [self getSerialNumber] == serialNumber;
}

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password;
{
    self = [super init];
    if (self)
    {
        _phidValue = phid;
        
        const char * buffer;
        
        CPhidget_getDeviceClass((CPhidgetHandle)[phid pointerValue], &_deviceClass);
        CPhidget_getDeviceID((CPhidgetHandle)[phid pointerValue], &_deviceId);
        CPhidget_getDeviceLabel((CPhidgetHandle)[phid pointerValue], &buffer);
        _deviceLabel = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
        
        CPhidget_getDeviceName((CPhidgetHandle)[phid pointerValue], &buffer);
        _deviceName = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
        
        CPhidget_getDeviceStatus((CPhidgetHandle)[phid pointerValue], &_deviceStatus);
        CPhidget_getDeviceType((CPhidgetHandle)[phid pointerValue], &buffer);
        _deviceType = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
        
        CPhidget_getDeviceVersion((CPhidgetHandle)[phid pointerValue], &_deviceVersion);
        CPhidget_getSerialNumber((CPhidgetHandle)[phid pointerValue], &_serialNumber);
        CPhidget_getServerAddress((CPhidgetHandle)[phid pointerValue], &buffer, &_serverPort);
        _serverAddress = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
        
        CPhidget_getServerID((CPhidgetHandle)[phid pointerValue], &buffer);
        _serverID = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
        
        CPhidget_getServerStatus((CPhidgetHandle)[phid pointerValue], &_serverStatus);
        
        mutableArray = [[NSMutableArray alloc] init];
        recordedMutableArray = [[NSMutableArray alloc] init];
        
        _serverPassword = [[NSString alloc] initWithString:password];
    }
    
    return self;
}

-(NSValue*)getPhidget
{
    return _phidValue;
}

-(CPhidget_DeviceClass) getDeviceClass
{
    return _deviceClass;
}
-(CPhidget_DeviceID) getDeviceId
{
    return _deviceId;
}
-(NSString*) getDeviceLabel
{
    return _deviceLabel;
}
-(NSString*) getDeviceName
{
    return _deviceName;
}
-(int) getDeviceStatus
{
    return _deviceStatus;
}
-(NSString*) getDeviceType
{
    return _deviceType;
}
-(int) getDeviceVersion
{
    return _deviceVersion;
}
-(int) getSerialNumber
{
    return _serialNumber;
}
-(NSString*) getServerAddress
{
    return _serverAddress;
}
-(int) getServerPort
{
    return _serverPort;
}
-(NSString*) getServerID
{
    return _serverID;
}
-(int) getServerStatus
{
    return _serverStatus;
}

-(NSString*)getServerPassword
{
    return _serverPassword;
}


-(int)numValues
{
    return [mutableArray count];
}

-(NSNumber*)yRecordedValue:(int)index identifier:(NSString*)identifier
{
    NSDictionary *d = [recordedMutableArray objectAtIndex:index];
    
    d = [d objectForKey:@"values"];
    
    return [d objectForKey:identifier];
}
-(NSNumber*)xRecordedValue:(int)index
{
    NSDictionary *d = [recordedMutableArray objectAtIndex:index];
    
    return [d objectForKey:@"time"];
}

-(NSNumber*)yValue:(int)index identifier:(NSString*)identifier
{
    NSDictionary *d = [mutableArray objectAtIndex:index];
    
    d = [d objectForKey:@"values"];
    
    return [d objectForKey:identifier];
}

-(NSNumber*)xValue:(int)index
{
    NSDictionary *d = [mutableArray objectAtIndex:index];
    
    return [d objectForKey:@"time"];
}

-(void)addValue:(NSNumber*)time values:(NSDictionary*)values
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          values,@"values",
                          time,@"time", nil];
    [mutableArray addObject:dict];
    
    if(recording)
    {
        [recordedMutableArray addObject:dict];
    }
}

-(void)pollPhidget
{
    [self doesNotRecognizeSelector:_cmd];
    
}
-(void)configurePlot:(CPTGraphHostingView*)hostView
{
    [self doesNotRecognizeSelector:_cmd];
}
-(void)updatePlot:(CPTGraphHostingView*)hostView
{
    [self doesNotRecognizeSelector:_cmd];
}

-(CPTScatterPlot *)addLinePlot:(NSString*)identifier
{
    // Create a IDENTIFIER_X plot area
    CPTScatterPlot *boundLinePlot  = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = identifier;
//    boundLinePlot.dataSource    = self;
//    [graph addPlot:boundLinePlot];
    
    // Add plot symbols
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor greenColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(10.0, 10.0);
    boundLinePlot.plotSymbol = plotSymbol;
    
    return boundLinePlot;
}

-(NSString*)getCSVFileContent
{
    [self doesNotRecognizeSelector:_cmd];
    return @"";
}

-(BOOL)hasRecordedData
{
    return [recordedMutableArray count] > 0 && !recording;
}
-(void)startRecording
{
    recording = YES;
}
-(void)stopRecording
{
    recording = NO;
}

-(NSString*)getUserDefaultsKey
{
    return [NSString stringWithFormat:@"deviceClass=%@, currentIndex=%@",
            [self valueForKey:@"deviceClass"],
            [self valueForKey:@"currentIndex"]];
}
//CPTXYAxisSet *axisSet = (CPTXYAxisSet *)hostView.hostedGraph.axisSet;
//-(CPTXYAxisSet*)getAxisSet
//{
//    return (CPTXYAxisSet *)hostView.hostedGraph.axisSet;
//}
@end
