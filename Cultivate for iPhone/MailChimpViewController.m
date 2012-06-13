//
//  MailChimpViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/30/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "MailChimpViewController.h"

@implementation MailChimpViewController
@synthesize list_title, email_field, firstname_field, lastname_field, listType, introBlurb, postcode_field, delegate, cb_1, cb_2, cb_3, cb_4, cb_5, label_cb_1, label_cb_2, label_cb_3, label_cb_4, label_cb_5, options_title, subscribe_btn, firstname_title, lastname_title, postcode_title, email_title, topView, midView, botView, container, cancel_btn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.container setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+230.0)];
    
    //UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
   // [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
   // [self.view addGestureRecognizer:swipe];
    
    
    [self.list_title setText: listType];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *button_tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonChoiceMade:)];
    [self.cb_1 addGestureRecognizer:button_tap_1];
     UITapGestureRecognizer *button_tap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonChoiceMade:)];
    [self.cb_2 addGestureRecognizer:button_tap_2];
     UITapGestureRecognizer *button_tap_3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonChoiceMade:)];
    [self.cb_3 addGestureRecognizer:button_tap_3];
     UITapGestureRecognizer *button_tap_4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonChoiceMade:)];
    [self.cb_4 addGestureRecognizer:button_tap_4];
     UITapGestureRecognizer *button_tap_5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonChoiceMade:)];
    [self.cb_5 addGestureRecognizer:button_tap_5];
    
    UITapGestureRecognizer *subscribe_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(joinMailingList:)];
    [self.subscribe_btn addGestureRecognizer:subscribe_tap];
    
    UITapGestureRecognizer *cancel_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    [self.cancel_btn addGestureRecognizer:cancel_tap];
    

    if ([listType isEqualToString: kJoinVolunteerMailingList])
    {
        [self.options_title setText: @"I can volunteer..."];
        [self.label_cb_1 setText: @"Weekly"];
        [self.label_cb_2 setText: @"Monthly"];
        [self.label_cb_3 setText: @"Once in a blue moon"];
        [self.label_cb_4 setHidden:YES];
        [self.label_cb_5 setHidden:YES];
        [self.cb_4 setHidden: YES];
        [self.cb_5 setHidden: YES];
    }
    else
    {
        [self.options_title setText: @"Sign me up as a..."];
        [self.label_cb_1 setText: @"Customer"];
        [self.label_cb_2 setText: @"Local champion"];
        [self.label_cb_3 setText: @"Member"];
        [self.label_cb_4 setText: @"Volunteer"];
        [self.label_cb_5 setText: @"Kept informed"];
    }
    
    [self.list_title setFont: [UIFont fontWithName: kTitleFont size: 26.0]];
    [self.firstname_title setFont: [UIFont fontWithName: kTextFont size: self.firstname_title.font.pointSize]];
    [self.lastname_title setFont: [UIFont fontWithName: kTextFont size: self.lastname_title.font.pointSize]];
    [self.postcode_title setFont: [UIFont fontWithName: kTextFont size: self.postcode_title.font.pointSize]];
    [self.email_title setFont: [UIFont fontWithName: kTextFont size: self.email_title.font.pointSize]];
    [self.label_cb_1 setFont: [UIFont fontWithName: kTextFont size: self.label_cb_1.font.pointSize]];
    [self.label_cb_2 setFont: [UIFont fontWithName: kTextFont size: self.label_cb_2.font.pointSize]];
    [self.label_cb_3 setFont: [UIFont fontWithName: kTextFont size: self.label_cb_3.font.pointSize]];
    [self.label_cb_4 setFont: [UIFont fontWithName: kTextFont size: self.label_cb_4.font.pointSize]];
    [self.label_cb_5 setFont: [UIFont fontWithName: kTextFont size: self.label_cb_5.font.pointSize]];
    [self.options_title setFont: [UIFont fontWithName: kTextFontBold size: self.options_title.font.pointSize]];
    
    self.topView.layer.cornerRadius = 8.0;
    self.midView.layer.cornerRadius = 8.0;
    self.botView.layer.cornerRadius = 8.0;
    
    [self.subscribe_btn setButtonTitle: @"Subscribe"];
    [self.subscribe_btn setSize: CGSizeMake(290.0, 37.0)];
    [self.subscribe_btn setFillWith:[Utilities colorWithHexString:@"#0f4d6f"] andHighlightedFillWith:[Utilities colorWithHexString:@"#092e42"] andBorderWith:[UIColor whiteColor] andTextWith:[UIColor whiteColor]];
    
    [self.cancel_btn setButtonTitle: @"Cancel"];
    [self.cancel_btn setSize: CGSizeMake(290.0, 37.0)];
    [self.cancel_btn setFillWith:[Utilities colorWithHexString:@"#771d10"] andHighlightedFillWith:[Utilities colorWithHexString:@"#61180d"] andBorderWith:[UIColor whiteColor] andTextWith:[UIColor whiteColor]];
    
    // test
    //[self unsubscribe];
    //[self fetchList];
    //[self fetchListMembers];
    //[self fetchListMemberInfo];
    //[self fetchListTemplate];
    //[self testSubscribe];
    //[self fetchListInterestGroupings];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"Join mailing list view"
                                         withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
}

#pragma mark -
#pragma mark Keyboard management
-(void)hideKeyboard
{
    [firstname_field resignFirstResponder];
    [lastname_field resignFirstResponder];
    [email_field resignFirstResponder];
}

-(IBAction)buttonChoiceMade:(UITapGestureRecognizer*)tap
{
    if ([listType isEqualToString:kJoinMainMailingList])
    {
        BOOL add = NO;
        NSInteger tag = 0;
        CustomCheckbox *checkbox = (CustomCheckbox*)tap.view;
        if (checkbox == cb_1)
        {
            tag = 100;
            if (!cb_1_isOn)
            {
                add = YES;
                cb_1_isOn = YES;
                
            }
            else
            {
                cb_1_isOn = NO;
            }
            
        }
        else if (checkbox == cb_2)
        {
            tag = 200;
            if (!cb_2_isOn)
            {
                add = YES;
                cb_2_isOn = YES;
                
            }
            else
            {
                cb_2_isOn = NO;
            }
        }
        else if (checkbox == cb_3)
        {
            tag = 300;
            if (!cb_3_isOn)
            {
                add = YES;
                cb_3_isOn = YES;
                
            }
            else
            {
                cb_3_isOn = NO;
            }
        }
        else if (checkbox == cb_4)
        {
            tag = 400;
            if (!cb_4_isOn)
            {
                
                add = YES;
                cb_4_isOn = YES;
                
            }
            else
            {
                cb_4_isOn = NO;
            }
        }
        else if (checkbox == cb_5)
        {
             tag = 500;
            if (!cb_5_isOn)
            {
               
                add = YES;
                cb_5_isOn = YES;
                
            }
            else
            {
                cb_5_isOn = NO;
            }
        }
        
        if (add)
        {
            float x = checkbox.frame.origin.x;
            float y = checkbox.frame.origin.y;
            NSString* tractorPath = [[NSBundle mainBundle] pathForResource:@"136-tractor" ofType:@"png"];
            UIImage* tractorImage = [[UIImage alloc] initWithContentsOfFile:tractorPath];
            UIImageView *tractorView = [[UIImageView alloc] initWithImage:tractorImage];
            [tractorView setFrame: CGRectMake(x+4,y+7,27.0,17.0)];
            tractorView.tag = tag;
            [self.botView addSubview:tractorView];
        }
        else
        {
            [[self.view viewWithTag: tag] removeFromSuperview];
        }
    }
    else
    {
        BOOL add = NO;
        NSInteger tag = 0;
        NSInteger discard_1 = 0;
        NSInteger discard_2 = 0;
        CustomCheckbox *checkbox = (CustomCheckbox*)tap.view;
        if (checkbox == cb_1)
        {
            tag = 100;
            if (!cb_1_isOn)
            {
                volunteerFrequencySelection = kWeekly;
                add = YES;
                cb_1_isOn = YES;
                cb_2_isOn = NO;
                cb_3_isOn = NO;
                discard_1 = 200;
                discard_2 = 300;
            }
            else
            {
                cb_1_isOn = NO;
            }
            
        }
        else if (checkbox == cb_2)
        {
            tag = 200;
            if (!cb_2_isOn)
            {
                volunteerFrequencySelection = kMonthly;
                add = YES;
                cb_2_isOn = YES;
                cb_1_isOn = NO;
                cb_3_isOn = NO;
                discard_1 = 100;
                discard_2 = 300;
            }
            else
            {
                cb_2_isOn = NO;
            }
        }
        else if (checkbox == cb_3)
        {
            tag = 300;
            if (!cb_3_isOn)
            {
                volunteerFrequencySelection = kOnceInABlueMoon;
                add = YES;
                cb_3_isOn = YES;
                cb_2_isOn = NO;
                cb_1_isOn = NO;
                discard_1 = 200;
                discard_2 = 100;
            }
            else
            {
                cb_3_isOn = NO;
            }
        }
        
        if (add)
        {
            float x = checkbox.frame.origin.x;
            float y = checkbox.frame.origin.y;
            NSString* tractorPath = [[NSBundle mainBundle] pathForResource:@"136-tractor" ofType:@"png"];
            UIImage* tractorImage = [[UIImage alloc] initWithContentsOfFile:tractorPath];
            UIImageView *tractorView = [[UIImageView alloc] initWithImage:tractorImage];
            [tractorView setFrame: CGRectMake(x+4,y+7,27.0,17.0)];
            tractorView.tag = tag;
            [self.botView addSubview:tractorView];
            
            [[self.view viewWithTag: discard_1] removeFromSuperview];
            [[self.view viewWithTag: discard_2] removeFromSuperview];
        }
        else
        {
            [[self.view viewWithTag: tag] removeFromSuperview];
        }
    }
}


#pragma mark -
#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark MailChimp
- (void)ckRequestSucceeded:(ChimpKit *)ckRequest {
    NSLog(@"HTTP Status Code: %d", [ckRequest responseStatusCode]);
    NSLog(@"Response String: %@", [ckRequest responseString]);
    
    [self notifySubscriptionSuccess:YES];
    
    //NSDictionary *jsonDict = [[ckRequest responseString] JSONValue]; 
    
    //NSLog(@"rd = %@", [jsonDict description]);
}

- (void)ckRequestFailed:(ChimpKit *)ckRequest andError:(NSError *)error
{
    NSLog(@"Response Error: %@", error);

    NSDictionary *jsonDict = [[ckRequest responseString] JSONValue]; 

    NSLog(@"Response data from failure: %@", [jsonDict description]);
    
     [self notifySubscriptionSuccess:NO];
}

-(void)notifySubscriptionSuccess:(BOOL)successful
{
    if (successful)
    {
        UIAlertView *successfulSubscribe = [[UIAlertView alloc]
                                     initWithTitle:@"Thank you!"
                                     message:@"You will shortly receive an e-mail asking for confirmation of the subscription request"
                                     delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        successfulSubscribe.tag = 1000;
        [successfulSubscribe show];
    }
    else
    {
        UIAlertView *unsuccessfulSubscribe = [[UIAlertView alloc]
                                            initWithTitle:@"Sorry!"
                                            message:@"There's a problem and we can't subscribe you - please try again later"
                                            delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        unsuccessfulSubscribe.tag = 2000;
        [unsuccessfulSubscribe show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1000)
    {
        [self.delegate mailChimpViewControllerDidCancel];
    }
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

-(void)fetchListInterestGroupings
{
    ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                            andApiKey:kMailChimpAPIKey];
    [ck callApiMethod:@"listInterestGroupings" withParams: [NSDictionary dictionaryWithObjectsAndKeys:kMailChimpAPIKey, @"apikey", kVolunteerMailingListID, @"id", nil ]];
}

-(void)fetchListMemberInfo
{
    ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                            andApiKey:kMailChimpAPIKey];
    
    NSMutableDictionary *emails = [NSMutableDictionary dictionary];
    [emails setValue:@"beaudry.kock@ouce.ox.ac.uk" forKey:@"email_address"];
    
    [ck callApiMethod:@"listMemberInfo" withParams: [NSDictionary dictionaryWithObjectsAndKeys:kMailChimpAPIKey, @"apikey", kVolunteerMailingListID, @"id", emails, @"email_address", nil ]];
}

-(void)fetchListTemplate
{
    ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                            andApiKey:kMailChimpAPIKey];
    [ck callApiMethod:@"templateInfo" withParams: [NSDictionary dictionaryWithObjectsAndKeys:kMailChimpAPIKey, @"apikey", kVolunteerMailingListID, @"tid", nil ]];
}

-(void)unsubscribe
{
    ChimpKit *ck = [[ChimpKit alloc] initWithDelegate:self 
                                            andApiKey:kMailChimpAPIKey];
    [ck callApiMethod:@"listUnsubscribe" withParams: [NSDictionary dictionaryWithObjectsAndKeys:kMailChimpAPIKey, @"apikey", kVolunteerMailingListID, @"id", @"beaudry.kock@ouce.ox.ac.uk", @"email_address", @"YES", @"delete_member", @"NO", @"send_goodbye", @"NO", @"send_notify", nil ]];
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
    [mergeVars setValue:@"OX1 1QY" forKey:@"MMERGE4"];
    [mergeVars setValue:@"1" forKey: @"weekly"];
    NSMutableDictionary *groups = [NSMutableDictionary dictionary];
    [groups setValue:@"4913" forKey:@"id"];
    [groups setValue:@"Weekly,Monthly" forKey:@"groups"];
    [mergeVars setValue:[NSArray arrayWithObjects:groups, nil] forKey:@"GROUPINGS"];
    [params setValue:mergeVars forKey:@"merge_vars"];
    //[params setValue:@"1" forKey: @"weekly"];
    NSLog(@"desc = %@", [params description]);
    
    [ck callApiMethod:@"listSubscribe" withParams:params];
}

-(IBAction)joinMailingList:(id)sender
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kFeedbackEvent
                                         action:@"Join mailing list"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    // parse e-mail
    NSString *email_text = [email_field text];
    NSString *firstname = [firstname_field text];
    NSString *lastname = [lastname_field text];
    NSString *postcode = [postcode_field text];
    
    if ([self NSStringIsValidEmail:email_text])
    {
        if ([firstname length]>0 && [lastname length]>0)
        {
            
            if ([listType isEqualToString: kJoinMainMailingList] || ([listType isEqualToString: kJoinVolunteerMailingList] && [postcode length]>0))
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
                [mergeVars setValue:postcode forKey:@"MMERGE3"];
                
                NSMutableDictionary *groups = [NSMutableDictionary dictionary];
                if ([listType isEqualToString: kJoinMainMailingList])
                {
                    [groups setValue:@"397" forKey:@"id"];
                    // [groups setValue:@"Weekly,Monthly" forKey:@"groups"];
                    NSMutableArray *groupingsChosen = [NSMutableArray arrayWithCapacity:5];
                    if (cb_1_isOn)
                    {
                        [groupingsChosen addObject:@"being a customer"];
                    }
                    if (cb_2_isOn)
                    {
                        [groupingsChosen addObject:@"being a local champion"];
                    }
                    if (cb_3_isOn)
                    {
                        [groupingsChosen addObject:@"being a member"];
                    }
                    if (cb_4_isOn)
                    {
                        [groupingsChosen addObject:@"being a volunteer"];
                    }
                    if (cb_5_isOn)
                    {
                        [groupingsChosen addObject:@"keeping informed"];
                    }
                    
                    NSString *finalStr = @"";
                    for (NSString *string in groupingsChosen)
                    {
                        finalStr = [finalStr stringByAppendingFormat:@"%@%@",string,@","];
                    }
                    NSLog(@"finalstr = %@", finalStr);
                    [groups setValue:finalStr forKey:@"groups"];
                }
                else
                {
                    [groups setValue:@"4913" forKey:@"id"];
                    [groups setValue:volunteerFrequencySelection forKey:@"groups"];
                    NSLog(@"vfs = %@", volunteerFrequencySelection);
                    [mergeVars setValue:postcode forKey:@"MMERGE4"];
                    
                }
                [mergeVars setValue:[NSArray arrayWithObjects:groups, nil] forKey:@"GROUPINGS"];
                [params setValue:mergeVars forKey:@"merge_vars"];
                
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
        //[self joinMailingList: nil];
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
