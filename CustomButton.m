//
//  PaintcodeButton.m
//  PaintcodeTest
//
//  Created by Beaudry Kock on 5/8/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize buttonTitle;

- (void)drawRect: (CGRect)rect
{
    [self drawButton];
}

-(void)setFillWith:(UIColor*)color1 andHighlightedFillWith: (UIColor*)color2 andBorderWith: (UIColor*)color3 andTextWith: (UIColor*)color4
{
    self->interiorColor = color1;
    self->interiorColorHighlighted = color2;
    self->borderColor = color3;
    self->textColor = color4;
}

- (void)drawButton
{
    UIColor *color = nil;
    if (!interiorColor)
    {
       color = [UIColor colorWithRed: 0.29 green: 0.53 blue: 0.16 alpha: 1];
    }
    else
    {
        color = interiorColor;
    }
    if (self.state == UIControlStateHighlighted && !interiorColorHighlighted) {
        color =[UIColor colorWithRed: 0.22 green: 0.42 blue: 0.13 alpha: 1];
    }
    else if (self.state == UIControlStateHighlighted && interiorColorHighlighted)
    {
        color = interiorColorHighlighted;
    }
    
    UIColor* color2 = nil;
    //// Color Declarations
    if (!borderColor)
    {
        color2= [UIColor colorWithRed: 0.22 green: 0.42 blue: 0.13 alpha: 1];
    }
    else
    {
        color2 = borderColor;
    }
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    //// Abstracted Graphic Attributes
    NSString* textContent = buttonTitle;
        
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 0.5, 160, 37) cornerRadius: 8];
    [color setFill];
    [roundedRectanglePath fill];
    
    [color2 setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    
    UIColor *color3 = nil;
    
    if (textColor)
    {
        color3 = textColor;
    }
    else
    {
        color3 = [UIColor whiteColor];
    }
    
    //// Text Drawing
    CGRect textFrame = CGRectMake(18, 8, 124, 22);
    [color3 setFill];
    [textContent drawInRect: textFrame withFont: [UIFont fontWithName: @"Calibri" size: 18] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
    
}

- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

@end
