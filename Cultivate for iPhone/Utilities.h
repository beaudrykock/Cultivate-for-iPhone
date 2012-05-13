//
//  Utilities.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VegVanStopNotification.h"
#import "Reachability.h"
#import "AppDelegate.h"

@interface Utilities : NSObject

+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
+(void)scheduleNotificationWithItem:(VegVanStopNotification*)item;
+(void)setDefaultMinutesBefore:(NSInteger)minutesBefore;
+(NSInteger)getDefaultMinutesBefore;
+(void)setDefaultRepeatPattern:(NSInteger)repeatPattern;
+(NSInteger)getDefaultRepeatPattern;
+(UIInterfaceOrientation) interfaceOrientation;
+(void)storePostcode:(NSString*)postcodeToStore;
+(NSString*)storedPostcode;
+(void)setup;
+(BOOL)postcodeIsValid:(NSString*)postcode;
+(BOOL)hasInternet;
+(BOOL)hostReachable;
+(AppDelegate*)sharedAppDelegate;
+(NSDictionary*)cultiRideDetails;
+(BOOL)cultiRideDetailsSet;
+(void)setCultiRideDetailsForName:(NSString*)_name mobile:(NSString*)_mobile postcode:(NSString*)_postcode;
+(void)enableLocalNotifications:(BOOL)enable;
+(BOOL)localNotificationsEnabled;
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
+(BOOL)isFirstLaunch;
+(NSMutableArray*)getVolunteerDatesWithRequestStatus;
+(void)refreshVolunteerDates;
+(void)updateVolunteerDatesWithRequestStatus:(NSMutableArray*)updatedVolunteerDates;
@end
