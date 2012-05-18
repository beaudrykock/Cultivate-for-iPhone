//
//  Utilities.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(void)setup
{
    if ([self storedPostcode]==nil)
    {
        [self storePostcode:kNoPostcodeStored];
    }
    
    [self checkBundleCompleteness];
}

+(BOOL)postcodeIsValid:(NSString*)postcode
{
    NSPredicate *postcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPostcodeRegex];
    return ([postcodeTest evaluateWithObject:postcode]);
}

// credit to Micah Hainline
// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
//
+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];          
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];                      
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];                      
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

// credit to Micah Hainline
// http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
//
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length 
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+(void)setDefaultSecondsBefore:(NSInteger)secondsBefore
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:secondsBefore forKey:pref_timeBeforeID];
    [prefs synchronize];
}

+(NSInteger)getDefaultSecondsBefore
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs integerForKey:pref_timeBeforeID])
    {
        return [prefs integerForKey:pref_timeBeforeID];
    }
    return 600; // otherwise return default
}

+(void)setDefaultRepeatPattern:(NSInteger)repeatPattern
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:repeatPattern forKey:pref_repeatPatternID];
    [prefs synchronize];
}

+(NSInteger)getDefaultRepeatPattern
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs integerForKey:pref_timeBeforeID])
    {
        return [prefs integerForKey:pref_timeBeforeID];
    }
    return 0; // otherwise return default, which is weekly
}

+(UIInterfaceOrientation) interfaceOrientation{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+(void)storePostcode:(NSString*)postcodeToStore
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:postcodeToStore forKey:pref_postcodeID];
    [prefs synchronize];
}

+(NSString*)storedPostcode
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:pref_postcodeID];
}

+(BOOL)hasInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        return YES;
    }
    else {
        return NO;
    }
    
}

+(BOOL)hostReachable
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"http://www.cultivateoxford.org"];    
    NetworkStatus hostStatus = [reachability currentReachabilityStatus];
    if (hostStatus != NotReachable) {
        return YES;
    }
    else {
        return NO;
    }
}

+(AppDelegate*)sharedAppDelegate 
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+(BOOL)cultiRideDetailsSet
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:pref_nameID]!=nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:pref_mobileID]!=nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:pref_postcodeID]!=nil)
        return YES;
    return NO;
}

+(void)setCultiRideDetailsForName:(NSString*)_name mobile:(NSString*)_mobile postcode:(NSString*)_postcode
{
    [[NSUserDefaults standardUserDefaults] setObject:_name forKey:pref_nameID];
    [[NSUserDefaults standardUserDefaults] setObject:_mobile forKey:pref_mobileID];
    [[NSUserDefaults standardUserDefaults] setObject:_postcode forKey:pref_postcodeID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDictionary*)cultiRideDetails
{
    NSDictionary *details = [NSDictionary dictionary];
    
    [details setValue: [[NSUserDefaults standardUserDefaults] objectForKey:pref_nameID] forKey: pref_nameID];
    [details setValue: [[NSUserDefaults standardUserDefaults] objectForKey:pref_postcodeID] forKey: pref_postcodeID];
    [details setValue: [[NSUserDefaults standardUserDefaults] objectForKey:pref_mobileID] forKey: pref_mobileID];
    [details setValue: [[NSUserDefaults standardUserDefaults] objectForKey:pref_emailID] forKey: pref_emailID];
    
    
    return details;
}

+(void)enableLocalNotifications:(BOOL)enable
{
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:pref_showRemindersID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)localNotificationsEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:pref_showRemindersID];
}

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(BOOL)isFirstLaunch
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFirstLaunchRecorded])
    {
        return NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool: YES forKey: kFirstLaunchRecorded];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }

}

// refresh with new content from XML
+(void)refreshVolunteerDates
{
    NSMutableArray *volunteerDates = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey: kVolunteerDatesKey];
    
    // TODO: get new dates from XML, if possible
    //NSMutableArray *volunteerDatesFromXML = ;
    
    if (!volunteerDates)
    {
        // TODO test
        // volunteerDates = NSMutableArray arrayWithArray: volunteerDatesFromXML]; 
        
        // TODO remove
        volunteerDates = [NSMutableArray arrayWithObjects: @"May 10", @"June 5", @"July 8", @"September 18", nil];
    }
    else {
        // merge existing with XML volunteer dates to avoid duplication
        /*
         for (NSString *date in volunteerDatesFromXML)
         {
         if (![volunteerDates containsObject: date])
         {
         [volunteerDates addObject: date]; 
         }
         }
         */
    }
    [self updateVolunteerDatesWithRequestStatus:volunteerDates];

}

+(NSMutableArray*)getVolunteerDatesWithRequestStatus
{
    NSMutableArray *volunteerDates = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey: kVolunteerDatesKey];
    return volunteerDates;
}

+(void)updateVolunteerDatesWithRequestStatus:(NSMutableArray*)updatedVolunteerDates
{
    [[NSUserDefaults standardUserDefaults] setObject: updatedVolunteerDates forKey: kVolunteerDatesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)updateTweets:(NSMutableArray*)tweets
{
    NSArray *oldTweets = [[NSUserDefaults standardUserDefaults] objectForKey: kOldTweetsKey];
    if (!oldTweets)
    {
        // no stored tweets = totally new set of tweets, so just update and return number of tweets in array
        [[NSUserDefaults standardUserDefaults] setObject: tweets forKey: kOldTweetsKey];
        return [tweets count];
    }
    else
    {
        NSInteger newTweetCount = 0;
        // otherwise compare the new tweets with old
        for (NSString *tweet in tweets)
        {
            if (![oldTweets containsObject: tweet])
                newTweetCount++;
        }
        // replace old tweets
        [[NSUserDefaults standardUserDefaults] setObject: tweets forKey: kOldTweetsKey];
        return newTweetCount;
    }
}

// utility function to handle the bug in the simulator where user has to go into preferences page to set preferences
+(void)checkBundleCompleteness
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:pref_showRemindersID])
    {
        [prefs setBool:YES forKey:pref_showRemindersID];
        [prefs synchronize];
    }
    
    if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:pref_resetDetailsID])
    {
        [prefs setBool:NO forKey:pref_resetDetailsID];
        [prefs synchronize];
    }
    
    if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:pref_applySettingsToAllRemindersID])
    {
        //NSLog(@"Utilities says it has fixed a missing reset app setting");
        [prefs setBool:YES forKey:pref_applySettingsToAllRemindersID];
        [prefs synchronize];
    }
    
}

@end
