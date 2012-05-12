//
//  ScheduleItemDetailViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ScheduleItemDetailViewControllerDelegate
- (void)hideSIDVC;
@end
@interface ScheduleItemDetailViewController : UIViewController
{
    UILabel *stopName;
    UILabel *stopAddress;
    UILabel *stopBlurb;
    UILabel *stopManager;
    UILabel *stopManagerContact;
    UIImageView *stopPhoto;
    NSDictionary *location;
    __weak id <ScheduleItemDetailViewControllerDelegate> delegate;
}

@property (nonatomic, strong) IBOutlet UILabel *stopName;
@property (nonatomic, strong) IBOutlet UILabel *stopAddress;
@property (nonatomic, strong) IBOutlet UILabel *stopBlurb;
@property (nonatomic, strong) IBOutlet UILabel *stopManager;
@property (nonatomic, strong) IBOutlet UILabel *stopManagerContact;
@property (nonatomic, strong) IBOutlet UIImageView *stopPhoto;
@property (weak) id  <ScheduleItemDetailViewControllerDelegate> delegate; 
@property (nonatomic, strong) NSDictionary *location;

-(void)addGestureRecognizers;
-(IBAction)removeView:(id)sender;
-(void)prettify;
-(IBAction)takeToGoogleMaps:(id)sender;

@end
