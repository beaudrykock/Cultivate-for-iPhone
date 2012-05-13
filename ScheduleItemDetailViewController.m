//
//  ScheduleItemDetailViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "ScheduleItemDetailViewController.h"

@implementation ScheduleItemDetailViewController
@synthesize stopName, stopManager, stopManagerTitle, stopAddress, stopBlurb, stopBlurbTitle, delegate, stopPhoto, stopManagerContact, stopManagerContactTitle, location;

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
    //[stopAddress sizeToFit];
    //[stopAddress setTextAlignment: UITextAlignmentCenter];
    [stopBlurb sizeToFit];
    [stopName setFont: [UIFont fontWithName:@"Nobile" size:26]];
    [stopBlurbTitle setFont: [UIFont fontWithName:@"Nobile" size:17]];
    [stopManagerTitle setFont: [UIFont fontWithName:@"Nobile" size:17]];
    [stopManagerContactTitle setFont: [UIFont fontWithName:@"Nobile" size:17]];

}

-(IBAction)takeToGoogleMaps:(id)sender
{
    NSString *urlString = 
    [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@ %@&layer=t", [location objectForKey:@"latitude"],[location objectForKey:@"longitude"]];
    
    NSString* encodedString =
    [urlString stringByAddingPercentEscapesUsingEncoding:
     NSUTF8StringEncoding];
    
    NSURL *aURL = [NSURL URLWithString:encodedString];
    
    [[UIApplication sharedApplication] openURL:aURL];
}

-(IBAction)removeView:(id)sender
{
    [[self delegate] hideSIDVC];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(takeToGoogleMaps:)];
    [stopPhoto addGestureRecognizer:mapTap];
    
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
