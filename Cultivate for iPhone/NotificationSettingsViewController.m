//
//  NotificationSettingsViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/18/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "NotificationSettingsViewController.h"

@interface NotificationSettingsViewController ()

@end

@implementation NotificationSettingsViewController
@synthesize minutesBeforeLabel, stepper, repeatPatternControl, notificationSettingsBackground, setAsDefaultSettingsSwitch, remindersTitleLabel, withRepeatLabel, setAsDefaultSettingsLabel, delegate, vegVanStop, vegVanScheduleItem;

#pragma mark - IBActions
-(IBAction)stepperPressed:(id)sender
{
        NSNumber *value = [NSNumber numberWithDouble: [stepper value]];
        NSInteger intVal = [value intValue];
        NSString *newLabel = nil;
        switch (intVal)
        {
            case 0:
                secondsBefore = 600;
                newLabel = @"10 minutes";
                break;
            case 1:
                secondsBefore = 1800;
                newLabel = @"30 minutes";
                break;
            case 2:
                secondsBefore = 3600;
                newLabel = @"1 hour";
                break;
            case 3:
                secondsBefore = 86400;
                newLabel = @"1 day";
                break;
        }
        NSString *label = [NSString stringWithFormat:@"%i%@",newLabel, @" before"];
        [self.minutesBeforeLabel setText:label];
}

-(IBAction)done:(id)sender
{
    // send notification
    VegVanStopNotification *notification = [[VegVanStopNotification alloc] initWithVegVanScheduleItem: vegVanScheduleItem andRepeat:repeatPattern andSecondsBefore:secondsBefore];
    
    [notification scheduleNotification];

    [delegate dismissNotificationSettingsViewController];
}

-(void)setAsDefaultSettings
{
    [Utilities setDefaultSecondsBefore:secondsBefore];
    [Utilities setDefaultRepeatPattern:repeatPattern];
    [Utilities setApplySettingsToAllNotifications: YES];
}

-(IBAction)patternSegmentChanged:(id)sender
{
    repeatPattern = [repeatPatternControl selectedSegmentIndex];
    
    if (secondsBefore>0 && repeatPattern!=-1)
        [setAsDefaultSettingsSwitch setEnabled:YES];
}

-(IBAction)toggleSetAsDefaultsSwitch:(id)sender
{
    UISwitch *switch_control = (UISwitch*)sender;
    
    if (![switch_control isOn])
    {
        // defaults must be unset
    }   
    else 
    {
        [self setAsDefaultSettings];
    }
}

#pragma mark - Utility
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
    // Do any additional setup after loading the view from its nib.
    
    secondsBefore = [Utilities getDefaultSecondsBefore];
    repeatPattern = [Utilities getDefaultRepeatPattern];
    
    NSString *newLabel = nil;
    switch (secondsBefore)
    {
        case 600:
            newLabel = @"10 minutes";
            break;
        case 1800:
            newLabel = @"30 minutes";
            break;
        case 3600:
            newLabel = @"1 hour";
            break;
        case 86400:
            newLabel = @"1 day";
            break;
    }
    NSString *label = [NSString stringWithFormat:@"%@%@",newLabel, @" before"];
    [self.minutesBeforeLabel setText:label];
    
    self.repeatPatternControl.selectedSegmentIndex = repeatPattern;
    
    self.notificationSettingsBackground.layer.cornerRadius = 0.6;
    [self.view setBackgroundColor: [Utilities colorWithHexString: @"#639939"]];
    
    // fonts
    [self.remindersTitleLabel setFont: [UIFont fontWithName:@"Calibri-Bold" size: self.remindersTitleLabel.font.pointSize]];
    [self.minutesBeforeLabel setFont: [UIFont fontWithName:@"Calibri" size: self.minutesBeforeLabel.font.pointSize]];
    [self.withRepeatLabel setFont: [UIFont fontWithName:@"Calibri" size: self.withRepeatLabel.font.pointSize]];
    [self.setAsDefaultSettingsLabel setFont: [UIFont fontWithName:@"Calibri" size: self.setAsDefaultSettingsLabel.font.pointSize]]; 
    //self.notificationSettingsBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //self.notificationSettingsBackground.layer.borderWidth = 1.0f;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
