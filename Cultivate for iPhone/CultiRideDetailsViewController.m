//
//  CultiRideDetailsViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/13/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "CultiRideDetailsViewController.h"

@interface CultiRideDetailsViewController ()

@end

@implementation CultiRideDetailsViewController
@synthesize name_field, postcode_field, mobile_field, updateCultiRideDetailsButton, delegate, cancelButton, viewTitle, name_label, mobile_label, postcode_label, about_label, disclaimer_label, email_label, email_field;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.updateCultiRideDetailsButton.buttonTitle = @"Update";
    [self.updateCultiRideDetailsButton setFillWith:[Utilities colorWithHexString: kCultivateGrayColor] andHighlightedFillWith: [Utilities colorWithHexString: @"#608370"]  andBorderWith: [UIColor blackColor] andTextWith: [UIColor whiteColor]];
    [self.updateCultiRideDetailsButton setSize: CGSizeMake(130.0, 37.0)];

    UITapGestureRecognizer *updateButtonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateCultiRideDetails:)];
    [self.updateCultiRideDetailsButton addGestureRecognizer:updateButtonTap];
    
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.cancelButton addGestureRecognizer:cancelTap];
    
    
    [self.view setBackgroundColor: [Utilities colorWithHexString: kCultivateGreenColor]];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self.viewTitle setFont: [UIFont fontWithName:@"nobile" size:24]];
    [self.name_label setFont: [UIFont fontWithName:@"Calibri" size:15]];
    [self.postcode_label setFont: [UIFont fontWithName:@"Calibri" size:15]];
    [self.mobile_label setFont: [UIFont fontWithName:@"Calibri" size:15]];
    [self.about_label setFont: [UIFont fontWithName:@"Calibri" size:15]];
    [self.disclaimer_label setFont: [UIFont fontWithName:@"Calibri" size:12]];
    [self.email_label setFont: [UIFont fontWithName:@"Calibri" size:15]];
    
    [self.navigationController setNavigationBarHidden: YES];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"CultiRide user details view"
                                         withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Keyboard management
-(void)hideKeyboard
{
    [name_field resignFirstResponder];
    [mobile_field resignFirstResponder];
    [email_field resignFirstResponder];
    [postcode_field resignFirstResponder];
}

-(IBAction)nextField:(id)sender
{
    UITextField*textField = (UITextField*)sender;
    if (textField.tag == 0)
    {
        [name_field resignFirstResponder];
        [mobile_field becomeFirstResponder];
    }
    else if (textField.tag == 1)
    {
        [mobile_field resignFirstResponder];
        [postcode_field becomeFirstResponder];
    }
    else if (textField.tag == 2)
    {
        [email_field resignFirstResponder];
        [postcode_field becomeFirstResponder];
    }
    else
    {
        [postcode_field resignFirstResponder];
        //[self updateCultiRideDetails: nil];
    }
}

-(void)dismiss
{
    [self.delegate cultiRideDetailsViewControllerDidFinish];
}

-(IBAction)updateCultiRideDetails:(id)sender
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kFeedbackEvent
                                         action:@"Updating user details for CultiRide"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    NSString *name = [name_field text];
    NSString *mobile = [mobile_field text];
    NSString *postcode = [postcode_field text];
    NSString *email = [email_field text];
    
    if ([name length]>0 && [mobile length]>0 && [postcode length] >0)
    {
        [Utilities setCultiRideDetailsForName: name mobile: mobile email: email postcode: postcode];
        [self dismiss];
    }
    else
    {
        [self alertIncompleteForm];
    }
}

-(void)alertIncompleteForm
{
    UIAlertView *incompleteForm = [[UIAlertView alloc]
                                   initWithTitle:@"All fields must be filled!"
                                   message:@"Please enter a name, postcode and mobile number"
                                   delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
    
    [incompleteForm show];
}

-(IBAction)cancel:(id)sender
{
    [self dismiss];
}

@end
