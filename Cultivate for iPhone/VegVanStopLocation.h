//
//  VegVanStopLocation.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VegVanStopLocation : NSObject <MKAnnotation>
{
    NSString *stopName;
    NSString *stopAddress;
    NSString *nextStopTime;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *stopName;
@property (copy) NSString *stopAddress;
@property (copy) NSString *nextStopTime;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address time:(NSString*)time coordinate:(CLLocationCoordinate2D)coordinate;

@end
