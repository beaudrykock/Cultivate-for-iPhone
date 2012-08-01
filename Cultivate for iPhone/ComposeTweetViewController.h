//
//  ComposeTweetViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 7/31/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ComposeTweetViewControllerDelegate <NSObject>

-(void)sendTweetWithText:(NSString*)text;
-(void)dismissTweetView;

@end

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate>
{
    NSString *cultivateTweetText;
    UILabel *cultivateTweet;
    UITextView *tweetField;
    UILabel *charCountLabel;
    NSInteger charCount;
    UILabel *replyLabel;
    UILabel *clearLabel;
    UILabel *imageLabel;
    UILabel *cancelLabel;
    UIButton *clearButton;
    UIButton *replyButton;
    UIImageView *profileImage;
    UIImagePickerController *imagePicker;
    UIImage* selectedImage;
    UIButton *imageButton;
    UIButton *cancelButton;
    UIView *containerView;
}

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIButton *imageButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) IBOutlet UIImageView *profileImage;
@property (nonatomic, strong) IBOutlet UIButton *replyButton;
@property (nonatomic, strong) IBOutlet UIButton *clearButton;
@property (nonatomic, strong) IBOutlet UILabel *replyLabel;
@property (nonatomic, strong) IBOutlet UILabel *cancelLabel;
@property (nonatomic, strong) IBOutlet UILabel *imageLabel;
@property (nonatomic, strong) IBOutlet UILabel *clearLabel;
@property (nonatomic, assign) id <ComposeTweetViewControllerDelegate> delegate;
@property (nonatomic) NSInteger charCount;
@property (nonatomic, strong) IBOutlet UILabel *charCountLabel;
@property (nonatomic, copy) NSString *cultivateTweetText;
@property (nonatomic, strong) IBOutlet UILabel *cultivateTweet;
@property (nonatomic, strong) IBOutlet UITextView *tweetField;

@end
