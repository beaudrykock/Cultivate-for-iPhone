// CustomPageControl.m

// Created by Beaudry Kock, 2011/04/18, based on Steven Preston's original class
// found here: http://www.madmob.co.za/2010/10/28/custom-uipagecontrol-changing-the-colour-of-a-pagecontrol/


#import "CustomPageControl.h"

@implementation CustomPageControl

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CUSTOM_PAGECONTROL_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedColor = [UIColor blackColor];
        self.deselectedColor = [UIColor lightGrayColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CUSTOM_PAGECONTROL_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        
        self.selectedColor = [UIColor blackColor];
        self.deselectedColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void) setNumberOfPages: (int) number
{
    numberOfPages = MAX(number, 0);
    currentPage = 0;
    
    CGPoint tempCenter = self.center;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            4 + numberOfPages * DOT_WIDTH + MAX(numberOfPages - 1, 0) * DOT_SPACING, self.frame.size.height);
    self.center = tempCenter;
    
    [self setNeedsDisplay];
}

-(int) numberOfPages
{
    return numberOfPages;
}

-(void) setCurrentPage: (int) index
{
    if (index >= numberOfPages)
        currentPage = 0;
    else
        currentPage = MAX(0, index);
    
    [self setNeedsDisplay];
}

-(int) currentPage
{
    return currentPage;
}

-(void) setSelectedColor: (UIColor*) color
{
    
    selectedColor = color;
    [self setNeedsDisplay];
}

-(UIColor*) selectedColor
{
    return selectedColor;
}

-(void) setDeselectedColor: (UIColor*) color
{
    
    deselectedColor = color;
    [self setNeedsDisplay];
}

-(UIColor*) deselectedColor
{
    return deselectedColor;
}

- (void)drawRect:(CGRect)rect {
    
    for (int i = 0; i < numberOfPages; i++) {
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        if (i == currentPage)
            CGContextSetFillColorWithColor(contextRef, selectedColor.CGColor);
        else
            CGContextSetFillColorWithColor(contextRef, deselectedColor.CGColor);
        
        CGContextFillEllipseInRect(contextRef, CGRectMake(2 + DOT_WIDTH * i + DOT_SPACING * i,
                                                          (CUSTOM_PAGECONTROL_HEIGHT - DOT_WIDTH) / 2, DOT_WIDTH, DOT_WIDTH));
    }
}
@end