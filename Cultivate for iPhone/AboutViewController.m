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
-(IBAction)showGetInvolvedActionSheet
{
	UIActionSheet *actionsheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"Get involved!"
                                  delegate:self 
                                  cancelButtonTitle:@"Cancel" 
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Join mailing list", @"Volunteer", @"Contact us", nil
								  ];
	[actionsheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [getInvolved setNeedsDisplay];
    [share setNeedsDisplay];
    if (buttonIndex ==0)
    {
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:kFeedbackEvent
                                             action:@"Open main mailing list form"
                                              label:@""
                                              value:0
                                          withError:&error]) {
            NSLog(@"GANTracker error, %@", [error localizedDescription]);
        }
        tappedListType = kJoinMainMailingList;
        [self performSegueWithIdentifier: @"join mailing list" sender: self];
        
    }
    else if (buttonIndex ==1)
    {
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:kFeedbackEvent
                                             action:@"Open volunteer mailing list form"
                                              label:@""
                                              value:0
                                          withError:&error]) {
            NSLog(@"GANTracker error, %@", [error localizedDescription]);
        }
        tappedListType = kJoinVolunteerMailingList;
        [self performSegueWithIdentifier: @"join mailing list" sender: self];
    }
    else if (buttonIndex ==2)
    {
        [self showPicker: nil];
    }
    
	//NSLog(@"button %i clicked", buttonIndex );
}

- (void)mailChimpViewControllerDidCancel
{
	[self dismissViewControllerAnimated:YES completion:nil];
    [getInvolved setNeedsDisplay];
}

-(IBAction)share:(id)selector
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kSharingEvent
                                         action:@"Share Cultivate with others"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    // Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:@"http://www.cultivateoxford.org"];
	SHKItem *item = [SHKItem URL:url title:@"Cultivate Oxford"];
    item.text = @"Check out these guys - people-powered food!";
    //item.image = ?;
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
	// Display the action sheet
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
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
    
    [self.share setButtonTitle: @"Share"];
    [self.getInvolved setButtonTitle: @"Get Involved"];
    [self.share setSize: CGSizeMake(130.0, 37.0)];
    [self.getInvolved setSize: CGSizeMake(130.0, 37.0)];
    [mainPara setFont: [UIFont fontWithName: @"Calibri" size:self.mainPara.font.pointSize]];
    pageControlBeingUsed = YES;
    [self addScrollingText];
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"About view"
                                         withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
}

-(void)addScrollingText
{
    for (int i = 0; i<3; i++)
    {
        CGRect frame;
        CGRect titleFrame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UILabel *subview = [[UILabel alloc] initWithFrame:frame];
        [subview setLineBreakMode: UILineBreakModeWordWrap];
        [subview setNumberOfLines: 0];
        subview.text = @"We are a not-for-profit social enterprise that will bring fresh, local, organically-grown food direct from farmers to the city and surrounding communities. Our five-acre market garden and other small farms nearby will provide the produce sold in the VegVan, our mobile greengrocery, which will set up wherever communities want it.";
        [subview setFont: [UIFont fontWithName: @"Calibri" size:15.0]];
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    
    CGRect pageControlFrame = CGRectMake(0.0, 283.0, self.view.frame.size.width, 20.0);
    self.pageControl = [[CustomPageControl alloc] initWithFrame:pageControlFrame];
    self.pageControl.numberOfPages = 3;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
}

-(void)shake
{
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = [ NSArray arrayWithObjects:
                   [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ],
                   [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ], 
                   nil ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    [shakeView.layer addAnimation:anim forKey:@"nil" ] ;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get reference to the destination view controller
    MailChimpViewController *mcvc = [segue destinationViewController];
    
    // Pass any objects to the view controller here, like...
    [mcvc setListType:tappedListType];
    [mcvc setDelegate: self];
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
