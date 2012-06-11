
/*
 File: TweetHeaderView.m
 Abstract: A view to display a tweet header, and support opening and closing a tweet.
 
 */

#import "tweetHeaderView.h"

@implementation TweetHeaderView


@synthesize titleLabel, delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title delegate:(id <TweetHeaderViewDelegate>)aDelegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        //float lineHeight = 1.0f;
        
        // Set up the tap gesture recognizer.
        delegate = aDelegate;        
        
        float tweetHeaderWidth = 320.0f; 
        
        if (self.bounds.size.width > tweetHeaderWidth+1.0 || self.bounds.size.width < tweetHeaderWidth-1.0)
        {
            self.bounds = CGRectMake(0.0, 0.0, tweetHeaderWidth, self.bounds.size.height);
        }
        
        // Create and configure the title label.
        CGRect titleLabelFrame = CGRectMake(self.bounds.origin.x+5.0, self.bounds.origin.y, self.bounds.size.width/2.0, self.bounds.size.height);
        titleLabelFrame.origin.y -= 11;
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.font = [UIFont fontWithName:kTitleFont size:15.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        // add thin white line to top of tweet header
        //UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tweetHeaderWidth, lineHeight)];
        //[topBorder setBackgroundColor:[UIColor whiteColor]];
        //[self addSubview:topBorder];
        
        [self setBackgroundColor:[Utilities colorWithHexString:kCultivateGreenColor]];//@"#91C65F"]];
        
    }
    
    return self;
}

@end
