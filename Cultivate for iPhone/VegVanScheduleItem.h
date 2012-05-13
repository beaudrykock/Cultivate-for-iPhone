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
}

@property (nonatomic, strong) NSString *stopName;
@property (nonatomic, strong) NSString *stopDay;
@property (nonatomic, strong) NSString *stopTime;
@property (nonatomic, strong) NSString *stopFrequency;

-(NSString*)scheduleDetailAsString;
-(NSString*)scheduleDetailAsStringLessFrequency;
-(NSInteger)getHourAsInteger;
-(NSInteger)getMinuteAsInteger;
-(NSInteger)getDayAsInteger;
-(void)description;
@end
