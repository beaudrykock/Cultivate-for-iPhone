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
#import "CultiRideDetailsViewController.h"
#import "MoveMeView.h"

@interface RideShareViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CultiRideDetailsViewControllerDelegate, MoveMeViewDelegate>
{
    NSMutableArray *volunteerDates;
    UILabel *viewTitle;
    UILabel *info;
    UITableView *tableView;
    NSMutableArray *selectedValues;
    CustomButton *submitButton;
    MoveMeView *cultiRideDetailsView;
    UIView *overlay;
}


@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) IBOutlet NSMutableArray *selectedValues;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *viewTitle;
@property (nonatomic, strong) IBOutlet UILabel *info;
@property (nonatomic, strong) NSMutableArray *volunteerDates;
@property (nonatomic, strong) IBOutlet CustomButton *submitButton;
@property (nonatomic, strong) IBOutlet MoveMeView *cultiRideDetailsView;

-(IBAction)prepareRequest;
-(void)submitRequest;
-(void)markPickerRowSelected:(NSInteger)pickerRow;
-(BOOL)dateRequestedAtRow:(NSInteger)row;
-(void)cultiRideDetailsViewControllerDidFinish;
-(BOOL)requestMade;


@end
