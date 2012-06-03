//
//  ScheduleItemDetailViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomPageControl.h"

@protocol ScheduleItemDetailViewControllerDelegate
- (void)hideSIDVC;
@end
@interface ScheduleItemDetailViewController : UIViewController
{
    UILabel *stopName;
    UILabel *stopAddress;
    UITextView *stopBlurb;
    UILabel *stopManager;
    UILabel *stopManagerTitle;
    UILabel *stopManagerContact;
    UILabel *stopManagerContactTitle;
    NSDictionary *location;
    
    // background views
    UIView *background_address;
    UIView *background_blurb;
    UIView *background_deets;
    
    // scrolling images
    UIScrollView *scrollView;
    CustomPageControl *pageControl;
    BOOL pageControlBeingUsed;
    
    __weak id <ScheduleItemDetailViewControllerDelegate> delegate;
}

@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet CustomPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIView *background_address;
@property (nonatomic, strong) IBOutlet UIView *background_blurb;
@property (nonatomic, strong) IBOutlet UIView *background_deets;
@property (nonatomic, strong) IBOutlet UILabel *stopName;
@property (nonatomic, strong) IBOutlet UILabel *stopAddress;
@property (nonatomic, strong) IBOutlet UITextView *stopBlurb;
@property (nonatomic, strong) IBOutlet UILabel *stopManager;
@property (nonatomic, strong) IBOutlet UILabel *stopManagerContact;
@property (nonatomic, strong) IBOutlet UILabel *stopManagerTitle;
@property (nonatomic, strong) IBOutlet UILabel *stopManagerContactTitle;
@property (weak) id  <ScheduleItemDetailViewControllerDelegate> delegate; 
@property (nonatomic, strong) NSDictionary *location;

-(void)addGestureRecognizers;
-(IBAction)removeView:(id)sender;
-(void)prettify;
-(IBAction)takeToGoogleMaps:(id)sender;

@end
