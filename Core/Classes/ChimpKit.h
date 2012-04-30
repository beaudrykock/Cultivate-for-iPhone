//
//  ChimpKit.h
//  ChimpKit2
//
//  Created by Amro Mousa on 11/19/10.
//  Copyright 2011 MailChimp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@class ChimpKit;

@protocol ChimpKitDelegate <NSObject>

@optional
- (void)ckRequestSucceeded:(ChimpKit *)ckRequest;

@optional
- (void)ckRequestFailed:(NSError *)error;

@optional
- (void)ckRequestFailed:(ChimpKit *)ckRequest andError:(NSError *)error;

@end

@interface ChimpKit : NSOperation {
    id<ChimpKitDelegate> delegate;
    SEL onSuccess;
    SEL onFailure;

    NSString *apiUrl;
    NSString *apiKey;

    id userInfo;

@private
    NSURLConnection *connection;
    NSMutableData *responseData;
}

@property (assign, readwrite) id<ChimpKitDelegate> delegate;
@property (nonatomic, retain) id userInfo;

@property (nonatomic, retain) NSString *apiUrl;
@property (nonatomic, retain) NSString *apiKey;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *responseData;

@property (nonatomic, readonly) NSString *responseString;
@property (nonatomic, readonly) NSInteger responseStatusCode;
@property (nonatomic, readonly) NSError *error;

+ (void)setTimeout:(NSUInteger)tout;

-(id)initWithDelegate:(id)aDelegate andApiKey:(NSString *)key;
-(void)callApiMethod:(NSString *)method withParams:(NSDictionary *)params;
- (void)cancel;

@end