//
//  MessageViewController.m
//  Cultivate for iPhone
//
//  Created by Beaudry Kock on 5/14/12.
//  Copyright (c) 2012 University of Oxford. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
@synthesize tweets, tweetImageURLs, loadingOverlay, tableViewCellSizes, tableViewCellImages;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addLoadingOverlay];
    //[self performSelectorInBackground:@selector(getPublicTimeline) withObject:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTweetNotification:) name:IFTweetLabelURLNotification object:nil];
    
    if ([[Utilities sharedAppDelegate] areTweetsLoaded])
    {
        [self performSelectorInBackground:@selector(populateTweetTable) withObject:nil];
        //[self populateTweetTable];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateTweetTable) name: kTweetsLoaded object:nil];
    }
}

-(void)populateTweetTable
{   
    
    self.tweets = [[Utilities sharedAppDelegate] tweets];
    if (!self.tweetImageURLs)
    {
        self.tweetImageURLs  = [NSMutableArray arrayWithCapacity: [tweets count]];
        self.tableViewCellSizes = [NSMutableArray arrayWithCapacity:[tweets count]];
        self.tableViewCellImages = [NSMutableArray arrayWithCapacity:[tweets count]];
    }
    
    NSInteger count = 0;
    for (NSDictionary *dict in tweets)
    {
        NSDictionary *user = (NSDictionary*)[dict objectForKey:@"user"];
        [tweetImageURLs addObject: [user objectForKey:@"profile_image_url"]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[tweetImageURLs objectAtIndex:count]]];
        UIImage *image = [UIImage imageWithData:data];
        [tableViewCellImages addObject: image];
        CGSize labelSize = [[dict objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:@"Calibri" size:14.0] 
                                                  constrainedToSize:CGSizeMake(240.0f, MAXFLOAT) 
                                                      lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 70) 
            labelSize.height = 70.0;
            
        [tableViewCellSizes addObject:[NSValue valueWithCGSize:labelSize]];
        count++;
    }
    [self removeLoadingOverlay];
    [self.tableView reloadData];
}

- (void)getPublicTimeline 
{
	// Create a request, which in this example, grabs the public timeline.
	// This example uses version 1 of the Twitter API.
	// This may need to be changed to whichever version is currently appropriate.
	TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline/CultivateOxford.json"] parameters:nil requestMethod:TWRequestMethodGET];
	
	// Perform the request created above and create a handler block to handle the response.
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		NSString *output;
		
		if ([urlResponse statusCode] == 200) {
			// Parse the responseData, which we asked to be in JSON format for this request, into an NSDictionary using NSJSONSerialization.
			NSError *jsonParsingError = nil;
			tweets = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            output = [NSString stringWithFormat:@"HTTP response status: %i\nPublic timeline:\n%@", [urlResponse statusCode], tweets];
            
            if (!tweetImageURLs)
                tweetImageURLs  = [NSMutableArray arrayWithCapacity: [tweets count]];
            for (NSDictionary *dict in tweets)
            {
                NSDictionary *user = (NSDictionary*)[dict objectForKey:@"user"];
                [tweetImageURLs addObject: [user objectForKey:@"profile_image_url"]];
            }
            NSInteger newTweetCount = [Utilities updateTweets:[self tweetTextsFromTweets]];
            
            [[[[[self tabBarController] tabBar] items] 
              objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%i", newTweetCount]];
            
            [self.tableView reloadData];
		}
		else {
			output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
		}
		
        if (overlayAdded)
            [self performSelectorOnMainThread:@selector(removeLoadingOverlay) withObject:nil waitUntilDone:NO];
	}];
}

-(NSMutableArray*)tweetTextsFromTweets
{
    NSMutableArray *tweetTexts = [[NSMutableArray alloc] initWithCapacity: [tweets count]];
    for (NSDictionary *dict in tweets)
    {
        [tweetTexts addObject: [dict objectForKey:@"text"]];
    }
    return tweetTexts;
}

-(void)addLoadingOverlay
{
    overlayAdded = YES;
    loadingOverlay = nil;
    loadingOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,480.0)];
    [loadingOverlay setBackgroundColor: [UIColor clearColor]];
    UIView *coloredOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,480.0)];
    [coloredOverlay setBackgroundColor: [Utilities colorWithHexString: kCultivateGreenColor]];
    [coloredOverlay setAlpha: 0.8];
    
    CGRect frame = coloredOverlay.frame;
    UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake((frame.size.width/2)-15, (frame.size.height/2)-15, 30, 30)];
    activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    if ([Utilities hasInternet])
        [coloredOverlay addSubview:activityWheel];
    
    UILabel *downloadingUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0, (frame.size.height/2)+15, 250.0, 50.0)];
    if ([Utilities hasInternet])
    {
        [downloadingUpdateLabel setText:@"Updating tweets..."];
    }
    else {
        [downloadingUpdateLabel setText:@"Internet not available"];
    }
    [downloadingUpdateLabel setBackgroundColor:[UIColor clearColor]];
    [downloadingUpdateLabel setFont:[UIFont fontWithName:@"Calibri" size:18.0]];
    [downloadingUpdateLabel setTextColor:[UIColor whiteColor]];
    [downloadingUpdateLabel setTextAlignment:UITextAlignmentCenter];
    [coloredOverlay addSubview:downloadingUpdateLabel];
    [loadingOverlay addSubview:coloredOverlay];
    [[[coloredOverlay subviews] objectAtIndex:0] startAnimating];
    
    [self.view addSubview: loadingOverlay];
}

-(void)removeLoadingOverlay
{
    overlayAdded = NO;
    [loadingOverlay removeFromSuperview];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [tweets count];
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Cultivate timeline";
}
 */

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TweetHeaderView* headerView = [[TweetHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 45.0) title:@"Cultivate tweets" delegate:self];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
       
    if (!overlayAdded)
    {
    NSDictionary *aTweet = [tweets objectAtIndex:[indexPath row]];
    UIImage *image = nil; 
    if ([tableViewCellImages count]>indexPath.row)
    {
        image = [tableViewCellImages objectAtIndex:[indexPath row]];
    }
    
    if (!image)
    {
        //NSLog(@"url = %@", [aTweet objectForKey: @"profile_image_url"]);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[tweetImageURLs objectAtIndex:indexPath.row]]];
        image = [UIImage imageWithData:data];
        [tableViewCellImages addObject: image];
    }
    
    NSValue* sizeValue = nil;
    if ([tableViewCellSizes count]>indexPath.row)
    {
        sizeValue = [tableViewCellSizes objectAtIndex:[indexPath row]];
    }
    
    CGSize labelSize;
    if (!sizeValue)
    {
        labelSize = [[aTweet objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:@"Calibri" size:14.0] 
                       constrainedToSize:CGSizeMake(240.0f, MAXFLOAT) 
                           lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 70) 
            labelSize.height = 70.0;
        
        [tableViewCellSizes addObject:[NSValue valueWithCGSize:labelSize]];
    }
    else {
        labelSize = [sizeValue CGSizeValue];
    }
    //NSString *imageURLString = [tweetImageURLs objectAtIndex: [indexPath row]];
    [cell setupWithText:[aTweet objectForKey:@"text"] andSize:[NSValue valueWithCGSize:labelSize] andImage:image];
    }
    //NSDictionary *aTweet = [tweets objectAtIndex:[indexPath row]];
    //NSString *imageURLString = [tweetImageURLs objectAtIndex: [indexPath row]];
    //[cell setupWithText: [aTweet objectForKey:@"text"] andImageURLString: imageURLString];//[aTweet objectForKey: @"profile_image_url"]];
	
    
    /*
    cell.textLabel.text = [aTweet objectForKey:@"text"];
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.textLabel.minimumFontSize = 10;
	cell.textLabel.numberOfLines = 4;
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	cell.detailTextLabel.text = [aTweet objectForKey:@"from_user"];
	NSLog(@"url = %@", [aTweet objectForKey:@"profile_image_url"]);
	NSURL *url = [NSURL URLWithString:[aTweet objectForKey:@"profile_image_url"]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	cell.imageView.image = [UIImage imageWithData:data];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;*/
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize labelSize;
    NSValue *val = nil;
    if ([tableViewCellSizes count]>indexPath.row)
    {
        val = (NSValue*)[tableViewCellSizes objectAtIndex:indexPath.row]; 
        labelSize = [val CGSizeValue];
    }
    if (!val)
    {
        NSString *string = [[tweets objectAtIndex: indexPath.row] objectForKey:@"text"];
        
        labelSize = [string sizeWithFont:[UIFont fontWithName:@"Calibri" size:14.0] 
                              constrainedToSize:CGSizeMake(240.0f, MAXFLOAT) 
                                  lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 70) 
            labelSize.height = 70.0;
        
        [tableViewCellSizes addObject:[NSValue valueWithCGSize:labelSize] ];
        NSLog(@"tableViewCellSizes count = %i", [tableViewCellSizes count]);
    }    
    return labelSize.height + 20;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)handleTweetNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString: IFTweetLabelURLNotification])
    {
        NSString *objectAsStr = (NSString*)notification.object;
        NSString *URLString = nil;
        // check if twitter handle
        //NSLog(@"%@",[objectAsStr substringToIndex:1]);
        NSString *leadingChar = [objectAsStr substringToIndex:1]; 
        if ([leadingChar isEqualToString:@"@"])
        {
            URLString = [NSString stringWithFormat:@"%@%@",@"http://www.twitter.com/#!/",objectAsStr];
        }
        else if ([leadingChar isEqualToString: @"#"])
        {
            URLString = [NSString stringWithFormat:@"%@%@",@"http://www.twitter.com/",objectAsStr];
        }
        else
        {
            URLString = objectAsStr;
        }
        [self launchWebViewWithURLString:URLString];
    }
	//NSLog(@"handleTweetNotification: notification = %@", notification);
}

-(void)launchWebViewWithURLString:(NSString*)urlString
{
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:urlString];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentModalViewController:webViewController animated:YES];	
}


@end
