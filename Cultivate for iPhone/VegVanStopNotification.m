//
//  VegVanStopNotification.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "VegVanStopNotification.h"

@implementation VegVanStopNotification
@synthesize item, stopName, eventDate;

-(id)initWithVegVanScheduleItem:(VegVanScheduleItem*)_item andRepeat:(NSInteger)_repeatPattern andSecondsBefore:(NSInteger)_secondsBefore
{
    self = [super init];
    
    if (self != nil)
    {
        repeatPattern = _repeatPattern;
        hash = arc4random()%1000;
        self.item = _item;
        repeatPattern = _repeatPattern;
        secondsBefore = _secondsBefore;
        self.stopName = _item.stopName;
    }
    return self;
}

-(NSDate*)getRealDateFromItem
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit |  NSMinuteCalendarUnit;
    NSDateComponents *components =[gregorian components:unitFlags fromDate:[NSDate date]];
    NSInteger weekday_now = [components weekday];
    NSInteger hour_now = [components hour];
    NSInteger minute_now = [components minute];
    
    NSInteger weekday_item = [item getDayAsInteger];
    NSInteger hour_item = [item getHourAsInteger];
    NSInteger minute_item = [item getMinuteAsInteger];
    
    NSInteger seconds_elasped_now = ((weekday_now-1)*86400)+((hour_now-1)*3600)+(minute_now*60);
    NSInteger seconds_elasped_item = ((weekday_item-1)*86400)+((hour_item-1)*3600)+(minute_item*60);
    
    NSDate *realDate = nil;
    if (seconds_elasped_now < seconds_elasped_item)
    {
        realDate = [[NSDate date] dateByAddingTimeInterval:(seconds_elasped_item-seconds_elasped_now)];
    }
    else
    {
        NSInteger totalWeekSeconds = 7*24*3600;
        NSInteger remainingSecsNow = totalWeekSeconds - seconds_elasped_now;
        realDate = [[NSDate date] dateByAddingTimeInterval: remainingSecsNow + seconds_elasped_item];
    }
    
    return realDate;
}

-(void)scheduleNotification 
{
    eventDate = [self getRealDateFromItem];
    //NSLog(@"SCHEDULING NOTIFICATION...");
    //NSLog(@"scheduleNotification: eventDate = %@", [eventDate description]);
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
    return;
    //NSLog(@"scheduleNotification: stopName = %@", self.stopName);
    //NSLog(@"scheduleNotification: secondsbefore = %i", secondsBefore);
    //NSLog(@"scheduleNotification: repeatPattern = %i", repeatPattern);
    localNotif.fireDate = [eventDate dateByAddingTimeInterval:-1*secondsBefore];
    localNotif.timeZone = [NSTimeZone systemTimeZone];
   // NSLog(@"fire date = %@", localNotif.fireDate.description);
   //NSString *address = [[[[[Utilities sharedAppDelegate] vegVanStopManager] vegVanStops] objectForKey: stopName] addressAsString];
   // NSLog(@"scheduleNotification: address = %@", address);
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"The veg van will be arriving at %@ in %i minutes.", nil),
                            self.stopName, (secondsBefore/60)];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);

    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;

    // default is no repeat
    if (repeatPattern == kRepeatPatternWeekly)
    {
        localNotif.repeatInterval = NSWeekCalendarUnit; // repeats weekly
    }
    else if (repeatPattern == kRepeatPatternMonthly)
    {
        localNotif.repeatInterval = NSMonthCalendarUnit; // repeats weekly
    }
    
    NSLog(@"adding notification with item hash %i", [self.item scheduleItemHash]);
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt: [self.item scheduleItemHash]] forKey:kScheduleItemRefKey];
    localNotif.userInfo = infoDict;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

-(NSInteger)getSecondsBefore
{
    return secondsBefore;
}

-(NSInteger)getRepeatPattern
{
    return repeatPattern;
}
@end
