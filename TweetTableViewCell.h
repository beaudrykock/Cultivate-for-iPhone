//
//  TweetTableViewCell.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/14/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFTweetLabel.h"
#import <QuartzCore/QuartzCore.h>

@protocol TweetTableViewCellDelegate <NSObject>

-(void)tweetReplyAtCellIndex:(NSInteger)index;

@end

@interface TweetTableViewCell : UITableViewCell
{
    NSInteger index;
    IFTweetLabel *tweetLabel;
    UIImageView *profileImage;
    UIButton *replyButton;
    __weak id <TweetTableViewCellDelegate> delegate;
}

@property (nonatomic) NSInteger index;
@property (weak) id <TweetTableViewCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *replyButton;
@property (nonatomic, strong) IFTweetLabel *tweetLabel;
@property (nonatomic, strong) UIImageView *profileImage;

-(void)setupWithText:(NSString*)text /*andImageURLString:(NSString*)urlString*/ andSize:(NSValue*)sizeAsValue andImage:(UIImage*)image andType:(NSInteger)type;

@end
