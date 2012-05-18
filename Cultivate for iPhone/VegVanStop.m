//
//  VegVanStop.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "VegVanStop.h"

@implementation VegVanStop
@synthesize name, area, location, address, photoURL, blurb, manager, scheduleItems, nextScheduledStop;

-(NSString*)addressAsString
{
    return [NSString stringWithFormat:@"%@%@%@%@%@", [address objectForKey: kStreetNumberElement],@" ", [address objectForKey: kStreetNameElement],@" ", [address objectForKey: kPostcodeElement]];
}

-(NSString*)postcodeAsString
{
    return [address objectForKey: kPostcodeElement];
}

-(float)secondsUntilNextScheduledStop
{
    // TODO: finish - need to iterate through schedule items and figure out closest item in time
    // implementation depends on Cultivate choice of scheduling
    VegVanScheduleItem *_nextScheduledStop = [self getNextScheduledStop];
   
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];

    unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit |  NSMinuteCalendarUnit;
    NSDateComponents *components =[gregorian components:unitFlags fromDate:[NSDate date]];
    NSInteger weekday_now = [components weekday];
    NSInteger hour_now = [components hour];
    NSInteger minute_now = [components minute];
    
    NSInteger weekSecondsElapsed_now = ((weekday_now-1)*86400)+((hour_now-1)*3600)+(minute_now*60);
    NSInteger weekSecondsElapsed_item = (([_nextScheduledStop getDayAsInteger]-1)*86400)
                                        +(([_nextScheduledStop getHourAsInteger]-1)*3600)
                                        +([_nextScheduledStop getMinuteAsInteger]*60);
    
    BOOL scheduledDateEarlierInWeek = NO;
    if ([_nextScheduledStop getDayAsInteger]<weekday_now)
    {
        scheduledDateEarlierInWeek = YES;
    }
    else if ([_nextScheduledStop getDayAsInteger]==weekday_now)
    {
        if ([_nextScheduledStop getHourAsInteger]<hour_now)
        {
            scheduledDateEarlierInWeek = YES;
        }
        else if ([_nextScheduledStop getHourAsInteger]==hour_now)
        {
            if ([_nextScheduledStop getMinuteAsInteger]<minute_now)
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
        return weekSecondsElapsed_item-weekSecondsElapsed_now;
    }
    // TEMPORARY ONLY - FOR TESTING
   // return (rand() / RAND_MAX) * 100;
}

-(NSString*)postcodeAndNextScheduledStopAsString
{
    NSString *nextScheduledStopAsString = [self nextStopTimeAsStringLessFrequency];
    NSString *postcode = [self postcodeAsString];
    return [NSString stringWithFormat:@"%@%@%@", postcode, @" | ",nextScheduledStopAsString];
}

-(VegVanScheduleItem*)getNextScheduledStop
{
    if (self.nextScheduledStop == nil)
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
            NSInteger weekSecondsElapsed_now = ((weekday_now-1)*86400)+((hour_now-1)*3600)+(minute_now*60);
            NSInteger weekSecondsElapsed_item = 0;
            NSInteger diff = 0;
            NSInteger smallestDiff = 691200;
            
            for (VegVanScheduleItem *item in itemsTodayOrAfterToday)
            {
                if ([item getHourAsInteger]>hour_now || [item getHourAsInteger]==hour_now && [item getMinuteAsInteger] > minute_now)
                {
                    weekSecondsElapsed_item = (([item getDayAsInteger]-1)*86400)
                    +(([item getHourAsInteger]-1)*3600)
                    +([item getMinuteAsInteger]*60);
                    
                    diff = weekSecondsElapsed_item-weekSecondsElapsed_now;
                    
                    if (diff<smallestDiff)
                    {
                        nextScheduled = item;
                        smallestDiff = diff;
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
        
        self.nextScheduledStop = nextScheduled;
    }
    return self.nextScheduledStop;
}

-(NSString*)nextStopTimeAsString
{
    VegVanScheduleItem *item = nextScheduledStop;
    if (item == nil) 
        item = [self getNextScheduledStop];
   
    return [item scheduleDetailAsString];
}


-(NSString*)nextStopTimeAsStringLessFrequency
{
    VegVanScheduleItem *item = nextScheduledStop;
    if (item == nil) 
        item = [self getNextScheduledStop];
    
    return [item scheduleDetailAsStringLessFrequency];
}

-(void)description
{
    NSLog(@"name = %@, area = %@", name, area);
}

@end
