//
//  ScheduleViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "ScheduleViewController.h"

@implementation ScheduleViewController
@synthesize areas, managedObjectContext, scheduledStopStringsByArea, sidvc, removeSIDVCPane, stopsForEachItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [areas count]; // adjust for multiple areas
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [areas objectAtIndex:section];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeaderView* headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 45.0) areaTitle:[areas objectAtIndex:section] delegate:self];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSString *area = [self tableView:tableView titleForHeaderInSection:section];
	return [[self.scheduledStopStringsByArea valueForKey:area] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduledStopCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
         
        [switchview addTarget:self action:@selector(accessorySwitchChanged:withEvent:) forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = switchview;
        
    }
    
    // Configure the cell...
	NSString *area = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	NSString *stop = [[self.scheduledStopStringsByArea valueForKey:area] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = stop;
    [cell.textLabel setFont:[UIFont systemFontOfSize:10.0]];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (void)accessorySwitchChanged:(UIControl*)button withEvent:(UIEvent*)event
{
    UISwitch *switch1 = (UISwitch *)button;
    UITableViewCell *cell = (UITableViewCell *)switch1.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //NSIndexPath * indexPath = [showLocationTableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: showLocationTableView]];
    if ( indexPath == nil )
        return;
    
    VegVanStopNotification *notification = [[VegVanStopNotification alloc] initWithStopName:@"Jericho / 65 Walton St" day:25 month: 4 year:2012 hour:16 minute:00 minutesBefore:5];
    [Utilities scheduleNotificationWithItem:notification];
    
    NSLog(@"switch changed in section %i and row %i", [indexPath section], [indexPath row]);
}
                            
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

-(NSInteger)getAbsoluteRowNumberForIndexPath:(NSIndexPath*)indexPath andArea: (NSString*)area
{
    NSInteger absoluteRow = 0;
    
    for (int i = 0; i<indexPath.section; i++)
    { 
        absoluteRow += [[self.scheduledStopStringsByArea valueForKey:area] count];
    }
    
    absoluteRow += indexPath.row;
    
    return absoluteRow;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *area = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	NSString *stop = [[self.scheduledStopStringsByArea valueForKey:area] objectAtIndex:indexPath.row];
	
    if (sidvc == nil)
    {
        sidvc = [[ScheduleItemDetailViewController alloc] initWithNibName:@"ScheduleItemDetailView" bundle:nil];
        [self.view addSubview: sidvc.view];
        [sidvc addGestureRecognizers];
        [sidvc.view setFrame: CGRectMake(320.0,0.0,sidvc.view.frame.size.width, sidvc.view.frame.size.height)];
        [sidvc setDelegate: self];
        [sidvc prettify];
    }
    
    // get stop and set sidvc parameters
    NSInteger absoluteIndex = [self getAbsoluteRowNumberForIndexPath:indexPath andArea: area];
    NSLog(@"absoluteIndex = %i", absoluteIndex);
    VegVanStop *vegVanStop = [[[[Utilities sharedAppDelegate] vegVanStopManager] vegVanStops] objectForKey: [stopsForEachItem objectAtIndex: absoluteIndex]];
    [vegVanStop description];
    [[sidvc stopName] setText: [vegVanStop name]];
    [[sidvc stopAddress] setText: [vegVanStop addressAsString]];
    [[sidvc stopBlurb] setText: [vegVanStop blurb]];
    //[sdivc setStopImage
    [[sidvc stopManager] setText: [vegVanStop manager]];
    
    CGRect frame = CGRectMake(42.0,0.0,sidvc.view.frame.size.width, sidvc.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    sidvc.view.frame = frame;
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector: @selector(quizViewCleared)];
    [UIView commitAnimations];
    
    // add touch sensitive pane
    removeSIDVCPane = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,42.0,480.0)];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSIDVC)];
    [removeSIDVCPane addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:removeSIDVCPane];
    /*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:[NSString stringWithFormat:@"You selected %@!", stop]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	*/
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)hideSIDVC
{
    [removeSIDVCPane removeFromSuperview];
    CGRect frame = CGRectMake(320.0,0.0,sidvc.view.frame.size.width, sidvc.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    sidvc.view.frame = frame;
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector: @selector(quizViewCleared)];
    [UIView commitAnimations];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
      
    self.stopsForEachItem = [[[Utilities sharedAppDelegate] vegVanStopManager] stopsForScheduledItems];
    self.scheduledStopStringsByArea = [[[Utilities sharedAppDelegate] vegVanStopManager] scheduledStopStringsByArea];
    //NSArray *jerichoStops = [NSArray arrayWithObjects:@"10 am Tuesdays @ 14 Oxford St", @"3 pm Wednesdays @ 23 Walton St", nil];
    //NSArray *eastOxfordStops = [NSArray arrayWithObjects:@"10 am Mondays @ 11 Magdalen Rd", @"11 am Fridays @ 16 London Road", nil];
    //self.scheduledStops = [NSDictionary dictionaryWithObjectsAndKeys:jerichoStops, @"Jericho", eastOxfordStops, @"East Oxford", nil];
    self.areas = [[[Utilities sharedAppDelegate] vegVanStopManager] vegVanStopAreas];
    //[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scheduledStops" ofType:@"plist"]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
