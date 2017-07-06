//
//  ESPhotoTimelineViewController.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESPhotoTimelineViewController.h"
#import "ESPhotoCell.h"
#import "ESAccountViewController.h"
#import "ESPhotoDetailsViewController.h"
#import "ESVideoDetailViewController.h"
#import "ESUtility.h"
#import "ESLoadMoreCell.h"
#import "AppDelegate.h"
#import "UIViewController+ScrollingNavbar.h"
#import "ESVideoTableViewCell.h"
#import "ESTextPostCell.h"
#import "ESTravelTimeline.h"

BOOL easter = YES;


@interface ESPhotoTimelineViewController ()
@end

@implementation ESPhotoTimelineViewController
@synthesize reusableSectionHeaderViews;
@synthesize reusableSectionFooterViews;
@synthesize shouldReloadOnAppear;
@synthesize outstandingSectionHeaderQueries, outstandingCountQueries, outstandingFollowQueries;
@synthesize outstandingSectionFooterQueries;
@synthesize activityIndicator, tapOnce, tapTwice;

#pragma mark - Initialization

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESTabBarControllerDidFinishEditingPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESUtilityUserFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:ESPhotoDetailsViewControllerUserReportedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESPhotoDetailsViewControllerUserDeletedPhotoNotification object:nil];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        self.outstandingSectionFooterQueries = [NSMutableDictionary dictionary];
        
        // The className to query on
        self.parseClassName = kESPhotoClassKey;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        // Improve scrolling performance by reusing UITableView section headers
        self.reusableSectionHeaderViews = [NSMutableSet setWithCapacity:3];
        self.reusableSectionFooterViews = [NSMutableSet setWithCapacity:3];
        self.loadingViewEnabled = YES;
        self.shouldReloadOnAppear = NO;
    }
    return self;
}

-(void)loadView {
    [super loadView];
    
}
#pragma mark - UIViewController
- (void)viewWillAppear:(BOOL)animated {
    
    
    
}
- (IBAction)loadMoreButtonTapped:(id)sender {
    [self loadNextPage];
}

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [super viewDidLoad];
    
    [self.tableView setScrollsToTop:YES];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self action:@selector(loadObjects) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
    self.tableView.backgroundColor = [UIColor clearColor];
    UIColor *backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    self.tableView.backgroundView = [[UIView alloc]initWithFrame:self.tableView.bounds];
    self.tableView.backgroundView.backgroundColor = backgroundColor;
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xcc0900)];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xcc0900);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishPhoto:) name:ESTabBarControllerDidFinishEditingPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFollowingChanged:) name:ESUtilityUserFollowingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidDeletePhoto:) name:ESPhotoDetailsViewControllerUserDeletedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikePhoto:) name:ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLikeOrUnlikePhoto:) name:ESUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCommentOnPhoto:) name:ESPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPublishPhoto:) name:@"videoUploadEnds" object:nil];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    // Create a new view to a specific size
    UIView *loadMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 718, 239, 50)];
    [loadMoreView setBackgroundColor:[UIColor clearColor]];
    
    // Make this view the footer of my tableview
    
    
    // Create the button
    UIButton *loadMoreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // Set the size of the button to fill up the view it's within
    [loadMoreButton setFrame: loadMoreView.bounds];
    
    // Set the title and colour
    [loadMoreButton setTitle:@"Load More" forState:UIControlStateNormal];
    
    // Connect up an action to trigger loadNextPage method when button is tapped
    [loadMoreButton addTarget:self action:@selector(loadMoreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add this new button to the loadMoreView
    [loadMoreView addSubview:loadMoreButton]; // add the button to bottom view
    //   self.tableView.tableFooterView = loadMoreView;
    
    tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(didTapOnPhotoAction:)];
    tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(userDidLikeOrUnlikePhoto:)];
    
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    //stops tapOnce from overriding tapTwice
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = self.objects.count;
    if (self.paginationEnabled && sections != 0)
        sections++;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


#pragma mark - UITableViewDelegate


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == self.objects.count) {
        // Load More section
        return nil;
    }
    
    ESPhotoHeaderView *headerView = [self dequeueReusableSectionHeaderView];
    
    if (!headerView) {
        headerView = [[ESPhotoHeaderView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:ESPhotoHeaderButtonsDefault];
        headerView.delegate = self;
        [self.reusableSectionHeaderViews addObject:headerView];
    }
    
    PFObject *photo = [self.objects objectAtIndex:section];
    [headerView setPhoto:photo];
    
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.objects.count) {
        // Load More section
        return nil;
    }
    
    ESPhotoFooterView *headerView = [self dequeueReusableSectionFooterView];
    
    if (!headerView) {
        headerView = [[ESPhotoFooterView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 64.0f) buttons:ESPhotoFooterButtonsDefault2];
        headerView.delegate = self;
        [self.reusableSectionFooterViews addObject:headerView];
    }
    
    PFObject *photo = [self.objects objectAtIndex:section];
    [headerView setPhoto:photo];
    headerView.tag = section;
    [headerView.likeButton setTag:section];
    
    NSDictionary *attributesForPhoto = [[ESCache sharedCache] attributesForPhoto:photo];
    
    if (attributesForPhoto) {
        [headerView setLikeStatus:[[ESCache sharedCache] isPhotoLikedByCurrentUser:photo]];
        [headerView.likeImage setTitle:[[[ESCache sharedCache] likeCountForPhoto:photo] description] forState:UIControlStateNormal];
        [headerView.commentImage setTitle:[[[ESCache sharedCache] commentCountForPhoto:photo] description] forState:UIControlStateNormal];
        if ([[[[ESCache sharedCache] likeCountForPhoto:photo] description] isEqualToString:@"1"]) {
            [headerView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
        }
        else {
            [headerView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
        }
        if ([[[[ESCache sharedCache] commentCountForPhoto:photo] description] isEqualToString:@"1"]) {
            [headerView.labelComment setTitle:NSLocalizedString(@"comment", nil) forState:UIControlStateNormal];
        }
        else {
            [headerView.labelComment setTitle:NSLocalizedString(@"comments", nil) forState:UIControlStateNormal];
        }
        
        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
            [UIView animateWithDuration:0.500f animations:^{
                headerView.likeButton.alpha = 1.0f;
            }];
        }
    } else {
        headerView.likeButton.alpha = 0.0f;
        
        @synchronized(self) {
            // check if we can update the cache
            NSNumber *outstandingSectionFooterQueryStatus = [self.outstandingSectionFooterQueries objectForKey:@(section)];
            if (!outstandingSectionFooterQueryStatus) {
                PFQuery *query = [ESUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
                if ([photo objectForKey:kESVideoFileKey]) {
                    query = [ESUtility queryForActivitiesOnVideo:photo cachePolicy:kPFCachePolicyNetworkOnly];
                }
                if ([[photo objectForKey:@"type"] isEqualToString:@"text"])
                {
                    query = [ESUtility queryForActivitiesOnPost:photo cachePolicy:kPFCachePolicyNetworkOnly];
                }
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    @synchronized(self) {
                        [self.outstandingSectionHeaderQueries removeObjectForKey:@(section)];
                        
                        if (error) {
                            return;
                        }
                        
                        NSMutableArray *likers = [NSMutableArray array];
                        NSMutableArray *commenters = [NSMutableArray array];
                        
                        BOOL isLikedByCurrentUser = NO;
                        
                        for (PFObject *activity in objects) {
                            if (([[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikePhoto] || [[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikeVideo] || [[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikePost])&& [activity objectForKey:kESActivityFromUserKey]) {
                                [likers addObject:[activity objectForKey:kESActivityFromUserKey]];
                            } else if (([[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeCommentPhoto]||[[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeCommentVideo] || [[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeCommentPost]) && [activity objectForKey:kESActivityFromUserKey]) {
                                [commenters addObject:[activity objectForKey:kESActivityFromUserKey]];
                            }
                            
                            if ([[[activity objectForKey:kESActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                                if ([[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikePhoto] || [[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikeVideo]|| [[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikePost]) {
                                    isLikedByCurrentUser = YES;
                                }
                            }
                        }
                        
                        
                        [[ESCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                        
                        if (headerView.tag != section) {
                            return;
                        }
                        
                        [headerView setLikeStatus:[[ESCache sharedCache] isPhotoLikedByCurrentUser:photo]];
                        [headerView.likeImage setTitle:[[[ESCache sharedCache] likeCountForPhoto:photo] description] forState:UIControlStateNormal];
                        [headerView.commentImage setTitle:[[[ESCache sharedCache] commentCountForPhoto:photo] description] forState:UIControlStateNormal];
                        if ([[[[ESCache sharedCache] likeCountForPhoto:photo] description] isEqualToString:@"1"]) {
                            [headerView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
                        }
                        else {
                            [headerView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
                        }
                        if ([[[[ESCache sharedCache] commentCountForPhoto:photo] description] isEqualToString:@"1"]) {
                            [headerView.labelComment setTitle:NSLocalizedString(@"comment", nil) forState:UIControlStateNormal];
                        }
                        else {
                            [headerView.labelComment setTitle:NSLocalizedString(@"comments", nil) forState:UIControlStateNormal];
                        }
                        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
                            [UIView animateWithDuration:0.500f animations:^{
                                headerView.likeButton.alpha = 1.0f;
                            }];
                        }
                    }
                }];
            }
        }
    }
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.objects.count) {
        return 0.0f;
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.objects.count) {
        return 0.0f;
    }
    return 84.0f;   //mod:16.0f
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.objects.count) {
        // Load More Section
        return 44.0f;
    }
    PFObject *object = [self.objects objectAtIndex:indexPath.section];
    if ([[object objectForKey:@"type"] isEqualToString:@"text"]) {
        CGSize labelSize = [[object objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                     constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 100)
                                                         lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat labelHeight = labelSize.height;
        return labelHeight+10;
    }
    return [UIScreen mainScreen].bounds.size.width;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
    }
    else {
        PFObject *object = [self.objects objectAtIndex:indexPath.section];
        
        if ([object objectForKey:@"type"] && [object objectForKey:kESVideoFileKey]) {
            ESVideoTableViewCell *cell = (ESVideoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if (cell.movie.playbackState != MPMoviePlaybackStatePlaying) {
                
                cell.mediaItemButton.hidden = YES;
                cell.imageView.hidden = YES;
                [cell.movie prepareToPlay];
                [cell.movie play];
                cell.movie.view.hidden = NO;
                
            }
        }
    }
    
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        //[self.refreshControl endRefreshing];
        return query;
    }
    //
    //
    /* NOTE THAT WE DONT SET A TYPE FOR IMAGES, SO TYPE FIELD IS EMPTY FOR THEM!*/
    //
    //
    //Sponsored posts query
    PFQuery *sponsoredQuery = [PFQuery queryWithClassName:self.parseClassName];
    [sponsoredQuery whereKey:kESPhotoIsSponsored equalTo:[NSNumber numberWithBool:YES]];
    
    PFQuery *followingActivitiesQuery = [PFQuery queryWithClassName:kESActivityClassKey];
    [followingActivitiesQuery whereKey:kESActivityTypeKey equalTo:kESActivityTypeFollow];
    [followingActivitiesQuery whereKey:kESActivityFromUserKey equalTo:[PFUser currentUser]];
    followingActivitiesQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    followingActivitiesQuery.limit = 1000;
    
    PFQuery *photosFromFollowedUsersQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromFollowedUsersQuery whereKey:kESPhotoUserKey matchesKey:kESActivityToUserKey inQuery:followingActivitiesQuery];
    [photosFromFollowedUsersQuery whereKeyDoesNotExist:@"type"];
    [photosFromFollowedUsersQuery whereKeyExists:kESPhotoPictureKey];
    [photosFromFollowedUsersQuery whereKey:kESPhotoExclusiveKey equalTo:[NSNumber numberWithBool:FALSE]];
    
    PFQuery *videosFromFollowedUserQuery = [PFQuery queryWithClassName:self.parseClassName];
    [videosFromFollowedUserQuery whereKey:kESPhotoUserKey matchesKey:kESActivityToUserKey inQuery:followingActivitiesQuery];
    [videosFromFollowedUserQuery whereKeyExists:@"type"];
    [videosFromFollowedUserQuery whereKey:kESPhotoExclusiveKey equalTo:[NSNumber numberWithBool:FALSE]];
    // [videosFromFollowedUserQuery whereKeyExists:kESVideoFileKey];
    
    PFQuery *photosFromCurrentUserQuery = [PFQuery queryWithClassName:self.parseClassName];
    [photosFromCurrentUserQuery whereKey:kESPhotoUserKey equalTo:[PFUser currentUser]];
    [photosFromCurrentUserQuery whereKeyExists:kESPhotoPictureKey];
    [photosFromCurrentUserQuery whereKeyDoesNotExist:@"type"];
    [photosFromCurrentUserQuery whereKey:kESPhotoExclusiveKey equalTo:[NSNumber numberWithBool:FALSE]];

    PFQuery *videosFromCurrentUserQuery = [PFQuery queryWithClassName:self.parseClassName];
    [videosFromCurrentUserQuery whereKey:kESPhotoUserKey equalTo:[PFUser currentUser]];
    [videosFromCurrentUserQuery whereKeyExists:@"type"];
    // [videosFromCurrentUserQuery whereKeyExists:kESVideoFileKey];
    [videosFromCurrentUserQuery whereKey:kESPhotoExclusiveKey equalTo:[NSNumber numberWithBool:FALSE]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:photosFromFollowedUsersQuery, photosFromCurrentUserQuery, videosFromCurrentUserQuery, videosFromFollowedUserQuery, sponsoredQuery, nil]];
    [query includeKey:kESPhotoUserKey];
    [query orderByDescending:@"createdAt"];
    
    // A pull-to-refresh should always trigger a network request.
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    return query;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    // overridden, since we want to implement sections
    if (indexPath.section < self.objects.count) {
        return [self.objects objectAtIndex:indexPath.section];
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(ESVideoTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ESVideoTableViewCell class]]) {
        [cell.movie stop];
        cell.imageView.hidden = NO;
        cell.mediaItemButton.hidden = NO;
    }
    
}
- (void) dummyTapForVideo:(id)sender {
    UIButton *clicked = (UIButton *) sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:clicked.tag];
    [self performSelector:@selector(tableView:didSelectRowAtIndexPath:) withObject:self.tableView withObject:indexPath];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    static NSString *TextIdentifier = @"TextCell";
    static NSString *VideoIdentifier = @"VideoCell";
    
    
    if (indexPath.section == self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    }
    else if ([[object objectForKey:@"type"] isEqualToString:@"video"]) {
        ESVideoTableViewCell *cell = (ESVideoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:VideoIdentifier];
        
        if (cell == nil) {
            cell = [[ESVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoIdentifier];
            
            [cell.mediaItemButton addTarget:self action:@selector(dummyTapForVideo:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        cell.mediaItemButton.tag = indexPath.section;
        
        cell.imageView.image = [UIImage imageNamed:@"PlaceholderPhoto"];
        // cell.imageView.hidden= YES;
        if (object) {
            
            cell.imageView.file = [object objectForKey:@"videoThumbnail"];
            [cell.imageView loadInBackground];
            
            PFFile *video =[object objectForKey:@"file"];
            [video getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    NSString *string = [NSString stringWithFormat:@"cell%li.m4v", (long)cell.mediaItemButton.tag];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:string];
                    [data writeToFile:appFile atomically:YES];
                    NSURL *movieUrl = [NSURL fileURLWithPath:appFile];
                    [cell.movie setContentURL:movieUrl];
                }
            }];
            
        }
        return cell;
    }
    else if ([[object objectForKey:@"type"] isEqualToString:@"text"]) {
        ESTextPostCell *cell = (ESTextPostCell *)[tableView dequeueReusableCellWithIdentifier:TextIdentifier];
        if (cell == nil) {
            cell = [[ESTextPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextIdentifier];
            
            [cell.itemButton addTarget:self action:@selector(didTapOnTextPostAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        cell.itemButton.tag = indexPath.section;
        
        // cell.imageView.hidden= YES;
        if (object) {
            CGSize labelSize = [[object objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                         constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 100)
                                                             lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat labelHeight = labelSize.height;
            cell.postText.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, labelHeight+10);
            cell.itemButton.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, labelHeight+10);
            cell.postText.text = [object objectForKey:@"text"];
        }
        return cell;
    }
    else {
        ESPhotoCell *cell = (ESPhotoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[ESPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.mediaItemButton addTarget:self action:@selector(didTapOnPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.mediaItemButton.tag = indexPath.section;
        cell.imageView.image = [UIImage imageNamed:@"PlaceholderPhoto"];
        
        if (object) {
            cell.imageView.file = [object objectForKey:kESPhotoPictureKey];
            
            // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
            //if ([cell.imageView.file isDataAvailable]) {
            [cell.imageView loadInBackground];
            
            //}
        }
        
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    ESLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[ESLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleGray;
        cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView bringSubviewToFront:cell];
}

#pragma mark - ESPhotoTimelineViewController

- (ESPhotoHeaderView *)dequeueReusableSectionHeaderView {
    for (ESPhotoHeaderView *sectionHeaderView in self.reusableSectionHeaderViews) {
        if (!sectionHeaderView.superview) {
            // we found a section header that is no longer visible
            return sectionHeaderView;
        }
    }
    
    return nil;
}

- (ESPhotoFooterView *)dequeueReusableSectionFooterView {
    for (ESPhotoFooterView *sectionFooterView in self.reusableSectionFooterViews) {
        if (!sectionFooterView.superview) {
            // we found a section header that is no longer visible
            return sectionFooterView;
        }
    }
    
    return nil;
}



#pragma mark - ESPhotoHeaderViewDelegate

- (void)photoHeaderView:(ESPhotoHeaderView *)photoHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user {
    ESAccountViewController *accountViewController = [[ESAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
    
}

#pragma mark - ESPhotoFooterViewDelegate

- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapUserButton:(UIButton *)button user:(PFUser *)user {
    ESAccountViewController *accountViewController = [[ESAccountViewController alloc] initWithStyle:UITableViewStylePlain];
    [accountViewController setUser:user];
    [self.navigationController pushViewController:accountViewController animated:YES];
    
}

- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapLikePhotoButton:(UIButton *)button photo:(PFObject *)photo {
    // Disable the button so users cannot send duplicate requests
    [photoFooterView shouldEnableLikeButton:NO];
    NSNumber *number = [NSNumber numberWithInt:0];
    [photoFooterView performSelector:@selector(shouldReEnableLikeButton:) withObject:number afterDelay:0.5];
     //photoFooterView shouldReEnableLikeButton:number];
    
    BOOL liked = !button.selected;
    [photoFooterView setLikeStatus:liked];
    
    NSString *originalButtonTitle = photoFooterView.likeImage.titleLabel.text;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSNumber *likeCount = [numberFormatter numberFromString:photoFooterView.likeImage.titleLabel.text];
    if (liked) {
        likeCount = [NSNumber numberWithInt:[likeCount intValue] + 1];
        [[ESCache sharedCache] incrementLikerCountForPhoto:photo];
    } else {
        if ([likeCount intValue] > 0) {
            likeCount = [NSNumber numberWithInt:[likeCount intValue] - 1];
        }
        [[ESCache sharedCache] decrementLikerCountForPhoto:photo];
    }
    
    [[ESCache sharedCache] setPhotoIsLikedByCurrentUser:photo liked:liked];
    
    if ([[numberFormatter stringFromNumber:likeCount] isEqualToString:@"1"]) {
        [photoFooterView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
    }
    else {
        [photoFooterView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
    }
    [photoFooterView.likeImage setTitle:[numberFormatter stringFromNumber:likeCount] forState:UIControlStateNormal];
    
    if (liked) {
        if ([photo objectForKey:kESVideoFileKey]) { //check if it is a video actually
            [ESUtility likeVideoInBackground:photo block:^(BOOL succeeded, NSError *error) {
                ESPhotoFooterView *actualHeaderView = (ESPhotoFooterView *)[self tableView:self.tableView viewForFooterInSection:button.tag];
                
                NSNumber *number = [NSNumber numberWithInt:1];
                [photoFooterView performSelector:@selector(shouldReEnableLikeButton:) withObject:number afterDelay:0.5];
                
                [actualHeaderView shouldEnableLikeButton:YES];
                [actualHeaderView setLikeStatus:succeeded];
                
                if (!succeeded) {
                    [actualHeaderView.likeImage setTitle:originalButtonTitle forState:UIControlStateNormal];
                    
                    if ([originalButtonTitle isEqualToString:@"1"]) {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
                    }
                    else {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
                        
                    }
                }
                
            }];
        }
        else if ([[photo objectForKey:@"type"] isEqualToString:@"text"]) { //check if it is a text post actually
            [ESUtility likePostInBackground:photo block:^(BOOL succeeded, NSError *error) {
                ESPhotoFooterView *actualHeaderView = (ESPhotoFooterView *)[self tableView:self.tableView viewForFooterInSection:button.tag];
                
                NSNumber *number = [NSNumber numberWithInt:1];
                [photoFooterView performSelector:@selector(shouldReEnableLikeButton:) withObject:number afterDelay:0.5];
                
                [actualHeaderView shouldEnableLikeButton:YES];
                [actualHeaderView setLikeStatus:succeeded];
                
                if (!succeeded) {
                    [actualHeaderView.likeImage setTitle:originalButtonTitle forState:UIControlStateNormal];
                    
                    if ([originalButtonTitle isEqualToString:@"1"]) {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
                    }
                    else {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
                        
                    }
                }
                
            }];
        }
        else {
            [ESUtility likePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
                ESPhotoFooterView *actualHeaderView = (ESPhotoFooterView *)[self tableView:self.tableView viewForFooterInSection:button.tag];
                
                NSNumber *number = [NSNumber numberWithInt:1];
                [photoFooterView performSelector:@selector(shouldReEnableLikeButton:) withObject:number afterDelay:0.5];
                
                [actualHeaderView shouldEnableLikeButton:YES];
                [actualHeaderView setLikeStatus:succeeded];
                
                if (!succeeded) {
                    [actualHeaderView.likeImage setTitle:originalButtonTitle forState:UIControlStateNormal];
                    
                    if ([originalButtonTitle isEqualToString:@"1"]) {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
                    }
                    else {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
                        
                    }
                }
                
            }];
        }
    } else {
        if ([photo objectForKey:kESVideoFileKey]) { //check if it is a video actually
            [ESUtility unlikeVideoInBackground:photo block:^(BOOL succeeded, NSError *error) {
                ESPhotoFooterView *actualHeaderView = (ESPhotoFooterView *)[self tableView:self.tableView viewForFooterInSection:button.tag];
                
                
                NSNumber *number = [NSNumber numberWithInt:1];
                [photoFooterView performSelector:@selector(shouldReEnableLikeButton:) withObject:number afterDelay:0.5];
                
                [actualHeaderView shouldEnableLikeButton:YES];
                [actualHeaderView setLikeStatus:!succeeded];
                
                if (!succeeded) {
                    [actualHeaderView.likeImage setTitle:originalButtonTitle forState:UIControlStateNormal];
                    if ([originalButtonTitle isEqualToString:@"1"]) {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
                    }
                    else {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
                    }
                }
                
            }];
        } else if ([[photo objectForKey:@"type"] isEqualToString:@"text"]) { //check if it is a video actually
            [ESUtility unlikePostInBackground:photo block:^(BOOL succeeded, NSError *error) {
                ESPhotoFooterView *actualHeaderView = (ESPhotoFooterView *)[self tableView:self.tableView viewForFooterInSection:button.tag];
                
                
                NSNumber *number = [NSNumber numberWithInt:1];
                [photoFooterView performSelector:@selector(shouldReEnableLikeButton:) withObject:number afterDelay:0.5];
                
                [actualHeaderView shouldEnableLikeButton:YES];
                [actualHeaderView setLikeStatus:!succeeded];
                
                if (!succeeded) {
                    [actualHeaderView.likeImage setTitle:originalButtonTitle forState:UIControlStateNormal];
                    if ([originalButtonTitle isEqualToString:@"1"]) {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
                    }
                    else {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
                    }
                }
                
            }];
        } else {
            [ESUtility unlikePhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
                ESPhotoFooterView *actualHeaderView = (ESPhotoFooterView *)[self tableView:self.tableView viewForFooterInSection:button.tag];
                
                
                NSNumber *number = [NSNumber numberWithInt:1];
                [photoFooterView performSelector:@selector(shouldReEnableLikeButton:) withObject:number afterDelay:0.5];
                
                [actualHeaderView shouldEnableLikeButton:YES];
                [actualHeaderView setLikeStatus:!succeeded];
                
                if (!succeeded) {
                    [actualHeaderView.likeImage setTitle:originalButtonTitle forState:UIControlStateNormal];
                    if ([originalButtonTitle isEqualToString:@"1"]) {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"like", nil) forState:UIControlStateNormal];
                    }
                    else {
                        [photoFooterView.labelButton setTitle:NSLocalizedString(@"likes", nil) forState:UIControlStateNormal];
                    }
                }
                
            }];
        }
        
    }
}
- (void)photoHeaderView:(ESPhotoHeaderView *)photoHeaderView didTapReportPhoto:(UIButton *)button photo:(PFObject *)photo {
}

- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapCommentOnPhotoButton:(UIButton *)button  photo:(PFObject *)photo {
    UITableView *tableView = self.tableView; // Or however you get your table view
    NSArray *paths = [tableView indexPathsForVisibleRows];
    
    //  For getting the cells themselves
    
    for (NSIndexPath *path in paths) {
        if (path.section >= [self.objects count] || path.section < 0) {
            break;
        }
        PFObject *object = [self.objects objectAtIndex:path.section];
        if (![object isKindOfClass:[NSNull class] ]) {
            if ([object objectForKey:@"type"] && [object objectForKey:kESVideoFileKey]) {
                ESVideoTableViewCell *cell = (ESVideoTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
                [cell.movie stop];
                cell.mediaItemButton.hidden = NO;
                [cell.imageView setHidden:NO];
                
            }
        }
    }
    
    if ([photo objectForKey:kESVideoFileKey]) {
        ESVideoDetailViewController *videoDetailsVC = [[ESVideoDetailViewController alloc] initWithPhoto:photo];
        [self.navigationController pushViewController:videoDetailsVC animated:YES];
    }
    else {
        ESPhotoDetailsViewController *photoDetailsVC = [[ESPhotoDetailsViewController alloc] initWithPhoto:photo];
        [self.navigationController pushViewController:photoDetailsVC animated:YES];
    }
    
}
- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapSharePhotoButton:(UIButton *)button  photo:(PFObject *)photo {
    UITableView *tableView = self.tableView; // Or however you get your table view
    NSArray *paths = [tableView indexPathsForVisibleRows];
    
    //  For getting the cells themselves
    
    for (NSIndexPath *path in paths) {
        if (path.section >= [self.objects count] || path.section < 0) {
            break;
        }
        PFObject *object = [self.objects objectAtIndex:path.section];
        if ([object objectForKey:@"type"] && [object objectForKey:kESVideoFileKey]) {
            ESVideoTableViewCell *cell = (ESVideoTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
            [cell.movie stop];
            cell.mediaItemButton.hidden = NO;
            [cell.imageView setHidden:NO];
            
        }
    }
    if ([photo objectForKey:kESVideoFileKey]) {
        [[photo objectForKey:kESVideoFileThumbnailKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
                
                // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
                
                [activityItems addObject:[UIImage imageWithData:data]];
                
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                    activityViewController.popoverPresentationController.sourceView = self.navigationController.navigationBar;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
                });
            }
        }];
    }else if ([[photo objectForKey:@"type"] isEqualToString:@"text"]) {
        NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
        
        /*    // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
         if ([[[PFUser currentUser] objectId] isEqualToString:[[photo objectForKey:kESPhotoUserKey] objectId]] && [self.objects count] > 0) {
         PFObject *firstActivity = self.objects[0];
         if ([[[firstActivity objectForKey:kESActivityFromUserKey] objectId] isEqualToString:[[photo objectForKey:kESPhotoUserKey] objectId]]) {
         NSString *commentString = [firstActivity objectForKey:kESActivityContentKey];
         [activityItems addObject:commentString];
         }
         } */
        
        [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/gasit/id659093855"]]];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            activityViewController.popoverPresentationController.sourceView = self.navigationController.navigationBar;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
        });
        
        
    }
    else {
        [[photo objectForKey:kESPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
                
                [activityItems addObject:[UIImage imageWithData:data]];
                
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                    activityViewController.popoverPresentationController.sourceView = self.navigationController.navigationBar;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
                });
            }
        }];
    }
    
}

- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapRepostPhotoButton:(UIButton *)button photo:(PFObject *)photo {
    
    [photoFooterView shouldEnableRepostButton:NO];
    NSNumber *number = [NSNumber numberWithInt:0];
    [photoFooterView shouldReEnableLikeButton:number];
    [ESUtility repostPhotoInBackground:photo block:^(BOOL succeeded, NSError *error) {
        
        ESPhotoFooterView *actualFooterView = (ESPhotoFooterView *)[self tableView:self.tableView viewForFooterInSection:button.tag];
        
        NSNumber *number = [NSNumber numberWithInt:1];
        [actualFooterView performSelector:@selector(shouldReEnableRepostButton:) withObject:number afterDelay:0.5];
        [actualFooterView shouldEnableLikeButton:YES];
        
        if (!succeeded) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This was already posted!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = 1001;
            [alert show];   
        }
        
    }];
    
}

#pragma mark - ()

- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *object = [self.objects objectAtIndex:i];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:0 inSection:i];
        }
    }
    
    return nil;
}

- (void)userDidLikeOrUnlikePhoto:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidCommentOnPhoto:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userDidDeletePhoto:(NSNotification *)note {
    // refresh timeline after a delay
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self loadObjects];
    });
}

- (void)userDidPublishPhoto:(NSNotification *)note {
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    [self loadObjects];
}

- (void)userFollowingChanged:(NSNotification *)note {
    self.shouldReloadOnAppear = YES;
}


- (void)didTapOnPhotoAction:(UIButton *)sender {
    PFObject *photo = [self.objects objectAtIndex:sender.tag];
    if (photo) {
        ESPhotoDetailsViewController *photoDetailsVC = [[ESPhotoDetailsViewController alloc] initWithPhoto:photo];
        [self.navigationController pushViewController:photoDetailsVC animated:YES];
        
        
    }
}
- (void)didTapOnTextPostAction:(UIButton *)sender {
    PFObject *text = [self.objects objectAtIndex:sender.tag];
    if (text) {
        ESPhotoDetailsViewController *photoDetailsVC = [[ESPhotoDetailsViewController alloc] initWithPhoto:text];
        [self.navigationController pushViewController:photoDetailsVC animated:YES];
        
        
    }
}
- (void)postNotificationWithString:(NSString *)notification {
    NSString *notificationName = @"ESNotification";
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:notification forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}
@end