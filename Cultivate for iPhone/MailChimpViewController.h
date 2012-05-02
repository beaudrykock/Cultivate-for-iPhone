//
//  MailChimpViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/30/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChimpKit.h"

@interface MailChimpViewController : UIViewController <ChimpKitDelegate, UITextFieldDelegate>
{
    NSString *listType; // must be set on init
    UILabel *list_title; // customize depending on whether this is mailing list or volunteer list
    UITextField *email_field;
    UITextField *firstname_field;
    UITextField *lastname_field;
}

@property (nonatomic, strong) NSString *listType;
@property (nonatomic, strong) IBOutlet UILabel *list_title;
@property (nonatomic, strong) IBOutlet UITextField *email_field;
@property (nonatomic, strong) IBOutlet UITextField *firstname_field;
@property (nonatomic, strong) IBOutlet UITextField *lastname_field;

-(void)alertEmailInvalid;
-(void)hideKeyboard;
-(IBAction)joinMailingList:(id)sender;
-(void)alertNeedsName;
-(NSString*)getListID;
-(IBAction)nextField:(id)sender;
-(IBAction)backgroundTap:(id)sender;
@end
