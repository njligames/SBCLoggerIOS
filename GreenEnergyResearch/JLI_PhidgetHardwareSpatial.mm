//
//  JLI_PhidgetHardwareSpatial.m
//  GreenEnergyResearch
//
//  Created by James Folk on 8/4/16.
//  Copyright © 2016 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareSpatial.h"
#import "JLI_AppDelegate.h"

//accelX, accelY, accelZ, angularX, angularY, angularZ, magneticX, magneticY, magneticZ
const char *const IDENTIFIERS[9] =
{
    "ACCELERATION X-AXIS", "ACCELERATION Y-AXIS", "ACCELERATION Z-AXIS",
    "ANGULAR X-AXIS", "ANGULAR Y-AXIS", "ANGULAR Z-AXIS",
    "MAGNETIC X-AXIS", "MAGNETIC Y-AXIS", "MAGNETIC Z-AXIS"
};

@implementation JLI_PhidgetHardwareSpatial

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password
{
    self = [super initWithPhidget:phid password:password];
    if (self)
    {
        LocalErrorCatcher(CPhidgetSpatial_create(&phidget));
        LocalErrorCatcher(CPhidget_openRemoteIP ((CPhidgetHandle) phidget,
                                                 [self getSerialNumber],
                                                 [[self getServerAddress] UTF8String],
                                                 [self getServerPort],
                                                 [[self getServerPassword] UTF8String]));
    }
    return self;
}

-(void)pollPhidget:(CPTGraphHostingView*)hostView
{
    
}

-(void)configurePlot:(CPTGraphHostingView*)hostView
{
    
}

-(void)updatePlot:(CPTGraphHostingView*)hostView
{
    
}

-(NSString*)getCSVFileContent
{
    NSMutableString *ret = [NSMutableString stringWithFormat:@"RTC, TIME, %s, %s, %s, %s, %s, %s, %s, %s, %s\n",
                            IDENTIFIERS[0], IDENTIFIERS[1], IDENTIFIERS[2],
                            IDENTIFIERS[3], IDENTIFIERS[4], IDENTIFIERS[5],
                            IDENTIFIERS[6], IDENTIFIERS[7], IDENTIFIERS[8]];
    return ret;
}

#pragma mark - Plot Data Source

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self numValues];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;
{
    if(index < [self numValues])
    {
        switch (fieldEnum)
        {
            case CPTScatterPlotFieldX:
                return [self xValue:index];
            case CPTScatterPlotFieldY:
                return [self yValue:index identifier:plot.identifier];
        }
    }
    
    return nil;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@", [self yValue:index identifier:plot.identifier]]];
    
//    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
//    
//    textStyle.color = [CPTColor colorWithComponentRed:0.2 green:0.6 blue:0.8 alpha:1.0];
//    textStyle.fontSize = 8.0f;
//    label.textStyle = textStyle;
    
    return label;
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
//    NSLog(@"-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations");
    return NO;
}

@end
