//
//  ScheduleViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"

@interface ScheduleViewController : UITableViewController <SectionHeaderViewDelegate>
{       
    NSArray *areas;
    NSDictionary *scheduledStops;
}

@property (nonatomic, strong) NSArray* areas;
@property (nonatomic, strong) NSDictionary* scheduledStops;

@end
