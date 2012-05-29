//
//  FarmAnnotation.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/29/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "FarmAnnotation.h"

@implementation FarmAnnotation
@synthesize farmName;
@synthesize farmAddress;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        farmName = [name copy];
        farmAddress = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([farmName isKindOfClass:[NSNull class]]) 
        return @"Unknown";
    else
        return farmName;
}

- (NSString *)subtitle {
    return farmAddress;
}
@end
