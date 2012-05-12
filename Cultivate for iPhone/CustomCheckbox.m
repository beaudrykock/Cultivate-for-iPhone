//
//  CustomCheckbox.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/12/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "CustomCheckbox.h"

@implementation CustomCheckbox

- (void)drawRect: (CGRect)rect
{
    [self drawButton];
}

- (void)drawButton
{
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.43 green: 0.61 blue: 0.19 alpha: 1];
    
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(2, 2, 31, 31) cornerRadius: 4];
    [[UIColor whiteColor] setFill];
    [roundedRectanglePath fill];
    
    [color setStroke];
    roundedRectanglePath.lineWidth = 3;
    [roundedRectanglePath stroke];

}


@end
