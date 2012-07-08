
#import "MoveMeView.h"

// Import QuartzCore for animations
#import <QuartzCore/QuartzCore.h>


@implementation MoveMeView

@synthesize slideView, overlay, handle, delegate, name_field, postcode_field, mobile_field, title_label, name_label, mobile_label, postcode_label, about_label, disclaimer_label, email_label, email_field, completion_label, completion_img;


/*
 If the view is stored in the nib file, when it's unarchived it's sent -initWithCoder:.
 This is the case in the example as provided.  See also initWithFrame:.
*/
- (id)initWithCoder:(NSCoder *)coder {
	
	self = [super initWithCoder:coder];
	if (self) {
		
	}
	return self;
}

/*
 If you were to create the view programmatically, you would use initWithFrame:.
 You want to make sure the placard view is set up in this case as well (as in initWithCoder:).
 */
- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CultiRideDetailsView" owner:self options:nil];
        UIView *mainView = [subviewArray objectAtIndex:0];
        [self addSubview:mainView];
                
        [self.handle setFont: [UIFont fontWithName:kTitleFont size:22]];
        [self.name_label setFont: [UIFont fontWithName:kTextFont size:15]];
        [self.postcode_label setFont: [UIFont fontWithName:kTextFont size:15]];
        [self.mobile_label setFont: [UIFont fontWithName:kTextFont size:15]];
        [self.about_label setFont: [UIFont fontWithName:kTextFont size:15]];
        [self.disclaimer_label setFont: [UIFont fontWithName:kTextFont size:12]];
        [self.email_label setFont: [UIFont fontWithName:kTextFont size:15]];
    
        //[[NSNotificationCenter defaultCenter] addObserver:self
        //                                         selector:@selector(doneWithKeyboard) name:@"UIKeyboardDidHideNotification" object:nil];
//       [self performSelector:@selector(editFirstField) withObject:nil afterDelay:2.0];
    }
	return self;
}

-(void)editFirstField
{
    [self.name_field becomeFirstResponder];
}

-(void)doneWithKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardDidHideNotification" object:nil];
    [self updateCultiRideDetails];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
    
	if ([touch view] != self.handle) {
		return;
	}
    else {
        // record offset from origin of view
        CGPoint location = [touch locationInView:self.slideView];
        offset_x = location.x;
        offset_y = location.y;
        count = 1;
        /*overlay = [[UIView alloc] initWithFrame:CGRectMake(35.0, 10.0, 250.0, 100.0)];
        [overlay setBackgroundColor:[UIColor clearColor]];
        UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 250.0, 100.0)];
        [overlay addSubview: transparentView];
        transparentView.layer.cornerRadius = 8.0;
        [transparentView setBackgroundColor:[UIColor blackColor]];
        [transparentView setAlpha:0.8];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 200.0, 90.0)];
        [label setText:@"Details are incomplete - closing will not update"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [overlay addSubview:label];
        
        [self.slideView addSubview:overlay];*/
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, move the placardView to its location
	if ([touch view] == self.handle) {
        CGPoint location = [touch locationInView:self];
		CGRect frame = self.slideView.frame;
        //NSLog(@"location.y = %f", location.y);
        //NSLog(@"offset_y = %f", offset_y);
        frame.origin.y = (location.y - offset_y);
        if (frame.origin.y<=0)
            self.slideView.frame = frame;		
		return;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, bounce it back to the center
	if ([touch view] == self.handle) {
        [self.overlay removeFromSuperview];
        if (self.slideView.frame.origin.y < -40)
        {
          [self animateViewOffScreen];  
        }
        else {
            [self restoreView];
        }
		// Disable user interaction so subsequent touches don't interfere with animation
		//self.slideView.userInteractionEnabled = NO;
		//[self animateViewOffScreen];
		return;
	}		
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//self.slideView.transform = CGAffineTransformIdentity;
}

-(void)restoreView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.slideView.frame = CGRectMake(0.0, 0.0, self.slideView.frame.size.width, self.slideView.frame.size.height);
    [UIView setAnimationDelay: UIViewAnimationCurveEaseIn];
	[UIView commitAnimations];
	
}

- (void)animateViewOffScreen {
	
    
    [self hideKeyboard];
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(updateCultiRideDetails)];
    self.slideView.frame = CGRectMake(0.0, -245.0, self.slideView.frame.size.width, self.slideView.frame.size.height);
	[UIView setAnimationDelay: UIViewAnimationCurveEaseOut];
    [UIView commitAnimations];
	
	// Set the placard view's center and transformation to the original values in preparation for the end of the animation
	//self.slideView.transform = CGAffineTransformIdentity;
}

#pragma mark -
#pragma mark Keyboard management
-(IBAction)registerKeyboardListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneWithKeyboard) name:@"UIKeyboardDidHideNotification" object:nil];
}

-(void)hideKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [name_field resignFirstResponder];
    [mobile_field resignFirstResponder];
    [email_field resignFirstResponder];
    [postcode_field resignFirstResponder];
}

-(IBAction)nextField:(id)sender
{
    [self checkFormCompletion];
    UITextField*textField = (UITextField*)sender;
    if (textField.tag == 0)
    {
        [self.name_field resignFirstResponder];
        [self.mobile_field becomeFirstResponder];
    }
    else if (textField.tag == 1)
    {
        [self.mobile_field resignFirstResponder];
        [self.postcode_field becomeFirstResponder];
    }
    else if (textField.tag == 2)
    {
        [self.email_field resignFirstResponder];
        [self.postcode_field becomeFirstResponder];
    }
    else
    {
        [self.postcode_field resignFirstResponder];
        [self updateCultiRideDetails];
    }
}

-(IBAction)checkFormCompletionFromField:(id)sender
{
    [self checkFormCompletion];
}

-(void)checkFormCompletion
{
    NSString *name = [name_field text];
    NSString *mobile = [mobile_field text];
    NSString *postcode = [postcode_field text];
    NSString *email = [email_field text];
    
    if ([name length]>0 && [mobile length]>0 && [postcode length] >0)
    {
        [completion_label setText:@"Details complete!"];
        [completion_img setImage:[UIImage imageNamed: @"details_complete.png"]];
    }
    else 
    {
        [completion_label setText:@"Details incomplete!"];
        [completion_img setImage:[UIImage imageNamed: @"details_incomplete.png"]];
    }
}

-(void)updateCultiRideDetails
{
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kFeedbackEvent
                                         action:@"Updating user details for CultiRide"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    NSString *name = [self.name_field text];
    NSString *mobile = [self.mobile_field text];
    NSString *postcode = [self.postcode_field text];
    NSString *email = [email_field text];
    //NSLog(@"details = %@,%@,%@,%@",name, mobile, postcode, email);
    if ([name length]>0 && [mobile length]>0 && [postcode length] >0)
    {
        [Utilities setCultiRideDetailsForName: name mobile: mobile email: email postcode: postcode];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveCultiRideDetailsView object: nil];
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


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	//Animation delegate method called when the animation's finished:
	// restore the transform and reenable user interaction
	//placardView.transform = CGAffineTransformIdentity;
	self.slideView.userInteractionEnabled = YES;
}


@end
