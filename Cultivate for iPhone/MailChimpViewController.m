//
//  MailChimpViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/30/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "MailChimpViewController.h"

@implementation MailChimpViewController
@synthesize list_title, email_field, firstname_field, lastname_field, listType, introBlurb, postcode_field, delegate, scrollView;

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
	// Do any additional setup after loading the view.
    
    [list_title setText: listType];
    [introBlurb setText: [self getBlurb]];
    
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
    CGSize scrollContentSize = CGSizeMake(320, 345);
    self.scrollView.contentSize = scrollContentSize;
    
    scrollView.exclusiveTouch = YES;
    scrollView.canCancelContentTouches = NO;
    scrollView.delaysContentTouches = NO;
    // test
    //[self fetchList];
    //[self fetchListMembers];
    //[self fetchListTemplate];
    //[self testSubscribe];
}

-(NSString*)getBlurb
{
    if ([listType isEqualToString: kJoinMainMailingList])
    {
        return @"Keep up with the latest news from the Cultivators. Sign up to the mailing list here.";
    }
    else
    {
        return @"Would you like to be a regular Cultivate volunteer? Sign up to this list, and we'll keep you in the loop about work days, events, and alternative ways to get involved.";
    }
}

-(void)hideKeyboard
{
    [firstname_field resignFirstResponder];
    [lastname_field resignFirstResponder];
    [email_field resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    CGPoint newPoint = self.scrollView.contentOffset;
    newPoint.y -= keyboardSize.height-44.0-20-60;
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
    newPoint.y += keyboardSize.height-44.0-20-60;
    [self.scrollView setContentOffset: newPoint animated:YES];
    
    keyboardIsShown = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark MailChimp
- (void)ckRequestSucceeded:(ChimpKit *)ckRequest {
    NSLog(@"HTTP Status Code: %d", [ckRequest responseStatusCode]);
    NSLog(@"Response String: %@", [ckRequest responseString]);
    
    //NSDictionary *jsonDict = [[ckRequest responseString] JSONValue]; 
    
    //NSLog(@"rd = %@", [jsonDict description]);
}

- (void)ckRequestFailed:(ChimpKit *)ckRequest andError:(NSError *)error
{
    NSLog(@"Response Error: %@", error);

    NSDictionary *jsonDict = [[ckRequest responseString] JSONValue]; 

    NSLog(@"Response data from failure: %@", [jsonDict description]);
}

-(void)fetchList
{
    ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                            andApiKey:kMailChimpAPIKey];
    [ck callApiMethod:@"lists" withParams:[NSDictionary dictionaryWithObjectsAndKeys:kMainMailingListID, @"list_id", nil ]];
}

-(void)fetchListMembers
{
    ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                            andApiKey:kMailChimpAPIKey];
    [ck callApiMethod:@"listMembers" withParams: [NSDictionary dictionaryWithObjectsAndKeys:kMailChimpAPIKey, @"apikey", kVolunteerMailingListID, @"id", nil ]];
}

-(void)fetchListTemplate
{
    ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                            andApiKey:kMailChimpAPIKey];
    [ck callApiMethod:@"templateInfo" withParams: [NSDictionary dictionaryWithObjectsAndKeys:kMailChimpAPIKey, @"apikey", kVolunteerMailingListID, @"tid", nil ]];
}

-(void)testSubscribe
{
    NSString *listID = kVolunteerMailingListID;
    
    ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                            andApiKey:kMailChimpAPIKey];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:listID forKey:@"id"];
    [params setValue:@"beaudry.kock@ouce.ox.ac.uk" forKey:@"email_address"];
    [params setValue:@"true" forKey:@"double_optin"];
    [params setValue:@"true" forKey:@"update_existing"];
    
    NSMutableDictionary *mergeVars = [NSMutableDictionary dictionary];
    [mergeVars setValue:@"beaudry" forKey:@"FNAME"];
    [mergeVars setValue:@"kock" forKey:@"LNAME"];
    [mergeVars setValue:@"02138" forKey:@"MMERGE3"];
    [params setValue:mergeVars forKey:@"merge_vars"];
    
    NSLog(@"desc = %@", [params description]);
    
    [ck callApiMethod:@"listSubscribe" withParams:params];
}

-(IBAction)joinMailingList:(id)sender
{
    // parse e-mail
    NSString *email_text = [email_field text];
    NSString *firstname = [firstname_field text];
    NSString *lastname = [lastname_field text];
    NSString *postcode = [postcode_field text];
    
    if ([self NSStringIsValidEmail:email_text])
    {
        if ([firstname length]>0 && [lastname length]>0)
        {
            
            if ([postcode length]>0)
            {
                NSString *listID = kVolunteerMailingListID;//[self getListID];
                
                ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                                         andApiKey:kMailChimpAPIKey];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setValue:listID forKey:@"id"];
                [params setValue:email_text forKey:@"email_address"];
                [params setValue:@"true" forKey:@"double_optin"];
                [params setValue:@"true" forKey:@"update_existing"];
                
                NSMutableDictionary *mergeVars = [NSMutableDictionary dictionary];
                [mergeVars setValue:firstname forKey:@"FNAME"];
                [mergeVars setValue:lastname forKey:@"LNAME"];
                [mergeVars setValue:postcode forKey:@"MMERGE3"];
                [params setValue:mergeVars forKey:@"merge_vars"];
                
                [ck callApiMethod:@"listSubscribe" withParams:params];
            }
            else
            {
                [self alertNeedsPostcode];
            }
        }
        else
        {
            [self alertNeedsName];
        }
    }
    else
    {
        [self alertEmailInvalid];
    }

}

-(NSString*)getListID
{
    if ([listType isEqualToString: kJoinMainMailingList])
    {
        return kMainMailingListID;
    }
    else
    {
        return kVolunteerMailingListID;
    }
}

-(void)alertEmailInvalid
{
    UIAlertView *emailInvalid = [[UIAlertView alloc]
                                 initWithTitle:@"E-mail invalid"
                                 message:@"Please enter a valid e-mail"
                                 delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    
    [emailInvalid show];

}

-(void)alertNeedsName
{
    UIAlertView *needsName = [[UIAlertView alloc]
                                 initWithTitle:@"Missing a first or last name"
                                 message:@"Please enter both first and last name"
                                 delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    
    [needsName show];
}

-(void)alertNeedsPostcode
{
    UIAlertView *needsName = [[UIAlertView alloc]
                              initWithTitle:@"Missing a postcode"
                              message:@"Please enter a postcode"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
    [needsName show];
}

// thanks to S Varma in answer to this http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction)nextField:(id)sender
{
    UITextField*textField = (UITextField*)sender;
    if (textField.tag == 0)
    {
        [firstname_field resignFirstResponder];
        [lastname_field becomeFirstResponder];
    }
    else if (textField.tag == 1)
    {
        [lastname_field resignFirstResponder];
        [email_field becomeFirstResponder];
    }
    else if (textField.tag == 2)
    {
        [email_field resignFirstResponder];
        [postcode_field becomeFirstResponder];
    }
    else
    {
        [postcode_field resignFirstResponder];
        [self joinMailingList: nil];
    }
}


-(IBAction)backgroundTap:(id)sender
{
    UITextField *textField =(UITextField*)sender;
    [textField resignFirstResponder];
}

-(IBAction)cancel:(id)sender
{
    [self.delegate mailChimpViewControllerDidCancel];
}

@end
