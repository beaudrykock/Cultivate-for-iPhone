//
//  AboutViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController
@synthesize share, getInvolved, mainPara, secondPara, scrollView, pageControl;

-(IBAction)contactCultivate:(id)sender
{
    [self showPicker: nil];
}

#pragma mark -
#pragma mark Launching and view cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([Utilities iPhone5])
    {
        [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height+88.0)];
    }
    
    [self.share setButtonTitle: @"Contact Cultivate"];
    [self.share setSize: CGSizeMake(130.0, 37.0)];
    [mainPara setFont: [UIFont fontWithName: kTextFont size:self.mainPara.font.pointSize]];
    pageControlBeingUsed = YES;
    
    [self updateLatestNews];
    
    [self addScrollingText];
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"About view"
                                         withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
}

-(void)updateLatestNews
{
    self.vegVanStatusUpdate = [Utilities sharedAppDelegate].vegVanStatusUpdate;
}

-(void)addScrollingText
{
    NSArray *textarr = [NSArray arrayWithObjects:self.vegVanStatusUpdate, @"Cultivate is about new ways of feeding Oxford. We’re a local food co-operative working to bring fresh, local food from our 5-acre market garden and from other Oxfordshire growers directly to you! Cultivate is people-powered! We are a co-operative owned, run and ﬁnanced by our members.",@"The VegVan, our mobile greengrocery, has a set of stops which are the same from week-to-week. You can use this app to find the one closest to you - your home, work, children’s school, church? And if you can’t find a location that works for you, let us know via the Feedback button below. We’re actively looking for new places to stop, so tell us where we should go, and we’ll hope to be near you soon.",@"Cultivate is about bringing people together. We have regular volunteer days and events, where you can learn about what we do and get stuck in. Check out the website (http://www.cultivateoxford.org) to find out what’s coming up soon. We are a membership-based organisation, so if you like what we do and want to get involved (or even if you’d just like a 10% discount on your veg) you can sign up for membership here: http://www.cultivateoxford.org/get-involved/membership.", nil];
    
    NSArray *titlearr = [NSArray arrayWithObjects:@"VegVan Status Updates", @"About Us", @"VegVan", @"Join Us", nil];
    
    for (int i = 0; i<4; i++)
    {
        CGRect frame;
        CGRect titleFrame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        titleFrame.origin.x = frame.origin.x;
        titleFrame.origin.y = 0.0;
        titleFrame.size = CGSizeMake(self.scrollView.frame.size.width, 30.0);
        frame.origin.y = titleFrame.origin.y+titleFrame.size.height;
        frame.size = CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height-titleFrame.size.height);
        
        UILabel *title = [[UILabel alloc] initWithFrame:titleFrame];
        [title setText:[titlearr objectAtIndex:i]];
        [title setTextAlignment:UITextAlignmentCenter];
        UITextView *subview = [[UITextView alloc] initWithFrame:frame];
        subview.text = [textarr objectAtIndex:i];
        [subview setEditable:NO];
        [title setFont: [UIFont fontWithName: kTitleFont size:17.0]];
        [subview setFont: [UIFont fontWithName: kTextFont size:15.0]];
        subview.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.scrollView addSubview:subview];
        [self.scrollView addSubview:title];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 4, self.scrollView.frame.size.height);
    
    float pageControl_y = 312.0;
    if ([Utilities iPhone5]) pageControl_y += 88.0;
    
    CGRect pageControlFrame = CGRectMake(0.0, pageControl_y, self.view.frame.size.width, 20.0);
    self.pageControl = [[CustomPageControl alloc] initWithFrame:pageControlFrame];
    self.pageControl.numberOfPages = 4;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Mail composition
-(IBAction)showPicker:(id)sender
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:kFeedbackEvent
                                             action:@"E-mail Cultivate"
                                              label:@""
                                              value:0
                                          withError:&error]) {
            NSLog(@"GANTracker error, %@", [error localizedDescription]);
        }
        
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Hello Cultivators!"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"info@cultivateoxford.org"];
	
	[picker setToRecipients:toRecipients];
    
	// Attach an image to the email
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
	//[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"Just wanted to say...";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
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

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:info@cultivateoxford.org&subject=Hello Cultivators!";
	NSString *body = @"&body=Just wanted to say...";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark - Cultivate logo button
-(IBAction)launchCultivateWebsite
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kContentInteractionEvent
                                         action:@"Launch Cultivate website"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    [self launchWebViewWithURLString:@"http://www.cultivateoxford.org"];
}

-(void)launchWebViewWithURLString:(NSString*)urlString
{
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:urlString];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentModalViewController:webViewController animated:YES];	
}

@end
