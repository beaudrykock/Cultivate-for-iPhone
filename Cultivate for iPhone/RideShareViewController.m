//
//  RideShareViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/7/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "RideShareViewController.h"

@interface RideShareViewController ()

@end

@implementation RideShareViewController
@synthesize volunteerDates, viewTitle, info, tableView, selectedValues, submitButton, cultiRideDetailsView, overlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [Utilities refreshVolunteerDates]; // loads from online XML and merges with existing if necessary
    self.volunteerDates = [Utilities getVolunteerDatesWithRequestStatus];
    [self.viewTitle setTextColor: [Utilities colorWithHexString: kCultivateGreenColor]];
    [self.info setTextColor: [Utilities colorWithHexString: kCultivateGrayColor]];
    [self.viewTitle setFont: [UIFont fontWithName: @"Nobile" size: 23.0]];
    [self.info setFont: [UIFont fontWithName: @"Calibri" size: self.info.font.pointSize]];
    
    NSMutableArray *arrayValues = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i = 0; i<[volunteerDates count]; i++)
    {
        NSString *date = [volunteerDates objectAtIndex: i]; 
        if ([date rangeOfString: @"requested"].location == NSNotFound)
        {
            [arrayValues addObject: @"0"];
        }
        else
        {
            [arrayValues addObject: @"0"];
        }
    }
    
    self.selectedValues = arrayValues;
    [self.submitButton setButtonTitle: @"Submit request"];
    
    //if (![Utilities cultiRideDetailsSet])
      // [self promptCultiRideDetails];
    
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"CultiRide view"
                                         withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    
}

-(void)test
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AKFusionTables *fusionTables = [[AKFusionTables alloc] initWithUsername:@"beaudrykock@gmail.com" password:@"hLsbp93iLUkbhaenQfcu"];
    [fusionTables querySql:@"SELECT * FROM 1XDJMKnYqaclEyzRHr0AuszDyv7Wb7G2zbHtCiyU" completionHandler:^(NSData *data, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error != nil){
            NSInteger code = [error code];
            NSLog(@"Error code %d", code);
        } else {
            NSString *content = [[NSString alloc]
                                 initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"Content: %@", content);
        }
    }];
    
    [fusionTables modifySql:@"INSERT INTO 1XDJMKnYqaclEyzRHr0AuszDyv7Wb7G2zbHtCiyU (name, mobile, postcode, volunteerDate) VALUES('John Doe', 0777777777, 'OX1 1QA', '10/10/10')" completionHandler:^(NSData *data, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error != nil){
                NSInteger code = [error code];
                NSLog(@"Error code %d", code);
            }
        }
    ];
}

-(IBAction)prepareRequest
{
    if ([Utilities cultiRideDetailsSet] && [self requestMade])
    {
        UIAlertView *confirm = [[UIAlertView alloc]
                                initWithTitle:@"Please confirm request"
                                message:@"Note: e-mail info@cultivateoxford.org if you wish to cancel a request"
                                delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:@"Confirm", nil];
        
        [confirm show];
    }
    else
    {
        [self promptCultiRideDetails];
    }
}

-(void)promptCultiRideDetails
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCultiRideDetailsView) name:kRemoveCultiRideDetailsView object:nil];
    
    overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [overlay setAlpha:0.0];
    [self.view addSubview:overlay];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCultiRideDetailsView)];
    [overlay addGestureRecognizer:tap];
    
    self.cultiRideDetailsView = [[MoveMeView alloc] initWithFrame:CGRectMake(0.0, -245.0, 320.0, 245)];
    [self.cultiRideDetailsView setDelegate:self];
    [self.view addSubview:cultiRideDetailsView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(promptTextfieldEntry)];
    cultiRideDetailsView.frame = CGRectMake(0.0, 0.0, cultiRideDetailsView.frame.size.width, cultiRideDetailsView.frame.size.height);
    [overlay setAlpha:0.8];
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
	[UIView commitAnimations];
    
}

-(void)removeCultiRideDetailsView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRemoveCultiRideDetailsView object:nil];
    
    if (cultiRideDetailsView != nil)
    {
        [cultiRideDetailsView removeFromSuperview];
        //cultiRideDetailsView = nil;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removeOverlay)];
        [overlay setAlpha:0.0];
        [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
        [UIView commitAnimations];
    }
}
                                                  
-(void)removeOverlay
{
    [overlay removeFromSuperview];
    overlay = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Confirm"])
    {
        [self submitRequest];
    }
    else {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        
    }
}


-(void)submitRequest
{
    NSInteger counter = 0;
    for (NSString *string in selectedValues)
    {
        if ([string isEqualToString: @"1"])
        {
            NSString *date = [volunteerDates objectAtIndex: counter];
            if ([date rangeOfString: @"requested"].location == NSNotFound)
            {
                NSError *error;
                if (![[GANTracker sharedTracker] trackEvent:kFeedbackEvent
                                                     action:@"Requesting a volunteer ride"
                                                      label:[NSString stringWithFormat:@"Date requested = %@",date]
                                                      value:0
                                                  withError:&error]) {
                    NSLog(@"GANTracker error, %@", [error localizedDescription]);
                }
                
                NSString *newDate = [NSString stringWithFormat:@"%@%@",date, @" - requested"];
                [self.volunteerDates replaceObjectAtIndex: counter withObject: newDate];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                AKFusionTables *fusionTables = [[AKFusionTables alloc] initWithUsername:@"beaudrykock@gmail.com" password:@"hLsbp93iLUkbhaenQfcu"];
                
                // TODO: customize with actual dates
                [fusionTables modifySql:@"INSERT INTO 1XDJMKnYqaclEyzRHr0AuszDyv7Wb7G2zbHtCiyU (name, mobile, postcode, volunteerDate) VALUES('Jane Doe', 0777777777, 'OX1 1QA', '10/10/10')" completionHandler:^(NSData *data, NSError *error) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    if (error != nil){
                        NSInteger code = [error code];
                        NSLog(@"Error code %d", code);
                    }
                }
                 ];
                
            }
        }
        counter++;
    }
    [Utilities updateVolunteerDatesWithRequestStatus:volunteerDates];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Volunteer dates";
}*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [volunteerDates count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VolunteerDateCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [volunteerDates objectAtIndex: indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Calibri" size: 15.0];
	cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
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
	NSUInteger row = [indexPath row];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![self dateRequestedAtRow:indexPath.row])
    {
        if ([[self.tableView cellForRowAtIndexPath:indexPath ] accessoryType] == UITableViewCellAccessoryCheckmark)
        {
            [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
            [selectedValues replaceObjectAtIndex:row withObject:@"0"];
        }
        else
        {
            [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            [selectedValues replaceObjectAtIndex:row withObject:@"1"];
        }
    }
}

-(BOOL)requestMade
{
    return [selectedValues containsObject:@"1"];
}

-(BOOL)dateRequestedAtRow:(NSInteger)row
{
    NSString *date = [volunteerDates objectAtIndex:row]; 
    return ([date rangeOfString:@"requested"].location != NSNotFound); 
}

-(void)cultiRideDetailsViewControllerDidFinish
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
