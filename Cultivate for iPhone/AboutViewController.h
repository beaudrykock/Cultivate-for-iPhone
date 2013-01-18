//
//  AboutViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CustomButton.h"
#import "SVWebViewController.h"
#import "CustomPageControl.h"

@interface AboutViewController : UIViewController <UIActionSheetDelegate>
{
    NSString *tappedListType;
    UIView *shakeView;
    CustomButton *share;
    CustomButton *getInvolved;
    UILabel *mainPara;
    UILabel *secondPara;
    UIScrollView *scrollView;
    CustomPageControl *pageControl;
    BOOL pageControlBeingUsed;
}

@property (nonatomic, copy) NSString *vegVanStatusUpdate;
@property(nonatomic, strong) IBOutlet CustomButton*share;
@property(nonatomic, strong) IBOutlet CustomButton*getInvolved;
@property(nonatomic, strong) IBOutlet UILabel *mainPara;
@property(nonatomic, strong) IBOutlet UILabel *secondPara;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet CustomPageControl *pageControl;

-(IBAction)share:(id)sender;
-(IBAction)showPicker:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(void)launchWebViewWithURLString:(NSString*)urlString;
-(IBAction)launchCultivateWebsite;
- (IBAction)changePage;
-(void)addScrollingImages;
-(void)dismissVegVanLocationSuggestionView;

@end
