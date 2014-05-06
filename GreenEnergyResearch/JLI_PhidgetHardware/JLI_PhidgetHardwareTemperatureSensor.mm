//
//  JLI_PhidgetHardwareTemperatureSensor.m
//  GreenEnergyResearch
//
//  Created by James Folk on 3/17/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareTemperatureSensor.h"
#import "JLI_AppDelegate.h"

@implementation JLI_PhidgetHardwareTemperatureSensor

#define IDENTIFIER @"TEMPERATURE"

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password
{
    self = [super initWithPhidget:phid password:password];
    if (self)
    {
        LocalErrorCatcher(CPhidgetTemperatureSensor_create(&phidget));
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
    
    double value;
    LocalErrorCatcher(CPhidgetTemperatureSensor_getTemperature(phidget, 0, &value));
    
    [self addValue:[NSNumber numberWithDouble:time] values:@{IDENTIFIER: [NSNumber numberWithDouble:value]}];
}

-(void)configurePlot:(CPTGraphHostingView*)hostView
{
    // Create graph from theme
//    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
//    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    hostView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostView.hostedGraph     = graph;
    
//    graph.paddingLeft   = 10.0;
//    graph.paddingTop    = 10.0;
//    graph.paddingRight  = 10.0;
//    graph.paddingBottom = 10.0;
    
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    
    
    
    if([self numValues] > 0)
    {
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0)
                                                        length:CPTDecimalFromDouble([[self xValue:[self numValues] - 1] doubleValue])];
        
        double yMax = 0, yMin = 0;
        CPhidgetTemperatureSensor_getPotentialMax(phidget, 0, &yMax);
        CPhidgetTemperatureSensor_getPotentialMin(phidget, 0, &yMin);
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yMin) length:CPTDecimalFromDouble(yMax)];
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
    
    CPTScatterPlot *plot = [self addLinePlot:IDENTIFIER];
    plot.dataSource    = self;
    [graph addPlot:plot];
}

-(void)updatePlot:(CPTGraphHostingView*)hostView
{
    if([self numValues] == 1)
    {
        CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
        
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0)
                                                        length:CPTDecimalFromDouble([[self xValue:[self numValues] - 1] doubleValue])];
        
        double yMax = 0, yMin = 0;
        CPhidgetTemperatureSensor_getPotentialMax(phidget, 0, &yMax);
        CPhidgetTemperatureSensor_getPotentialMin(phidget, 0, &yMin);
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yMin) length:CPTDecimalFromDouble(yMax)];
    }
    
}

-(NSString*)getCSVFileContent
{
    NSMutableString *ret = [NSMutableString stringWithFormat:@"TIME, %@\n", IDENTIFIER];
    NSString *temp;
    for(int i = 0; i < [recordedMutableArray count]; i++)
    {
        temp = [NSString stringWithFormat:@"%@, %@\n", [self xRecordedValue:i], [self yRecordedValue:i identifier:IDENTIFIER]];
        
        [ret appendString:temp];
    }
    return ret;
}

#pragma mark - Plot Data Source

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self numValues];
}

//-(double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;
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