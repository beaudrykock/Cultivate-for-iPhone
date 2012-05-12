//
//  VegVanStop.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "VegVanStop.h"

@implementation VegVanStop
@synthesize name, area, location, address, photoURL, blurb, manager, scheduleItems;

-(NSString*)addressAsString
{
    return [NSString stringWithFormat:@"%@%@%@%@%@", [address objectForKey: kStreetNumberElement],@" ", [address objectForKey: kStreetNameElement],@" ", [address objectForKey: kPostcodeElement]];
}

-(float)secondsUntilNextScheduledStop
{
    // TODO: finish - need to iterate through schedule items and figure out closest item in time
    // implementation depends on Cultivate choice of scheduling
    VegVanScheduleItem *nextScheduledStop = [self getNextScheduledStop];
   
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];

    unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit |  NSMinuteCalendarUnit;
    NSDateComponents *components =[gregorian components:unitFlags fromDate:[NSDate date]];
    NSInteger weekday_now = [components weekday];
    NSInteger hour_now = [components hour];
    NSInteger minute_now = [components minute];
    
    NSInteger weekSecondsElapsed_now = ((weekday_now-1)*86400)+(hour_now*3600)+(minute_now*60);
    NSInteger weekSecondsElapsed_item = (([nextScheduledStop getDayAsInteger]-1)*86400)
                                        +([nextScheduledStop getHourAsInteger]*3600)
                                        +([nextScheduledStop getMinuteAsInteger]*60);
    
    BOOL scheduledDateEarlierInWeek = NO;
    if ([nextScheduledStop getDayAsInteger]<weekday_now)
    {
        scheduledDateEarlierInWeek = YES;
    }
    else if ([nextScheduledStop getDayAsInteger]==weekday_now)
    {
        if ([nextScheduledStop getHourAsInteger]<hour_now)
        {
            scheduledDateEarlierInWeek = YES;
        }
        else if ([nextScheduledStop getHourAsInteger]==hour_now)
        {
            if ([nextScheduledStop getMinuteAsInteger]<minute_now)
            {
                scheduledDateEarlierInWeek = YES;
            }
        }
    }
    NSLog(@"stop %@, weekSecondsElapsed_now = %i, weekSecondsElapsed_item = %i", [self name], weekSecondsElapsed_now, weekSecondsElapsed_item);
    
    if (scheduledDateEarlierInWeek)
    {
        return weekSecondsElapsed_item-weekSecondsElapsed_now;
    }
    else
    {
        return weekSecondsElapsed_now-weekSecondsElapsed_item;
    }
    // TEMPORARY ONLY - FOR TESTING
   // return (rand() / RAND_MAX) * 100;
}

-(VegVanScheduleItem*)getNextScheduledStop
{
    VegVanScheduleItem *nextScheduled = nil;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit |  NSMinuteCalendarUnit;
    NSDateComponents *components =[gregorian components:unitFlags fromDate:[NSDate date]];
    NSInteger weekday_now = [components weekday];
    NSInteger hour_now = [components hour];
    NSInteger minute_now = [components minute];
    
    NSMutableArray *itemsTodayOrAfterToday = [[NSMutableArray alloc] initWithCapacity:5];
    // first figure out if any items are today or after today in the week
    for (VegVanScheduleItem *item in scheduleItems)
    {
        [item description];
        if ([item getDayAsInteger] >= weekday_now)
        {
            [itemsTodayOrAfterToday addObject: item];
        }
    }
    if ([itemsTodayOrAfterToday count] > 0)
    {
        for (VegVanScheduleItem *item in itemsTodayOrAfterToday)
        {
            if ([item getHourAsInteger]>hour_now)
            {
                nextScheduled = item;
                break;
            }
            else if ([item getHourAsInteger] == hour_now)
            {
                if ([item getMinuteAsInteger] > minute_now)
                {
                    nextScheduled = item;
                    break;
                }
            }
        }
    }
    
    if (!nextScheduled)
    {
        NSInteger earliestDay = -1;
        NSInteger earliestHour = -1;
        NSInteger earliestMinute = -1;
        VegVanScheduleItem *soonest = nil;
        // no items today or after today in the week, so get item with earliest day, hour and time
        for (VegVanScheduleItem *item in scheduleItems)
        {
            if (earliestDay == -1)
            {
                earliestDay = [item getDayAsInteger];
                earliestHour = [item getHourAsInteger];
                earliestMinute = [item getMinuteAsInteger];
                soonest = item;
            }
            else
            {
                if ([item getDayAsInteger]<earliestDay)
                {
                    earliestDay = [item getDayAsInteger];
                    soonest = item;
                }
                else if ([item getDayAsInteger]==earliestDay)
                {
                    if ([item getHourAsInteger]<earliestHour)
                    {
                        earliestHour = [item getHourAsInteger];
                        soonest = item;
                    }
                    else if ([item getHourAsInteger]==earliestHour)
                    {
                        if ([item getMinuteAsInteger]<earliestMinute)
                        {
                            earliestMinute = [item getMinuteAsInteger];
                            soonest = item;
                        }
                    }
                }
            }
        }
        nextScheduled = soonest;
    }
    
    return nextScheduled;
}

-(NSString*)nextStopTimeAsString
{
    return @"Wednesday @ 2 pm";
}

-(void)description
{
    NSLog(@"name = %@, area = %@", name, area);
}

@end
