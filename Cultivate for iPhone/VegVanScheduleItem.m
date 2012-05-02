//
//  VegVanScheduleItem.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "VegVanScheduleItem.h"

@implementation VegVanScheduleItem
@synthesize stopName, stopTime, stopFrequency;

-(NSString*)scheduleDetailAsString
{
    // TODO: change time representation
    return [NSString stringWithFormat:@"%@%@%@%@", @"10 am Wednesdays at ", stopName, @", ", stopFrequency];
}

@end
