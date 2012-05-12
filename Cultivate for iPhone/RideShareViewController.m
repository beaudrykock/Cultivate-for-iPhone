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
@synthesize volunteerDates, title, info, tableView, selectedValues, submitButton;

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
    
    volunteerDates = [Utilities getVolunteerDatesWithRequestStatus];
    [title setTextColor: [Utilities colorWithHexString: kCultivateGreenColor]];
    [info setTextColor: [Utilities colorWithHexString: kCultivateGrayColor]];
    
    if (![Utilities cultiRideDetailsSet])
        [self promptCultiRideDetails];
    
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
    if ([Utilities cultiRideDetailsSet])
    {
        [self submitRequest];
    }
    else
    {
        [self promptCultiRideDetails];
    }
}

-(void)promptCultiRideDetails
{
    UIAlertView *missingDetails = [[UIAlertView alloc]
                              initWithTitle:@"Missing contact details"
                              message:@"CultiRide needs your contact details! Please supply them in Settings"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Take me there", nil];
    
    [missingDetails show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Take me there"])
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:3];
    }
    else {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
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
                NSString *newDate = [NSString stringWithFormat:@"%@%@",date, @" - requested"];
                [volunteerDates replaceObjectAtIndex: counter withObject: newDate];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Volunteer dates";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [volunteerDates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VolunteerDateCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [volunteerDates objectAtIndex: indexPath.row];
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

-(BOOL)dateRequestedAtRow:(NSInteger)row
{
    NSString *date = [volunteerDates objectAtIndex:row]; 
    return ([date rangeOfString:@"requested"].location != NSNotFound); 
}


@end
