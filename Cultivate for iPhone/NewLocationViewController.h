//
//  NewLocationViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 6/6/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomButton.h"
#import "AKFusionTables.h"
#import "MapViewController.h"

@protocol NewLocationViewControllerDelegate <NSObject>

-(void)dismissVegVanLocationSuggestionView;

@end

@interface NewLocationViewController : UIViewController 
{
    CustomButton *myLocationButton;
    UITextField *postcodeField;
    UITextView *describeView;
    UILabel *or_1;
    UILabel *or_2;
    UILabel *titleLabel;
    UILabel *whatDaysLabel;
    UILabel *whatTimesLabel;
    UILabel *viewTitleLabel;
    CustomButton *submit;
    UIView *topView;
    UIView *middleView;
    UIView *bottomView;
    UIView *titleView;
    UISegmentedControl *dayPicker;
    UIStepper *timeStepper;
    
    NSString *dayChosen;
    NSString *timeForDayChosen;
    
    NSInteger whereChoice;
    NSNumber* latitude;
    NSNumber *longitude;
    NSString *postcodeLocation;
    NSString *describedLocation;
    UILabel *myLocationLabel;
    __weak id<NewLocationViewControllerDelegate> delegate;
}

@property (nonatomic, weak) id<NewLocationViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *myLocationLabel;
@property (nonatomic, strong) IBOutlet CustomButton *myLocationButton;
@property (nonatomic, strong) IBOutlet CustomButton *submit;
@property (nonatomic, strong) IBOutlet UILabel *viewTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *or_1;
@property (nonatomic, strong) IBOutlet UILabel *or_2;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *whatDaysLabel;
@property (nonatomic, strong) IBOutlet UILabel *whatTimesLabel;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *titleView;
@property (nonatomic, strong) IBOutlet UIView *middleView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UITextView *describeView;
@property (nonatomic, strong) IBOutlet UITextField *postcodeField;
@property (nonatomic, strong) IBOutlet UISegmentedControl *dayPicker;
@property (nonatomic, strong) IBOutlet UIStepper *timeStepper;

@property (nonatomic, strong) NSString *dayChosen;
@property (nonatomic, strong) NSString *timeForDayChosen;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@end
