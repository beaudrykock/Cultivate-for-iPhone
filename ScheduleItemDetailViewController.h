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
    __weak id <ScheduleItemDetailViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *stopName;
@property (nonatomic, retain) IBOutlet UILabel *stopAddress;
@property (nonatomic, retain) IBOutlet UILabel *stopBlurb;
@property (nonatomic, retain) IBOutlet UILabel *stopManager;
@property (nonatomic, retain) IBOutlet UILabel *stopManagerContact;
@property (nonatomic, retain) IBOutlet UIImageView *stopPhoto;
@property (weak) id  <ScheduleItemDetailViewControllerDelegate> delegate; 

-(void)addGestureRecognizers;
-(IBAction)removeView:(id)sender;
-(void)prettify;

@end
