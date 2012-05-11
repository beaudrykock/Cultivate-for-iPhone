//
//  MailChimpViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/30/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChimpKit.h"
#import "JSON.h"
#import "SlidingPickerViewController.h"
#import <QuartzCore/QuartzCore.h>

@protocol MailChimpViewControllerDelegate
- (void)mailChimpViewControllerDidCancel;
@end

@interface MailChimpViewController : UIViewController <ChimpKitDelegate, UITextFieldDelegate, SlidingPickerViewControllerDelegate>
{
    NSString *listType; // must be set on init
    UILabel *list_title; // customize depending on whether this is mailing list or volunteer list
    UILabel *introBlurb;
    UITextField *email_field;
    UITextField *firstname_field;
    UITextField *lastname_field;
    UITextField *postcode_field;
    __weak id delegate;
    BOOL keyboardIsShown;
    UIScrollView *scrollView;
    NSString* volunteerFrequencySelection;
    UIButton *volunteerOptionsBtn;
    SlidingPickerViewController *picker ;
}

@property (nonatomic, strong) IBOutlet UIButton *volunteerOptionsBtn;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSString *listType;
@property (nonatomic, strong) IBOutlet UILabel *list_title;
@property (nonatomic, strong) IBOutlet UILabel *introBlurb;
@property (nonatomic, strong) IBOutlet UITextField *email_field;
@property (nonatomic, strong) IBOutlet UITextField *firstname_field;
@property (nonatomic, strong) IBOutlet UITextField *lastname_field;
@property (nonatomic, strong) IBOutlet UITextField *postcode_field;
@property (nonatomic, weak) id <MailChimpViewControllerDelegate> delegate;
@property (nonatomic, strong) SlidingPickerViewController *picker;

-(void)alertEmailInvalid;
-(void)hideKeyboard;
-(IBAction)joinMailingList:(id)sender;
-(void)alertNeedsName;
-(NSString*)getListID;
-(IBAction)nextField:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(NSString*)getBlurb;
-(IBAction)cancel:(id)sender;
-(void)alertNeedsPostcode;
-(void)unsubscribe;
-(void)fetchListMemberInfo;
-(IBAction)showVolunteerInterestOptions;
-(void)slidingPickerViewControllerDidCancel;

@end
