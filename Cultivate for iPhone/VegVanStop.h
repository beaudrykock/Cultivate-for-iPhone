//
//  VegVanStop.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VegVanStop : NSObject
{
    NSString *name;
    NSString *area;
    CLLocation *location;
    NSDictionary *address;
    NSURL *photoURL;
    NSString *blurb;
    NSString *manager;
    NSMutableArray *scheduleItems;
    
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDictionary *address;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSString *manager;
@property (nonatomic, strong) NSMutableArray *scheduleItems;

-(NSString*)addressAsString;
-(float)secondsUntilNextScheduledStop;
-(void)description;
-(NSString*)nextStopTimeAsString;

@end
