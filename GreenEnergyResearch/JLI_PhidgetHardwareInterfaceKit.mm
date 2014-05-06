//
//  JLI_PhidgetHardwareInterfaceKit.m
//  GreenEnergyResearch
//
//  Created by James Folk on 3/17/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareInterfaceKit.h"
#import "JLI_AppDelegate.h"

const char *const IDENTIFIERS[8] =
{
    "ANALOG SENSOR 1",
    "ANALOG SENSOR 2",
    "ANALOG SENSOR 3",
    "ANALOG SENSOR 4",
    "ANALOG SENSOR 5",
    "ANALOG SENSOR 6",
    "ANALOG SENSOR 7",
    "ANALOG SENSOR 8"
};

@implementation JLI_PhidgetHardwareInterfaceKit

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password
{
    self = [super initWithPhidget:phid password:password];
    if (self)
    {
        LocalErrorCatcher(CPhidgetInterfaceKit_create(&phidget));
        LocalErrorCatcher(CPhidget_openRemoteIP ((CPhidgetHandle) phidget,
                                                 [self getSerialNumber],
                                                 [[self getServerAddress] UTF8String],
                                                 [self getServerPort],
                                                 [[self getServerPassword] UTF8String]));
    }
    return self;
}

-(void)dealloc
{
    
}

-(void)pollPhidget
{
    if([self numValues] == 0)
    {
        startDate = [NSDate date];
    }
    
    NSTimeInterval time = [startDate timeIntervalSinceNow] * -1.0;
    
    int count = 0;
    LocalErrorCatcher(CPhidgetInterfaceKit_getInputCount(phidget, &count));
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for(int inputIndex = 0; inputIndex < count; ++inputIndex)
    {
        int sensorValue;
        
        LocalErrorCatcher(CPhidgetInterfaceKit_getSensorValue(phidget,
                                                              inputIndex,
                                                              &sensorValue));
        
        NSNumber *val = [NSNumber numberWithInt:sensorValue];
        NSString *ident = [NSString stringWithUTF8String:IDENTIFIERS[inputIndex]];
        [mutableDictionary setObject:val forKey:ident];
    }
    
    [self addValue:[NSNumber numberWithDouble:time] values:mutableDictionary];
}

-(void)configurePlot:(CPTGraphHostingView*)hostView
{
    // Create graph from theme
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
    hostView.collapsesLayers = NO;
    hostView.hostedGraph     = graph;
    
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    
    
    
    if([self numValues] > 0)
    {
//        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0)
//                                                        length:CPTDecimalFromDouble([[self xValue:[self numValues] - 1] doubleValue])];
//        
//        double yMax = 0, yMin = 0;
//        LocalErrorCatcher(CPhidgetAccelerometer_getAccelerationMax(phidget, 0, &yMax));
//        LocalErrorCatcher(CPhidgetAccelerometer_getAccelerationMin(phidget, 0, &yMin));
//        
//        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yMin) length:CPTDecimalFromDouble(yMax)];
    }
    else
    {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0f)
                                                        length:CPTDecimalFromDouble(10.0)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-10.0) length:CPTDecimalFromDouble(70.0)];
    }
    
    
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromString(@"1.0");
    x.minorTicksPerInterval       = 0;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromString(@"1.0");
    y.minorTicksPerInterval       = 0;
    
    y.delegate             = self;
    
    
//    double *acceleration = nullptr;
    int inputCount = 0;
//    LocalErrorCatcher(CPhidgetAccelerometer_getAxisCount(phidget, &count));
//    acceleration = new double[count];
    CPhidgetInterfaceKit_getSensorCount(phidget, &inputCount);
    
//    LocalErrorCatcher(CPhidgetAccelerometer_getAcceleration(phidget, 0, acceleration));
    
    CPTScatterPlot *plot = nil;
    for(int inputIndex = 0; inputIndex < inputCount; ++inputIndex)
    {
        NSString *ident = [NSString stringWithUTF8String:IDENTIFIERS[inputIndex]];
        
        plot = [self addLinePlot:ident];
        plot.dataSource    = self;
        [graph addPlot:plot];
    }
    
//    delete [] acceleration;
}

-(void)updatePlot:(CPTGraphHostingView*)hostView
{
//    if([self numValues] == 1)
//    {
//        CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
//        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
//        
//        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0)
//                                                        length:CPTDecimalFromDouble([[self xValue:[self numValues] - 1] doubleValue])];
//        
//        double yMax = 0, yMin = 0;
//        LocalErrorCatcher(CPhidgetAccelerometer_getAccelerationMax(phidget, 0, &yMax));
//        LocalErrorCatcher(CPhidgetAccelerometer_getAccelerationMin(phidget, 0, &yMin));
//        
//        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yMin) length:CPTDecimalFromDouble(yMax)];
//    }
}

-(NSString*)getCSVFileContent
{
    NSMutableString *ret = [NSMutableString stringWithFormat:@"TIME, %s, %s, %s, %s, %s, %s, %s, %s\n", IDENTIFIERS[0], IDENTIFIERS[1], IDENTIFIERS[2], IDENTIFIERS[3], IDENTIFIERS[4], IDENTIFIERS[5], IDENTIFIERS[6], IDENTIFIERS[7]];
    
    NSString *temp;
    for(int i = 0; i < [recordedMutableArray count]; i++)
    {
        temp = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@\n",
                [self xRecordedValue:i],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[0]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[1]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[2]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[3]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[4]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[5]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[6]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[7]]]];
        
        [ret appendString:temp];
    }
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
    
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    
    textStyle.color = [CPTColor redColor];
    textStyle.fontSize = 8.0f;
    label.textStyle = textStyle;
    
    return label;
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    NSLog(@"-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations");
    return NO;
}
@end
