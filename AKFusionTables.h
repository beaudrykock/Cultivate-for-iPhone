//
//  GFT.h
//  ATM
//
//  Created by Pavel Aksonov on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKFusionTables : NSObject {
@private
    NSString *googleUsername;
    NSString *googlePassword;
    NSString *authToken;
}
-(id)initWithUsername:(NSString *)username password:(NSString *)password;
-(void)querySql:(NSString *) sql completionHandler:(void(^)(NSData *data, NSError *error))handler;
-(void)modifySql:(NSString *) sql completionHandler:(void(^)(NSData *data, NSError *error))handler;

@end
