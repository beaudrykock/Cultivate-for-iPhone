//
//  NewLocationViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 6/6/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "NewLocationViewController.h"


@interface NewLocationViewController ()

@end

@implementation NewLocationViewController

@synthesize myLocationButton, postcodeField, describeView, or_1, or_2, titleLabel, whatDaysLabel, whatTimesLabel, pick_1, pick_2, submit, topView, middleView, bottomView, dayPicker, timeStepper, dayChosen, timeForDayChosen, latitude, longitude;

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
}

-(void)viewWillAppear:(BOOL)animated
{
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    self.topView.layer.cornerRadius = 8.0;
    self.middleView.layer.cornerRadius = 8.0;
    self.bottomView.layer.cornerRadius = 8.0;
    self.describeView.layer.cornerRadius = 8.0;
    
    self.describeView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.describeView.layer.borderWidth = 1.0;
    
    [self.titleLabel setFont: [UIFont fontWithName:@"nobile" size:20]];
    [self.or_1 setFont: [UIFont fontWithName:@"Calibri" size:17]];
    [self.or_2 setFont: [UIFont fontWithName:@"nobile" size:17]];
    [self.whatDaysLabel setFont: [UIFont fontWithName:@"nobile" size:17]];
    [self.whatTimesLabel setFont: [UIFont fontWithName:@"nobile" size:17]];
    [self.describeView setFont:[UIFont fontWithName:@"nobile" size:15]];
    
    self.dayChosen = @"no day";
    self.timeForDayChosen = @"no time";
    [self.describeView setText:@"please describe..."];
    [self.whatTimesLabel setText:@"@ what time?"];
}

-(IBAction)myLocation:(id)sender
{
    if ((![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized))
    {
        [self promptForLocationServices];
    }
    else {
        
        whereChoice = 0;
            
        // get currentlocation from tab 1
        __weak MapViewController *mpv = [self.tabBarController.childViewControllers objectAtIndex:0];
        
        CLLocation *loc = mpv.currentLocation;
        self.latitude = [NSNumber numberWithFloat:loc.coordinate.latitude];
        self.longitude = [NSNumber numberWithFloat:loc.coordinate.longitude];
    }
}



-(void)reset
{
    self.dayChosen = @"no day";
    self.timeForDayChosen = @"no time";
    [self.describeView setText:@"please describe..."];
    [self.whatTimesLabel setText:@"@ what time?"];
    [self.timeStepper setValue:0.0];
    [self.dayPicker setSelectedSegmentIndex:0];
    [self.postcodeField setText:nil];
    self.latitude = nil;
    self.longitude = nil;
}

-(IBAction)submit:(id)sender
{
    if (![Utilities hasInternet])
    {
        [self notifyNoInternet];
    }
    else {
        
        if (whereChoice == 1)
        {
            NSPredicate *postcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPostcodeRegex];
            if ([postcodeTest evaluateWithObject:[self.postcodeField text]])
            {
                CLPlacemark *loc = [self forwardGeocode:self.postcodeField.text];
                self.latitude = [NSNumber numberWithFloat:loc.location.coordinate.latitude];
                self.longitude = [NSNumber numberWithFloat:loc.location.coordinate.longitude];
            }
            else {
                [self promptInvalidPostcode];
            }
        }
        else if (whereChoice == 2)
        {
            self.latitude = [NSNumber numberWithFloat:0.0];
            self.longitude = [NSNumber numberWithFloat:0.0];
        }
        
        if ([self.dayChosen isEqualToString:@"no day"])
        {
            [self promptChooseDay];
        }
        else {
            if ([self.timeForDayChosen isEqualToString:@"no time"])
            {
                [self promptChooseTime];
            }
            else {
                [self sendToFusionTable];
            }
        }
    }
    
    // otherwise submit to Fusion table
}

-(void)sendToFusionTable
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AKFusionTables *fusionTables = [[AKFusionTables alloc] initWithUsername:@"beaudrykock@gmail.com" password:@"hLsbp93iLUkbhaenQfcu"];
    
    // TODO: customize with actual dates
    NSString *tableID = @"S532916HW9Z";
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (Lat, Long, Desc, When, When, Time) VALUES('%@', '%@', '%@', '%@', '%@', '%@')", tableID, self.latitude.stringValue, self.longitude.stringValue, self.describeView.text, self.dayChosen, self.dayChosen, self.timeForDayChosen];
    NSString *query2 = @"INSERT INTO 1ngoMdAM_oQsh-au8gGuIB5qGlw06rJfZ9rAAQ5s (Lat, Long, Desc, When, Time) VALUES('0', '0', 'desc', 'Monday', '8 am')";
    NSLog(@"query = %@", query);
    NSString *query3 = [NSString stringWithFormat: @"INSERT INTO 1XDJMKnYqaclEyzRHr0AuszDyv7Wb7G2zbHtCiyU (name, mobile, postcode, volunteerDate) VALUES('%@', %@, '%@', '%@')", @"Jane Doe", @"077777777", @"OX1 1QA", @"10/10/10"];
    [fusionTables modifySql:query completionHandler:^(NSData *data, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error != nil){
            NSInteger code = [error code];
            NSLog(@"Error code %d, desc %@", code, [error description]);
        }
    }
     ];

    
    [self reset];
}

-(CLPlacemark*)forwardGeocode:(NSString*)postcode
{
    __block CLPlacemark *placemark = nil;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:postcode completionHandler:^(NSArray *placemarks, NSError *error) {
            placemark = [placemarks objectAtIndex:0];
            
            NSLog(@"lat = %f, long = %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        }];
    return placemark;
}

-(void)promptInvalidPostcode
{
    UIAlertView *invalidPostcode = [[UIAlertView alloc] initWithTitle:@"Invalid postcode" message:@"Please re-enter your postcode, including a space in the middle" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [invalidPostcode show];
}

-(void)promptChooseDay
{
    UIAlertView *chooseDay = [[UIAlertView alloc] initWithTitle:@"Choose a day" message:@"Please make sure to choose a day for your proposed VegVan stop" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [chooseDay show];
}

-(void)promptChooseTime
{
    UIAlertView *chooseTime = [[UIAlertView alloc] initWithTitle:@"Choose a time" message:@"Please make sure to choose a time for your selected day" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [chooseTime show];
}

-(void)promptForLocationServices
{
    UIAlertView *chooseTime = [[UIAlertView alloc] initWithTitle:@"Location Services not enabled" message:@"Please enable Location Services in Settings to use this feature" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [chooseTime show];
}

-(void)notifyNoInternet
{
    UIAlertView *noInternet = [[UIAlertView alloc] initWithTitle:@"No internet" message:@"No internet connection is available. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [noInternet show];
}

-(IBAction)pickDay:(id)sender
{
    NSInteger index = self.dayPicker.selectedSegmentIndex;
    
    switch (index)
    {
        case 0: dayChosen = @"Monday";
            break;
        case 1:dayChosen = @"Tuesday";
            break;
        case 2:dayChosen = @"Wednesday";
            break;
        case 3:dayChosen = @"Thursday";
            break;
        case 4:dayChosen = @"Friday";
            break;
        case 5:dayChosen = @"Saturday";
            break;
        case 6:dayChosen = @"Sunday";
            break;
    }
}

-(IBAction)step:(id)sender
{
   NSInteger val = [self.timeStepper value];
    switch (val) {
        case 0:
            self.timeForDayChosen = @"8 am";
            break;
        case 1:
            self.timeForDayChosen = @"9 am";
            break;
        case 2:
            self.timeForDayChosen = @"10 am";
            break;
        case 3:
            self.timeForDayChosen = @"11 am";
            break;
        case 4:
            self.timeForDayChosen = @"12 pm";
            break;
        case 5:
            self.timeForDayChosen = @"1 pm";
            break;
        case 6:
            self.timeForDayChosen = @"2 pm";
            break;
        case 7:
            self.timeForDayChosen = @"3 pm";
            break;
        case 8:
            self.timeForDayChosen = @"4 pm";
            break;
        case 9:
            self.timeForDayChosen = @"5 pm";
            break;
        case 10:
            self.timeForDayChosen = @"6 pm";
            break;            
        default:
            break;
    }
    [self.whatTimesLabel setText:[NSString stringWithFormat:@"@ %@", self.timeForDayChosen]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
