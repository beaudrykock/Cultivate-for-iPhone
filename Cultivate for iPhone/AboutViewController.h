//
//  AboutViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHK.h"
#import "SHKItem.h"
#import "ChimpKit.h"
#import "MailChimpViewController.h"

@interface AboutViewController : UIViewController <UIActionSheetDelegate, ChimpKitDelegate>
{
    NSString *tappedListType;
}
-(IBAction)share:(id)sender;

@end
