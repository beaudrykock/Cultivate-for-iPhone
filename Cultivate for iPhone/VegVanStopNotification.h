//
//  VegVanStopNotification.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VegVanScheduleItem.h"

@interface VegVanStopNotification : NSObject
{
    NSString *stopName;
    NSDate *eventDate;
    NSInteger secondsBefore;
    NSInteger repeatPattern;
    NSInteger hash;
    VegVanScheduleItem *item;
}

@property (nonatomic, strong) NSString* stopName;
@property (nonatomic, strong) NSDate* eventDate;
@property (nonatomic, strong) VegVanScheduleItem *item;


-(id)initWithVegVanScheduleItem:(VegVanScheduleItem*)_item andRepeat:(NSInteger)_repeatPattern andSecondsBefore:(NSInteger)_secondsBefore;
-(NSInteger)getSecondsBefore;
-(NSString*)getStopName;
-(NSInteger)getRepeatPattern;
-(void)scheduleNotification;
@end
