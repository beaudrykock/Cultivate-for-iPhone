
@protocol MoveMeViewDelegate
-(void)removeCultiRideDetailsView;
@end

@interface MoveMeView : UIView 
{
	UIView *slideView;
    float offset_x;
    float offset_y;
    UIView *overlay;
    UILabel *handle;
    __weak id <MoveMeViewDelegate> delegate;
    UITextField *name_field;
    UITextField *mobile_field;
    UITextField *postcode_field;
    UITextField *email_field;
    UILabel *title_label;
    UILabel *name_label;
    UILabel *mobile_label;
    UILabel *postcode_label;
    UILabel *about_label;
    UILabel *disclaimer_label;
    UILabel *email_label;
    UILabel *completion_label;
    UIImageView *completion_img;
    BOOL canAnimateTouches;
    NSInteger count;
}

@property (nonatomic, strong) IBOutlet UIImageView *completion_img;
@property (nonatomic, strong) IBOutlet UILabel *completion_label;
@property (nonatomic, strong) IBOutlet UILabel *handle;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) IBOutlet UIView *slideView;
@property (weak) id<MoveMeViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *name_field;
@property (nonatomic, strong) IBOutlet UITextField *postcode_field;
@property (nonatomic, strong) IBOutlet UITextField *mobile_field;
@property (nonatomic, strong) IBOutlet UITextField *email_field;
@property (nonatomic, strong) IBOutlet UILabel *title_label;
@property (nonatomic, strong) IBOutlet UILabel *name_label;
@property (nonatomic, strong) IBOutlet UILabel *mobile_label;
@property (nonatomic, strong) IBOutlet UILabel *postcode_label;
@property (nonatomic, strong) IBOutlet UILabel *about_label;
@property (nonatomic, strong) IBOutlet UILabel *disclaimer_label;
@property (nonatomic, strong) IBOutlet UILabel *email_label;


- (void)animateViewOffScreen;
-(IBAction)updateCultiRideDetails:(id)sender;
-(IBAction)nextField:(id)sender;
-(void)alertIncompleteForm;
-(void)hideKeyboard;
-(IBAction)checkFormCompletionFromField:(id)sender;
-(void)doneWithKeyboard;

@end

