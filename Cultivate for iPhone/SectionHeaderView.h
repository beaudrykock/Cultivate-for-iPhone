
/*
     File: SectionHeaderView.h
 Abstract: A view to display a section header, and support opening and closing a section.
 
 */

#import <Foundation/Foundation.h>

@protocol SectionHeaderViewDelegate;


@interface SectionHeaderView : UIView {
}

@property (nonatomic, strong) UILabel *areaTitleLabel;
@property (nonatomic, strong) UILabel *notifyColumnTitleLabel;
@property (nonatomic, weak) id <SectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame areaTitle:(NSString*)title delegate:(id <SectionHeaderViewDelegate>)aDelegate;

@end



/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional

@end

