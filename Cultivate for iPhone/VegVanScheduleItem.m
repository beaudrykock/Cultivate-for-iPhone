//
//  VegVanScheduleItem.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "VegVanScheduleItem.h"

@implementation VegVanScheduleItem
@synthesize stopName, stopDay, stopTime, stopFrequency, stopDuration;

-(NSString*)scheduleDetailAsString
{
    return [NSString stringWithFormat:@"%@%@%@%@%@%@", stopTime, @" on ", stopDay, @", (", stopFrequency, @")"];
}

-(NSString*)scheduleDetailAsStringLessFrequency
{
    return [NSString stringWithFormat:@"%@%@%@", stopTime, @" on ", stopDay];
}

-(NSString*)scheduleDetailWithDurationAsStringLessFrequency
{
    // 
    NSInteger hours = [self getHourAsInteger];
    NSInteger minutes = [self getMinuteAsInteger];
    
    minutes += [self getDurationAsInteger];
    
    if (minutes>=60)
    {
        hours++;
        minutes = minutes-60;
    }
    
    NSNumber *newHours = [NSNumber numberWithInt:hours];
    NSNumber *newMinutes = [NSNumber numberWithInt:minutes];
    
    NSString *minsTemp = [newMinutes stringValue];
    if ([minsTemp length]==1)
    {
        // <10 minutes after hour, insert 0
        minsTemp = [NSString stringWithFormat:@"0%@",minsTemp];
    }
    
    NSString *endTime = [NSString stringWithFormat:@"%@:%@",[newHours stringValue],minsTemp]; 
    
    return [NSString stringWithFormat:@"%@-%@ on %@", stopTime, endTime, stopDay];
}


-(NSInteger)hash
{
    NSString *hashStr = [NSString stringWithFormat:@"%@%@%i",[stopTime substringToIndex: 2],[stopTime substringFromIndex: 3],[stopName hash]];
    
    return [hashStr integerValue];
}

-(NSInteger)getHourAsInteger
{
    NSString *hour = [stopTime substringToIndex: 2];
    return [hour intValue];
}

-(NSInteger)getMinuteAsInteger
{
    NSString *minute = [stopTime substringFromIndex: 3];
    return [minute intValue];
}

-(NSInteger)getDurationAsInteger
{
    return [stopDuration intValue];
}

-(NSInteger)getDayAsInteger
{
    NSArray *freqBreakdown = [self getFrequencyBrokenDown];
    BOOL validThisWeek = YES;
    if ([freqBreakdown count]>1)
    {
        // for special frequencies...
        if ([[freqBreakdown objectAtIndex:0] isEqualToString:@"Monthly"])
        {
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit |  NSMinuteCalendarUnit;
            NSDateComponents *components =[gregorian components:unitFlags fromDate:[NSDate date]];
            NSInteger weekOfMonth = [components weekOfMonth];
            
            if ([[freqBreakdown objectAtIndex:1] intValue] != weekOfMonth)
            {
                // we're not in the valid week - pass an invalid response
                validThisWeek = NO;
            }
        }
    }
    
    if (validThisWeek)
    {
        if ([stopDay caseInsensitiveCompare: @"Monday"] == NSOrderedSame)
        {
            return 2;
        }
        else if ([stopDay caseInsensitiveCompare: @"Tuesday"] == NSOrderedSame)
        {
            return 3;
        }
        else if ([stopDay caseInsensitiveCompare: @"Wednesday"] == NSOrderedSame)
        {
            return 4;
        }
        else if ([stopDay caseInsensitiveCompare: @"Thursday"] == NSOrderedSame)
        {
            return 5;
        }
        else if ([stopDay caseInsensitiveCompare: @"Friday"] == NSOrderedSame)
        {
            return 6;
        }
        else if ([stopDay caseInsensitiveCompare: @"Saturday"] == NSOrderedSame)
        {
            return 7;
        }
        else if ([stopDay caseInsensitiveCompare: @"Sunday"] == NSOrderedSame)
        {
            return 1;
        }
        else
        {
            return -1;
        }
    }
    else 
    {
        return -1;
    }
}

-(NSArray*)getFrequencyBrokenDown
{
    if ([self.stopFrequency rangeOfString:@"Weekly"].location != NSNotFound)
    {
        return [NSArray arrayWithObject:@"Weekly"]; 
    }
    else if ([self.stopFrequency rangeOfString:@"Monthly"].location != NSNotFound)
    {
        return [self.stopFrequency componentsSeparatedByString:@","];
    }
}

-(void)description
{
    NSLog(@"Stop description: %@%@%@", stopName, stopDay, stopTime);
}

@end
