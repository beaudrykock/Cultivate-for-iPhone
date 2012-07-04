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

@synthesize myLocationButton, postcodeField, describeView, or_1, or_2, titleLabel, whatDaysLabel, whatTimesLabel, submit, topView, middleView, bottomView, dayPicker, timeStepper, dayChosen, timeForDayChosen, latitude, longitude, myLocationLabel, viewTitleLabel, titleView, delegate, backgroundView;

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
    
    [self.backgroundView setBackgroundColor:[Utilities colorWithHexString:kCultivateGreenColor]];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipe];
    
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //[self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.describeView resignFirstResponder];
}

-(void)dismiss
{
    [self.delegate dismissVegVanLocationSuggestionView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    self.titleView.layer.cornerRadius = 8.0;
    self.topView.layer.cornerRadius = 8.0;
    self.middleView.layer.cornerRadius = 8.0;
    self.bottomView.layer.cornerRadius = 8.0;
    self.describeView.layer.cornerRadius = 8.0;
    
    self.describeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.describeView.layer.borderWidth = 1.0;
    self.describeView.delegate = self;
    
    [self.viewTitleLabel setFont: [UIFont fontWithName:kTitleFont size:20]];
    [self.myLocationLabel setFont: [UIFont fontWithName:kTextFont size:17.0]];
    [self.titleLabel setFont: [UIFont fontWithName:kTitleFont size:20]];
    [self.or_1 setFont: [UIFont fontWithName:kTextFont size:17]];
    [self.or_2 setFont: [UIFont fontWithName:kTextFont size:17]];
    [self.whatDaysLabel setFont: [UIFont fontWithName:kTitleFont size:20]];
    [self.whatTimesLabel setFont: [UIFont fontWithName:kTextFont size:20]];
    [self.describeView setFont:[UIFont fontWithName:kTextFont size:15]];
    
    self.dayChosen = @"no day";
    self.timeForDayChosen = @"no time";
    [self.describeView setText:@"e.g. car park at Iffley and Magdalen, East Oxford"];
    [self.whatTimesLabel setText:@"@ what time?"];
    
    // custom buttons
    [self.submit setButtonTitle: @"Submit"];
    [self.submit setSize: CGSizeMake(279.0, 37.0)];
    [self.submit setFillWith:[Utilities colorWithHexString:@"#0f4d6f"] andHighlightedFillWith:[Utilities colorWithHexString:@"#092e42"] andBorderWith:[UIColor whiteColor] andTextWith:[UIColor whiteColor]];
    
}

-(IBAction)myLocation:(id)sender
{
    if ((![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized))
    {
        [self promptForLocationServices];
    }
    else {
        [self.myLocationLabel setText:@"Locating..."];
        whereChoice = 0;
            
        NSArray *location = [Utilities getLocation];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[location objectAtIndex:0] floatValue] longitude:[[location objectAtIndex:1] floatValue]];
        self.latitude = [NSNumber numberWithFloat:loc.coordinate.latitude];
        self.longitude = [NSNumber numberWithFloat:loc.coordinate.longitude];
        
        [self reverseGeocode:loc];
        
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
                [self forwardGeocode:self.postcodeField.text];
                
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
    [self addActivityOverlay];
    AKFusionTables *fusionTables = [[AKFusionTables alloc] initWithUsername:@"beaudrykock@gmail.com" password:@"hLsbp93iLUkbhaenQfcu"];
    
    NSString *desc = [self.describeView text];
    if ([desc isEqualToString:@"e.g. car park at Iffley and Magdalen, East Oxford"])
        desc = @"no_desc";
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO 1v-9AZ0SUShqU-SbXWTFAUDN0zfk36x-HvXG4KCY (data_1, data_2, data_3, data_4, data_5) VALUES('%@', '%@', '%@', '%@', '%@')", self.latitude.stringValue, self.longitude.stringValue, desc, self.dayChosen, self.timeForDayChosen];
    //NSString *query = [NSString stringWithFormat:@"INSERT INTO 1v-9AZ0SUShqU-SbXWTFAUDN0zfk36x-HvXG4KCY (Data, Data2) VALUES('%@', '%@')", @"blag", @"blag"];
    //self.latitude.stringValue, self.longitude.stringValue, @"blag", self.dayChosen, self.timeForDayChosen
    //NSLog(@"query = %@", query);
    // access
    /*[fusionTables querySql:@"SELECT * FROM 1lx5fkmE4V0WAjhOhPmHxMtqmQT0Y1k1UWgU4UZk" completionHandler:^(NSData *data, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error != nil){
            NSInteger code = [error code];
            NSLog(@"Error code %d", code);
        } else {
            NSString *content = [[NSString alloc]
                                 initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"Content: %@", content);
        }
    }];*/
    [fusionTables modifySql:query completionHandler:^(NSData *data, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self removeActivityOverlay];
        [self dismiss];
        if (error != nil){
            NSInteger code = [error code];
            NSLog(@"Error code %d, desc %@", code, [error description]);
        }
    }
     ];
    
    //[self reset];
}

-(void)addActivityOverlay
{
    UIView *base = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [base setTag:1000];
    [base setBackgroundColor:[UIColor clearColor]];
    UIView *overlay = [[UIView alloc] initWithFrame:base.frame];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [overlay setAlpha:0.8];
    [base addSubview:overlay];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-(50.0), (self.view.bounds.size.height/2)-(20.0), 100.0, 40.0)];
    [base addSubview:label];
    [label setText:@"Submitting to Cultivate HQ..."];
    
}

-(void)removeActivityOverlay
{
    for (UIView *view in self.view.subviews)
    {
        if (view.tag == 1000)
        {
            [view removeFromSuperview];
            break;
        }
    }
}

-(CLPlacemark*)forwardGeocode:(NSString*)postcode
{
    __block CLPlacemark *placemark = nil;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:postcode completionHandler:^(NSArray *placemarks, NSError *error) {
            placemark = [placemarks objectAtIndex:0];
            self.latitude = [NSNumber numberWithFloat:placemark.location.coordinate.latitude];
            self.longitude = [NSNumber numberWithFloat:placemark.location.coordinate.longitude];
            NSLog(@"lat = %f, long = %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        }];
    return placemark;
}

-(CLPlacemark*)reverseGeocode:(CLLocation*)loc
{
    __block CLPlacemark *placemark = nil;
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            placemark = [placemarks objectAtIndex:0];
        NSLog(@"postal code = %@", placemark.postalCode);
        
        if (placemark.postalCode != NULL)
        {
            [self.myLocationLabel setText: [placemark postalCode]];
        }
        else 
        {
            [self.myLocationLabel setText:@"Location unavailable"];
        }
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
