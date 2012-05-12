//
//  VegVanScheduleItem.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "VegVanScheduleItem.h"

@implementation VegVanScheduleItem
@synthesize stopName, stopDay, stopTime, stopFrequency;

-(NSString*)scheduleDetailAsString
{
    // TODO: change time representation
    return [NSString stringWithFormat:@"%@%@%@%@", @"10 am Wednesdays at ", stopName, @", ", stopFrequency];
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

-(NSInteger)getDayAsInteger
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

-(void)description
{
    NSLog(@"Stop description: %@%@%@", stopName, stopDay, stopTime);
}

@end
