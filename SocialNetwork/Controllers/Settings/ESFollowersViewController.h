//
//  Created by Eric Schanet on 19/09/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "ESFindFriendsCell.h"
#import "ESProfileImageView.h"
#import "AppDelegate.h"
#import "ESLoadMoreCell.h"
#import "ESAccountViewController.h"
#import "MBProgressHUD.h"
#import "ESPhoneContacts.h"
#import "ESTravelTimeline.h"

/**
 *  Interface of the ESFindFriendsViewController, used to find new friends and other users.
 */
@interface ESFollowersViewController : PFQueryTableViewController <ESFindFriendsCellDelegate, ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate,UISearchDisplayDelegate, UISearchBarDelegate>
/**
 *  Header of the UITableView
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  Followstatus between the current user and the respective users in the different cells.
 */
@property (nonatomic, assign) ESFindFriendsFollowStatus followStatus;
/**
 *  If the user wants to invite another user per mail, we store the recipient's email here.
 */
@property (nonatomic, strong) NSString *selectedEmailAddress;
@property (nonatomic, strong) NSString *option;
/**
 *  Mutable dictionary of follower queries still outstanding.
 */
@property (nonatomic, strong) NSMutableDictionary *outstandingFollowQueries;
/**
 *  Mutable dictionary of outstanding photo count queries.
 */
@property (nonatomic, strong) NSMutableDictionary *outstandingCountQueries;
/**
 *  The searchbar that is displayed at the top of the tableview.
 */
@property (nonatomic, strong) UISearchBar *searchBar;
/**
 *  Search controller used to display the filtered result of users.
 */
@property (nonatomic, strong) UISearchDisplayController *searchController;
/**
 *  The results of the search query.
 */
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *queriedUsers;
/**
 *  PFQuery gathering the users based on the search keys.
 */
@property (nonatomic, strong) PFQuery *searchQuery;
@property (nonatomic, strong) PFUser *user;

- (id)initWithStyle:(UITableViewStyle)style andOption:(NSString *)string andUser:(PFUser *)user;
/**
 *  Filtering the results: we search for users that contain the searchTerm
 */
-(void)filterResults:(NSString *)searchTerm;
/**
 *  Dismissing the viewcontroller.
 */
- (void)backButtonAction:(id)sender;
/**
 *  Invite friends to join the social network.
 */
- (void)inviteFriendsButtonAction:(id)sender;
/**
 *  Toggle the followstatus in the friendcell from following to unfollowing and vice versa.
 *
 *  @param cell the cell containing the respective follow button
 */
- (void)shouldToggleFollowFriendForCell:(ESFindFriendsCell*)cell;
/**
 *  Presenting a mail composer with the recipient's email as prefilled address.
 *
 *  @param recipient recipient's email
 */
- (void)presentMailComposeViewController:(NSString *)recipient;
/**
 *  Presenting a message composer with the recipient's number.
 *
 *  @param recipient the recipient's number
 */
- (void)presentMessageComposeViewController:(NSString *)recipient;
/**
 *  Fixing a bug in the Parse SDK when calling the LoadMoreCell in a section based tableview.
 */
- (NSIndexPath *)_indexPathForPaginationCell;
@end
