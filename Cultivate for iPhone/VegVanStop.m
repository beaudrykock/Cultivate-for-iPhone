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

@end
