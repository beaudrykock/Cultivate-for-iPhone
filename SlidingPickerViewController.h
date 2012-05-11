//
//  SlidingPickerViewController.h
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/11/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlidingPickerViewControllerDelegate
- (void)slidingPickerViewControllerDidCancel;
- (void)recordGroupSelection:(NSInteger)selection;
@end


@interface SlidingPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *picker;
    NSMutableArray *pickerOptions;
    NSInteger pickerType;
    __weak id delegate;
}

@property (nonatomic, strong) IBOutlet UIPickerView* picker;
@property (nonatomic, strong) NSMutableArray *pickerOptions;
@property (nonatomic, weak) id <SlidingPickerViewControllerDelegate> delegate;

-(IBAction)cancel:(id)sender;

@end
