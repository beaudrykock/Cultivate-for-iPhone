//
//  ComposeTweetViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 7/31/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>
{
    NSString *cultivateTweetText;
    UILabel *cultivateTweet;
    UITextView *tweetField;
}

@property (nonatomic, copy) NSString *cultivateTweetText;
@property (nonatomic, strong) IBOutlet UILabel *cultivateTweet;
@property (nonatomic, strong) IBOutlet UITextView *tweetField;

@end
