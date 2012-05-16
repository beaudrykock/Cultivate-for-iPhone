//
//  SettingsViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize minutesBeforeLabel, stepper, repeatPatternControl, notificationSettingsBackground, toggleNotificationsSwitch, cultiRideDetailsViewController, promptCultiRideDetailsButton, promptCultiRideDetailsBackground, remindersTitleLabel, withRepeatLabel, updateCultiRideDetailsLabel, clearCultiRideDetailsButton, clearButtonLabel, updateButtonLabel;

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
    [self.toggleNotificationsSwitch setOn: [Utilities localNotificationsEnabled] animated: NO];
    NSInteger currentMinutesBefore = [Utilities getDefaultMinutesBefore];
    [self.stepper setValue:currentMinutesBefore*1.0];
    NSNumber *value = [NSNumber numberWithDouble:[stepper value]];
    NSString *label = [NSString stringWithFormat:@"%i%@",[value intValue], @" minutes before"];
    [self.minutesBeforeLabel setText:label];
    [self.repeatPatternControl setSelectedSegmentIndex:[Utilities getDefaultRepeatPattern]];
    self.notificationSettingsBackground.layer.cornerRadius = 8.0;
    self.promptCultiRideDetailsBackground.layer.cornerRadius = 8.0;
    
    // fonts
    [self.remindersTitleLabel setFont: [UIFont fontWithName:@"Calibri-Bold" size: self.remindersTitleLabel.font.pointSize]];
    [self.minutesBeforeLabel setFont: [UIFont fontWithName:@"Calibri" size: self.minutesBeforeLabel.font.pointSize]];
    [self.withRepeatLabel setFont: [UIFont fontWithName:@"Calibri" size: self.withRepeatLabel.font.pointSize]];
    [self.updateCultiRideDetailsLabel setFont: [UIFont fontWithName:@"Calibri-Bold" size: self.updateCultiRideDetailsLabel.font.pointSize]];
    [self.clearButtonLabel setFont: [UIFont fontWithName:@"Calibri" size: self.clearButtonLabel.font.pointSize]];
    [self.updateButtonLabel setFont: [UIFont fontWithName:@"Calibri" size: self.updateButtonLabel.font.pointSize]];
    
    [self.view setBackgroundColor: [Utilities colorWithHexString: @"#639939"]];
    
    if (![toggleNotificationsSwitch isOn])
    {
        [self.stepper setEnabled:NO];
        [self.repeatPatternControl setEnabled: NO];
    }
    
    self.promptCultiRideDetailsButton.buttonTitle = @"Add new";
    self.clearCultiRideDetailsButton.buttonTitle = @"Clear";
    
    [self.promptCultiRideDetailsButton setFillWith:[Utilities colorWithHexString: @"#727272"] andHighlightedFillWith: [Utilities colorWithHexString: kCultivateGrayColor]  andBorderWith: [UIColor blackColor] andTextWith: [UIColor whiteColor]];
    
    [self.clearCultiRideDetailsButton setFillWith:[Utilities colorWithHexString: @"#f46459"] andHighlightedFillWith: [Utilities colorWithHexString: kCultivateGrayColor]  andBorderWith: [Utilities colorWithHexString: @"#D41C23"] andTextWith: [UIColor whiteColor]];
    [self.clearCultiRideDetailsButton setSize: CGSizeMake(130.0, 37.0)];
    [self.promptCultiRideDetailsButton setSize: CGSizeMake(130.0, 37.0)];
    
    UITapGestureRecognizer *updateButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptCultiRideDetails:)];
    [self.promptCultiRideDetailsButton addGestureRecognizer:updateButtonTap];
    
    UITapGestureRecognizer *clearButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearCultiRideDetails)];
    [self.clearCultiRideDetailsButton addGestureRecognizer:clearButtonTap];
    
    [self.navigationController setNavigationBarHidden: YES];
    self.notificationSettingsBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.notificationSettingsBackground.layer.borderWidth = 1.0f;
    
    self.promptCultiRideDetailsBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.promptCultiRideDetailsBackground.layer.borderWidth = 1.0f;
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
        [self.stepper setEnabled:YES];
        [self.repeatPatternControl setEnabled:YES];
    }   
    localNotificationsEnabled = [switch_control isOn];
    [Utilities enableLocalNotifications:localNotificationsEnabled];
}


-(IBAction)stepperPressed:(id)sender
{
    NSNumber *value = [NSNumber numberWithDouble: [stepper value]];
    [Utilities setDefaultMinutesBefore:[value intValue]];
    NSString *label = [NSString stringWithFormat:@"%i%@",[value intValue], @" minutes before"];
    [self.minutesBeforeLabel setText:label];
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

-(IBAction)promptCultiRideDetails:(id)sender
{
    self.cultiRideDetailsViewController = [[CultiRideDetailsViewController alloc] initWithNibName: @"CultiRideDetailsView" bundle: nil];
    [self.cultiRideDetailsViewController setDelegate:self];
    [self presentModalViewController:cultiRideDetailsViewController animated:YES];
}

-(void)clearCultiRideDetails
{
    [Utilities setCultiRideDetailsForName: nil mobile: nil postcode: nil];
}

-(void)cultiRideDetailsViewControllerDidFinish
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
