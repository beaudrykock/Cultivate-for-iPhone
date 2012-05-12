//
//  SettingsViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize minutesBeforeLabel, stepper, repeatPatternControl, notificationSettingsBackground, scrollView, name_field, postcode_field, mobile_field, cultiRideSettingsBackground, toggleNotificationsSwitch;

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
    [toggleNotificationsSwitch setOn: [Utilities localNotificationsEnabled] animated: NO];
    NSInteger currentMinutesBefore = [Utilities getDefaultMinutesBefore];
    [stepper setValue:currentMinutesBefore*1.0];
    NSNumber *value = [NSNumber numberWithDouble:[stepper value]];
    NSString *label = [NSString stringWithFormat:@"%i%@",[value intValue], @" minutes before"];
    [minutesBeforeLabel setText:label];
    [repeatPatternControl setSelectedSegmentIndex:[Utilities getDefaultRepeatPattern]];
    notificationSettingsBackground.layer.cornerRadius = 8.0;
    cultiRideSettingsBackground.layer.cornerRadius = 8.0;
    
    [scrollView setBackgroundColor: [Utilities colorWithHexString: @"#639939"]];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
    keyboardIsShown = NO;
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 510);
    self.scrollView.contentSize = scrollContentSize;
    
    if (![toggleNotificationsSwitch isOn])
    {
        [stepper setEnabled:NO];
        [repeatPatternControl setEnabled: NO];
    }
    //scrollView.exclusiveTouch = YES;
    //scrollView.canCancelContentTouches = NO;
    //scrollView.delaysContentTouches = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)toggleLocalNotifications:(id)sender
{
    UISwitch *switch_control = (UISwitch*)sender;
    
    if (![switch_control isOn])
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [stepper setEnabled:NO];
        [repeatPatternControl setEnabled:NO];
    }   
    else {
        [stepper setEnabled:YES];
        [repeatPatternControl setEnabled:YES];
    }   
    localNotificationsEnabled = [switch_control isOn];
    [Utilities enableLocalNotifications:localNotificationsEnabled];
}

#pragma mark - Keyboard management
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    CGPoint newPoint = self.scrollView.contentOffset;
    newPoint.y -= keyboardSize.height;
    [self.scrollView setContentOffset: newPoint animated:YES];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the UIScrollView if the keyboard is already shown.  This can happen if the user, after fixing editing a UITextField, scrolls the resized UIScrollView to another UITextField and attempts to edit the next UITextField.  If we were to resize the UIScrollView again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint newPoint = self.scrollView.contentOffset;
    newPoint.y += keyboardSize.height;
    [self.scrollView setContentOffset: newPoint animated:YES];
    
    keyboardIsShown = YES;
}

-(void)hideKeyboard
{
    [name_field resignFirstResponder];
    [mobile_field resignFirstResponder];
    [postcode_field resignFirstResponder];
}

-(IBAction)updateCultiRideDetails
{
    // TODO
}

-(IBAction)stepperPressed:(id)sender
{
    NSNumber *value = [NSNumber numberWithDouble: [stepper value]];
    [Utilities setDefaultMinutesBefore:[value intValue]];
    NSString *label = [NSString stringWithFormat:@"%i%@",[value intValue], @" minutes before"];
    [minutesBeforeLabel setText:label];
}

-(IBAction)patternSegmentChanged:(id)sender
{
    [Utilities setDefaultRepeatPattern: [repeatPatternControl selectedSegmentIndex]];
}



#pragma mark -
#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
