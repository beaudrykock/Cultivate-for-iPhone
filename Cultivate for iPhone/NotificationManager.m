//
//  NotificationManager.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 1/18/13.
//  Copyright (c) 2013 University of Oxford. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager

+ (NotificationManager *)sharedInstance
{
    static NotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NotificationManager alloc] init];
    });
    return sharedInstance;
}

-(void)updateNotifications
{
    NSMutableDictionary *stops = [[[Utilities sharedAppDelegate] vegVanStopManager] vegVanStops];
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if ([notifications count]>0)
    {
        for (UILocalNotification *notification in notifications)
        {
            NSDictionary* info = notification.userInfo;
            
            VegVanStop *stop = (VegVanStop*)[stops objectForKey:[info objectForKey:kScheduleItemNameKey]];
            
            // if the stop exists and is active
            if (stop!=NULL && stop.active)
            {
                // do time and day match?
                NSString *stopDay = (NSString*)[info objectForKey:kScheduleItemDayKey];
                NSString *stopTime = (NSString*)[info objectForKey:kScheduleItemTimeKey];
                
                BOOL exists = NO;
                for (VegVanScheduleItem *scheduledStop in stop.scheduleItems)
                {
                    if ([scheduledStop.stopDay isEqualToString:stopDay] && [scheduledStop.stopName isEqualToString:stopTime])
                    {
                        exists = YES;
                    }
                }
                
                // if no match found, then cancel the notification
                if (!exists)
                    [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
            // otherwise cancel
            else
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
    
    
    for (NSString *stopName in [stops allKeys])
    {
        
    }
}

@end
