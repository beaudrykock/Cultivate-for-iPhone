//
//  GFT.m
//  ATM
//
//  Created by Pavel Aksonov on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AKFusionTables.h"
#import "GDataHTTPFetcher.h"
#import "GDataAuthenticationFetcher.h"

static NSString *const GOOGLE_QUERY_URL = @"https://www.google.com/fusiontables/api/query";


@implementation AKFusionTables

-(id)initWithUsername:(NSString *)username password:(NSString *)password {
    googlePassword = password;
    googleUsername = username;
    
    return [super init];
}

+(NSString *)parseAuthToken:(NSString *)postData {
    NSArray *arr = [postData componentsSeparatedByString:@"\n"];
    NSString* res = nil;
    for (NSString *line in arr){
        if ([line hasPrefix:@"Auth"]){
            int index = [line rangeOfString:@"="].location;
            res = [line substringFromIndex:index+1];
            break;
        }
    }
    return [res copy];
}


-(void)checkAuth:(void (^)(void)) block {
    if (googleUsername != nil && authToken == nil){
        GDataHTTPFetcher *fetcher = [GDataAuthenticationFetcher authTokenFetcherWithUsername:googleUsername
                                                                                     password:googlePassword
                                                                                      service:@"fusiontables"
                                                                                       source:@"gft"
                                                                                 signInDomain:nil
                                                                                  accountType:@"GOOGLE"
                                                                         additionalParameters:nil
                                                                                customHeaders:nil]; 
        
        [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) { 
            if (error == nil){
                NSString *content = [[NSString alloc]
                                     initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                NSLog(@"Auth content: %@", content);
                authToken = [AKFusionTables parseAuthToken:content];
                [content release];
                
                // call block only if authentication is successful
                if (authToken != nil){
                    block();
                }
            } else {
                NSInteger code = [error code];
                NSLog(@"Error code during auth: %d", code);
            }
        }
         ];
        
    } else {
        // run block directly since we don't need authentication (user didn't pass username within constructor)
        block();
    }
}

-(void)querySql:(NSString *) sql completionHandler:(void(^)(NSData *data, NSError *error))handler {
    [self checkAuth: ^{
        NSString *url = [NSString stringWithFormat:@"%@?sql=%@", GOOGLE_QUERY_URL, [sql stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:url]];
        
        // add authorization tag if necessary
        if (authToken != nil){
            [request addValue:[NSString stringWithFormat:@"GoogleLogin auth=%@", authToken] forHTTPHeaderField:@"Authorization"];
        }
        
        GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
        [fetcher beginFetchWithCompletionHandler:handler];
    }];
    
}

-(void)modifySql:(NSString *) sql completionHandler:(void(^)(NSData *data, NSError *error))handler {
    [self checkAuth: ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:GOOGLE_QUERY_URL]];
        
        if (authToken != nil){
            [request addValue:[NSString stringWithFormat:@"GoogleLogin auth=%@", authToken] forHTTPHeaderField:@"Authorization"];
        
            GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
            NSData *postData = [[NSString stringWithFormat:@"sql=%@",sql] dataUsingEncoding:NSUTF8StringEncoding];
            [fetcher setPostData:postData];
            [fetcher beginFetchWithCompletionHandler:handler];
        } else {
            [NSException raise:@"No auth token is provided" format:@"No token"];
        }
    }];
    
}

-(void)dealloc {
    [authToken release];
    authToken = nil;
    [super dealloc];
}

@end
