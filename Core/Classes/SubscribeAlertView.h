//
//  SubscriptionAlertView.h
//  ChimpKit2
//
//  Created by Amro Mousa on 4/6/11.
//  Copyright 2011 MailChimp. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define kSubscriptionAlertViewHeight 230
#define kSubscriptionAlertViewTextFieldHeight 30
#define kSubscriptionAlertViewTextFieldYPadding 5

@class ChimpKit;

@interface SubscribeAlertView : UIAlertView <UITextFieldDelegate, UIAlertViewDelegate> {
    UITextField *textField;
    ChimpKit *chimpKit;
    NSString *listId;
}

@property (nonatomic, retain) UITextField *textField;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
             apiKey:(NSString *)apiKey
             listId:(NSString *)aListId
  cancelButtonTitle:(NSString *)cancelButtonTitle
subscribeButtonTitle:(NSString *)subscribeButtonTitle;

@end
