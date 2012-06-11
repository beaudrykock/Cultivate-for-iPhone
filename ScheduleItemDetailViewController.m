//
//  ScheduleItemDetailViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/2/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "ScheduleItemDetailViewController.h"

@implementation ScheduleItemDetailViewController
@synthesize stopName, stopManager, stopManagerTitle, stopAddress, stopBlurb, delegate, stopManagerContact, stopManagerContactTitle, location, background_blurb, background_deets, background_address, scrollView, pageControl;

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
    
    // rounded corners to backgrounds
    self.background_address.layer.cornerRadius = 8.0;
    self.background_blurb.layer.cornerRadius = 8.0;
    self.background_deets.layer.cornerRadius = 8.0;
    
    [self.stopAddress setFont: [UIFont fontWithName:kTextFont size:17]];
    //[self.stopName setFont: [UIFont fontWithName:kTextFont size:26]];
    [self.stopBlurb setFont: [UIFont fontWithName:kTextFont size:17]];
    [self.stopManagerTitle setFont: [UIFont fontWithName:kTextFont size:17]];
    [self.stopManagerContactTitle setFont: [UIFont fontWithName:kTextFont size:17]];
    [self.stopManager setFont: [UIFont fontWithName:kTextFont size:17]];
    [self.stopManagerContact setFont: [UIFont fontWithName:kTextFont size:17]];

}

-(IBAction)takeToGoogleMaps:(id)sender
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kContentInteractionEvent
                                         action:@"Show veg van stop in Google Maps app"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    
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
    
    //UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(takeToGoogleMaps:)];
   // [stopPhoto addGestureRecognizer:mapTap];
    
    UITapGestureRecognizer *mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeToGoogleMaps:)];
    [self.scrollView addGestureRecognizer:mapTap]; 
    
    pageControlBeingUsed = YES;
    [self addScrollingImages];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"Vegvan stop detail view"
                                         withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
}

/*- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{ 
    CGPoint touchPoint=[gesture locationInView:scrollView];
    NSLog(@"touchPoint x,y = %f,%f", touchPoint.x, touchPoint.y);
}*/

-(void)addScrollingImages
{
    // to do - change number of images
    for (int i = 0; i<3; i++)
    {
        CGRect frame;
        frame.origin.x = 40.0+(self.scrollView.frame.size.width * i);
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        frame.size.width = 200.0;
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        NSString* testImageFilename = [[NSBundle mainBundle] pathForResource:@"stop_placeholder" ofType:@"png"];
        UIImage *image = [Utilities scale: [[UIImage alloc] initWithContentsOfFile:testImageFilename] toSize: CGSizeMake(frame.size.width,frame.size.height)];
        [subview setImage: image];
        [subview setContentMode:UIViewContentModeScaleAspectFit];
        subview.layer.cornerRadius = 8.0;
        subview.layer.masksToBounds = YES;
        subview.layer.borderColor = [UIColor whiteColor].CGColor;
        subview.layer.borderWidth = 2.0;
        
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    //180
    CGRect pageControlFrame = CGRectMake(0.0, 168.0, self.view.frame.size.width, 20.0);
    self.pageControl = [[CustomPageControl alloc] initWithFrame:pageControlFrame];
    self.pageControl.numberOfPages = 3;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
}

#pragma mark - Page control
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
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
