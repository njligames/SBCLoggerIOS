//
//  JLI_PlotViewController.m
//  GreenEnergyResearch
//
//  Created by James Folk on 3/12/14.
//  Copyright (c) 2014 James Folk. All rights reserved.
//

#import "JLI_PlotViewController.h"
#import <AddressBook/AddressBook.h>
#import "JLI_GraphEditorViewController.h"

//#import "MJPopupBackgroundView.h"

#import "UIViewController+MJPopupViewController.h"
#import "GraphEditViewController.h"

#import "JLI_AppDelegate.h"

@interface JLI_PlotViewController () <GraphEditPopupDelegate>

//@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (nonatomic, assign) NSTimer *phidgetPollTimer;
@property (nonatomic, assign) NSTimer *drawPollTimer;



//@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, assign) CPhidgetTemperatureSensorHandle device;

@end

@implementation JLI_PlotViewController


@synthesize splitViewButton = _splitViewButton;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self.splitViewController setDelegate:self];
    
//    self.clearsSelectionOnViewWillAppear = NO;
//    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)saveButtonClicked:(GraphEditViewController *)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *val = [defaults valueForKey:[self.phidgetHardware getUserDefaultsKey]];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.scatterPlotView.hostedGraph.axisSet;
    [axisSet.yAxis setTitle:val];
}

/*--------------------------------------------------------------
 * One finger, two taps
 *-------------------------------------------------------------*/
- (void)oneFingerTwoTaps
{
    MJPopupViewAnimation anim = MJPopupViewAnimationFade;
    
    GraphEditViewController *detailViewController = [[GraphEditViewController alloc] initWithNibName:@"GraphEditViewController" bundle:nil];
    
    detailViewController.delegate = self;
    [detailViewController setPhidgetHardwareDevice:_phidgetHardware];
    
    [self presentPopupViewController:detailViewController
                       animationType:anim];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // -----------------------------
    // One finger, two taps
    // -----------------------------
    
    // Create gesture recognizer
    UITapGestureRecognizer *oneFingerTwoTaps =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTwoTaps)];
    
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [[self view] addGestureRecognizer:oneFingerTwoTaps];
    
    
    
    
    
    
    
}

#pragma mark - Managing the detail item

- (void)setPhidgetPollInterval:(NSTimeInterval)interval
{
    _phidgetPollInterval = interval;
}

- (void)setPhidgetGraphDrawInterval:(NSTimeInterval)interval
{
    _phidgetGraphDrawInterval = interval;
}

- (void)setPhidgetHardware:(id)newPhidgetHardware
{
    if(_phidgetHardware != newPhidgetHardware)
    {
        _phidgetHardware = newPhidgetHardware;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            [_phidgetHardware configurePlot:self.scatterPlotView];
            
            [self stopAnimation];
            [self startAnimation];
        }
    }
    
    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(recordButton:)];
        
        UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(emailAction:)];
        emailButton.enabled = [self.phidgetHardware hasRecordedData];
        self.navigationItem.rightBarButtonItems = @[recordButton, emailButton];
        
        [_phidgetHardware configurePlot:self.scatterPlotView];
        
        [self stopAnimation];
        [self startAnimation];
    }
}

- (void)writeStringToFile:(NSString*)aString {
    
    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@.csv", [self.phidgetHardware getDeviceName]];
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
    
    
    [self writeStringToFile:[_phidgetHardware getCSVFileContent]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@.csv", [self.phidgetHardware getDeviceName]];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:filename];
    NSData *myData = [NSData dataWithContentsOfFile:fullPathToFile];
    [mc addAttachmentData:myData mimeType:@"text/csv" fileName:filename];
    
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
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
    
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(emailAction:)];
    emailButton.enabled = NO;
    self.navigationItem.rightBarButtonItems = @[stopButton, emailButton];
    
    [self.phidgetHardware startRecording];
}

- (void)stopButton:(id)sender
{
    UIBarButtonItem *recordButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(recordButton:)];
    
    UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(emailAction:)];
    emailButton.enabled = YES;
    self.navigationItem.rightBarButtonItems = @[recordButton, emailButton];
    
    [self.phidgetHardware stopRecording];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pollPhidget
{
    if(_drawPollTimer == nil)
    {
        self.drawPollTimer = [NSTimer scheduledTimerWithTimeInterval:(_phidgetGraphDrawInterval / 1000.0)
                                                              target:self
                                                            selector:@selector(drawView)
                                                            userInfo:nil
                                                             repeats:YES];
        [self drawView];
    }
    
    [self.phidgetHardware pollPhidget];
}

- (void)drawView
{
    [self.scatterPlotView.hostedGraph reloadData];
    [self.phidgetHardware updatePlot:self.scatterPlotView];
    
    
    
    
    
    
    
}

- (void)startAnimation
{
    self.phidgetPollTimer = [NSTimer scheduledTimerWithTimeInterval:(_phidgetPollInterval / 1000.0) target:self selector:@selector(pollPhidget) userInfo:nil repeats:YES];
}


- (void)stopAnimation
{
    [self.phidgetPollTimer invalidate];
    [self.drawPollTimer invalidate];
    
    self.phidgetPollTimer = nil;
    self.drawPollTimer = nil;
}

//#pragma mark - Split view
//
//- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
//{
//    barButtonItem.title = NSLocalizedString(@"Hardware List", @"Hardware List");
//    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    self.masterPopoverController = popoverController;
//}
//
//- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    // Called when the view is shown again in the split view, invalidating the button and popover controller.
//    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
//    self.masterPopoverController = nil;
//}
//
//-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
//{
//    return YES;
//}





























// I observe the rotation in my detailview's navigationcontroller like this.
// We track this on the navigation controller to globally reset the master hidden state to where it needs to be. This won't take into account previously passed completion blocks. If needed that can be handled in the view controller implementing the hideable splitview.
// Again - additional things will need to be considered if supporting portrait - like resetting if we rotate to a portrait orientation.
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    JLI_AppDelegate *appDelegate = (JLI_AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    [appDelegate updateHideMasterOnRotation];
//}


//- (IBAction)touchUpInside:(id)sender
//{
//    __weak JLI_AppDelegate  *delegate = (JLI_AppDelegate*)[UIApplication sharedApplication].delegate;
//    __weak UISplitViewController *splitView = (UISplitViewController*)delegate.window.rootViewController;
//
//}



#pragma mark - Split view

#pragma mark - Split View Handler
-(void) turnSplitViewButtonOn: (UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *) popoverController {
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    _splitViewButton = barButtonItem;
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

-(void)turnSplitViewButtonOff {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    _splitViewButton = nil;
    self.masterPopoverController = nil;
    
}

-(void) setSplitViewButton:(UIBarButtonItem *)splitViewButton forPopoverController:(UIPopoverController *)popoverController {
    if (splitViewButton != _splitViewButton) {
        if (splitViewButton) {
            [self turnSplitViewButtonOn:splitViewButton forPopoverController:popoverController];
        } else {
            [self turnSplitViewButtonOff];
        }
    }
}


@end
