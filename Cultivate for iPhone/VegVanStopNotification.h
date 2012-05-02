//
//  VegVanStopNotification.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VegVanStopNotification : NSObject
{
    NSString *stopName;
    NSInteger month;
    NSInteger day;
    NSInteger year;
    NSInteger hour;
    NSInteger minute;
    NSInteger minutesBefore;
}
-(id)initWithStopName:(NSString*)_stopName day:(NSInteger)_day month: (NSInteger)_month year:(NSInteger)_year hour:(NSInteger)_hour minute:(NSInteger)_minute minutesBefore:(NSInteger)_minutesBefore;
-(NSInteger)getDay;
-(NSInteger)getMonth;
-(NSInteger)getYear;
-(NSInteger)getHour;
-(NSInteger)getMinute;
-(NSInteger)getMinutesBefore;
-(NSString*)getStopName;
@end
