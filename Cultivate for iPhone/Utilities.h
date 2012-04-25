//
//  Utilities.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
@end
