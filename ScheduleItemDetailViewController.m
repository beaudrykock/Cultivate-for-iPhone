//
//  ScheduleItemDetailViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "ScheduleItemDetailViewController.h"

@implementation ScheduleItemDetailViewController
@synthesize stopName, stopManager, stopAddress, stopBlurb, delegate, stopPhoto, stopManagerContact;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)addGestureRecognizers
{
    //UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    //[self.view addGestureRecognizer:gestureRecognizer];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc] 
                                                      initWithTarget:self 
                                                     action:@selector(removeView:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
}

-(void)prettify
{
    self.view.layer.cornerRadius = 5.0f;
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowOffset = CGSizeMake(-5, 5);
    self.view.layer.shadowOffset = CGSizeMake(-5, 5);
    self.view.layer.shadowOpacity = 0.5;
    
    [stopPhoto.layer setBorderColor: [[Utilities colorWithHexString: @"#588B21"] CGColor]];
    [stopPhoto.layer setBorderWidth: 2.0];
    
}


-(IBAction)removeView:(id)sender
{
    [[self delegate] hideSIDVC];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
