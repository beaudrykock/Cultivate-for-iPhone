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
@synthesize tweets, tweetImageURLs, loadingOverlay, tableViewCellSizes, tableViewCellImages, downloadingUpdateLabel, activityWheel, replies, screenName, userProfileImage;
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self readUserReplies];
    
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFailureOverlay) name: kTweetsLoadingFailed object:nil];
    }
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"Tweets view"
                                         withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
}



-(void)updateFailureOverlay
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTweetsLoadingFailed object:self];
    [self.downloadingUpdateLabel setText:@"Tweets not currently available"];
    [self.activityWheel stopAnimating];
}

-(void)populateTweetTable
{
    self.tweets = [NSMutableArray arrayWithCapacity:[[[Utilities sharedAppDelegate] tweets] count]];
    self.userProfileImage = [[Utilities sharedAppDelegate] userProfileImage];
    
    NSMutableArray *repliesToRemove = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary *tweet in [[Utilities sharedAppDelegate] tweets])
    {
        [self.tweets addObject:tweet];
        if ([self.replies count]>0)
        {
            for (NSDictionary* reply in self.replies)
            {
                NSString *associatedText = [reply objectForKey:@"in_reply_to_tweet_text"];
                if ([[tweet objectForKey:@"text"] isEqualToString: associatedText])
                {
                    [self.tweets addObject:reply];
                }
            }
        }
    }
        // no recent replies and Cultivate tweets have changed
    for (NSDictionary* reply in self.replies)
    {
        if (![self.tweets containsObject:reply])
        {
            [repliesToRemove addObject:reply];
        }
    }
    
    for (NSDictionary *reply in repliesToRemove)
    {
        [self.replies removeObject:reply];
    }
    
    if ([self.replies count]>0)
        [self writeUserReplies];
    
    if (self.tweetImageURLs)
    {
        self.tweetImageURLs = nil;
        self.tableViewCellSizes = nil;
        self.tableViewCellImages = nil;
    }
    
    self.tweetImageURLs  = [NSMutableArray arrayWithCapacity: [tweets count]];
    self.tableViewCellSizes = [NSMutableArray arrayWithCapacity:[tweets count]];
    self.tableViewCellImages = [NSMutableArray arrayWithCapacity:[tweets count]];
    
    NSInteger count = 0;
    for (NSDictionary *dict in tweets)
    {
        NSDictionary *user = (NSDictionary*)[dict objectForKey:@"user"];
        [self.tweetImageURLs addObject: [user objectForKey:@"profile_image_url"]];
        //NSLog(@"%@",[user objectForKey:@"profile_image_url"]);
        UIImage *image = nil;
        #ifdef kDownloadProfileImage
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[tweetImageURLs objectAtIndex:count]]];
            image = [UIImage imageWithData:data];
        #else
            image = [UIImage imageNamed:@"droplet_normal.png"];
        #endif
        
        if ([dict objectForKey:@"isReply"] && userProfileImage)
        {
                //NSLog(@"adding user profile image");
            [self.tableViewCellImages addObject: self.userProfileImage];
        }
        else if ([dict objectForKey:@"isReply"] && !userProfileImage)
        {
                //NSLog(@"adding placeholder user profile image");
            [self.tableViewCellImages addObject: [UIImage imageNamed:@"profileImagePlaceholder.png"]];
        }
        else
        {
                //NSLog(@"adding cultivate image");
            [self.tableViewCellImages addObject: image];
        }
            CGSize labelSize = [[dict objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:kTextFont size:12.0]
                                                  constrainedToSize:CGSizeMake(kMaxTweetLabelSize, MAXFLOAT)
                                                      lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 70) 
            labelSize.height = 70.0;
            
        [self.tableViewCellSizes addObject:[NSValue valueWithCGSize:labelSize]];
        count++;
    }
    
    
    
    [self removeLoadingOverlay];
    [self.tableView reloadData];
    [self loadingComplete];
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
            
            if (overlayAdded)
                [self performSelectorOnMainThread:@selector(removeLoadingOverlay) withObject:nil waitUntilDone:NO];
		}
		else {
			output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
		}
		
        
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
    self.loadingOverlay = nil;
    self.loadingOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,480.0)];
    [self.loadingOverlay setBackgroundColor: [UIColor clearColor]];
    UIView *coloredOverlay = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,480.0)];
    [coloredOverlay setBackgroundColor: [Utilities colorWithHexString: kCultivateGreenColor]];
    [coloredOverlay setAlpha: 0.8];
    
    CGRect frame = coloredOverlay.frame;
    self.activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake((frame.size.width/2)-15, (frame.size.height/2)-15, 30, 30)];
    self.activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    if ([Utilities hasInternet])
        [coloredOverlay addSubview:self.activityWheel];
    
    self.downloadingUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0, (frame.size.height/2)+15, 250.0, 50.0)];
    if ([Utilities hasInternet])
    {
        [self.downloadingUpdateLabel setText:@"Updating tweets..."];
    }
    else {
        [self.downloadingUpdateLabel setText:@"Internet not available"];
    }
    [self.downloadingUpdateLabel setBackgroundColor:[UIColor clearColor]];
    [self.downloadingUpdateLabel setFont:[UIFont fontWithName:kTextFont size:18.0]];
    [self.downloadingUpdateLabel setTextColor:[UIColor whiteColor]];
    [self.downloadingUpdateLabel setTextAlignment:UITextAlignmentCenter];
    [coloredOverlay addSubview:self.downloadingUpdateLabel];
    [self.loadingOverlay addSubview:coloredOverlay];
    if ([Utilities hasInternet])
        [self.activityWheel startAnimating];
    
    [self.view addSubview: self.loadingOverlay];
}

-(void)removeLoadingOverlay
{
    if (self.loadingOverlay)
    {
        overlayAdded = NO;
        [loadingOverlay removeFromSuperview];
    }
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
    TweetHeaderView* headerView = [[TweetHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 45.0) title:@"Get involved in the VegVan conversation!" delegate:self];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    else
    {
        cell.profileImage.image = nil;
    }
    [cell setIndex: indexPath.row];
    
    if (!overlayAdded)
    {
    NSDictionary *aTweet = [tweets objectAtIndex:[indexPath row]];
    UIImage *image = nil; 
    if ([tableViewCellImages count]>indexPath.row)
    {
        image = [tableViewCellImages objectAtIndex:[indexPath row]];
    }
    else
    {
        image = [UIImage imageNamed:@"droplet_normal.png"];
    }

    NSValue* sizeValue = nil;
    if ([tableViewCellSizes count]>indexPath.row)
    {
        sizeValue = [tableViewCellSizes objectAtIndex:[indexPath row]];
    }
    
    CGSize labelSize;
    if (!sizeValue)
    {
        labelSize = [[aTweet objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:kTextFont size:12.0]
                       constrainedToSize:CGSizeMake(kMaxTweetLabelSize, MAXFLOAT)
                           lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 70) 
            labelSize.height = 70.0;
        
        [tableViewCellSizes addObject:[NSValue valueWithCGSize:labelSize]];
    }
    else {
        labelSize = [sizeValue CGSizeValue];
    }
    //NSString *imageURLString = [tweetImageURLs objectAtIndex: [indexPath row]];
        if (![aTweet objectForKey:@"isReply"])
        {
            [cell setupWithText:[aTweet objectForKey:@"text"] andSize:[NSValue valueWithCGSize:labelSize] andImage:image andType:kTweet];
        }
        else
        {
            [cell setupWithText:[aTweet objectForKey:@"text"] andSize:[NSValue valueWithCGSize:labelSize] andImage:image andType:kReply];
        }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"compose-tweet"])
    {
        ComposeTweetViewController *vc = [segue destinationViewController];
        
        [vc setCultivateTweetText: replyCellTweetContents];
        [vc setDelegate:self];
    }
}

-(void)dismissTweetView
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)sendTweetWithText:(NSString*)text
{
    if ([TWTweetComposeViewController canSendTweet])
    {
            // Create account store, followed by a twitter account identifier
            // At this point, twitter is the only account type available
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
            // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
         {
                 // Did user allow us access?
             if (granted == YES)
             {
                     // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 
                     // Sanity check
                 if ([arrayOfAccounts count] > 0)
                 {
                         // Keep it simple, use the first account available
                     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                                          
                         // Build a twitter request
                         //NSLog(@"status text = %@", text);
                         //NSLog(@"reply id = %@", replyID);
                     TWRequest *postRequest = [[TWRequest alloc] initWithURL:
                                               [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
                                                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys: replyID, @"in_reply_to_status_id", text, @"status", nil] requestMethod:TWRequestMethodPOST];
                         // [NSDictionary dictionaryWithObject:@"Test test"                 forKey:@"status"]

                         // Post the request
                     [postRequest setAccount:acct];
                     
                         // Block handler to manage the response
                     [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                      {
                              //NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                              //NSLog(@"Error = %@", [NSHTTPURLResponse localizedStringForStatusCode: [urlResponse statusCode]]);
                          
                          if ([urlResponse statusCode]==200)
                          {
                              dispatch_sync(dispatch_get_main_queue(), ^{
                                  
                                  [self addTweetBelowTweetWithText:text];                              
                                  
                              });//end block
                          }
                          else
                          {
                              UIAlertView *tweetFailed = [[UIAlertView alloc] initWithTitle:@"Tweet failed" message:@"Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                              [tweetFailed show];
                          }
                      }];
                 }
             }
         }];
        
    }
}

-(void)addTweetBelowTweetWithText:(NSString*)text
{
    if (!replies)
    {
        self.replies = [NSMutableArray arrayWithCapacity:20];
    }
    
    NSDictionary *user = [NSDictionary dictionaryWithObject:@"NO_URL" forKey:@"profile_image_url"];
    NSDictionary *replyTweet = [NSDictionary dictionaryWithObjectsAndKeys:
                                    text, @"text",
                                    [NSNumber numberWithBool:YES], @"isReply",
                                    user, @"user",
                                    replyCellTweetContents, @"in_reply_to_tweet_text", nil];
    [self.replies addObject:replyTweet];
    
    [self writeUserReplies];
    
    [self populateTweetTable];
}

-(void)tweetReplyAtCellIndex:(NSInteger)index
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        NSDictionary *aTweet = [tweets objectAtIndex:index];
            //NSDictionary *user = (NSDictionary*)[aTweet objectForKey:@"user"];
            //replyID = (NSString*)[user objectForKey:@"id_str"];
            replyID = (NSString*)[aTweet objectForKey:@"id_str"];
        replyCellTweetContents = [aTweet objectForKey:@"text"];
        
        [self performSegueWithIdentifier:@"compose-tweet" sender:nil];
    }
    else
    {
        UIAlertView *noTweetPossible = [[UIAlertView alloc] initWithTitle:@"Chat unavailable" message:@"You have no Twitter accounts setup on this device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noTweetPossible show];
    }
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
        
        labelSize = [string sizeWithFont:[UIFont fontWithName:kTextFont size:14.0] 
                              constrainedToSize:CGSizeMake(kMaxTweetLabelSize, MAXFLOAT)
                                  lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 70) 
            labelSize.height = 70.0;
        
        [tableViewCellSizes addObject:[NSValue valueWithCGSize:labelSize] ];
        //NSLog(@"tableViewCellSizes count = %i", [tableViewCellSizes count]);
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
            URLString = [NSString stringWithFormat:@"%@%@",@"http://mobile.twitter.com/search/%23",[objectAsStr substringFromIndex:1]];
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

#pragma mark - Pull-to-refresh functionality
-(void) loadingComplete  {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTweetsLoaded object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTweetsLoadingFailed object:nil];
    self.loading = NO;
}
-(void) doRefresh  {
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:kContentInteractionEvent
                                         action:@"Refresh list of tweets"
                                          label:@""
                                          value:0
                                      withError:&error]) {
        NSLog(@"GANTracker error, %@", [error localizedDescription]);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateTweetTable) name:kTweetsLoaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingComplete) name:kTweetsLoadingFailed object:nil];
    [[Utilities sharedAppDelegate] getPublicTimelineInBackground];

}

-(void)reloadTweetTableWithUpdate:(BOOL)update
{
    if (update)
        self.tweets = [[Utilities sharedAppDelegate] tweets];
    
    self.tweetImageURLs  = [NSMutableArray arrayWithCapacity: [tweets count]];
    self.tableViewCellSizes = [NSMutableArray arrayWithCapacity:[tweets count]];
    self.tableViewCellImages = [NSMutableArray arrayWithCapacity:[tweets count]];
    
    NSInteger count = 0;
    for (NSDictionary *dict in tweets)
    {
        NSDictionary *user = (NSDictionary*)[dict objectForKey:@"user"];
        [tweetImageURLs addObject: [user objectForKey:@"profile_image_url"]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[tweetImageURLs objectAtIndex:count]]];
        UIImage *image = [UIImage imageWithData:data];
        [tableViewCellImages addObject: image];
        CGSize labelSize = [[dict objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:kTextFont size:14.0] 
                                                   constrainedToSize:CGSizeMake(kMaxTweetLabelSize, MAXFLOAT)
                                                       lineBreakMode:UILineBreakModeWordWrap];
        if (labelSize.height < 70) 
            labelSize.height = 70.0;
        
        [tableViewCellSizes addObject:[NSValue valueWithCGSize:labelSize]];
        count++;
    }
    [self.tableView reloadData];
    [self loadingComplete]; 
}

-(void)writeUserReplies
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.replies forKey:kUserRepliesKey];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilename = [documentsDirectory stringByAppendingPathComponent:kUserRepliesFilename];
    [dict writeToFile:dataFilename atomically:YES];
}

-(void)readUserReplies
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilename = [documentsDirectory stringByAppendingPathComponent:kUserRepliesFilename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFilename])
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dataFilename];
        self.replies = (NSMutableArray*)[dict objectForKey:kUserRepliesKey];
    }
}

@end
