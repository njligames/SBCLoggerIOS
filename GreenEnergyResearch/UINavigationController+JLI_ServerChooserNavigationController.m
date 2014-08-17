//
//  UINavigationController+JLI_ServerChooserNavigationController.m
//  GreenEnergyResearch
//
//  Created by James Folk on 8/17/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "UINavigationController+JLI_ServerChooserNavigationController.h"

@implementation UINavigationController (JLI_ServerChooserNavigationController)

-(BOOL)shouldAutorotate
{
    return NO;
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
