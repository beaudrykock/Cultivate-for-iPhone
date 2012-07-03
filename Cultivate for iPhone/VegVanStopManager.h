//
//  VegVanStopManager.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
#import "VegVanStop.h"
#import "VegVanScheduleItem.h"
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"

@interface VegVanStopManager : NSObject
{
    NSMutableDictionary *vegVanStops;
    NSMutableArray *vegVanStopNames;
    NSMutableArray *vegVanStopAreas;
}

@property (nonatomic, strong) NSMutableDictionary* vegVanStops;
@property (nonatomic, strong) NSMutableArray* vegVanStopNames;
@property (nonatomic, strong) NSMutableArray* vegVanStopAreas;

-(NSString*)stringStrippedOfWhitespaceAndNewlines:(NSString*)oldString;
-(BOOL)loadVegVanStops;
-(NSArray*)getStopAreasArray;
-(NSMutableDictionary*)scheduledStopStringsByArea;
-(float)secondsUntilNextScheduledStopWithName:(NSString*)stopName;
-(NSMutableArray*)stopNamesInArea:(NSString*)area;
-(NSMutableArray*)stopNamesWithStreetName:(NSString*)streetName;
-(NSMutableArray*)stopNamesWithPostcode:(NSString*)postcode;
-(NSMutableArray*)stopsForScheduledItems;

@end
