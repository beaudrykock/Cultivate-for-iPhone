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
#import <QuartzCore/QuartzCore.h>
#import "CustomCheckbox.h"

@protocol MailChimpViewControllerDelegate
- (void)mailChimpViewControllerDidCancel;
@end

@interface MailChimpViewController : UIViewController <ChimpKitDelegate, UITextFieldDelegate>
{
    NSString *listType; // must be set on init
    UILabel *list_title; // customize depending on whether this is mailing list or volunteer list
    UILabel *introBlurb;
    UITextField *email_field;
    UILabel *email_title;
    UITextField *firstname_field;
    UILabel *firstname_title;
    UITextField *lastname_field;
    UILabel *lastname_title;
    UITextField *postcode_field;
    UILabel *postcode_title;
    __weak id delegate;
    BOOL keyboardIsShown;
    NSString* volunteerFrequencySelection;
    CustomCheckbox* cb_1;
    CustomCheckbox* cb_2;
    CustomCheckbox* cb_3;
    CustomCheckbox* cb_4;
    CustomCheckbox* cb_5;
    BOOL cb_1_isOn;
    BOOL cb_2_isOn;
    BOOL cb_3_isOn;
    BOOL cb_4_isOn;
    BOOL cb_5_isOn;
    UILabel *label_cb_1;
    UILabel *label_cb_2;
    UILabel *label_cb_3;
    UILabel *label_cb_4;
    UILabel *label_cb_5;
    UILabel *options_title;
    UIButton *cancel_btn;
    UIButton *subscribe_btn;
}

@property (nonatomic, strong) IBOutlet CustomCheckbox *cb_1;
@property (nonatomic, strong) IBOutlet CustomCheckbox *cb_2;
@property (nonatomic, strong) IBOutlet CustomCheckbox *cb_3;
@property (nonatomic, strong) IBOutlet CustomCheckbox *cb_4;
@property (nonatomic, strong) IBOutlet CustomCheckbox *cb_5;
@property (nonatomic, strong) IBOutlet UILabel *label_cb_1;
@property (nonatomic, strong) IBOutlet UILabel *label_cb_2;
@property (nonatomic, strong) IBOutlet UILabel *label_cb_3;
@property (nonatomic, strong) IBOutlet UILabel *label_cb_4;
@property (nonatomic, strong) IBOutlet UILabel *email_title;
@property (nonatomic, strong) IBOutlet UILabel *firstname_title;
@property (nonatomic, strong) IBOutlet UILabel *lastname_title;
@property (nonatomic, strong) IBOutlet UILabel *postcode_title;

@property (nonatomic, strong) IBOutlet UILabel *label_cb_5;
@property (nonatomic, strong) IBOutlet UILabel *options_title;
@property (nonatomic, strong) IBOutlet UIButton *cancel_btn;
@property (nonatomic, strong) IBOutlet UIButton *subscribe_btn;
@property (nonatomic, strong) NSString *listType;
@property (nonatomic, strong) IBOutlet UILabel *list_title;
@property (nonatomic, strong) IBOutlet UILabel *introBlurb;
@property (nonatomic, strong) IBOutlet UITextField *email_field;
@property (nonatomic, strong) IBOutlet UITextField *firstname_field;
@property (nonatomic, strong) IBOutlet UITextField *lastname_field;
@property (nonatomic, strong) IBOutlet UITextField *postcode_field;
@property (nonatomic, weak) id <MailChimpViewControllerDelegate> delegate;

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
-(IBAction)buttonChoiceMade:(id)sender;
-(void)notifySubscriptionSuccess:(BOOL)successful;
@end
