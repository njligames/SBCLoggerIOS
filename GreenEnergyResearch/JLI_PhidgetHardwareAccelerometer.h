//
//  JLI_PhidgetHardwareAccelerometer.h
//  GreenEnergyResearch
//
//  Created by James Folk on 3/19/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareDevice.h"

@interface JLI_PhidgetHardwareAccelerometer : JLI_PhidgetHardwareDevice <CPTPlotDataSource, CPTAxisDelegate>
{
    CPhidgetAccelerometerHandle phidget;
}

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password;

-(void)pollPhidget:(CPTGraphHostingView*)hostView;
-(void)configurePlot:(CPTGraphHostingView*)hostView;
-(void)updatePlot:(CPTGraphHostingView*)hostView;

-(NSString*)getCSVFileContent;

@end
