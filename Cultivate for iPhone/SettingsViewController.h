//
//  SettingsViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomButton.h"
@interface SettingsViewController : UIViewController
{
    UISwitch *toggleNotificationsSwitch;
    UILabel *minutesBeforeLabel;
    UIStepper *stepper;
    UISegmentedControl *repeatPatternControl;
    UIView *notificationSettingsBackground;
    UIView *cultiRideSettingsBackground;
    UITextField *name_field;
    UITextField *mobile_field;
    UITextField *postcode_field;
    BOOL localNotificationsEnabled;
    CustomButton *updateCultiRideDetailsButton;
}

@property (nonatomic, strong) IBOutlet CustomButton *updateCultiRideDetailsButton;
@property (nonatomic, strong) IBOutlet UISwitch *toggleNotificationsSwitch;
@property (nonatomic, strong) IBOutlet UILabel *minutesBeforeLabel;
@property (nonatomic, strong) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) IBOutlet UISegmentedControl *repeatPatternControl;
@property (nonatomic, strong) IBOutlet UIView *notificationSettingsBackground;
@property (nonatomic, strong) IBOutlet UIView *cultiRideSettingsBackground;
@property (nonatomic, strong) IBOutlet UITextField *name_field;
@property (nonatomic, strong) IBOutlet UITextField *postcode_field;
@property (nonatomic, strong) IBOutlet UITextField *mobile_field;
-(IBAction)stepperPressed:(id)sender;
-(IBAction)patternSegmentChanged:(id)sender;
-(void)hideKeyboard;
-(IBAction)updateCultiRideDetails:(id)sender;
-(IBAction)toggleLocalNotifications:(id)sender;
-(void)alertIncompleteForm;
-(IBAction)nextField:(id)sender;

@end
