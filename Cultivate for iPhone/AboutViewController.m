//
//  AboutViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/24/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

-(IBAction)showGetInvolvedActionSheet
{
	UIActionSheet *actionsheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"Get involved!"
                                  delegate:self 
                                  cancelButtonTitle:@"Cancel" 
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Join mailing list", @"Volunteer", @"Invest", nil
								  ];
	[actionsheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex ==0)
    {
        tappedListType = kJoinMainMailingList;
        [self performSegueWithIdentifier: @"join mailing list" sender: self];
    }
    else if (buttonIndex ==1)
    {
        tappedListType = kJoinVolunteerMailingList;
        [self performSegueWithIdentifier: @"join mailing list" sender: self];
    }
    
	NSLog(@"button %i clicked", buttonIndex );
}

-(IBAction)share:(id)selector
{
    // Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:@"http://www.cultivateoxford.org"];
	SHKItem *item = [SHKItem URL:url title:@"Cultivate Oxford"];
    item.text = @"Sharing text here";
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
    
    // test shake
    shakeView = [[UIView alloc] initWithFrame:CGRectMake(50.0, 50.0, 100.0, 100.0)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10.0,10.0,50.0,50.0);
    [button addTarget:self action:@selector(shake) forControlEvents:UIControlEventTouchUpInside];
    [shakeView addSubview:button];
    [self.view addSubview:shakeView];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get reference to the destination view controller
    MailChimpViewController *mcvc = [segue destinationViewController];
    
    // Pass any objects to the view controller here, like...
    [mcvc setListType:tappedListType];
}
@end
