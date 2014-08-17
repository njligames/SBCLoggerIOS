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
        shouldPanView = YES;
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    NSNumber *n = [self valueForKey:@"currentIndex"];
    int _currentIndex = [n integerValue];
    int sensorValue;
    
    LocalErrorCatcher(CPhidgetInterfaceKit_getSensorValue(phidget,
                                                          _currentIndex,
                                                          &sensorValue));
    NSNumber *val = [NSNumber numberWithInt:sensorValue];
    NSString *ident = [NSString stringWithUTF8String:IDENTIFIERS[_currentIndex]];
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary setObject:val forKey:ident];
    [self addValue:[NSNumber numberWithDouble:time] values:mutableDictionary];
    
    
    
    
    
    
    
    
//    int count = 0;
//    LocalErrorCatcher(CPhidgetInterfaceKit_getInputCount(phidget, &count));
//    
//    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
//    for(int inputIndex = 0; inputIndex < count; ++inputIndex)
//    {
//        int sensorValue;
//        
//        LocalErrorCatcher(CPhidgetInterfaceKit_getSensorValue(phidget,
//                                                              inputIndex,
//                                                              &sensorValue));
//        
//        NSNumber *val = [NSNumber numberWithInt:sensorValue];
//        NSString *ident = [NSString stringWithUTF8String:IDENTIFIERS[inputIndex]];
//        [mutableDictionary setObject:val forKey:ident];
//    }
//    
//    [self addValue:[NSNumber numberWithDouble:time] values:mutableDictionary];
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
    
    
    
    
    
    
    
    
    
    
    
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0f)
                                                    length:CPTDecimalFromDouble(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-10.0) length:CPTDecimalFromDouble(70.0)];
    
    
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromString(@"1.0");
    x.minorTicksPerInterval       = 0;
    
    [x setTitle:@"Time"];
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromString(@"1.0");
    y.minorTicksPerInterval       = 0;
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    NSNumber *deviceClass = [self valueForKey:@"deviceClass"];
//    NSNumber *currentIndex = [self valueForKey:@"currentIndex"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *val = [defaults valueForKey:[self getUserDefaultsKey]];
    
    if([val isEqualToString:@""])
    {
        [y setTitle:@"Y Label"];
    }
    else
    {
        [y setTitle:val];
    }
    
//    [y setTitle:[defaults valueForKey:[self getUserDefaultsKey]]];
    
//    y.delegate             = self;
    
    
    
    
    
    
    
    
    
    
    
    
    NSNumber *n = [self valueForKey:@"currentIndex"];
    int _currentIndex = [n integerValue];
    CPTScatterPlot *plot = nil;
    
    NSString *ident = [NSString stringWithUTF8String:IDENTIFIERS[_currentIndex]];
    
    plot = [self addLinePlot:ident];
    plot.dataSource    = self;
    [graph addPlot:plot];
    
    
    
    
    
    
    
    
    
//    int inputCount = 0;
//
//    CPhidgetInterfaceKit_getSensorCount(phidget, &inputCount);
//    
//
//    
//    
//    CPTScatterPlot *plot = nil;
//    for(int inputIndex = 0; inputIndex < inputCount; ++inputIndex)
//    {
//        NSString *ident = [NSString stringWithUTF8String:IDENTIFIERS[inputIndex]];
//        
//        plot = [self addLinePlot:ident];
//        plot.dataSource    = self;
//        [graph addPlot:plot];
//    }
}

-(void)updatePlot:(CPTGraphHostingView*)hostView
{
    BOOL canPanView = ([self numValues] > 0);
    
    if(canPanView && shouldPanView)
    {
        shouldPanView = NO;
        
        int lastIndex = [self numValues] - 1;
        
        NSString *identifier = [NSString stringWithUTF8String:IDENTIFIERS[0]];
        
        double time = [[self xValue:lastIndex] doubleValue];
        int value = [[self yValue:lastIndex identifier:identifier] integerValue];
        
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)hostView.hostedGraph.defaultPlotSpace;
        
        NSDecimal xFrom = CPTDecimalFromDouble(-1.0f);
        NSDecimal xLength = CPTDecimalFromDouble(10.0 + time);
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:xFrom
                                                        length:xLength];
        
        NSDecimal yFrom = CPTDecimalFromDouble(value - 10);
        NSDecimal yLength = CPTDecimalFromDouble(value / 10);
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:yFrom
                                                        length:yLength];
    }
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
