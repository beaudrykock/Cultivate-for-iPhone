//
//  ScheduleViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"
#import "VegVanStopNotification.h"
#import "ScheduleItemDetailViewController.h"
#import "PullToRefreshViewController.h"

@interface ScheduleViewController : PullToRefreshViewController <SectionHeaderViewDelegate, ScheduleItemDetailViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{       
    NSMutableArray *areas;
    NSDictionary *scheduledStopStringsByArea;
    NSDictionary *stopsByArea;
    ScheduleItemDetailViewController *sidvc;
    UIView *removeSIDVCPane;
    NSMutableArray *stopsForEachItem; // stop name reference for each schedule item
    UIView *background;
    UIView *settingsBackground;
    UIView *overlay;
    NSMutableArray *vegVanScheduleItems;
    NSIndexPath *accessorySwitchIndexPath;
    NSArray *timeBeforeOptions;
    NSArray *repeatOptions;
    VegVanScheduleItem *notificationScheduleItem;
    
        // picker
    NSInteger secondsBefore;
    NSInteger repeatPattern;
    UIActionSheet *actionSheet;
}

@property (nonatomic, retain) VegVanScheduleItem *notificationScheduleItem;
@property (nonatomic) NSInteger secondsBefore;
@property (nonatomic) NSInteger repeatPattern;
@property (nonatomic, strong) NSArray *timeBeforeOptions;
@property (nonatomic, strong) NSArray *repeatOptions;
@property (nonatomic, strong) NSIndexPath *accessorySwitchIndexPath;
@property (nonatomic, strong) NSDictionary *stopsByArea;
@property (nonatomic, strong) NSMutableArray *vegVanScheduleItems;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) UIView *settingsBackground;
@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) NSMutableArray *stopsForEachItem;
@property (nonatomic, strong) UIView *removeSIDVCPane;
@property (nonatomic, strong) NSMutableArray* areas;
@property (nonatomic, strong) NSDictionary* scheduledStopStringsByArea;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) ScheduleItemDetailViewController *sidvc;

-(void)hideSIDVC;
-(NSInteger)getAbsoluteRowNumberForIndexPath:(NSIndexPath*)indexPath andArea: (NSString*)area;
-(void)removeHelp;
-(void)dismissNotificationSettingsViewController;
-(void)removeNotificationSettingsViews;
-(BOOL)localNotificationInSystemForStopAtIndex:(NSInteger)indexPath;
-(void)loadingComplete;
-(void)doRefresh;
-(void)dismissNotificationSettingsViewControllerAndRestoreSwitch;

@end

