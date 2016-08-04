//
//  JLI_PhidgetHardwareSpatial.h
//  GreenEnergyResearch
//
//  Created by James Folk on 8/4/16.
//  Copyright © 2016 James Folk. All rights reserved.
//

#import "JLI_PhidgetHardwareDevice.h"

@interface JLI_PhidgetHardwareSpatial : JLI_PhidgetHardwareDevice <CPTPlotDataSource, CPTAxisDelegate>
{
    CPhidgetSpatialHandle phidget;
}

- (id)initWithPhidget:(NSValue *)phid password:(NSString*)password;

-(void)pollPhidget:(CPTGraphHostingView*)hostView;
-(void)configurePlot:(CPTGraphHostingView*)hostView;
-(void)updatePlot:(CPTGraphHostingView*)hostView;

-(NSString*)getCSVFileContent;

@end
