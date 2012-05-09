//
//  RideShareViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/7/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "RideShareViewController.h"

@interface RideShareViewController ()

@end

@implementation RideShareViewController
@synthesize picker, pickerOptions, title, info;

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
    
    pickerOptions = [NSMutableArray arrayWithObjects: @"May 10", @"June 5", @"July 8", @"September 18", nil];
    [title setTextColor: [Utilities colorWithHexString: kCultivateGreenColor]];
    [info setTextColor: [Utilities colorWithHexString: kCultivateGrayColor]];
    //[self test];
}


-(void)test
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AKFusionTables *fusionTables = [[AKFusionTables alloc] initWithUsername:@"beaudrykock@gmail.com" password:@"hLsbp93iLUkbhaenQfcu"];
    [fusionTables querySql:@"SELECT * FROM 1XDJMKnYqaclEyzRHr0AuszDyv7Wb7G2zbHtCiyU" completionHandler:^(NSData *data, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error != nil){
            NSInteger code = [error code];
            NSLog(@"Error code %d", code);
        } else {
            NSString *content = [[NSString alloc]
                                 initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            NSLog(@"Content: %@", content);
        }
    }];
    
    [fusionTables modifySql:@"INSERT INTO 1XDJMKnYqaclEyzRHr0AuszDyv7Wb7G2zbHtCiyU (name, mobile, postcode, volunteerDate) VALUES('John Doe', 0777777777, 'OX1 1QA', '10/10/10')" completionHandler:^(NSData *data, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error != nil){
                NSInteger code = [error code];
                NSLog(@"Error code %d", code);
            }
        }
    ];
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
    //[self purchaseProductForID:row];
}

-(IBAction)prepareRequest
{
    if ([Utilities cultiRideDetailsSet])
    {
        // TODO - T&Cs page
        
        [self submitRequest];
    }
    else
    {
        [self promptCultiRideDetails];
    }
}

-(void)promptCultiRideDetails
{
    UIAlertView *missingDetails = [[UIAlertView alloc]
                              initWithTitle:@"Missing contact details"
                              message:@"Please supply your contact details on the Settings page"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Take me there", nil];
    
    [missingDetails show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Take me there"])
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    }
    else {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
    }
}


-(void)submitRequest
{
    NSString *date = [pickerOptions objectAtIndex: [picker selectedRowInComponent:0]];
    NSLog(@"date = %@", date);
    [self markPickerRowSelected:[picker selectedRowInComponent:0]];
    
    // TODO
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AKFusionTables *fusionTables = [[AKFusionTables alloc] initWithUsername:@"beaudrykock@gmail.com" password:@"hLsbp93iLUkbhaenQfcu"];
    
    [fusionTables modifySql:@"INSERT INTO 1XDJMKnYqaclEyzRHr0AuszDyv7Wb7G2zbHtCiyU (name, mobile, postcode, volunteerDate) VALUES('John Doe', 0777777777, 'OX1 1QA', '10/10/10')" completionHandler:^(NSData *data, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error != nil){
            NSInteger code = [error code];
            NSLog(@"Error code %d", code);
        }
    }
     ];
}

-(void)markPickerRowSelected:(NSInteger)pickerRow
{
    NSLog(@"picker row = %i", pickerRow);
    NSString *original = [pickerOptions objectAtIndex:pickerRow];
    NSString *new = [NSString stringWithFormat:@"%@%@", original, @" - requested!"];
    [pickerOptions replaceObjectAtIndex: pickerRow withObject: new];
    [picker reloadComponent:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

@end
