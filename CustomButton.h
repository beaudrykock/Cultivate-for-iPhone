//
//  CustomButton.h
//
//  Created by Beaudry Kock on 5/8/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
{
    NSString *buttonTitle;
}
@property (nonatomic, strong) NSString * buttonTitle;

-(void)drawButton;
@end
