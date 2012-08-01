//
//  TweetTableViewCell.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/14/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "TweetTableViewCell.h"

@implementation TweetTableViewCell
@synthesize tweetLabel, profileImage;
@synthesize replyButton, delegate, index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithText:(NSString*)text /*andImageURLString:(NSString*)urlString*/ andSize:(NSValue*)sizeAsValue andImage:(UIImage*)image andType:(NSInteger)type
{
    CGSize labelSize;
    if (sizeAsValue != nil)
    {
        labelSize = [sizeAsValue CGSizeValue];
    }
    else {
        
        labelSize = [text sizeWithFont:[UIFont fontWithName:kTextFont size:12.0]
                                                     constrainedToSize:CGSizeMake(200.0f, MAXFLOAT)
                                                        lineBreakMode:UILineBreakModeWordWrap];
    }
    // Configure the cell...
    if (tweetLabel != nil)
    {
        [tweetLabel removeFromSuperview];
        tweetLabel = nil;
    }
    if (labelSize.height < 70.0) 
        labelSize.height = 70.0;
    tweetLabel = [[IFTweetLabel alloc] initWithFrame:CGRectMake(60.0, 0.0, labelSize.width, labelSize.height+20.0)];
    [self.tweetLabel setFont:[UIFont fontWithName:kTextFont size:13.0]];
    [self.tweetLabel setTextColor:[UIColor blackColor]];
    [self.tweetLabel setBackgroundColor:[UIColor clearColor]];
    [self.tweetLabel setNumberOfLines:0];
    [self.tweetLabel setText:text];
    [self.tweetLabel setLinksEnabled:YES];
    [self addSubview:tweetLabel];
    
    if (type==kTweet)
    {
        self.replyButton = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 35.0, 26.0, 20.0)];
        [self.replyButton setBackgroundImage:[UIImage imageNamed:@"213-reply.png"] forState:UIControlStateNormal];
        [self.replyButton setAlpha:0.8];
        [self.replyButton addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.replyButton];
        
        UIView *target = [[UIView alloc] initWithFrame:CGRectMake(277.0, 23.0, 44.0, 44.0)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reply)];
        [target addGestureRecognizer:tap];
        [self addSubview:target];
    }
    //NSLog(@"frame height = %f", self.frame.size.height);
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    if (self.profileImage.superclass)
        [profileImage removeFromSuperview];
    
    self.profileImage = [[UIImageView alloc] initWithImage:image];//[[UIImageView alloc] initWithImage: [UIImage imageWithData:data]];
    [self.profileImage setFrame: CGRectMake(5.0,((labelSize.height+20.0)-50)/2.0,50.0,50.0)];
    self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
    CALayer * profileImageLayer = [profileImage layer];
    [profileImageLayer setMasksToBounds:YES];
    [profileImageLayer setCornerRadius:8.0];
    [self addSubview:self.profileImage];
}

-(void)reply
{
   [self.delegate tweetReplyAtCellIndex:index];
}

@end
