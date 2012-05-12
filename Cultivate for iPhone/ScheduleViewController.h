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

@interface ScheduleViewController : UITableViewController <SectionHeaderViewDelegate, ScheduleItemDetailViewControllerDelegate>
{       
    NSMutableArray *areas;
    NSDictionary *scheduledStopStringsByArea;
    ScheduleItemDetailViewController *sidvc;
    UIView *removeSIDVCPane;
    NSMutableArray *stopsForEachItem; // stop name reference for each schedule item
    UIView *background;
}
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

@end

