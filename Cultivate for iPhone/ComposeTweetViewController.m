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
@synthesize tweetField, cultivateTweet, cultivateTweetText, charCount, charCountLabel, delegate, replyLabel, clearButton, replyButton, clearLabel, profileImage, imagePicker, imageButton, imageLabel, removeImageButton, containerView, cancelButton, cancelLabel;

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
    
    [self.tweetField setFont:[UIFont fontWithName:kTextFont size:16.0]];
    [self.cultivateTweet setFont:[UIFont fontWithName:kTextFont size:12.0]];
    [self.replyLabel setFont:[UIFont fontWithName:kTextFont size:16.0]];
    [self.imageLabel setFont:[UIFont fontWithName:kTextFont size:16.0]];
    [self.clearLabel setFont:[UIFont fontWithName:kTextFont size:16.0]];
    [self.cancelLabel setFont:[UIFont fontWithName:kTextFont size:16.0]];
    [self.charCountLabel setFont:[UIFont fontWithName:kTextFont size:16.0]];
    [self.removeImageButton.titleLabel setFont:[UIFont fontWithName:kTextFont size:16.0]];
    [self.charCountLabel setText:@"17/140 + 0 images"];
    [self.removeImageButton setHidden:YES];
    
    CALayer * profileImageLayer = [self.profileImage layer];
    [profileImageLayer setMasksToBounds:YES];
    [profileImageLayer setCornerRadius:8.0];
    
}

-(IBAction)attachImage:(id)sender
{
    [self.imageButton setHighlighted:NO];
    if (!imagePicker)
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:self.imagePicker animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.removeImageButton setHidden:NO];
    [self.charCountLabel setText:[NSString stringWithFormat:@"%i/140 + 1 image", self.tweetField.text.length]];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)deleteImage:(id)sender
{
    [self.removeImageButton setHidden:YES];
    selectedImage = nil;
    [self.charCountLabel setText:[NSString stringWithFormat:@"%i/140 + 0 images", self.tweetField.text.length]];
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
        if (self.tweetField.text.length <= 140 && self.tweetField.text.length>17)
        {
            [self.delegate sendTweetWithText:self.tweetField.text];
            [self.delegate dismissTweetView];
        }
        return NO;
    }
    else
    {
        NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        if (newText.length > 140) {
            [self.charCountLabel setTextColor:[UIColor redColor]];
            return NO;
        }
        else if (newText.length < 17)
        {
            return NO;
        }
        else {
            if (selectedImage)
            {
                [self.charCountLabel setText:[NSString stringWithFormat:@"%i/140 + 1 image", newText.length]];
            }
            else
            {
                [self.charCountLabel setText:[NSString stringWithFormat:@"%i/140 + 0 images", newText.length]];
            }
            
            [self.charCountLabel setTextColor:[UIColor blackColor]];
            return YES;
        }
    }
}

-(IBAction)highlightClearButton:(id)sender
{
    [self.clearButton setHighlighted:YES];
}


-(IBAction)highlightReplyButton:(id)sender
{
    [self.replyButton setHighlighted:YES];
}

-(IBAction)highlightImageButton:(id)sender
{
    [self.imageButton setHighlighted:YES];
}

-(IBAction)highlightCancelButton:(id)sender
{
    [self.cancelButton setHighlighted:YES];
}


-(IBAction)clearText:(id)sender
{
    [self.clearButton setHighlighted:NO];
    [self.tweetField setText:@"@CultivateOxford "];
}

-(IBAction)sendTweet:(id)sender
{
    [self.replyButton setHighlighted:NO];
    if (self.tweetField.text.length<=140 && self.tweetField.text.length>17)
    {
        [self.delegate sendTweetWithText:self.tweetField.text];
        [self.delegate dismissTweetView];
    }
}

-(IBAction)dismissFromTap:(id)sender
{
    [self.delegate dismissTweetView];
}

@end
