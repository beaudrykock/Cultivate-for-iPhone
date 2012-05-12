//
//  SettingsViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize minutesBeforeLabel, stepper, repeatPatternControl, notificationSettingsBackground, name_field, postcode_field, mobile_field, cultiRideSettingsBackground, toggleNotificationsSwitch, updateCultiRideDetailsButton;

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
    [toggleNotificationsSwitch setOn: [Utilities localNotificationsEnabled] animated: NO];
    NSInteger currentMinutesBefore = [Utilities getDefaultMinutesBefore];
    [stepper setValue:currentMinutesBefore*1.0];
    NSNumber *value = [NSNumber numberWithDouble:[stepper value]];
    NSString *label = [NSString stringWithFormat:@"%i%@",[value intValue], @" minutes before"];
    [minutesBeforeLabel setText:label];
    [repeatPatternControl setSelectedSegmentIndex:[Utilities getDefaultRepeatPattern]];
    notificationSettingsBackground.layer.cornerRadius = 8.0;
    cultiRideSettingsBackground.layer.cornerRadius = 8.0;
    
    [self.view setBackgroundColor: [Utilities colorWithHexString: @"#639939"]];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *updateButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateCultiRideDetails:)];
    [self.updateCultiRideDetailsButton addGestureRecognizer:updateButtonTap];
    
    if (![toggleNotificationsSwitch isOn])
    {
        [stepper setEnabled:NO];
        [repeatPatternControl setEnabled: NO];
    }
    
    [updateCultiRideDetailsButton setFillWith:[Utilities colorWithHexString: @"#727272"] andHighlightedFillWith: [Utilities colorWithHexString: kCultivateGrayColor]  andBorderWith: [UIColor blackColor] andTextWith: [UIColor whiteColor]];

    updateCultiRideDetailsButton.buttonTitle = @"Update";
}

-(IBAction)nextField:(id)sender
{
    UITextField*textField = (UITextField*)sender;
    if (textField.tag == 0)
    {
        [name_field resignFirstResponder];
        [mobile_field becomeFirstResponder];
    }
    else if (textField.tag == 1)
    {
        [mobile_field resignFirstResponder];
        [postcode_field becomeFirstResponder];
    }
    else
    {
        [postcode_field resignFirstResponder];
        [self updateCultiRideDetails: nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)toggleLocalNotifications:(id)sender
{
    UISwitch *switch_control = (UISwitch*)sender;
    
    if (![switch_control isOn])
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [stepper setEnabled:NO];
        [repeatPatternControl setEnabled:NO];
    }   
    else {
        [stepper setEnabled:YES];
        [repeatPatternControl setEnabled:YES];
    }   
    localNotificationsEnabled = [switch_control isOn];
    [Utilities enableLocalNotifications:localNotificationsEnabled];
}

-(void)hideKeyboard
{
    [name_field resignFirstResponder];
    [mobile_field resignFirstResponder];
    [postcode_field resignFirstResponder];
}

-(IBAction)updateCultiRideDetails:(id)sender
{
    
    NSString *name = [name_field text];
    NSString *mobile = [mobile_field text];
    NSString *postcode = [postcode_field text];
    
    if ([name length]>0 && [mobile length]>0 && [postcode length] >0)
    {
        [Utilities setCultiRideDetailsForName: name mobile: mobile postcode: postcode];
    }
    else
    {
        [self alertIncompleteForm];
    }
}

-(void)alertIncompleteForm
{
    UIAlertView *incompleteForm = [[UIAlertView alloc]
                              initWithTitle:@"All fields must be filled!"
                              message:@"Please enter a name, postcode and mobile number"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
    [incompleteForm show];
}

-(IBAction)stepperPressed:(id)sender
{
    NSNumber *value = [NSNumber numberWithDouble: [stepper value]];
    [Utilities setDefaultMinutesBefore:[value intValue]];
    NSString *label = [NSString stringWithFormat:@"%i%@",[value intValue], @" minutes before"];
    [minutesBeforeLabel setText:label];
}

-(IBAction)patternSegmentChanged:(id)sender
{
    [Utilities setDefaultRepeatPattern: [repeatPatternControl selectedSegmentIndex]];
}



#pragma mark -
#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
