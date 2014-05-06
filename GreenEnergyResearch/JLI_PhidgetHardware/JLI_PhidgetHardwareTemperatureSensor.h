//
//  JLI_PhidgetHardwareTemperatureSensor.h
//  GreenEnergyResearch
//
//  Created by James Folk on 3/17/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareDevice.h"

@interface JLI_PhidgetHardwareTemperatureSensor : JLI_PhidgetHardwareDevice <CPTPlotDataSource, CPTAxisDelegate>
{
    CPhidgetTemperatureSensorHandle phidget;
}

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password;

-(void)pollPhidget;
-(void)configurePlot:(CPTGraphHostingView*)hostView;
-(void)updatePlot:(CPTGraphHostingView*)hostView;

-(NSString*)getCSVFileContent;

@end
