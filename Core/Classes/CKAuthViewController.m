//
//  CKAuthViewController.m
//  ChimpKit2
//
//  Created by Amro Mousa on 8/16/11.
//  Copyright (c) 2011 MailChimp. All rights reserved.
//

#import "CKAuthViewController.h"
#import "SBJson.h"

@interface CKAuthViewController()
- (void)authWithClientId:(NSString *)yd andSecret:(NSString *)secret;
- (void)getAccessTokenMetaDataForAccessToken:(NSString *)anAccessToken;
- (void)cleanup;
- (void)dismiss;
@end

@implementation CKAuthViewController
@synthesize delegate;
@synthesize clientId, clientSecret, accessToken;
@synthesize connection, connectionData;
@synthesize spinner;
@synthesize webview;

- (id)initWithClientId:(NSString *)cId andClientSecret:(NSString *)cSecret {
    self = [super init];
    if (self) {
        self.clientId = cId;
        self.clientSecret = cSecret;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Connect to MailChimp";
    self.connectionData = [NSMutableData data];
    
    //If presented modally in a new VC, add the cancel button
    if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                               target:self 
                                                                                               action:@selector(cancelButtonPressed:)] autorelease];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self authWithClientId:self.clientId andSecret:self.clientSecret];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webview stopLoading];
}

- (void)viewDidUnload {
    [self.connection cancel];
    [self setConnection:nil];
    [self setConnectionData:nil];
    [self setClientId:nil];
    [self setClientSecret:nil];
    [self setAccessToken:nil];
    [self setWebview:nil];
    
    [self setSpinner:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [connection release];
    [connectionData release];
    [clientId release];
    [clientSecret release];
    [accessToken release];
    [webview release];
    [spinner release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Helpers

- (void)authWithClientId:(NSString *)yd andSecret:(NSString *)secret {
    self.clientId = yd;
    self.clientSecret = secret;
    
    //Kick off the auth process
    NSString *url = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@",
                     kAuthorizeUrl,
                     self.clientId,
                     kRedirectUrl];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:
                              [NSURL URLWithString:url]] autorelease];
    [self.webview loadRequest:request];
}

- (void)getAccessTokenForAuthCode:(NSString *)authCode {
    [self cleanup];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAccessTokenUrl]];
    [request setHTTPMethod:@"POST"];

    NSString *postBody = [NSString stringWithFormat:@"grant_type=authorization_code&client_id=%@&client_secret=%@&code=%@&redirect_uri=%@",
                          self.clientId,
                          self.clientSecret,
                          authCode,
                          kRedirectUrl];

    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];

    self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

- (void)getAccessTokenMetaDataForAccessToken:(NSString *)anAccessToken {
    [self cleanup];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMetaDataUrl]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", anAccessToken] forHTTPHeaderField:@"Authorization"];
    
    self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

- (void)cleanup {
    self.connection = nil;
    [self.connectionData setLength:0];
}

- (void)cancelButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(ckAuthUserDismissedView)]) {
        [self.delegate ckAuthUserDismissedView];
    }
    
    [self dismiss];
}

- (void)dismiss {
    if (self.navigationController) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - <UIWebViewDelegate> Methods

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
    [self.spinner setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    [self.spinner setHidden:YES];

    NSString *currentUrl = aWebView.request.URL.absoluteString;
    if (kCKAuthDebug) NSLog(@"CKAuthViewController webview loaded url: %@", currentUrl);

    //If MailChimp redirected us to our redirect url, then the user has been auth'd
    if ([currentUrl rangeOfString:kRedirectUrl].location == 0) {
        NSArray *urlSplit = [currentUrl componentsSeparatedByString:@"code="];

        //The auth code must now be exchanged for an access token (the api key)
        NSString *authCode = [urlSplit objectAtIndex:1];
        [self getAccessTokenForAuthCode:authCode];
    }
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
    //ToDo: Show error
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.spinner setHidden:NO];

    [self.connectionData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[[NSString alloc] initWithData:self.connectionData encoding:NSUTF8StringEncoding] autorelease];
    if (kCKAuthDebug) NSLog(@"Auth Response: %@", response);

    if (!self.accessToken) {
        self.accessToken = [[response JSONValue] objectForKey:@"access_token"];

        //Get the access token metadata so we can return a proper API key
        [self getAccessTokenMetaDataForAccessToken:self.accessToken];
    } else {
        [self.spinner setHidden:YES];

        //And we're done. We can now concat the access token and the data center
        //to form the MailChimp API key and notify our delegate
        NSString *dataCenter = [[response JSONValue] objectForKey:@"dc"];
        NSString *apiKey = [NSString stringWithFormat:@"%@-%@", self.accessToken, dataCenter];
        [self.delegate ckAuthSucceededWithApiKey:apiKey];

        [self cleanup];
        [self dismiss];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.spinner setHidden:YES];

    [self.delegate ckAuthFailedWithError:error];
    [self cleanup];
}

@end
