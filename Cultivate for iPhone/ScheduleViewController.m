//
//  ScheduleViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "ScheduleViewController.h"

@implementation ScheduleViewController
@synthesize areas, managedObjectContext, scheduledStopStringsByArea, sidvc, removeSIDVCPane, stopsForEachItem, background, settingsBackground, overlay, vegVanScheduleItems, stopsByArea, accessorySwitchIndexPath, timeBeforeOptions, repeatOptions, secondsBefore, repeatPattern, notificationScheduleItem;

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
    
    if ([switch1 isOn])
    {
        [self promptForNotificationSettingsWithStop:vegVanStop andItem:[vegVanScheduleItems objectAtIndex: absoluteIndex]];
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
            VegVanScheduleItem *item = (VegVanScheduleItem*)[self.vegVanScheduleItems objectAtIndex: absoluteIndex];
            if ([itemHash intValue] ==  [item scheduleItemHash])
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
            /// NSLog(@"absolute index = %i", index);
        notif = [notifications objectAtIndex: counter];
            //NSLog(@"alertbody = %@", notif.alertBody);
        NSDictionary *userinfo = notif.userInfo;
        NSNumber *itemHash = [userinfo objectForKey: kScheduleItemRefKey]; 
            //NSLog(@"notification hash = %i", [itemHash intValue]);
        
        VegVanScheduleItem*item = (VegVanScheduleItem*)[self.vegVanScheduleItems objectAtIndex:index];
            //NSLog(@"stored item hash = %i\n", [item scheduleItemHash]);
            //NSLog(@"Stop name = %@", item.stopName);
        if ([itemHash intValue] == [item scheduleItemHash])
        {
            found = YES;
        }
        counter++;
        
        if (found) break;
    }
    return found;
}

#pragma mark - Picker
-(void)promptForNotificationSettingsWithStop:(VegVanStop*)vegVanStop andItem:(VegVanScheduleItem*)item
{
    self.tableView.scrollEnabled = NO;
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Set your reminder details"
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:1 inComponent:0 animated:NO];
    [pickerView selectRow:1 inComponent:1 animated:NO];
    [actionSheet addSubview:pickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
    cancelButton.momentary = YES;
    cancelButton.frame = CGRectMake(10.0, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    cancelButton.tintColor = [UIColor blackColor];
    [cancelButton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:cancelButton];
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    self.notificationScheduleItem = item;
}

-(IBAction)dismissActionSheet:(id)sender
{
        // send notification
    VegVanStopNotification *notification = [[VegVanStopNotification alloc] initWithVegVanScheduleItem: self.notificationScheduleItem andRepeat:repeatPattern andSecondsBefore:secondsBefore];
    
    [notification scheduleNotification];
    
    self.notificationScheduleItem = nil;
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    self.tableView.scrollEnabled = YES;
}

-(IBAction)cancelActionSheet:(id)sender
{
    self.notificationScheduleItem = nil;
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.accessorySwitchIndexPath];
    UISwitch *accSwitch = (UISwitch*)cell.accessoryView;
    [accSwitch setOn:NO];
    
    self.tableView.scrollEnabled = YES;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.timeBeforeOptions count];
            break;
            
        case 1:
            return [self.repeatOptions count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.timeBeforeOptions objectAtIndex:row];
            break;
            
        case 1:
            return [self.repeatOptions objectAtIndex:row];
            break;
        default:
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            switch (row)
            {
                case 0:
                    secondsBefore = 600;
                    break;
                case 1:
                    secondsBefore = 1800;
                    break;
                case 2:
                    secondsBefore = 3600;
                    break;
                case 3:
                    secondsBefore = 86400;
                    break;
            }
            break;
            
        case 1:
            repeatPattern = row;
            break;
        default:
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 200.0;
            break;
            
        case 1:
            return 120.0;
            break;
        default:
            break;
    }
}

#pragma mark - Pull-to-refresh functionality
-(void) loadingComplete  {
    
    [self.tableView reloadData];
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
    if ([[[Utilities sharedAppDelegate] vegVanStopManager] loadVegVanStops])
    {
        self.stopsForEachItem = [[[Utilities sharedAppDelegate] vegVanStopManager] stopsForScheduledItems];
        self.scheduledStopStringsByArea = [[[Utilities sharedAppDelegate] vegVanStopManager] scheduledStopStringsByArea];
        self.areas = [[[Utilities sharedAppDelegate] vegVanStopManager] vegVanStopAreas];
        self.stopsByArea = [[[Utilities sharedAppDelegate] vegVanStopManager] vegVanStopsByArea];
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
        if ([Utilities iPhone5])
        {
            CGRect iPhone5_frame = CGRectMake(0.0, 0.0, 320.0, 568.0);
            sidvc.view.frame = iPhone5_frame;
        }
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
    self.repeatOptions = [NSArray arrayWithObjects:@"One-off", @"Weekly", @"Monthly", nil];
    self.timeBeforeOptions = [NSArray arrayWithObjects:@"10 minutes before",@"30 minutes before", @"1 hour before", @"1 day before", nil];
    self.repeatPattern = 1;
    self.secondsBefore = 1800;
    
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
        [overlayView setFrame: CGRectMake(35,25,261.0,299.0)];
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
