//
//  SettingsViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController : UIViewController
{
    UILabel *minutesBeforeLabel;
    UIStepper *stepper;
    UISegmentedControl *repeatPatternControl;
    UIView *notificationSettingsBackground;
}

@property (nonatomic, strong) IBOutlet UILabel *minutesBeforeLabel;
@property (nonatomic, strong) IBOutlet UIStepper *stepper;
@property (nonatomic, strong) IBOutlet UISegmentedControl *repeatPatternControl;
@property (nonatomic, strong) IBOutlet UIView *notificationSettingsBackground;

-(IBAction)stepperPressed:(id)sender;
-(IBAction)patternSegmentChanged:(id)sender;

@end
