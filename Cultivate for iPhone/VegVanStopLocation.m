//
//  VegVanStopLocation.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "VegVanStopLocation.h"


@implementation VegVanStopLocation
@synthesize stopName;
@synthesize stopAddress;
@synthesize nextStopTime;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address time:(NSString*)time coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        stopName = [name copy];
        stopAddress = [address copy];
        nextStopTime = [time copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([stopAddress isKindOfClass:[NSNull class]]) 
        return @"Unknown";
    else
        return stopAddress;
}

- (NSString *)subtitle {
    return nextStopTime;
}

@end
