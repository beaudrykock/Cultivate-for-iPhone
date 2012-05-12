//
//  RideShareViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/7/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFusionTables.h"
#import "CustomButton.h"

@interface RideShareViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *volunteerDates;
    UILabel *title;
    UILabel *info;
    UITableView *tableView;
    NSMutableArray *selectedValues;
    CustomButton *submitButton;
}

@property (nonatomic, strong) IBOutlet NSMutableArray *selectedValues;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *info;
@property (nonatomic, strong) NSMutableArray *volunteerDates;
@property (nonatomic, strong) IBOutlet CustomButton *submitButton;

-(IBAction)prepareRequest;
-(void)submitRequest;
-(void)markPickerRowSelected:(NSInteger)pickerRow;
-(BOOL)dateRequestedAtRow:(NSInteger)row;
@end
