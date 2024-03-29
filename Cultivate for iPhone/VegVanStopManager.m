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
    if (![Utilities hasInternet]) // TODO: RETURN THIS TO NORMAL WHEN FINISHED TESTING
    {
        data = [NSData dataWithContentsOfFile:[Utilities cachePath:kXmlDataFile]];
        if (!data)
        {
            objectXML = [[NSBundle mainBundle] pathForResource:@"VegVanStops" ofType:@"xml"];
            data = [NSData dataWithContentsOfFile:objectXML];
        }
        loadedSuccessfully = YES;
    }
    else {
        // load from URL
        NSString *urlString = kVegVanStopXMLURL;
        // alternative: @"http://web62557.aiso.net/cultivate/VegVanStops.xml";
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        [request setTimeOutSeconds:10.0];
        [request startSynchronous];
        
        data = [request responseData];
        
        if (!data)
        {
            data = [NSData dataWithContentsOfFile:[Utilities cachePath:kXmlDataFile]];
            if (!data)
            {
                objectXML = [[NSBundle mainBundle] pathForResource:@"VegVanStops" ofType:@"xml"];
                data = [NSData dataWithContentsOfFile:objectXML];
            }
            loadedSuccessfully = YES;
        }
        else 
        {
            loadedSuccessfully = YES;
        }
        
        BOOL writtenSuccessfully = [self writeDataToFile:data];
    }
    
    // create a new SMXMLDocument
    SMXMLDocument *document = [SMXMLDocument documentWithData:data error:NULL];
    
    // Debugging: demonstrate -description of document/element classes
    // NSLog(@"Document:\n %@", document);
    
    // Pull out the <rdf> node
    SMXMLElement *root = document.root;
    
    for (SMXMLElement *vegVanStopElement in [root childrenNamed:kVegVanStopElement])
    {
        [self generateVegVanStopFromElement: vegVanStopElement];
    }
    
    [self removeInactiveAreas];

    return loadedSuccessfully;
}

-(void)removeInactiveAreas
{
    NSMutableArray *areasToRemove = [NSMutableArray arrayWithCapacity:5];
    for (NSString *area in vegVanStopAreas)
    {
        BOOL activeArea = NO;
        for (NSString *stopName in vegVanStopNames)
        {
            VegVanStop *stop = [vegVanStops objectForKey:stopName];
            if ([stop.area isEqualToString:area] && stop.active)
            {
                activeArea = YES;
            }
        }
        
        if (!activeArea)
            [areasToRemove addObject:area];
    }
    
    for (NSString *area in areasToRemove)
        [vegVanStopAreas removeObject:area];
}

-(BOOL)writeDataToFile:(NSData*)data
{
    return [data writeToFile:[Utilities cachePath:kXmlDataFile] atomically:YES];
}

-(void)generateVegVanStopFromElement: (SMXMLElement *)vegVanStopElement
{
    if (vegVanStops == nil)
        vegVanStops = [NSMutableDictionary dictionaryWithCapacity:15];
    
    if (vegVanStopAreas == nil)
        vegVanStopAreas = [NSMutableArray arrayWithCapacity: 10];
    
    if (vegVanStopNames == nil)
        vegVanStopNames = [NSMutableArray arrayWithCapacity: 10];
    
    
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
    [newStop setContact: [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kContactElement]]];
    NSString *isActive = [self stringStrippedOfWhitespaceAndNewlines:[vegVanStopElement valueWithPath:kActiveElement]];
    [newStop setActive:[isActive boolValue]];
    
    SMXMLElement *scheduleItemsElement = [vegVanStopElement childNamed:kScheduleItemsElement];
    
    if (scheduleItemsElement.name)
    {
        newStop.scheduleItems = [NSMutableArray arrayWithCapacity:5];
        NSArray *scheduleItems = [scheduleItemsElement childrenNamed:kScheduleItemElement];
        
        for (SMXMLElement *scheduleItemElement in scheduleItems)
        {
            VegVanScheduleItem *scheduleItem = [[VegVanScheduleItem alloc] init];
            
            [scheduleItem setStopName: [newStop name]];//[self stringStrippedOfWhitespaceAndNewlines:[scheduleItemElement valueWithPath:kStopNameElement]]];
            [scheduleItem setStopDay:[self stringStrippedOfWhitespaceAndNewlines:[scheduleItemElement valueWithPath:kStopDayElement]]];
            [scheduleItem setStopTime:[self stringStrippedOfWhitespaceAndNewlines:[scheduleItemElement valueWithPath:kStopTimeElement]]];
            [scheduleItem setStopFrequency: [self stringStrippedOfWhitespaceAndNewlines:[scheduleItemElement valueWithPath:kStopFrequencyElement]]];
            [scheduleItem setStopDuration: [self stringStrippedOfWhitespaceAndNewlines:[scheduleItemElement valueWithPath:kStopDurationElement]]];
            [newStop.scheduleItems addObject:scheduleItem];
            
        }
    }
    
    //[newStop description];
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
    
    for (NSString *aKey in vegVanStops)
    {
        //NSLog(@"key = %@", aKey);
        stop = [vegVanStops objectForKey: aKey];
        
        if (stop.active)
        {
            NSMutableArray * arrayForArea = [scheduledStopStringsByArea objectForKey: [stop area]];
            
            for (VegVanScheduleItem *item in [stop scheduleItems])
            {
                //NSLog(@"Adding to array %@", [item scheduleDetailAsString]);
                [arrayForArea addObject: [item scheduleDetailAsString]];
            }
        }
    }
    
    for (NSString *aKey in scheduledStopStringsByArea)
    {
       // NSLog(@"For area %@", aKey);
        NSMutableArray *arr = [scheduledStopStringsByArea objectForKey: aKey];
        //NSLog(@"Count = %i", [arr count]);
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
        
        if ([[stop area] rangeOfString:area options:NSCaseInsensitiveSearch].location != NSNotFound &&
            [stop active])
            [stopNames addObject:[stop name]];
    }
    
    return stopNames;
}

-(NSMutableArray*)stopNamesWithStreetName:(NSString*)streetName
{
    NSMutableArray *stopNames = [NSMutableArray arrayWithCapacity:10];
    VegVanStop *stop = nil;
    for (NSString *aKey in vegVanStops)
    {
        stop = [vegVanStops objectForKey: aKey];
        
        if ([[[stop address] objectForKey:kStreetNameElement] rangeOfString:streetName options:NSCaseInsensitiveSearch].location != NSNotFound  &&
            [stop active])
            [stopNames addObject:[stop name]];
    }
    
    return stopNames;
}

-(NSMutableArray*)stopNamesWithPostcode:(NSString*)postcode
{
    NSMutableArray *stopNames = [NSMutableArray arrayWithCapacity:10];
    VegVanStop *stop = nil;
    for (NSString *aKey in vegVanStops)
    {
        stop = [vegVanStops objectForKey: aKey];
        //NSLog(@"postcode = %@", [[stop address] objectForKey:kPostcodeElement]);
        if ([[[stop address] objectForKey:kPostcodeElement] rangeOfString:postcode options:NSCaseInsensitiveSearch].location != NSNotFound  &&
            [stop active])
            [stopNames addObject:[stop name]];
    }
    
    return stopNames;
}

// returns an array of 1 stop name per scheduled item in each stop
-(NSMutableArray*)stopsForScheduledItems
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    NSArray *stops = [vegVanStops allValues];
    
    NSInteger count = [stops count];
    for (int i = 0; i<count; i++)
    {
        VegVanStop *stop = (VegVanStop*)[stops objectAtIndex: i];
        if  ([stop active])
        {
            NSMutableArray *scheduleItems = [stop scheduleItems];
            for (VegVanScheduleItem *item in scheduleItems)
            {
                [array addObject: [item stopName]];
            }
        }
    }
    return array;
}

// returns a dictionary of arrays - each key is an area, and array contains all stops for that area
-(NSMutableDictionary*)vegVanStopsByArea
{
    VegVanStop *stop = nil;
    NSMutableDictionary *stopsByArea = [NSMutableDictionary dictionaryWithCapacity: 20];
    
    // create a new array for each area, ready for storing the actual stop strings
    for (NSString *area in vegVanStopAreas)
    {
        [stopsByArea setObject: [NSMutableArray arrayWithCapacity: 5] forKey: area];
    }
    
    for (NSString *aKey in vegVanStops)
    {
        stop = [vegVanStops objectForKey: aKey];
        NSMutableArray * arrayForArea = [stopsByArea objectForKey: [stop area]];
        
        [arrayForArea addObject: stop];
    }
    
    return stopsByArea;
}

// TODO: implement this
-(VegVanStop*)getVegVanStopForScheduledStopString:(NSString*)scheduledStopString
{
    VegVanStop *stop = nil;
    
    return stop;
}

@end
