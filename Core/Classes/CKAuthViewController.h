//
//  CKAuthViewController.h
//  ChimpKit2
//
//  Created by Amro Mousa on 8/16/11.
//  Copyright (c) 2011 MailChimp. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCKAuthDebug        0

#define kAuthorizeUrl       @"https://login.mailchimp.com/oauth2/authorize"
#define kAccessTokenUrl     @"https://login.mailchimp.com/oauth2/token"
#define kMetaDataUrl        @"https://login.mailchimp.com/oauth2/metadata"
#define kRedirectUrl        @"https://modev1.mailchimp.com/wait.html"

@protocol CKAuthViewControllerDelegate <NSObject>

- (void)ckAuthSucceededWithApiKey:(NSString *)apiKey;
- (void)ckAuthFailedWithError:(NSError *)error;

@optional
- (void)ckAuthUserDismissedView;

@end

@interface CKAuthViewController : UIViewController <UIWebViewDelegate> {

@private
    NSURLConnection *connection;
    NSMutableData *connectionData;
}

@property (assign, readwrite) id<CKAuthViewControllerDelegate> delegate;

@property (retain, nonatomic) NSString *clientId;
@property (retain, nonatomic) NSString *clientSecret;

@property (retain, nonatomic) NSString *accessToken;

@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *connectionData;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UIWebView *webview;

- (id)initWithClientId:(NSString *)cId andClientSecret:(NSString *)cSecret;
@end
