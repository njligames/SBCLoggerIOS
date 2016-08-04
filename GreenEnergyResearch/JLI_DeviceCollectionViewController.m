//
//  JLI_DeviceCollectionViewController.m
//  GreenEnergyResearch
//
//  Created by James Folk on 8/2/16.
//  Copyright © 2016 James Folk. All rights reserved.
//

#import "JLI_DeviceCollectionViewController.h"
#import "JLI_AppDelegate.h"
#import "JLI_PlotViewController.h"

@implementation JLI_DeviceCollectionViewController

- (void)deviceAttached:(NSNotification *)notif
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.collectionView reloadData];
    });
    
//    JLI_DeviceCollectionViewController *vc = [notif object];
//    [vc reloadInputViews];
    
//    JLI_HardwareListTableViewController *vc = [notif object];
//    [vc reloadTable];
}

- (void)deviceDetached:(NSNotification *)notif
{
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.collectionView reloadData];
    });
    
//    JLI_DeviceCollectionViewController *vc = [notif object];
//    [vc reloadInputViews];
    
//    JLI_HardwareListTableViewController *vc = [notif object];
//    [vc reloadTable];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"com.jamesfolk.greenenergyresearch.deviceAttached" object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"com.jamesfolk.greenenergyresearch.deviceDetached" object:self];

    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAttached:) name:@"com.jamesfolk.greenenergyresearch.deviceAttached" object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDetached:) name:@"com.jamesfolk.greenenergyresearch.deviceDetached" object:self];
    
//    devicePhotos = [NSArray arrayWithObjects:
//                    @"1000.png",
//                    @"1001.png",
//                    @"1002.png",
//                    @"1012.png",
//                    @"1014.png",
//                    @"1015.png",
//                    @"1016.png",
//                    @"1017.png",
//                    @"1018.png",
//                    @"1019.png",
//                    @"1023.png",
//                    @"1030.png",
//                    @"1031.png",
//                    @"1040.png",
//                    @"1045.png",
//                    @"1047.png",
//                    @"1047.png",
//                    @"1049.png",
//                    @"1051.png",
//                    @"1052.png",
//                    @"1053.png",
//                    @"1055.png",
//                    @"1056.png",
//                    @"1057.png",
//                    @"1058.png",
//                    @"1059.png",
//                    @"1060.png",
//                    @"1061.png",
//                    @"1062.png",
//                    @"1063.png",
//                    @"1064.png",
//                    @"1066.png",
//                    @"1070.png",
//                    @"1200.png",
//                    @"1203.png",
//                    nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
//    return devicePhotos.count;
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [appDelegate getHardwareCount];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image = [appDelegate phidgetHardwareIcon:indexPath.row];
    
    UILabel *labelView = (UILabel*)[cell viewWithTag:200];
    labelView.text = [appDelegate phidgetHardwareName:indexPath.row];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-selected.png"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectHardwareItem:indexPath.row];
}

-(void)selectHardwareItem:(NSInteger)index
{
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
        JLI_PlotViewController *newController = nil;
        
//        if(index == 0)
//        {
//            newController = [storyboard instantiateViewControllerWithIdentifier:@"WebCamViewController"];
//        }
//        else
        {
            newController = [storyboard instantiateViewControllerWithIdentifier:@"PlotViewController"];
            newController.phidgetGraphDrawInterval = [[appDelegate pollInterval] doubleValue];
            newController.phidgetPollInterval = [[appDelegate pollInterval] doubleValue];
            
            id object = [appDelegate getPhidgetHardwareIndex:index];
            newController.phidgetHardware = object;
            
            UIBarButtonItem *button = self.navigationItem.rightBarButtonItems[0];
            button.enabled = YES;
            
        }
        
        UINavigationController *navController = [[[self splitViewController ] viewControllers ] lastObject ];
        JLI_PlotViewController *oldController = [[navController viewControllers] firstObject];
        
        NSArray *newStack = [NSArray arrayWithObjects:newController, nil ];
        [navController setViewControllers:newStack];
        
        UIBarButtonItem *splitViewButton = [[oldController navigationItem] leftBarButtonItem];
        UIPopoverController *popoverController = [oldController masterPopoverController];
        [newController setSplitViewButton:splitViewButton forPopoverController:popoverController];
        
        // see if we should be hidden
        if (!UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
        {
            // we are in portrait mode so go away
            [popoverController dismissPopoverAnimated:YES];
        }
    }
    else 
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        
        
//        if(index == 0)
//        {
//            JLI_PlotViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebCamViewController"];
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else
        {
            JLI_PlotViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PlotViewController"];
            
            [vc setPhidgetGraphDrawInterval:[[appDelegate pollInterval] doubleValue]];
            [vc setPhidgetPollInterval:[[appDelegate pollInterval] doubleValue]];
            
            id object = [appDelegate getPhidgetHardwareIndex:index];
            [vc setPhidgetHardware:object];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


@end
