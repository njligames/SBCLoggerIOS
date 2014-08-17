//
//  JLI_PhidgetHardwareAccelerometer.m
//  GreenEnergyResearch
//
//  Created by James Folk on 3/19/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareAccelerometer.h"
#import "JLI_AppDelegate.h"

const char *const IDENTIFIERS[3] = {"X AXIS", "Y AXIS", "Z AXIS"};

@implementation JLI_PhidgetHardwareAccelerometer

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password
{
    self = [super initWithPhidget:phid password:password];
    if (self)
    {
        LocalErrorCatcher(CPhidgetAccelerometer_create(&phidget));
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
    LocalErrorCatcher(CPhidgetAccelerometer_getAxisCount(phidget, &count));
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for(int axis = 0; axis < count; ++axis)
    {
        double acceleration;
        LocalErrorCatcher(CPhidgetAccelerometer_getAcceleration(phidget, axis, &acceleration));
        NSNumber *acc = [NSNumber numberWithDouble:acceleration];
        NSString *ident = [NSString stringWithUTF8String:IDENTIFIERS[axis]];
        [mutableDictionary setObject:acc forKey:ident];
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
    
    
    {
        double yMax = 0, yMin = 0;
        LocalErrorCatcher(CPhidgetAccelerometer_getAccelerationMax(phidget, 0, &yMax));
        LocalErrorCatcher(CPhidgetAccelerometer_getAccelerationMin(phidget, 0, &yMin));
        
        
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0f)
                                                        length:CPTDecimalFromDouble(10.0)];
        
        double length = fabs(yMax) + fabs(yMin);
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yMin)
                                                        length:CPTDecimalFromDouble(length)];
    }
    
    
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromString(@"1.0");
    x.minorTicksPerInterval       = 0;
    
//    x.delegate = self;
    
//    x.title = @"JAMESFOLK";
    [x setTitle:@"Time (seconds)"];
    
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromString(@"1.0");
    y.minorTicksPerInterval       = 0;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *val = [defaults valueForKey:[self getUserDefaultsKey]];
    
    if([val isEqualToString:@""])
    {
        [y setTitle:@"Acceleration (G)"];
    }
    else
    {
        [y setTitle:val];
    }
    
    
//    [y setTitle:@"Acceleration (G)"];
    
//    y.delegate             = self;
    
    
//    double *acceleration = nullptr;
    int count = 0;
    LocalErrorCatcher(CPhidgetAccelerometer_getAxisCount(phidget, &count));
//    acceleration = new double[count];
    
//    LocalErrorCatcher(CPhidgetAccelerometer_getAcceleration(phidget, 0, acceleration));
    
    CPTScatterPlot *plot = nil;
    for(int axis = 0; axis < count; ++axis)
    {
        NSString *ident = [NSString stringWithUTF8String:IDENTIFIERS[axis]];
        
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
    NSMutableString *ret = [NSMutableString stringWithFormat:@"TIME, %s, %s, %s\n", IDENTIFIERS[0], IDENTIFIERS[1], IDENTIFIERS[2]];
    
    NSString *temp;
    for(int i = 0; i < [recordedMutableArray count]; i++)
    {
        temp = [NSString stringWithFormat:@"%@, %@, %@, %@\n",
                [self xRecordedValue:i],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[0]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[1]]],
                [self yRecordedValue:i identifier:[NSString stringWithUTF8String:IDENTIFIERS[2]]]];
        
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
