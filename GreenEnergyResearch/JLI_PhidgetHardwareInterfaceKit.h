//
//  JLI_PhidgetHardwareInterfaceKit.h
//  GreenEnergyResearch
//
//  Created by James Folk on 3/17/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareDevice.h"

@interface JLI_PhidgetHardwareInterfaceKit : JLI_PhidgetHardwareDevice <CPTPlotDataSource, CPTAxisDelegate>
{
    CPhidgetInterfaceKitHandle phidget;
    BOOL shouldPanView;
}

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password;

-(void)pollPhidget;
-(void)configurePlot:(CPTGraphHostingView*)hostView;
-(void)updatePlot:(CPTGraphHostingView*)hostView;

-(NSString*)getCSVFileContent;

@end
