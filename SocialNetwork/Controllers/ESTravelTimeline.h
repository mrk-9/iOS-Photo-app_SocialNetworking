//
//  ESTravelTimeline.h
//  SocialNetwork
//
//  Created by Orbin V on 11/18/15.
//  Copyright © 2015 Eric Schanet. All rights reserved.
//

#import "ESPhotoTimelineAccountViewController.h"
#import "ESPhotoCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "ESLoadMoreCell.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ResizeAdditions.h"
#import "ESEditPhotoViewController.h"
#import "SCLAlertView.h"
#import "ESEditProfileViewController.h"

#import "MMDrawerBarButtonItem.h"
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "KILabel.h"

@interface ESTravelTimeline : ESPhotoTimelineAccountViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
 *  The user that belongs to the profile page.
 */
@property (nonatomic, strong) PFUser *user;
/**
 *  Imageview containing the profile picture of the user.
 */
@property (nonatomic, strong) PFImageView *profilePictureImageView;
/**
 *  The header of the tableview, this is where the profile picture, header picture and personal information of the user is displayed.
 */
@property (nonatomic, strong) UIView *headerView;
/**
 *  White background in the header.
 */
@property (nonatomic, strong) UIView *whiteBackground;
/**
 *  A textured background in case no profile picture is there.
 */
@property (nonatomic, strong) UIView *texturedBackgroundView;
/**
 *  Gray line separating the header from the first post.
 */
@property (nonatomic, strong) UILabel *grayLine;
/**
 *  Background of the newsfeed in case the user has already a profile picture.
 */
@property (nonatomic, strong) UIImageView *backgroundImageView;
/**
 *  Display name of the user, usually his actual name.
 */
@property (nonatomic, strong) UILabel *userDisplayNameLabel;
/**
 *  Mention name of the user, used to mention him in a comment.
 */
@property (nonatomic, strong) UILabel *userMentionLabel;
/**
 *  Number of photos uploaded by the user.
 */
@property (nonatomic, strong) UILabel *photoCountLabel;
/**
 *  Containing personal information about the user, usually a bio.
 */
@property (nonatomic, strong) UILabel *infoLabel;
/**
 *  Rough number of followers of the user.
 */
@property (nonatomic, strong) UILabel *followerCountLabel;
/**
 *  Rough number of users the current user is following.
 */
@property (nonatomic, strong) UILabel *followingCountLabel;
/**
 *  Containing the home town/city of the user.
 */
@property (nonatomic, strong) UILabel *cityLabel;
/**
 *  Containing the website of the user.
 */
@property (nonatomic, strong) KILabel *siteLabel;
/**
 *  Only displayed when the user's profile isn't our own profile, used to report the user for infringing our terms of use.
 */
@property (nonatomic, strong) UIButton *reportUser;
/**
 *  Imageview where the profile picture of the user will be displayed
 */
@property (nonatomic, strong) PFImageView *imageView;
/**
 *  Background of the profile picture, a bit bigger than the actual picture in order to create a white border.
 */
@property (nonatomic, strong) UIButton *profilePictureBackgroundView;
/**
 *  Button taking the user to his edit profile page. In case it isn't our own profile page we display a follow button instead.
 */

@property (nonatomic, strong) UIButton *editProfileBtn;
/**
 *  Segmented control containing the number of photos and followers. One could implement newsfeeds depending on what tab of the segmented control is selected.
 */
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIButton *photosBtn;
@property (nonatomic, strong) UIButton *followerBtn;
@property (nonatomic, strong) UIButton *followingBtn;

/**
 *  Hot fix for the bug in the Parse SDK causing a crash when the LoadMoreCell is tapped in a section based tableview.
 *
 *  @return NSIndexPath for the PaginationCell
 */
- (NSIndexPath *)_indexPathForPaginationCell;
/**
 *  Called when a user taps on the raport button
 */
- (void)ReportTap;
/**
 *  Method creating the actual report with a parameter used to identify the reason.
 *
 *  @param i reason why the user is reported
 */
-(void)reportUser:(int)i;

/**
 *  Called when the edit profile button is tapped .
 */
- (void) editProfileBtnTapped;
/**
 *  Configures the unfollowbutton.
 */
- (void)configureUnfollowButton;
/**
 *  Configures the follow button.
 */
- (void)configureFollowButton;
/**
 *  Configures the edit profile button because we're on our own profile page.
 */
- (void)configureSettingsButton;
/**
 *  Unfollows the user
 *
 *  @param sender id of the unfollow button.
 */
- (void)unfollowButtonAction:(id)sender;
/**
 *  Follows the user
 *
 *  @param sender id of the follow button.
 */
- (void)followButtonAction:(id)sender;
/**
 *  Setting up the layout of the header.
 */
- (void) setupHeader;
@end
