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
    float shortestTimeInSeconds = 0.0;
    NSInteger counter = 0;
    // TODO: finish - need to iterate through schedule items and figure out closest item in time
    // implementation depends on Cultivate choice of scheduling
    
    // TEMPORARY ONLY - FOR TESTING
    return (rand() / RAND_MAX) * 100;
}

-(void)description
{
    NSLog(@"name = %@, area = %@", name, area);
}

@end
