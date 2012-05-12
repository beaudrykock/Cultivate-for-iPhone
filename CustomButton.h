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
    UIColor *interiorColor;
    UIColor *interiorColorHighlighted;
    UIColor *borderColor;
    UIColor *textColor;
}
@property (nonatomic, strong) NSString * buttonTitle;

-(void)drawButton;
-(void)setFillWith:(UIColor*)color1 andHighlightedFillWith: (UIColor*)color2 andBorderWith: (UIColor*)color3 andTextWith: (UIColor*)color4;
@end
