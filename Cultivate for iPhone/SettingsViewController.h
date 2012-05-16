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
#import "CultiRideDetailsViewController.h"

@interface SettingsViewController : UIViewController <CultiRideDetailsViewControllerDelegate>
{
    UISwitch *toggleNotificationsSwitch;
    UILabel *remindersTitleLabel;
    UILabel *minutesBeforeLabel;
    UILabel *withRepeatLabel;
    UILabel *updateCultiRideDetailsLabel;
    UIStepper *stepper;
    UISegmentedControl *repeatPatternControl;
    UIView *notificationSettingsBackground;
    UIView *promptCultiRideDetailsBackground;
    BOOL localNotificationsEnabled;
    CultiRideDetailsViewController *cultiRideDetailsViewController;
    CustomButton *promptCultiRideDetailsButton;
    CustomButton *clearCultiRideDetailsButton;
    UILabel *clearButtonLabel;
    UILabel *updateButtonLabel;
    
}
@property (nonatomic, strong) IBOutlet UISwitch *toggleNotificationsSwitch;
@property (nonatomic, strong) IBOutlet UILabel *minutesBeforeLabel;
@property (nonatomic, strong) IBOutlet UILabel *remindersTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *withRepeatLabel;
@property (nonatomic, strong) IBOutlet UILabel *updateCultiRideDetailsLabel;
@property (nonatomic, strong) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) IBOutlet UISegmentedControl *repeatPatternControl;
@property (nonatomic, strong) IBOutlet UIView *notificationSettingsBackground;
@property (nonatomic, strong) IBOutlet UIView *promptCultiRideDetailsBackground;
@property (nonatomic, strong) CultiRideDetailsViewController *cultiRideDetailsViewController;
@property (nonatomic, strong) IBOutlet CustomButton *promptCultiRideDetailsButton;
@property (nonatomic, strong) IBOutlet CustomButton *clearCultiRideDetailsButton;
@property (nonatomic, strong) IBOutlet UILabel *clearButtonLabel;
@property (nonatomic, strong) IBOutlet UILabel *updateButtonLabel;

-(IBAction)stepperPressed:(id)sender;
-(IBAction)patternSegmentChanged:(id)sender;
-(void)hideKeyboard;
-(IBAction)toggleLocalNotifications:(id)sender;
-(IBAction)promptCultiRideDetails:(id)sender;
-(void)cultiRideDetailsViewControllerDidFinish;
-(void)clearCultiRideDetails;
@end
