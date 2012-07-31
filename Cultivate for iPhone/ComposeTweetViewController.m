//
//  ComposeTweetViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 7/31/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "ComposeTweetViewController.h"

@interface ComposeTweetViewController ()

@end

@implementation ComposeTweetViewController
@synthesize tweetField, cultivateTweet, cultivateTweetText;

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
    [self.tweetField becomeFirstResponder];
    [self.cultivateTweet setText:cultivateTweetText];
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [self.tweetField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
