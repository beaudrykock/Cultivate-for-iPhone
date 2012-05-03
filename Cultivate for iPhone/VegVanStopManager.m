//
//  VegVanStopManager.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "VegVanStopManager.h"

@implementation VegVanStopManager
@synthesize vegVanStops, vegVanStopNames, vegVanStopAreas;

-(BOOL)loadVegVanStops
{
    NSString *objectXML = nil;
    NSData *data = nil;
    BOOL loadedSuccessfully = NO;
    if (YES || ![Utilities hasInternet] || ![Utilities hostReachable])
    {
        objectXML = [[NSBundle mainBundle] pathForResource:@"VegVanStops" ofType:@"xml"];
        data = [NSData dataWithContentsOfFile:objectXML];
                
        loadedSuccessfully = YES;
    }
    else {
        // load from URL
        NSString *urlString = @"http://www.cultivateoxford.org/vegvanstops.xml";
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        [request startSynchronous];
        
        data = [request responseData];
        
        loadedSuccessfully = YES;
    }
    
    // create a new SMXMLDocument
    SMXMLDocument *document = [SMXMLDocument documentWithData:data error:NULL];
    
    // Debugging: demonstrate -description of document/element classes
    NSLog(@"Document:\n %@", document);
    
    // Pull out the <rdf> node
    SMXMLElement *root = document.root;
    
    for (SMXMLElement *vegVanStopElement in [root childrenNamed:kVegVanStopElement])
    {
        [self generateVegVanStopFromElement: vegVanStopElement];
    }

    return loadedSuccessfully;
}

-(void)generateVegVanStopFromElement: (SMXMLElement *)vegVanStopElement
{
    if (vegVanStops == nil)
        vegVanStops = [NSMutableDictionary dictionaryWithCapacity:15];
    
    if (vegVanStopAreas == nil)
        vegVanStopAreas = [NSMutableArray arrayWithCapacity: 10];
    
    VegVanStop *newStop = [[VegVanStop alloc] init];
    
    [newStop setName:[self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kNameElement]]];
    [newStop setArea: [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kAreaElement]]];
    NSString *longitudeStr = [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kLongitudeElement]];
    NSString *latitudeStr = [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kLatitudeElement]];
    CLLocation *location = [[CLLocation alloc] initWithLatitude: [latitudeStr floatValue] longitude: [longitudeStr floatValue]];
    [newStop setLocation:location];
    NSString *streetNumber = [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kStreetNumberElement]];
    NSString *streetName = [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kStreetNameElement]];
    NSString *postcode = [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kPostcodeElement]];
    
    NSDictionary *address = [[NSDictionary alloc] initWithObjectsAndKeys:streetNumber, kStreetNumberElement, streetName, kStreetNameElement, postcode, kPostcodeElement, nil];
    [newStop setAddress:address];
    [newStop setPhotoURL:[NSURL URLWithString:[self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kPhotoURLElement]]]];
    [newStop setBlurb: [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kBlurbElement]]];
    [newStop setManager: [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kManagerElement]]];
    
    SMXMLElement *scheduleItemsElement = [vegVanStopElement childNamed:kScheduleItemsElement];
    
    if (scheduleItemsElement.name)
    {
        newStop.scheduleItems = [NSMutableArray arrayWithCapacity:5];
        NSArray *scheduleItems = [scheduleItemsElement childrenNamed:kScheduleItemElement];
        
        for (SMXMLElement *scheduleItemElement in scheduleItems)
        {
            VegVanScheduleItem *scheduleItem = [[VegVanScheduleItem alloc] init];
            
            [scheduleItem setStopName:[self stringStrippedOfWhitespaceAndNewlines:[scheduleItemElement valueWithPath:kStopNameElement]]];
            // TODO: implement dates components depending on Cultivate implementation
            
            [scheduleItem setStopFrequency: [self stringStrippedOfWhitespaceAndNewlines:[scheduleItemElement valueWithPath:kStopFrequencyElement]]];
            
            [newStop.scheduleItems addObject:scheduleItem];
            
        }
    }
    
    [vegVanStops setObject:newStop forKey:[newStop name]];
    [vegVanStopNames addObject: [newStop name]];
    if (![vegVanStopAreas containsObject: [newStop area]])
    {
        [vegVanStopAreas addObject: [newStop area]];
    }
}

-(NSString*)stringStrippedOfWhitespaceAndNewlines:(NSString*)oldString
{
    return [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(float)secondsUntilNextScheduledStopWithName:(NSString*)stopName
{
    VegVanStop* stop = [vegVanStops objectForKey:stopName];
    
    return [stop secondsUntilNextScheduledStop];
}

// returns a custom string for the schedule view, organized into arrays and then into a dictionary
// with the area key
-(NSMutableDictionary*)scheduledStopStringsByArea
{
    VegVanStop *stop = nil;
    NSMutableDictionary *scheduledStopStringsByArea = [NSMutableDictionary dictionaryWithCapacity: 20];
    
    // create a new array for each area, ready for storing the actual stop strings
    for (NSString *area in vegVanStopAreas)
    {
        [scheduledStopStringsByArea setObject: [NSMutableArray arrayWithCapacity: 5] forKey: area];
    }
    
    NSMutableArray *arrayForArea = nil;
    for (NSString *aKey in vegVanStops)
    {
        stop = [vegVanStops objectForKey: aKey];
        
        arrayForArea = [scheduledStopStringsByArea objectForKey: [stop area]];
        
        for (VegVanScheduleItem *item in [stop scheduleItems])
        {
            [arrayForArea addObject: [item scheduleDetailAsString]];
        }
    }
    
    return scheduledStopStringsByArea;
}

-(NSMutableArray*)stopNamesInArea:(NSString*)area
{
    NSMutableArray *stopNames = [NSMutableArray arrayWithCapacity:10];
    VegVanStop *stop = nil;
    for (NSString *aKey in vegVanStops)
    {
        stop = [vegVanStops objectForKey: aKey];
        
        if ([[stop area] rangeOfString:area options:NSCaseInsensitiveSearch].location != NSNotFound)
            [stopNames addObject:[stop name]];
    }
    
    return stopNames;
}

// TODO: implement this
-(VegVanStop*)getVegVanStopForScheduledStopString:(NSString*)scheduledStopString
{
    VegVanStop *stop = nil;
    
    return stop;
}

@end