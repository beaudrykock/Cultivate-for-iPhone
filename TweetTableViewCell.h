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

@interface TweetTableViewCell : UITableViewCell
{
    IFTweetLabel *tweetLabel;
    UIImageView *profileImage;
}

@property (nonatomic, strong) IFTweetLabel *tweetLabel;
@property (nonatomic, strong) UIImageView *profileImage;

-(void)setupWithText:(NSString*)text /*andImageURLString:(NSString*)urlString*/ andSize:(NSValue*)sizeAsValue andImage:(UIImage*)image;

@end
