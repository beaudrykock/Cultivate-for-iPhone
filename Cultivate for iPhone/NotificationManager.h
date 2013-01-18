//
//  NotificationManager.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 1/18/13.
//  Copyright (c) 2013 University of Oxford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject
+ (NotificationManager *)sharedInstance;
-(void)updateNotifications;

@end
