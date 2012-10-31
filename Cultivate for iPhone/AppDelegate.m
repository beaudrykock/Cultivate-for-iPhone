//
//  AppDelegate.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "AppDelegate.h"
#import "GANTracker.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize vegVanStopManager;
@synthesize tweets;
@synthesize tabBarController, userProfileImage, screenName;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Utilities setup];
    
    [self checkNotificationsEnabledStatus];
    
    vegVanStopManager = [[VegVanStopManager alloc] init];
    BOOL successfulLoad = [vegVanStopManager loadVegVanStops];
    
    NSAssert(successfulLoad, @"Stops not loaded");
    
    // clear the badge number
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([Utilities hasInternet])
    {
        //[self getPublicTimeline];
        [self performSelectorInBackground:@selector(getPublicTimeline) withObject:nil];
        
        [self performSelectorInBackground:@selector(getUserProfileImage) withObject:nil];
        
    }
    tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.moreNavigationController.navigationBar.hidden = YES;
    
    [self startGoogleAnalytics];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

-(void)startGoogleAnalytics
{
    [[GANTracker sharedTracker] startTrackerWithAccountID:kGoogleAnalyticsKey
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
}

-(void)checkNotificationsEnabledStatus
{
    if (![Utilities localNotificationsEnabled])
    {
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        if ([notifications count]>0)
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
    }
}

-(void)getPublicTimelineInBackground
{
    if ([Utilities hasInternet])
    {
        //[self getPublicTimeline];
        [self performSelectorInBackground:@selector(getPublicTimeline) withObject:nil];
    }
    else 
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTweetsLoadingFailed object:nil];
    }
}

- (void)getPublicTimeline 
{
	// Create a request, which in this example, grabs the public timeline.
	// This example uses version 1 of the Twitter API.
	// This may need to be changed to whichever version is currently appropriate.
	TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline/CultivateOxford.json"] parameters:nil requestMethod:TWRequestMethodGET];
	
        // TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline/TestUse05477637.json"] parameters:nil requestMethod:TWRequestMethodGET];
	
    
    // Perform the request created above and create a handler block to handle the response.
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		NSString *output;
		if ([urlResponse statusCode] == 200) {
			// Parse the responseData, which we asked to be in JSON format for this request, into an NSDictionary using NSJSONSerialization.
			NSError *jsonParsingError = nil;
			tweets = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            output = [NSString stringWithFormat:@"HTTP response status: %i\nPublic timeline:\n%@", [urlResponse statusCode], tweets];
            
            newTweetCount = [Utilities updateTweets:[self tweetTextsFromTweets]];
            tweetsLoaded = YES;
            [self performSelectorOnMainThread:@selector(notifyNewTweetCount) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(notifySuccessToTweetTab) withObject:nil waitUntilDone:NO];
            
		}
		else {
			output = [NSString stringWithFormat:@"HTTP response status: %i\nerror: %@", [urlResponse statusCode], [error description]];
            NSError *jsonParsingError = nil;
            [self performSelectorOnMainThread:@selector(notifyFailureToTweetTab) withObject:nil waitUntilDone:NO];
            //NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            //NSLog(@"error desc = %@", [errorDict description]);
		}
            //NSLog(@"output = %@", output);
        
	}];
}

-(void)getUserProfileImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilename = [documentsDirectory stringByAppendingPathComponent:kUserProfileImageFilename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFilename])
    {
        self.userProfileImage = [UIImage imageWithContentsOfFile:dataFilename];
    }
    
    if (!userProfileImage)
    {
    
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
            // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
         {
                 // Did user allow us access?
             if (granted == YES)
             {
                     // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 
                     // Sanity check
                 if ([arrayOfAccounts count] > 0)
                 {
                         // Keep it simple, use the first account available
                     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                     self.screenName = [acct username];
                 }
                 
                 if ([self.screenName length]>0)
                 {
                     NSURL *url =
                     [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
                     
                     NSDictionary *params = [NSDictionary dictionaryWithObject:self.screenName
                                                                        forKey:@"screen_name"];
                     
                     TWRequest *request = [[TWRequest alloc] initWithURL:url
                                                              parameters:params
                                                           requestMethod:TWRequestMethodGET];
                     
                     [request performRequestWithHandler:
                      ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                          if (responseData) {
                              NSDictionary *user =
                              [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:NSJSONReadingAllowFragments
                                                                error:NULL];
                              
                              NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
                              
                              dispatch_async
                              (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                  NSData *imageData =
                                  [NSData dataWithContentsOfURL:
                                   [NSURL URLWithString:profileImageUrl]];
                                  
                                  self.userProfileImage = [UIImage imageWithData:imageData];
                                  
                                  NSData* imageDataAsJPEG = UIImageJPEGRepresentation(self.userProfileImage, 1.0);
                                  
                                  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                  NSString *documentsDirectory = [paths objectAtIndex:0];
                                  NSString *dataFilename = [documentsDirectory stringByAppendingPathComponent:kUserProfileImageFilename];
                                  
                                  [imageDataAsJPEG writeToFile:dataFilename atomically:NO];
                              });
                          }
                      }];
                 }
             }
         }];
    }
    
}

-(NSInteger)getNewTweetCount
{
    return newTweetCount;
}

-(BOOL)areTweetsLoaded
{
    return tweetsLoaded;
}

-(void)notifyNewTweetCount
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewTweetCountGenerated object:nil];
}

-(void)notifySuccessToTweetTab
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTweetsLoaded object:nil];
}

-(void)notifyFailureToTweetTab
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTweetsLoadingFailed object:nil];
}

-(NSMutableArray*)tweetTextsFromTweets
{
    NSMutableArray *tweetTexts = [[NSMutableArray alloc] initWithCapacity: [tweets count]];
    for (NSDictionary *dict in tweets)
    {
        [tweetTexts addObject: [dict objectForKey:@"text"]];
    }
    return tweetTexts;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
