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

-(void)pollPhidget:(CPTGraphHostingView*)hostView
{
    if([self numValues] == 0)
    {
        startDate = [NSDate date];
    }
    
    NSTimeInterval time = [startDate timeIntervalSinceNow] * -1.0;
    
    double value;
    LocalErrorCatcher(CPhidgetTemperatureSensor_getTemperature(phidget, 0, &value));
    
    [self addValue:[NSNumber numberWithDouble:time] values:@{IDENTIFIER: [NSNumber numberWithDouble:value]}];
    
    [self changeXAxisRange:hostView withNewValue:time];
}



-(void)configurePlot:(CPTGraphHostingView*)hostView
{
    // Create graph from theme
//    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
//    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    hostView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostView.hostedGraph     = graph;
    
//    graph.paddingLeft   = 10.0;
//    graph.paddingTop    = 10.0;
//    graph.paddingRight  = 10.0;
//    graph.paddingBottom = 10.0;
    
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)hostView.hostedGraph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)hostView.hostedGraph.axisSet;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *val = [defaults valueForKey:[self getUserDefaultsKey]];
    
    {
        double yMax = 0, yMin = 0;
        
        LocalErrorCatcher(CPhidgetTemperatureSensor_getPotentialMax(phidget, 0, &yMax));
        LocalErrorCatcher(CPhidgetTemperatureSensor_getPotentialMin(phidget, 0, &yMin));
        
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-2.0f)
                                                        length:CPTDecimalFromDouble(10.0)];
        
//        [self changeXAxisRange:hostView withNewValue:10.0];
        
        double length = fabs(yMax) + fabs(yMin);
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yMin)
                                                        length:CPTDecimalFromDouble(length)];
        
        
        
        CPTXYAxis *x          = axisSet.xAxis;
        x.majorIntervalLength         = CPTDecimalFromString(@"1.0");
        x.minorTicksPerInterval       = 0;
        
        [x setTitle:@"Time (seconds)"];
        
        
        CPTXYAxis *y = axisSet.yAxis;
//        y.majorIntervalLength         = CPTDecimalFromString(@"5.0");
        
        NSDecimalNumber *doubleDecimal = [[NSDecimalNumber alloc] initWithDouble:(yMax - yMin) / 10];

        y.majorIntervalLength = [doubleDecimal decimalValue];
        y.minorTicksPerInterval       = 1;
        
        if([val isEqualToString:@""])
        {
            [y setTitle:@"Temperature"];
        }
        else
        {
            [y setTitle:val];
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    [y setTitle:@"Temperature"];
    
//    y.delegate             = self;
    
    CPTScatterPlot *plot = [self addLinePlot:IDENTIFIER];
    plot.dataSource    = self;
    [hostView.hostedGraph addPlot:plot];
}

-(void)updatePlot:(CPTGraphHostingView*)hostView
{
    
}

-(NSString*)getCSVFileContent
{
    NSMutableString *ret = [NSMutableString stringWithFormat:@"RTC, TIME, %@\n", IDENTIFIER];
    NSString *temp;
    for(int i = 0; i < [recordedMutableArray count]; i++)
    {
        temp = [NSString stringWithFormat:@"%@, %@, %@\n",
                [self dateRecordedValue:i],
                [self xRecordedValue:i],
                [self yRecordedValue:i identifier:IDENTIFIER]];
        
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
    
    textStyle.color = [CPTColor colorWithComponentRed:0.2 green:0.6 blue:0.8 alpha:1.0];
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
