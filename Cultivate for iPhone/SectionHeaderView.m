
/*
     File: SectionHeaderView.m
 Abstract: A view to display a section header, and support opening and closing a section.
 
 */

#import "SectionHeaderView.h"

@implementation SectionHeaderView


@synthesize areaTitleLabel, notifyColumnTitleLabel, delegate;

-(id)initWithFrame:(CGRect)frame areaTitle:(NSString*)title delegate:(id <SectionHeaderViewDelegate>)aDelegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        float lineHeight = 1.0f;
        
        // Set up the tap gesture recognizer.
        delegate = aDelegate;        
        
        float sectionHeaderWidth = 320.0f; 
        
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        {
            sectionHeaderWidth = 320.0f;
        }
        else
        {
            sectionHeaderWidth = 480.0f;
        }
        
        if (self.bounds.size.width > sectionHeaderWidth+1.0 || self.bounds.size.width < sectionHeaderWidth-1.0)
        {
            self.bounds = CGRectMake(0.0, 0.0, sectionHeaderWidth, self.bounds.size.height);
        }
        
        // Create and configure the title label.
        CGRect areaTitleLabelFrame = CGRectMake(self.bounds.origin.x+5.0, self.bounds.origin.y, self.bounds.size.width/2.0, self.bounds.size.height);
        CGRect notifyColumnTitleLabelFrame = CGRectMake(areaTitleLabelFrame.origin.x+areaTitleLabelFrame.size.width, self.bounds.origin.y, (self.bounds.size.width/2.0)-5.0, self.bounds.size.height);
        
        areaTitleLabelFrame.origin.y -= 10.5;
        notifyColumnTitleLabelFrame.origin.y -= 10.5;
        areaTitleLabel = [[UILabel alloc] initWithFrame:areaTitleLabelFrame];
        areaTitleLabel.text = title;
        areaTitleLabel.textAlignment = UITextAlignmentLeft;
        areaTitleLabel.font = [UIFont fontWithName:@"Nobile" size:15.0];
        areaTitleLabel.textColor = [UIColor whiteColor];
        areaTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:areaTitleLabel];
        
        notifyColumnTitleLabel = [[UILabel alloc] initWithFrame:notifyColumnTitleLabelFrame];
        notifyColumnTitleLabel.text = @"Notification   ";
        notifyColumnTitleLabel.textAlignment = UITextAlignmentRight;
        notifyColumnTitleLabel.font = [UIFont fontWithName:@"Nobile" size:15.0];
        notifyColumnTitleLabel.textColor = [UIColor whiteColor];
        notifyColumnTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:notifyColumnTitleLabel];
        
        // add thin white line to top of section header
        //UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, sectionHeaderWidth, lineHeight)];
        //[topBorder setBackgroundColor:[UIColor whiteColor]];
        //[self addSubview:topBorder];
        
        [self setBackgroundColor:[Utilities colorWithHexString:@"#91C65F"]];
        
    }
    
    return self;
}

@end
