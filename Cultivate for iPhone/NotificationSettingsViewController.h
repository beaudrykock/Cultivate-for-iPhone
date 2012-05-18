//
//  NotificationSettingsViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/18/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VegVanStop.h"
#import "VegVanStopNotification.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"

@protocol NotificationSettingsViewControllerDelegate
    -(void)dismissNotificationSettingsViewController;
@end

@interface NotificationSettingsViewController : UIViewController
{
    UISwitch *setAsDefaultSettingsSwitch;
    UILabel *remindersTitleLabel;
    UILabel *minutesBeforeLabel;
    UILabel *withRepeatLabel;
    UILabel *updateCultiRideDetailsLabel;
    UIStepper *stepper;
    UISegmentedControl *repeatPatternControl;
    UIView *notificationSettingsBackground;
    UILabel *setAsDefaultSettingsLabel;
    NSInteger secondsBefore;
    NSInteger repeatPattern;
    __weak id <NotificationSettingsViewControllerDelegate> delegate;
    VegVanStop* vegVanStop;
    VegVanScheduleItem* vegVanScheduleItem;
}

@property (nonatomic, strong) IBOutlet UISwitch *setAsDefaultSettingsSwitch;
@property (nonatomic, strong) IBOutlet UILabel *minutesBeforeLabel;
@property (nonatomic, strong) IBOutlet UILabel *remindersTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *withRepeatLabel;
@property (nonatomic, strong) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) IBOutlet UISegmentedControl *repeatPatternControl;
@property (nonatomic, strong) IBOutlet UIView *notificationSettingsBackground;
@property (nonatomic, strong) IBOutlet UILabel *setAsDefaultSettingsLabel;
@property (weak) id <NotificationSettingsViewControllerDelegate> delegate;
@property (nonatomic, strong) VegVanStop* vegVanStop;
@property (nonatomic, strong) VegVanScheduleItem *vegVanScheduleItem;

-(IBAction)stepperPressed:(id)sender;
-(IBAction)patternSegmentChanged:(id)sender;
-(void)setAsDefaultSettings;
-(IBAction)done:(id)sender;
-(IBAction)toggleSetAsDefaultsSwitch:(id)sender;
@end
