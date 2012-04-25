//
//  ScheduleViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "ScheduleViewController.h"

@implementation ScheduleViewController
@synthesize scheduledStops, areas;

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
	return [[self.scheduledStops valueForKey:area] count];
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
	NSString *stop = [[self.scheduledStops valueForKey:area] objectAtIndex:indexPath.row];
	
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *area = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	NSString *stop = [[self.scheduledStops valueForKey:area] objectAtIndex:indexPath.row];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:[NSString stringWithFormat:@"You selected %@!", stop]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    NSArray *jerichoStops = [NSArray arrayWithObjects:@"10 am Tuesdays @ 14 Oxford St", @"3 pm Wednesdays @ 23 Walton St", nil];
    NSArray *eastOxfordStops = [NSArray arrayWithObjects:@"10 am Mondays @ 11 Magdalen Rd", @"11 am Fridays @ 16 London Road", nil];
    self.scheduledStops = [NSDictionary dictionaryWithObjectsAndKeys:jerichoStops, @"Jericho", eastOxfordStops, @"East Oxford", nil];
    self.areas = [NSArray arrayWithObjects:@"Jericho", @"East Oxford", nil];
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
