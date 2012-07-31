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
#import "PullToRefreshViewController.h"
#import "ComposeTweetViewController.h"

@interface MessageViewController : PullToRefreshViewController <TweetTableViewCellDelegate>
{
    NSArray *tweets;
    NSMutableArray *tweetImageURLs;
    NSMutableArray *tableViewCellSizes;
    NSMutableArray *tableViewCellImages;
    UIView *loadingOverlay;
    BOOL overlayAdded;
    UILabel *downloadingUpdateLabel;
    UIActivityIndicatorView *activityWheel;
    BOOL loadTextField;
    NSString *replyCellTweetContents;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityWheel;
@property (nonatomic, strong) UILabel *downloadingUpdateLabel;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) NSMutableArray *tweetImageURLs;
@property (nonatomic, strong) NSMutableArray *tableViewCellSizes;
@property (nonatomic, strong) NSMutableArray *tableViewCellImages;
@property (nonatomic, strong) UIView *loadingOverlay;

- (void)getPublicTimeline;
- (void)handleTweetNotification:(NSNotification *)notification;
-(void)launchWebViewWithURLString:(NSString*)urlString;
-(NSMutableArray*)tweetTextsFromTweets;
-(void)loadingComplete;
-(void)doRefresh;
-(void)tweetReply;

@end
