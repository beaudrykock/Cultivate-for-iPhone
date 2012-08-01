//
//  ScheduleViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "ScheduleViewController.h"

@implementation ScheduleViewController
@synthesize areas, managedObjectContext, scheduledStopStringsByArea, sidvc, removeSIDVCPane, stopsForEachItem, background, settingsBackground, notificationSettingsViewController, overlay, vegVanScheduleItems, stopsByArea, accessorySwitchIndexPath;

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

-(VegVanStop*)stopForArea:(NSString*)area andIndexPath:(NSIndexPath*)indexPath
{
    NSArray *stopsInArea = (NSArray*)[self.stopsByArea objectForKey:area];
    
    return [stopsInArea objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduledStopCell";
    NSString *area = [self tableView:self.tableView titleForHeaderInSection:indexPath.section];
    NSInteger absoluteIndex = [self getAbsoluteRowNumberForIndexPath:indexPath andArea: area];
    VegVanStop *vegVanStop = [self stopForArea:area andIndexPath:indexPath];
    if ([vegVanScheduleItems count] <= absoluteIndex)
    {
        [vegVanScheduleItems addObject: [vegVanStop getNextScheduledStop]];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
         
        if ([self localNotificationInSystemForStopAtIndex:absoluteIndex]) 
        {
            [switchview setOn: YES animated: NO];
        }
        
        [switchview addTarget:self action:@selector(accessorySwitchChanged:withEvent:) forControlEvents:UIControlEventValueChanged];
        
        if (![Utilities localNotificationsEnabled])
            [switchview setEnabled: NO];
        
        cell.accessoryView = switchview;
    }
    else 
    {
        UISwitch *switchview = (UISwitch*)cell.accessoryView;
        if ([self localNotificationInSystemForStopAtIndex:absoluteIndex]) 
        {
            [switchview setOn: YES animated: NO];
        }
        else 
        {
            [switchview setOn: NO animated: NO];
        }
        
        if (![Utilities localNotificationsEnabled])
            [switchview setEnabled: NO];
    }
	cell.textLabel.text = [vegVanStop name];//[vegVanStop addressAsString];
    cell.detailTextLabel.text = [vegVanStop nextStopTimeAndDurationAsStringLessFrequency];
    cell.textLabel.font = [UIFont fontWithName:kTextFont size: 16.0];
    cell.detailTextLabel.font = [UIFont fontWithName:kTextFont size: 16.0];
    
    NSString* imageFilename = [[NSBundle mainBundle] pathForResource:@"cultivan" ofType:@"png"];
    UIImage *image = [Utilities scale: [[UIImage alloc] initWithContentsOfFile:imageFilename] toSize: CGSizeMake(40.0,30.0)];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    cell.imageView.image = image;//[[UIImage alloc] initWithContentsOfFile:testImageFilename];
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)accessorySwitchChanged:(UIControl*)button withEvent:(UIEvent*)event
{
    UISwitch *switch1 = (UISwitch *)button;
    
    UITableViewCell *cell = (UITableViewCell *)switch1.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.accessorySwitchIndexPath = indexPath;
    //NSIndexPath * indexPath = [showLocationTableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: showLocationTableView]];
    if ( indexPath == nil )
        return;
    
    NSString *area = [self tableView:self.tableView titleForHeaderInSection:indexPath.section];
    NSInteger absoluteIndex = [self getAbsoluteRowNumberForIndexPath:indexPath andArea: area];
    VegVanStop *vegVanStop = [self stopForArea:area andIndexPath:indexPath];
    
    if ([switch1 isOn])
    {
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:kNotificationEvent
                                             action:@"Activate notification"
                                              label:@""
                                              value:0
                                          withError:&error]) {
            NSLog(@"GANTracker error, %@", [error localizedDescription]);
        }
    }
    else {
        
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:kNotificationEvent
                                             action:@"Deactivate notification"
                                              label:@""
                                              value:0
                                          withError:&error]) {
            NSLog(@"GANTracker error, %@", [error localizedDescription]);
        }
    }
    
    if ([switch1 isOn] && ![Utilities applySettingsToAllNotifications])
    {
        [self promptForNotificationSettingsWithStop:vegVanStop andItem:[vegVanScheduleItems objectAtIndex: absoluteIndex]];
    }
    else if ([switch1 isOn] && [Utilities applySettingsToAllNotifications])
    {
        VegVanStopNotification *notification = [[VegVanStopNotification alloc] initWithVegVanScheduleItem: [vegVanScheduleItems objectAtIndex: absoluteIndex] andRepeat:[Utilities getDefaultRepeatPattern] andSecondsBefore:[Utilities getDefaultSecondsBefore]];
        
        [notification scheduleNotification];
    }
    else
    {
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        BOOL found = NO;
        NSInteger counter = 0;
        NSInteger foundIndex = -1;
        UILocalNotification* notif = nil;
        while (!found && counter < [notifications count])
        {
            notif = [notifications objectAtIndex: counter];
            NSDictionary *userinfo = notif.userInfo;
            NSNumber *itemHash = [userinfo objectForKey: kScheduleItemRefKey]; 
            if ([itemHash intValue] == [[self.vegVanScheduleItems objectAtIndex: absoluteIndex] hash])
            {
                found = YES;
                foundIndex = counter;
                
            }
            counter++;
            
            if (found) break;
        }
        
        if (found)
            [[UIApplication sharedApplication] cancelLocalNotification:[notifications objectAtIndex: foundIndex]];
    }
    //NSLog(@"switch changed in section %i and row %i", [indexPath section], [indexPath row]);
}

-(BOOL)localNotificationInSystemForStopAtIndex:(NSInteger)index
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //NSLog(@"notifications in memory = %i", [notifications count]);
    
    BOOL found = NO;
    NSInteger counter = 0;
    UILocalNotification* notif = nil;
    while (!found && counter < [notifications count])
    {
        notif = [notifications objectAtIndex: counter];
        //NSLog(@"alertbody = %@", notif.alertBody);
        NSDictionary *userinfo = notif.userInfo;
        NSNumber *itemHash = [userinfo objectForKey: kScheduleItemRefKey]; 
        //NSLog(@"notification hash = %i", [itemHash intValue]);
        //NSLog(@"stored item hash = %i", [[self.vegVanScheduleItems objectAtIndex: index] hash]);
        if ([itemHash intValue] == [[self.vegVanScheduleItems objectAtIndex: index] hash])
        {
            found = YES;
        }
        counter++;
        
        if (found) break;
    }
    return found;
}

-(void)promptForNotificationSettingsWithStop:(VegVanStop*)vegVanStop andItem:(VegVanScheduleItem*)item
{
    self.tableView.scrollEnabled = NO;
    
    settingsBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    [settingsBackground setBackgroundColor:[UIColor clearColor]];
    overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [overlay setAlpha:0.0];
    [settingsBackground addSubview:overlay];
    UITapGestureRecognizer *tapToCancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotificationSettingsViewControllerAndRestoreSwitch)];
    [self.overlay addGestureRecognizer:tapToCancel];
    
    [self.view addSubview:settingsBackground];
    
    notificationSettingsViewController = [[NotificationSettingsViewController alloc] init];
    [notificationSettingsViewController setVegVanStop: vegVanStop];
    [notificationSettingsViewController setDelegate:self];
    [notificationSettingsViewController setVegVanScheduleItem:item];
    [notificationSettingsViewController.view setFrame:CGRectMake(0.0, -294.0, notificationSettingsViewController.view.frame.size.width, notificationSettingsViewController.view.frame.size.height)];
    CGRect animateToFrame = notificationSettingsViewController.view.frame;
    animateToFrame.origin.y = 0.0;
    [self.view addSubview:notificationSettingsViewController.view];
    [UIView beginAnimations:nil context:NULL];  
    
    [UIView setAnimationDuration:0.4];
    
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(_shrinkDidEnd:finished:contextInfo:)];
    notificationSettingsViewController.view.frame = animateToFrame;  
    [overlay setAlpha:0.8];
    [UIView commitAnimations];
    
    /*
    CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    slideAnimation.toValue = [NSNumber numberWithDouble:0];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    */
    
}       

#pragma mark - Pull-to-refresh functionality
-(void) loadingComplete  {
    
    self.loading = NO;
}
-(void) doRefresh  {
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kContentInteractionEvent
                                         action:@"Refresh list of stops"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    [self performSelector:@selector(loadingComplete) withObject:nil afterDelay:2];
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
        absoluteRow += [[self.stopsByArea valueForKey:[self.areas objectAtIndex:i]] count];
    }
    absoluteRow += indexPath.row;
    
    return absoluteRow;
}

-(void)dismissNotificationSettingsViewController
{
    self.tableView.scrollEnabled = YES;
    [UIView beginAnimations:nil context:NULL];  
    
    [UIView setAnimationDuration:0.4];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeNotificationSettingsViews)];
    CGRect animateToFrame = notificationSettingsViewController.view.frame;
    animateToFrame.origin.y = -303.0;
    notificationSettingsViewController.view.frame = animateToFrame;  
    [overlay setAlpha:0.0];
    [UIView commitAnimations];
}

// call this when the controller is canceled out of
// so that the accessory button can be reset
-(void)dismissNotificationSettingsViewControllerAndRestoreSwitch
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.accessorySwitchIndexPath];
    UISwitch *accSwitch = (UISwitch*)cell.accessoryView;
    [accSwitch setOn:NO];
    
    self.tableView.scrollEnabled = YES;
    [UIView beginAnimations:nil context:NULL];  
    
    [UIView setAnimationDuration:0.4];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeNotificationSettingsViews)];
    CGRect animateToFrame = notificationSettingsViewController.view.frame;
    animateToFrame.origin.y = -303.0;
    notificationSettingsViewController.view.frame = animateToFrame;  
    [overlay setAlpha:0.0];
    [UIView commitAnimations];
}

-(void)removeNotificationSettingsViews
{
    [settingsBackground removeFromSuperview];
    settingsBackground = nil;
    [notificationSettingsViewController.view removeFromSuperview];
    notificationSettingsViewController = nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kContentInteractionEvent
                                         action:@"Load stop detail"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    
	NSString *area = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	
    if (sidvc == nil)
    {
        sidvc = [[ScheduleItemDetailViewController alloc] initWithNibName:@"ScheduleItemDetailView" bundle:nil];
        [self.view addSubview: sidvc.view];
        [sidvc addGestureRecognizers];
        [sidvc setDelegate: self];
    }
    
    // get stop and set sidvc parameters
    NSInteger absoluteIndex = [self getAbsoluteRowNumberForIndexPath:indexPath andArea: area];
    //NSLog(@"absoluteIndex = %i", absoluteIndex);
    VegVanStop *vegVanStop = [self stopForArea:area andIndexPath:indexPath];
    //[vegVanStop description];
    [[sidvc stopName] setText: [vegVanStop name]];
    [[sidvc stopAddress] setText: [vegVanStop addressAsString]];
    [[sidvc stopBlurb] setText: [vegVanStop blurb]];
    NSString *_lat = [[NSNumber numberWithFloat: [vegVanStop location].coordinate.latitude] stringValue];
    NSString *_long = [[NSNumber numberWithFloat: [vegVanStop location].coordinate.longitude] stringValue];
    [sidvc setLocation: [NSDictionary dictionaryWithObjectsAndKeys: _lat, @"latitude", _long, @"longitude", nil]];
    //[sdivc setStopImage
    [[sidvc stopManager] setText: [vegVanStop manager]];
    [[sidvc stopManagerContact] setText: [vegVanStop contact]];
    [sidvc prettify];
    [UIView transitionFromView:self.view 
                        toView:sidvc.view 
                      duration:0.5 
                       options:UIViewAnimationOptionTransitionFlipFromLeft   
                    completion:^(BOOL finished){
                        /* do something on animation completion */
                    }];
    /*
    // add touch sensitive pane
    removeSIDVCPane = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,42.0,480.0)];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSIDVC)];
    [removeSIDVCPane addGestureRecognizer:gestureRecognizer];
    [self.view addSubview:removeSIDVCPane];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:[NSString stringWithFormat:@"You selected %@!", stop]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	*/
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 
#pragma mark Handling subviews
-(void)hideSIDVC
{
    [UIView transitionFromView:sidvc.view 
                        toView:self.view 
                      duration:0.5 
                       options:UIViewAnimationOptionTransitionFlipFromRight  
                    completion:^(BOOL finished){
                        /* do something on animation completion */
                    }];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// tableview data must be reloaded in case notifications switch has been toggled
-(void)viewWillAppear
{
    [self.tableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
      
    self.vegVanScheduleItems = [NSMutableArray arrayWithCapacity:10];
    self.stopsForEachItem = [[[Utilities sharedAppDelegate] vegVanStopManager] stopsForScheduledItems];
    self.scheduledStopStringsByArea = [[[Utilities sharedAppDelegate] vegVanStopManager] scheduledStopStringsByArea];
    self.areas = [[[Utilities sharedAppDelegate] vegVanStopManager] vegVanStopAreas];
    self.stopsByArea = [[[Utilities sharedAppDelegate] vegVanStopManager] vegVanStopsByArea];
    if ([Utilities isFirstLaunch])
    {
        background = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,320,480)];
        [background setBackgroundColor: [UIColor clearColor]];
        
        UIView* _overlay = [[UIView alloc] initWithFrame:background.frame];
        [_overlay setBackgroundColor:[UIColor blackColor]];
        [_overlay setAlpha: 0.5];
        [background addSubview: _overlay];
        NSString* overlayPath = [[NSBundle mainBundle] pathForResource:@"schedule_help" ofType:@"png"];
        UIImage* overlayImage = [[UIImage alloc] initWithContentsOfFile:overlayPath];
        UIImageView *overlayView = [[UIImageView alloc] initWithImage:overlayImage];
        [overlayView setFrame: CGRectMake(35,25,250.0,370.0)];
        [background addSubview:overlayView];
        [self.view addSubview: background];
        
        UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(removeHelp)];
        [background addGestureRecognizer: backgroundTap];
    }
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"Schedule view"
                                         withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
}

-(void)removeHelp
{
    [background removeFromSuperview];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
