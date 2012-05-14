
/*
 File: TweetHeaderView.h
 Abstract: A view to display a Tweet header, and support opening and closing a Tweet.
 
 */

#import <Foundation/Foundation.h>

@protocol TweetHeaderViewDelegate;


@interface TweetHeaderView : UIView {
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) id <TweetHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title delegate:(id <TweetHeaderViewDelegate>)aDelegate;

@end



/*
 Protocol to be adopted by the Tweet header's delegate; the Tweet header tells its delegate when the Tweet should be opened and closed.
 */
@protocol TweetHeaderViewDelegate <NSObject>

@optional

@end

