//
//  SettingsViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 4/25/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize minutesBeforeLabel, stepper, repeatPatternControl, notificationSettingsBackground;

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
    
    NSInteger currentMinutesBefore = [Utilities getDefaultMinutesBefore];
    [stepper setValue:currentMinutesBefore*1.0];
    NSNumber *value = [NSNumber numberWithDouble:[stepper value]];
    NSString *label = [NSString stringWithFormat:@"%i%@",[value intValue], @" minutes before"];
    [minutesBeforeLabel setText:label];
    [repeatPatternControl setSelectedSegmentIndex:[Utilities getDefaultRepeatPattern]];
    notificationSettingsBackground.layer.cornerRadius = 8.0;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
