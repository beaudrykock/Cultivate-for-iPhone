//
//  AboutViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHK.h"
#import "SHKItem.h"
#import "ChimpKit.h"
#import "MailChimpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CustomButton.h"

@interface AboutViewController : UIViewController <UIActionSheetDelegate, ChimpKitDelegate, MailChimpViewControllerDelegate>
{
    NSString *tappedListType;
    UIView *shakeView;
    CustomButton *share;
    CustomButton *getInvolved;
    UILabel *mainPara;
    UILabel *secondPara;
}

@property(nonatomic, strong) IBOutlet CustomButton*share;
@property(nonatomic, strong) IBOutlet CustomButton*getInvolved;
@property(nonatomic, strong) IBOutlet UILabel *mainPara;
@property(nonatomic, strong) IBOutlet UILabel *secondPara;

-(IBAction)share:(id)sender;
-(IBAction)showPicker:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end
