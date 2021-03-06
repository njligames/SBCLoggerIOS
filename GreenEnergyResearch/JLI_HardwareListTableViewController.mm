//
//  JLI_HardwareListTableViewController.m
//  GreenEnergyResearch
//
//  Created by James Folk on 3/12/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_HardwareListTableViewController.h"

#import "JLI_AppDelegate.h"
#import "JLI_PlotViewController.h"
#import "JLI_WebCamViewController.h"

@interface JLI_HardwareListTableViewController ()

@end

@implementation JLI_HardwareListTableViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
        
//        UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(recordButton:)];
//        recordButton.enabled = NO;
//        
//        UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(emailAction:)];
//        emailButton.enabled = NO;
        
//        self.navigationItem.rightBarButtonItems = @[recordButton, emailButton];
        
        [self.splitViewController setDelegate:self];
        
        
    }
    [super awakeFromNib];
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"com.jamesfolk.greenenergyresearch.updatehardware" object:self];
}

- (void)updateHardware:(NSNotification *)notif
{
    JLI_HardwareListTableViewController *vc = [notif object];
    [vc reloadTable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.plotViewController = (JLI_PlotViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHardware:) name:@"com.jamesfolk.greenenergyresearch.updatehardware" object:self];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [self selectHardwareItem:0];
    }
}

- (void)writeStringToFile:(NSString*)aString {
    
    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@.csv", [self.plotViewController.phidgetHardware getDeviceName]];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

-(void)emailAction:(id)sender
{
    // Email Subject
    NSString *emailTitle = @"Logged Data";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"jamesfolk1@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    
    [self writeStringToFile:[self.plotViewController.phidgetHardware getCSVFileContent]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@.csv", [self.plotViewController.phidgetHardware getDeviceName]];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:filename];
    NSData *myData = [NSData dataWithContentsOfFile:fullPathToFile];
    [mc addAttachmentData:myData mimeType:@"text/csv" fileName:filename];
    
    UIView *the_view = self.plotViewController.view;
    UIGraphicsBeginImageContextWithOptions(the_view.bounds.size, NO, [UIScreen mainScreen].scale);
    [the_view drawViewHierarchyInRect:the_view.bounds afterScreenUpdates:YES];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *screenShot = UIImageJPEGRepresentation(capturedImage, 1);
    [mc addAttachmentData:screenShot mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"screenshot.jpg"]];
    
    
    NSData *photoData = UIImageJPEGRepresentation([UIImage imageNamed:@"logo"], 1);
    [mc addAttachmentData:photoData mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"logo.jpg"]];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)recordButton:(id)sender
{
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopButton:)];
    stopButton.enabled = YES;
    
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(emailAction:)];
    emailButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItems = @[stopButton, emailButton];
    
    [self.plotViewController.phidgetHardware startRecording];
}

- (void)stopButton:(id)sender
{
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(recordButton:)];
    recordButton.enabled = YES;
    
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(emailAction:)];
    emailButton.enabled = YES;
    
    self.navigationItem.rightBarButtonItems = @[recordButton, emailButton];
    
    [self.plotViewController.phidgetHardware stopRecording];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [appDelegate getHardwareCount] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"Web Camera";
    }
    else
    {
        JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        cell.textLabel.text = [[appDelegate getPhidgetHardwareIndex:indexPath.row - 1] getDeviceName];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectHardwareItem:indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    id dest = [segue destinationViewController];
    if(indexPath.row == 0)
    {
        dest = [segue destinationViewController];
        
    }
    else
    {
        [[segue destinationViewController] setPhidgetGraphDrawInterval:[[appDelegate pollInterval] doubleValue]];
        [[segue destinationViewController] setPhidgetPollInterval:[[appDelegate pollInterval] doubleValue]];
        
        id object = [appDelegate getPhidgetHardwareIndex:indexPath.row];
        [[segue destinationViewController] setPhidgetHardware:object];
    }
    
//    if ([[segue identifier] isEqualToString:@"showDetail"])
//    {
//        id dest = nil;
//        if(indexPath.row == 0)
//        {
//            dest = [segue destinationViewController];
//            
//        }
//        else
//        {
//            [[segue destinationViewController] setPhidgetGraphDrawInterval:[[appDelegate pollInterval] doubleValue]];
//            [[segue destinationViewController] setPhidgetPollInterval:[[appDelegate pollInterval] doubleValue]];
//            
//            id object = [appDelegate getPhidgetHardware:indexPath.row];
//            [[segue destinationViewController] setPhidgetHardware:object];
//        }
//    }
//    
//    else if ([[segue identifier] isEqualToString:@"showWebcam"])
//    {
//        
//    }
}

-(void)reloadTable
{
    [self.tableView reloadData];
}


#pragma mark - Split View Delegate
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    UINavigationController *navController = [[[self splitViewController ] viewControllers ] lastObject ];
    JLI_PlotViewController *vc = [[navController viewControllers] firstObject];
    
    [vc setSplitViewButton:barButtonItem forPopoverController:popoverController];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    UINavigationController *navController = [[[self splitViewController ] viewControllers ] lastObject ];
    JLI_PlotViewController *vc = [[navController viewControllers] firstObject];
    
    [vc setSplitViewButton:nil forPopoverController:nil];
}


-(void)selectHardwareItem:(NSInteger)index
{
    JLI_AppDelegate *appDelegate = (JLI_AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
        JLI_PlotViewController *newController = nil;
        
        if(index == 0)
        {
            newController = [storyboard instantiateViewControllerWithIdentifier:@"WebCamViewController"];
        }
        else
        {
            newController = [storyboard instantiateViewControllerWithIdentifier:@"PlotViewController"];
            newController.phidgetGraphDrawInterval = [[appDelegate pollInterval] doubleValue];
            newController.phidgetPollInterval = [[appDelegate pollInterval] doubleValue];
            
            id object = [appDelegate getPhidgetHardwareIndex:index - 1];
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
        
        
        if(index == 0)
        {
            JLI_PlotViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WebCamViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            JLI_PlotViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PlotViewController"];
            
            [vc setPhidgetGraphDrawInterval:[[appDelegate pollInterval] doubleValue]];
            [vc setPhidgetPollInterval:[[appDelegate pollInterval] doubleValue]];
            
            id object = [appDelegate getPhidgetHardwareIndex:index - 1];
            [vc setPhidgetHardware:object];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
