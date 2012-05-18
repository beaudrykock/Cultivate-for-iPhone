//
//  CultiRideDetailsViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/13/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import <QuartzCore/QuartzCore.h>

@protocol CultiRideDetailsViewControllerDelegate
    -(void)cultiRideDetailsViewControllerDidFinish;
@end
@interface CultiRideDetailsViewController : UIViewController
{
    UITextField *name_field;
    UITextField *mobile_field;
    UITextField *postcode_field;
    UITextField *email_field;
    CustomButton *updateCultiRideDetailsButton;
    __weak id <CultiRideDetailsViewControllerDelegate> delegate;
    UIButton *cancelButton;
    UILabel *viewTitle;
    UILabel *name_label;
    UILabel *mobile_label;
    UILabel *postcode_label;
    UILabel *about_label;
    UILabel *disclaimer_label;
    UILabel *email_label;
}

@property (nonatomic, strong) IBOutlet CustomButton *updateCultiRideDetailsButton;
@property (nonatomic, strong) IBOutlet UITextField *name_field;
@property (nonatomic, strong) IBOutlet UITextField *postcode_field;
@property (nonatomic, strong) IBOutlet UITextField *mobile_field;
@property (nonatomic, strong) IBOutlet UITextField *email_field;
@property (nonatomic, weak) id <CultiRideDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UILabel *viewTitle;
@property (nonatomic, strong) IBOutlet UILabel *name_label;
@property (nonatomic, strong) IBOutlet UILabel *mobile_label;
@property (nonatomic, strong) IBOutlet UILabel *postcode_label;
@property (nonatomic, strong) IBOutlet UILabel *about_label;
@property (nonatomic, strong) IBOutlet UILabel *disclaimer_label;
@property (nonatomic, strong) IBOutlet UILabel *email_label;

-(IBAction)updateCultiRideDetails:(id)sender;
-(IBAction)nextField:(id)sender;
-(void)alertIncompleteForm;
-(IBAction)cancel:(id)sender;
-(void)hideKeyboard;

@end
