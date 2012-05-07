//
//  RideShareViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/7/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFusionTables.h"

@interface RideShareViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *picker;
    NSMutableArray *pickerOptions;
    UILabel *title;
    UILabel *info;
}
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *info;
@property (nonatomic, strong) IBOutlet UIPickerView* picker;
@property (nonatomic, strong) NSMutableArray *pickerOptions;

-(IBAction)prepareRequest;
-(void)submitRequest;
-(void)markPickerRowSelected:(NSInteger)pickerRow;

@end
