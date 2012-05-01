//
//  Utilities.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(void)setup
{
    if ([self storedPostcode]==nil)
    {
        [self storePostcode:kNoPostcodeStored];
    }
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

+(void)scheduleNotificationWithItem:(VegVanStopNotification*)item 
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[item getDay]];
    [dateComps setMonth:[item getMonth]];
    [dateComps setYear:[item getYear]];
    [dateComps setHour:[item getHour]];
    [dateComps setMinute:[item getMinute]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    // testing only below - need to figure out how to pass the right date
    NSDate *date = [NSDate date];
    localNotif.fireDate = [date dateByAddingTimeInterval:10];//[itemDate dateByAddingTimeInterval:-([item getMinutesBefore]*60)];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    NSLog(@"fire date = %@", localNotif.fireDate.description);
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"The veg van will be arriving at the %@ stop in %i minutes.", nil),
                            [item getStopName], [item getMinutesBefore]];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.repeatInterval = NSWeekCalendarUnit; // repeats weekly
    
    //NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[item getStopName] forKey:ToDoItemKey];
    //localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

+(void)setDefaultMinutesBefore:(NSInteger)minutesBefore
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:minutesBefore forKey:kDefaultMinutesBeforeKey];
    [prefs synchronize];
}

+(NSInteger)getDefaultMinutesBefore
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs integerForKey:kDefaultMinutesBeforeKey])
    {
        return [prefs integerForKey:kDefaultMinutesBeforeKey];
    }
    return 5; // otherwise return default
}

+(void)setDefaultRepeatPattern:(NSInteger)repeatPattern
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:repeatPattern forKey:kDefaultRepeatPatternKey];
    [prefs synchronize];
}

+(NSInteger)getDefaultRepeatPattern
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs integerForKey:kDefaultRepeatPatternKey])
    {
        return [prefs integerForKey:kDefaultRepeatPatternKey];
    }
    return 1; // otherwise return default, which is weekly
}

+(UIInterfaceOrientation) interfaceOrientation{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+(void)storePostcode:(NSString*)postcodeToStore
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:postcodeToStore forKey:kPostcodeKey];
    [prefs synchronize];
}

+(NSString*)storedPostcode
{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kPostcodeKey];
}

@end
