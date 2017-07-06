//
//  ESMyTravelsPhotoDetails.m
//  SocialNetwork
//
//  Created by Orbin V on 12/11/15.
//  Copyright © 2015 Eric Schanet. All rights reserved.
//

#import "ESMyTravels.h"
#import "ESMyTravelsPhotoDetails.h"
#import "ESBaseTextCell.h"
#import "ESActivityCell.h"
#import "ESPhotoDetailsFooterView.h"
#import "ESConstants.h"
//#import "ESAccountViewController.h"
#import "ESLoadMoreCell.h"
#import "ESUtility.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SCLAlertView.h"
#import "KILabel.h"
#import "ESHashtagTimelineViewController.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "TOWebViewController.h"
#import "ESTravelTimeline.h"

enum ActionSheetTags {
    MainActionSheetTag = 0,
    ConfirmDeleteActionSheetTag = 1,
    ReportPhotoActionSheetTag = 2,
    ThisIsUserTag = 3,
    DeleteCommentTag = 4,
    ReportUserCommentTag = 5,
    ReportUserReasonTag = 6
    
};

static const CGFloat kESCellInsetWidth = 0.0f;

@implementation ESMyTravelsPhotoDetails

@synthesize commentTextField;
@synthesize photo, headerView;

#pragma mark - Initialization

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ESUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.photo];
}

- (id)initWithPhoto:(PFObject *)aPhoto {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // The className to query on
        self.parseClassName = kESActivityClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of comments to show per page
        self.objectsPerPage = 30;
        
        self.photo = aPhoto;
        
        self.likersQueryInProgress = NO;
    }
    return self;
}


#pragma mark - UIViewController

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}
-(void)viewWillAppear:(BOOL)animated {
    self.tableView.tag = 3;
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44);
    [self updateBarButtonItems:1];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.container.panMode = MFSideMenuPanModeNone;
}
- (void)viewDidLoad {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//LogoNavigationBar.png"]];
    
    // Set table view properties
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    
    // Set table header
    if ([[self.photo objectForKey:@"type"]isEqualToString:@"text"]) {
        CGSize labelSize = [[self.photo objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                         constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 100)
                                                             lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat labelHeight = labelSize.height;
        
        self.headerView = [[ESPhotoDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 46+labelHeight+63) photo:self.photo];
    }
    else {
        self.headerView = [[ESPhotoDetailsHeaderView alloc] initWithFrame:[ESPhotoDetailsHeaderView rectForView] photo:self.photo];
    }
    self.headerView.delegate = self;
    
    self.tableView.tableHeaderView = self.headerView;
    
    // Set table footer
    ESPhotoDetailsFooterView *footerView = [[ESPhotoDetailsFooterView alloc] initWithFrame:[ESPhotoDetailsFooterView rectForView]];
    commentTextField = footerView.commentField;
    commentTextField.delegate = self;
    self.tableView.tableFooterView = footerView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonAction:)];
    
    // Register to be notified when the keyboard will be shown to scroll the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikedOrUnlikedPhoto:) name:ESUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.photo];
    NSString *notificationName = @"Hashtag";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useNotificationWithString:) name:notificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useNotificationWithMentionString:) name:@"Mention" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useNotificationWithWebsiteString:) name:@"Website" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.headerView reloadLikeBar];
    
    // we will only hit the network if we have no cached data for this photo
    BOOL hasCachedLikers = [[ESCache sharedCache] attributesForPhoto:self.photo] != nil;
    if (!hasCachedLikers) {
        [self loadLikers];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) { // A comment row
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        if (object) {
            NSString *commentString = [self.objects[indexPath.row] objectForKey:kESActivityContentKey];
            
            PFUser *commentAuthor = (PFUser *)[object objectForKey:kESActivityFromUserKey];
            
            NSString *nameString = @"";
            if (commentAuthor) {
                nameString = [commentAuthor objectForKey:kESUserDisplayNameKey];
            }
            
            return [ESActivityCell heightForCellWithName:nameString contentString:commentString cellInsetWidth:kESCellInsetWidth];
        }
    }
    
    // The pagination row
    return 44.0f;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kESActivityPhotoKey equalTo:self.photo];
    [query whereKeyDoesNotExist:@"noneread"];
    [query includeKey:kESActivityFromUserKey];
    //[query includeKey:kESPhotoExclusivesKey];

    if ([[self.photo objectForKey:@"type"] isEqualToString:@"text"]) {
        [query whereKey:kESActivityTypeKey equalTo:kESActivityTypeCommentPost];
    }
    else {
        [query whereKey:kESActivityTypeKey equalTo:kESActivityTypeCommentPhoto];
    }
    [query orderByAscending:@"createdAt"];
    
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

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    [self.headerView reloadLikeBar];
    [self loadLikers];
}

# pragma mark - UITableView data source and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellID = @"CommentCell";
    
    // Try to dequeue a cell and create one if necessary
    ESBaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ESBaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.cellInsetWidth = kESCellInsetWidth;
        cell.delegate = self;
    }
    
    [cell setUser:[object objectForKey:kESActivityFromUserKey]];
    [cell setContentText:[object objectForKey:kESActivityContentKey]];
    [cell setDate:[object createdAt]];
    
    if ([[(PFUser *)[object objectForKey:kESActivityFromUserKey] objectId] isEqualToString:[PFUser currentUser].objectId]) {
        cell.replyButton.hidden = YES;
    }
    
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    ESLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ESLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.cellInsetWidth = kESCellInsetWidth;
        cell.hideSeparatorTop = YES;
    }
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    if ([[[object objectForKey:@"fromUser"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            // show UIActionSheet
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you really want to delete this comment?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles: nil];
            [actionSheet showInView:self.view];
            actionSheet.tag = DeleteCommentTag;
            savedIndexPath = indexPath;
            
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        return @[deleteAction];
        
    }
    else {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"Report User", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            // show UIActionSheet
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you really want to report this user?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Report", nil) otherButtonTitles: nil];
            [actionSheet showInView:self.view];
            actionSheet.tag = ReportUserCommentTag;
            savedIndexPath = indexPath;
            
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        return @[deleteAction];
        
    }
    
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //We make some changes to the comment and verify everything is alright before we actually upload it.
    //We also search for mentions, hashtags and links.
    
    NSString *dummyComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *trimmedComment = [NSString stringWithFormat:@"%@ ",dummyComment];
    if (trimmedComment.length != 0 && [self.photo objectForKey:kESPhotoUserKey]) {
        NSRegularExpression *_regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:nil];
        NSArray *_matches = [_regex matchesInString:trimmedComment options:0 range:NSMakeRange(0, trimmedComment.length)];
        NSMutableArray *hashtagsArray = [[NSMutableArray alloc]init];
        for (NSTextCheckingResult *match in _matches) {
            NSRange wordRange = [match rangeAtIndex:1];
            NSString* word = [trimmedComment substringWithRange:wordRange];
            [hashtagsArray addObject:[word lowercaseString]];
        }
        
        PFObject *comment = [PFObject objectWithClassName:kESActivityClassKey];
        [comment setObject:trimmedComment forKey:kESActivityContentKey]; // Set comment text
        [comment setObject:[self.photo objectForKey:kESPhotoUserKey] forKey:kESActivityToUserKey]; // Set toUser
        [comment setObject:[PFUser currentUser] forKey:kESActivityFromUserKey]; // Set fromUser
        if ([photo objectForKey:kESVideoFileKey]) {
            [comment setObject:kESActivityTypeCommentVideo forKey:kESActivityTypeKey];
        }else if ([[photo objectForKey:@"type"] isEqualToString:@"text"]) {
            [comment setObject:kESActivityTypeCommentPost forKey:kESActivityTypeKey];
        }else [comment setObject:kESActivityTypeCommentPhoto forKey:kESActivityTypeKey];
        [comment setObject:self.photo forKey:kESActivityPhotoKey];
        if (hashtagsArray.count > 0) {
            [comment setObject:hashtagsArray forKey:@"hashtags"];
            
            for (int i = 0; i < hashtagsArray.count; i++) {
                
                //In the Hashtags class, if the hashtag doesn't already exist, we add it to the list a user can search through.
                
                NSString *hash = [[hashtagsArray objectAtIndex:i] lowercaseString];
                PFQuery *hashQuery = [PFQuery queryWithClassName:@"Hashtags"];
                [hashQuery whereKey:@"hashtag" equalTo:hash];
                [hashQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        if (objects.count == 0) {
                            PFObject *hashtag = [PFObject objectWithClassName:@"Hashtags"];
                            [hashtag setObject:hash forKey:@"hashtag"];
                            [hashtag saveInBackground];
                        }
                    }
                }];
            }
        }
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        [ACL setWriteAccess:YES forUser:[PFUser currentUser]];
        comment.ACL = ACL;
        
        [[ESCache sharedCache] incrementCommentCountForPhoto:self.photo];
        
        // Show HUD view
        [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        
        
        // If more than 5 seconds pass since we post a comment, stop waiting for the server to respond
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(handleCommentTimeout:) userInfo:@{@"comment": comment} repeats:NO];
        
        PFObject *mention = [PFObject objectWithClassName:kESActivityClassKey];
        [mention setObject:[PFUser currentUser] forKey:kESActivityFromUserKey]; // Set fromUser
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:nil];
        NSArray *matches = [regex matchesInString:trimmedComment options:0 range:NSMakeRange(0, trimmedComment.length)];
        NSMutableArray *mentionsArray = [[NSMutableArray alloc]init];
        for (NSTextCheckingResult *match in matches) {
            NSRange wordRange = [match rangeAtIndex:1];
            NSString* word = [trimmedComment substringWithRange:wordRange];
            [mentionsArray addObject:word];
        }
        if (mentionsArray.count > 0 ) {
            PFQuery *mentionQuery = [PFUser query];
            [mentionQuery whereKey:@"usernameFix" containedIn:mentionsArray];
            [mentionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [mention setObject:objects forKey:@"mentions"]; // Set toUser
                    [mention setObject:kESActivityTypeMention forKey:kESActivityTypeKey];
                    [mention setObject:self.photo forKey:kESActivityPhotoKey];
                    [mention saveEventually];
                }
            }];
        }
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [timer invalidate];
            
            if (error && error.code == kPFErrorObjectNotFound) {
                NSLog(@"ERROR:%@",error);
                [[ESCache sharedCache] decrementCommentCountForPhoto:self.photo];
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showError:self.tabBarController title:NSLocalizedString(@"Hold On...", nil)
                        subTitle:NSLocalizedString(@"We were unable to post your comment because this photo is no longer available.", nil)
                closeButtonTitle:@"OK" duration:0.0f];
                
                [self.navigationController popViewControllerAnimated:YES];
            }else if (error){
                [comment saveEventually];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ESPhotoDetailsViewControllerUserCommentedOnPhotoNotification object:self.photo userInfo:@{@"comments": @(self.objects.count + 1)}];
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self loadObjects];
        }];
    }
    
    [textField setText:@""];
    return [textField resignFirstResponder];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == MainActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to report this photo? This can not be undone and might have consequences for the author.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes, report this photo", nil) otherButtonTitles:nil];
            actionSheet.tag = ReportPhotoActionSheetTag;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        } else if (buttonIndex == 1){
            [self activityButtonAction:actionSheet];
        }
        
    }
    else if (actionSheet.tag == ThisIsUserTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            // prompt to delete
            if ([[self.photo objectForKey:@"type"] isEqualToString:@"text"]) {
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this post? This can not be undone.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes, delete post", nil) otherButtonTitles:nil];
                actionSheet.tag = ConfirmDeleteActionSheetTag;
                [actionSheet showFromTabBar:self.tabBarController.tabBar];
            }
            else {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this photo? This can not be undone.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes, delete photo", nil) otherButtonTitles:nil];
                actionSheet.tag = ConfirmDeleteActionSheetTag;
                [actionSheet showFromTabBar:self.tabBarController.tabBar];
            }
            
        } else if (buttonIndex == 1){
            [self activityButtonAction:actionSheet];
        }
        
    }
    else if (actionSheet.tag == ConfirmDeleteActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            
            [self shouldDeletePhoto];
        }
    } else if (actionSheet.tag == ReportPhotoActionSheetTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            
            [self shouldReportPhoto];
        }
    }
    else if (actionSheet.tag == DeleteCommentTag) {
        if ([actionSheet destructiveButtonIndex] == buttonIndex) {
            
            PFObject *object = [self.objects objectAtIndex:savedIndexPath.row];
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert showError:self.tabBarController title:NSLocalizedString(@"Hold On...", nil)
                            subTitle:NSLocalizedString(@"We were unable to delete your comment, retry later", nil)
                    closeButtonTitle:@"OK" duration:0.0f];
                }
                else {
                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert showSuccess:self.tabBarController title:NSLocalizedString(@"Congratulations", nil) subTitle:NSLocalizedString(@"Your comment has been successfully deleted", nil) closeButtonTitle:NSLocalizedString(@"Done", nil) duration:0.0f];
                    
                    [self loadObjects];
                    [self.tableView reloadData];
                }
            }];
        }
        
    }
    else if (actionSheet.tag == ReportUserCommentTag) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"What do you want the user to be reported for?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Sexual content", nil), NSLocalizedString(@"Offensive content", nil), NSLocalizedString(@"Spam", nil), NSLocalizedString(@"Other", nil), nil];
        //actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        actionSheet.tag = ReportUserReasonTag;
        [actionSheet showInView:self.view];
        
    }
    else if (actionSheet.tag == ReportUserReasonTag) {
        PFObject *object = [self.objects objectAtIndex:savedIndexPath.row];
        PFUser *user = [object objectForKey:kESActivityFromUserKey];
        if (buttonIndex == 0) {
            [ESUtility reportUser:0 withUser:user andObject:object];
        }
        else if (buttonIndex == 1) {
            [ESUtility reportUser:1 withUser:user andObject:object];
        }
        else if (buttonIndex == 2) {
            [ESUtility reportUser:2 withUser:user andObject:object];
        }
        else if (buttonIndex == 3) {
            [ESUtility reportUser:3 withUser:user andObject:object];
        }
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [commentTextField resignFirstResponder];
}


#pragma mark - ESBaseTextCellDelegate

- (void)cell:(ESBaseTextCell *)cellView didTapUserButton:(PFUser *)aUser {
    [self shouldPresentAccountViewForUser:aUser];
}
- (void)cell:(ESBaseTextCell *)cellView didTapReplyButton:(PFUser *)aUser {
    NSString *string = [NSString stringWithFormat:@"@%@ ",[aUser objectForKey:@"usernameFix"]];
    [commentTextField setText:string];
    [commentTextField becomeFirstResponder];
    
}


#pragma mark - ESPhotoDetailsHeaderViewDelegate

-(void)photoDetailsHeaderView:(ESPhotoDetailsHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user {
    [self shouldPresentAccountViewForUser:user];
}
- (void)photoDetailsHeaderView:(ESPhotoDetailsHeaderView *)_headerView didTapPhotoButton:(UIButton *)button {
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
#if TRY_AN_ANIMATED_GIF == 1
    imageInfo.imageURL = [NSURL URLWithString:@"http://media.giphy.com/media/O3QpFiN97YjJu/giphy.gif"];
#else
    imageInfo.image = _headerView.photoImageView.image;
#endif
    imageInfo.referenceRect = _headerView.photoImageView.frame;
    imageInfo.referenceView = _headerView.photoImageView.superview;
    imageInfo.referenceContentMode = _headerView.photoImageView.contentMode;
    imageInfo.referenceCornerRadius = _headerView.photoImageView.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    
}
- (void)shareButtonAction:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    
    if ([self currentUserOwnsPhoto]) {
        // Else we only want to show an action button if the user owns the photo and has permission to delete it.
        actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Delete", nil)];
        actionSheet.tag = ThisIsUserTag;
    }
    else {
        actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Report", nil)];
        actionSheet.tag = MainActionSheetTag;
    }
    if (NSClassFromString(@"UIActivityViewController")) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Share", nil)];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (void)activityButtonAction:(id)sender {
    if (NSClassFromString(@"UIActivityViewController")) {
        // TODO: Need to do something when the photo hasn't finished downloading!
        if ([[self.photo objectForKey:kESPhotoPictureKey] isDataAvailable]) {
            [self showShareSheet];
        } else if ([[self.photo objectForKey:@"type"] isEqualToString:@"text"]) {
            [self showShareSheet];
        }
        else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[self.photo objectForKey:kESPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!error) {
                    [self showShareSheet];
                }
            }];
        }
        
    }
}


#pragma mark - ()

- (void)showShareSheet {
    if ([[self.photo objectForKey:@"type"] isEqualToString:@"text"]) {
        NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
        
        // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
        if ([[[PFUser currentUser] objectId] isEqualToString:[[self.photo objectForKey:kESPhotoUserKey] objectId]] && [self.objects count] > 0) {
            PFObject *firstActivity = self.objects[0];
            if ([[[firstActivity objectForKey:kESActivityFromUserKey] objectId] isEqualToString:[[self.photo objectForKey:kESPhotoUserKey] objectId]]) {
                NSString *commentString = [firstActivity objectForKey:kESActivityContentKey];
                [activityItems addObject:commentString];
            }
        }
        
        //[activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"https://Netzwierk.org/#pic/%@", self.photo.objectId]]];
        [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/gasit/id659093855"]]];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            activityViewController.popoverPresentationController.sourceView = self.navigationController.navigationBar;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
        });
    } else {
        
        [[self.photo objectForKey:kESPhotoPictureKey] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                
                NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:3];
                
                // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
                if ([[[PFUser currentUser] objectId] isEqualToString:[[self.photo objectForKey:kESPhotoUserKey] objectId]] && [self.objects count] > 0) {
                    PFObject *firstActivity = self.objects[0];
                    if ([[[firstActivity objectForKey:kESActivityFromUserKey] objectId] isEqualToString:[[self.photo objectForKey:kESPhotoUserKey] objectId]]) {
                        NSString *commentString = [firstActivity objectForKey:kESActivityContentKey];
                        [activityItems addObject:commentString];
                    }
                }
                
                [activityItems addObject:[UIImage imageWithData:data]];
                //[activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"https://Netzwierk.org/#pic/%@", self.photo.objectId]]];
                [activityItems addObject:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/gasit/id659093855"]]];
                
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

- (void)handleCommentTimeout:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self.tabBarController title:NSLocalizedString(@"Hold On...", nil)
            subTitle:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)
    closeButtonTitle:@"OK" duration:0.0f];
}

- (void)shouldPresentAccountViewForUser:(PFUser *)user {
    ESTravelTimeline *accountsViewController = [[ESTravelTimeline alloc] initWithStyle:UITableViewStylePlain];
    [accountsViewController setUser:user];
    [self.navigationController pushViewController:accountsViewController animated:YES];
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userLikedOrUnlikedPhoto:(NSNotification *)note {
    [self.headerView reloadLikeBar];
}

- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0.0f, self.tableView.contentSize.height-kbSize.height) animated:YES];
}

- (void)loadLikers {
    if (self.likersQueryInProgress) {
        return;
    }
    
    self.likersQueryInProgress = YES;
    PFQuery *query = [ESUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
    if ([photo objectForKey:kESVideoFileKey]) {
        query = [ESUtility queryForActivitiesOnVideo:photo cachePolicy:kPFCachePolicyNetworkOnly];
    }
    if ([[photo objectForKey:@"type"] isEqualToString:@"text"])
    {
        query = [ESUtility queryForActivitiesOnPost:photo cachePolicy:kPFCachePolicyNetworkOnly];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.likersQueryInProgress = NO;
        if (error) {
            [self.headerView reloadLikeBar];
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
                if ([[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikePhoto] || [[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikeVideo] || [[activity objectForKey:kESActivityTypeKey] isEqualToString:kESActivityTypeLikePost]) {
                    isLikedByCurrentUser = YES;
                }
            }
        }
        
        
        [[ESCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
        [self.headerView reloadLikeBar];
    }];
}

- (BOOL)currentUserOwnsPhoto {
    return [[[self.photo objectForKey:kESPhotoUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]];
}

- (void)shouldDeletePhoto {
    // Delete all activites related to this photo
    PFQuery *query = [PFQuery queryWithClassName:kESActivityClassKey];
    [query whereKey:kESActivityPhotoKey equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }
        
        // Delete photo
        [self.photo deleteInBackgroundWithBlock:^(BOOL result, NSError *error){
            if (!error) {
                NSLog(@"happy");
            }
        }];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:ESPhotoDetailsViewControllerUserDeletedPhotoNotification object:[self.photo objectId]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shouldReportPhoto {
    PFObject *object = [PFObject objectWithClassName:@"Report"];
    [object setObject:photo forKey:@"ReportedPhoto"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundType = Blur;
            [alert showNotice:self.tabBarController title:NSLocalizedString(@"Notice", nil) subTitle:NSLocalizedString(@"Photo has been successfully reported.", nil) closeButtonTitle:@"OK" duration:0.0f];
            
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:self.tabBarController title:NSLocalizedString(@"Hold On...", nil)
                    subTitle:NSLocalizedString(@"Check your internet connection.", nil)
            closeButtonTitle:@"OK" duration:0.0f];
            NSLog(@"error %@",error);
        }
        
    }];
    
}

- (void)useNotificationWithString:(NSNotification *)notification {
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [notification userInfo];
    NSString *stringValueToUse = [dictionary valueForKey:key];
    ESHashtagTimelineViewController *hashtagSearch = [[ESHashtagTimelineViewController alloc] initWithStyle:UITableViewStyleGrouped andHashtag:stringValueToUse];
    [self.navigationController pushViewController:hashtagSearch animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
- (void)useNotificationWithMentionString:(NSNotification *)notification {
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [notification userInfo];
    NSString *stringValueToUse = [dictionary valueForKey:key];
    
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"usernameFix" equalTo:stringValueToUse];
    [ProgressHUD show:@"Loading..."];
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        [ProgressHUD dismiss];
        if (!error) {
            PFUser *mentionnedUser = (PFUser *)object;
            ESTravelTimeline *accountsViewController = [[ESTravelTimeline alloc] initWithStyle:UITableViewStylePlain];
            [accountsViewController setUser:mentionnedUser];
            [self.navigationController pushViewController:accountsViewController animated:YES];
        }
        else [ProgressHUD showError:@"Network error"];
    }];
}
- (void)useNotificationWithWebsiteString:(NSNotification *)notification {
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [notification userInfo];
    NSString *stringValueToUse = [dictionary valueForKey:key];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:stringValueToUse]];
    webViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
