//
//  AppDelegate.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#import "VegVanStopManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    VegVanStopManager* vegVanStopManager;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) VegVanStopManager *vegVanStopManager;

@end
