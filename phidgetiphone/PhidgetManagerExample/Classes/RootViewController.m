//
//  RootViewController.m
//  PhidgetManager
//
//  Created by Patrick Mcneil on 05/07/09.
//  Copyright Phidgets Inc. 2009. All rights reserved.
//

#import "RootViewController.h"

#define kProgressIndicatorSize 20.0

int gotAttach(CPhidgetHandle phid, void *context) {
	Phidget *phidget = [[Phidget alloc] initWithPhidgetHandle:phid];
	[(id)context performSelectorOnMainThread:@selector(phidgetAdded:)
						   withObject:phidget
						waitUntilDone:YES];
	[phidget release];
	return 0;
}

int gotDetach(CPhidgetHandle phid, void *context) {
	Phidget *phidget = [[Phidget alloc] initWithPhidgetHandle:phid];
	[(id)context performSelectorOnMainThread:@selector(phidgetRemoved:)
								  withObject:phidget
							   waitUntilDone:YES];
	[phidget release];
	return 0;
}

@implementation RootViewController

@synthesize initialWaitOver;

- (void)phidgetAdded:(Phidget *)phidget
{
	[phidgetList addObject:phidget];
	[phidgetList sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[phidgetList indexOfObject:phidget] inSection:0];
	
	//because there is always one row in the list (searching for phidets...)
	if([phidgetList count] == 1)
		[self sortAndUpdateUI];
	else
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];}

- (void)phidgetRemoved:(Phidget *)phidget
{
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[phidgetList indexOfObject:phidget] inSection:0];
	[phidgetList removeObject:phidget];
	
	if([phidgetList count] == 0)
		[self sortAndUpdateUI];
	else
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	phidgetList = [[NSMutableArray alloc] init];
	
	CPhidgetManager_create(&phidMan);
	
	CPhidgetManager_set_OnAttach_Handler(phidMan, gotAttach, self);
	CPhidgetManager_set_OnDetach_Handler(phidMan, gotDetach, self);
	
	CPhidgetManager_openRemote(phidMan, NULL, NULL);
	
	// Make sure we have a chance to discover devices before showing the user that nothing was found (yet)
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(initialWaitOver:) userInfo:nil repeats:NO];
}

- (void)initialWaitOver:(NSTimer*)timer {
	self.initialWaitOver= YES;
	if (![phidgetList count])
		[self.tableView reloadData];
}

- (void)sortAndUpdateUI {
	// Sort the devices by name.
	[phidgetList sortUsingSelector:@selector(caseInsensitiveCompare:)];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
	CPhidgetManager_close(phidMan);
	CPhidgetManager_delete(phidMan);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSUInteger count = [phidgetList count];
	if (count == 0 && self.initialWaitOver)
		return 1;
	
	return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DiscoveredCellIdentifier = @"DiscoveredPhidget";
    static NSString *SearchingCellIdentifier = @"Searching";
	
	NSUInteger count = [phidgetList count];
	if (count == 0) {
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchingCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchingCellIdentifier] autorelease];
		}	
		
        // If there are no services and searchingForServicesString is set, show one row explaining that to the user.
        cell.textLabel.text = @"Searching for Phidgets...";
		cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		CGRect frame = CGRectMake(0.0, 0.0, kProgressIndicatorSize, kProgressIndicatorSize);
		UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		[spinner startAnimating];
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[spinner sizeToFit];
		spinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
									UIViewAutoresizingFlexibleRightMargin |
									UIViewAutoresizingFlexibleTopMargin |
									UIViewAutoresizingFlexibleBottomMargin);
		cell.accessoryView = spinner;
		
		return cell;
	}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscoveredCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DiscoveredCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }	
	
	// Configure the cell.
	Phidget *phidget = (Phidget *)[phidgetList objectAtIndex:indexPath.row];
	cell.textLabel.text = [phidget.name substringFromIndex:8];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d - %@", phidget.serialNumber, phidget.serverID];
	
	UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[phidget productID]]];
	
	//resize it to fill the cell
	//this smooths the image but on retina display, we on't get half-pixels for some reason...
	//I should really just have two versions of each pic which are already the right size
	/*if(img)
	{
		float height = cell.contentView.frame.size.height;
		UIGraphicsBeginImageContext(CGSizeMake(height,height));
		[img drawInRect:CGRectMake(0,0,height,height)];
		img = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}*/
	
	cell.imageView.image = img;

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([phidgetList count] == 0)
		return nil;
	return indexPath;
}

- (void)dealloc {
    [super dealloc];
}


@end

