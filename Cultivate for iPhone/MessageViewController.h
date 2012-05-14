//
//  MessageViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/14/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "IFTweetLabel.h"
#import "TweetTableViewCell.h"
#import "SVWebViewController.h"
#import "TweetHeaderView.h"

@interface MessageViewController : UITableViewController
{
    NSArray *tweets;
    NSMutableArray *tweetImageURLs;
    UIView *loadingOverlay;
    BOOL overlayAdded;
}

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) NSMutableArray *tweetImageURLs;
@property (nonatomic, strong) UIView *loadingOverlay;

- (void)getPublicTimeline;
- (void)handleTweetNotification:(NSNotification *)notification;
-(void)launchWebViewWithURLString:(NSString*)urlString;
-(NSMutableArray*)tweetTextsFromTweets;

@end
