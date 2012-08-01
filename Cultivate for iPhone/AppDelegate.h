//
//  AppDelegate.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#import "VegVanStopManager.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    VegVanStopManager* vegVanStopManager;
    UIImage *userProfileImage;
    NSString *screenName;
    NSArray *tweets;
    BOOL tweetsLoaded;
    NSInteger newTweetCount;
    __weak UITabBarController *tabBarController;
}
@property (weak, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) VegVanStopManager *vegVanStopManager;
@property (strong, nonatomic) NSArray *tweets;
@property (copy, nonatomic) NSString *screenName;
@property (strong, nonatomic) UIImage *userProfileImage;

-(NSInteger)getNewTweetCount;
-(BOOL)areTweetsLoaded;
-(void)checkNotificationsEnabledStatus;
-(void)startGoogleAnalytics;
-(void)getPublicTimelineInBackground;

@end
