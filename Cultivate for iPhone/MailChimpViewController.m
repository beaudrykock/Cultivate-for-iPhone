//
//  MailChimpViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/30/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "MailChimpViewController.h"

@implementation MailChimpViewController
@synthesize list_title, email_field, firstname_field, lastname_field, listType;

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
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void)hideKeyboard
{
    [firstname_field resignFirstResponder];
    [lastname_field resignFirstResponder];
    [email_field resignFirstResponder];
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
}

- (void)ckRequestFailed:(NSError *)error {
    NSLog(@"Response Error: %@", error);
}

-(IBAction)joinMailingList:(id)sender
{
    // parse e-mail
    NSString *email_text = [email_field text];
    NSString *firstname = [firstname_field text];
    NSString *lastname = [lastname_field text];
    
    if ([self NSStringIsValidEmail:email_text])
    {
        if ([firstname length]>0 && [lastname length]>0)
        {
            
            NSString *listID = [self getListID];
            
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
            [params setValue:mergeVars forKey:@"merge_vars"];
            
            [ck callApiMethod:@"listSubscribe" withParams:params];
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
    else
    {
        [email_field resignFirstResponder];
        [self joinMailingList: nil];
    }
}


-(IBAction)backgroundTap:(id)sender
{
    UITextField *textField =(UITextField*)sender;
    [textField resignFirstResponder];
}

@end
