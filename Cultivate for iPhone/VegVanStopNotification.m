//
//  VegVanStopNotification.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "VegVanStopNotification.h"

@implementation VegVanStopNotification

-(id)initWithStopName:(NSString*)_stopName day:(NSInteger)_day month: (NSInteger)_month year:(NSInteger)_year hour:(NSInteger)_hour minute:(NSInteger)_minute minutesBefore:(NSInteger)_minutesBefore
{
    self = [super init];
    
    if (self != nil)
    {
        stopName = _stopName;
        day = _day;
        month = _month;
        year = _year;
        minute = _minute;
        hour = _hour;
        minutesBefore = minutesBefore;
    }
    return self;
}

-(NSInteger)getDay
{
    return day;
}

-(NSInteger)getMonth
{
    return month;
}

-(NSInteger)getYear
{
    return year;
}

-(NSInteger)getHour
{
    return hour;
}

-(NSInteger)getMinute
{
    return minute;
}

-(NSInteger)getMinutesBefore
{
    return minutesBefore;
}

-(NSString*)getStopName
{
    return stopName;
}

@end
