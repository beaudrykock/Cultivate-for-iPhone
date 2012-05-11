//
//  SlidingPickerViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/11/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "SlidingPickerViewController.h"

@interface SlidingPickerViewController ()

@end

@implementation SlidingPickerViewController
@synthesize delegate, picker, pickerOptions, title;

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
    pickerOptions = [NSMutableArray arrayWithObjects: @"weekly", @"monthly", @"once in a blue moon", nil];
}

#pragma mark -
#pragma mark Picker view

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerOptions count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerOptions objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.delegate recordGroupSelection:row];
}

-(IBAction)cancel:(id)sender
{
    [self.delegate slidingPickerViewControllerDidCancel];
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

@end
