//  CustomPageControl.h
//  Created by Beaudry Kock on 2011/04/18, based on Steven Preston's original class
// found here: http://www.madmob.co.za/2010/10/28/custom-uipagecontrol-changing-the-colour-of-a-pagecontrol/

#import <UIKit/UIKit.h>

#define CUSTOM_PAGECONTROL_HEIGHT 20
#define DOT_WIDTH 6
#define DOT_SPACING 10

@interface CustomPageControl : UIView {
    int numberOfPages;
    int currentPage;
    UIColor* selectedColor;
    UIColor* deselectedColor;
}

@property (assign) int numberOfPages;
@property (assign) int currentPage;
@property (nonatomic, retain) UIColor* selectedColor;
@property (nonatomic, retain) UIColor* deselectedColor;

@end
