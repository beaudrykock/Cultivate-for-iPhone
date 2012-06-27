//
//  VegVanScheduleItem.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VegVanScheduleItem : NSObject
{
    NSString *stopName;
    NSString *stopDay;
    NSString *stopTime;
    NSString *stopFrequency;
    NSString *stopDuration;
}

@property (nonatomic, strong) NSString *stopName;
@property (nonatomic, strong) NSString *stopDay;
@property (nonatomic, strong) NSString *stopTime;
@property (nonatomic, strong) NSString *stopFrequency;
@property (nonatomic, strong) NSString *stopDuration;

-(NSString*)scheduleDetailAsString;
-(NSString*)scheduleDetailAsStringLessFrequency;
-(NSString*)scheduleDetailWithDurationAsStringLessFrequency;
-(NSInteger)getHourAsInteger;
-(NSInteger)getMinuteAsInteger;
-(NSInteger)getDayAsInteger;
-(NSInteger)getDurationAsInteger;
-(void)description;
-(NSInteger)hash; // returns a consistent hash based on ivars
-(NSArray*)getFrequencyBrokenDown;

@end
