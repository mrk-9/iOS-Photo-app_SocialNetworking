//
//  ESActivityFeedViewController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESSettingsActionSheetDelegate.h"
#import "ESActivityCell.h"
#import "ESAccountViewController.h"
#import "ESPhotoDetailsViewController.h"
#import "ESVideoDetailViewController.h"
#import "ESBaseTextCell.h"
#import "ESLoadMoreCell.h"
#import "ESSettingsButtonItem.h"
#import "ESFindFriendsViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "MMDrawerBarButtonItem.h"
#import "SideViewController.h"
#import "MFSideMenu.h"
#import "ESTravelTimeline.h"

/**
 *  Interface of the ESActivityFeedViewController
 */
@interface ESActivityFeedViewController : PFQueryTableViewController <ESActivityCellDelegate>
/**
 *  Assigning the ESSettingsActionSheetDelegate.
 */
@property (nonatomic, strong) ESSettingsActionSheetDelegate *settingsActionSheetDelegate;
/**
 *  Date telling us when we last refreshed the activity feed.
 */
@property (nonatomic, strong) NSDate *lastRefresh;
/**
 *  UIView that is displayed when no Activity is available.
 */
@property (nonatomic, strong) UIView *blankTimelineView;
/**
 *  There are different types of activities, and every type has to get an own description and text. We assign a type to each activity and everytime we need to differentiate the activities, we look at that exact key.
 *
 *  @param activityType type of the activity (like, comment, mention, ...)
 *
 *  @return string containing the text we put in the activity cell
 */
+ (NSString *)stringForActivityType:(NSString *)activityType;
/**
 *  The settings button has been tapped, thus we open the sideviewcontroller.
 */
- (void)settingsButtonAction:(id)sender;
/**
 *  The invite friends cell has been tapped, thus we open the InviteFriendsViewController.
 */
- (void)inviteFriendsButtonAction:(id)sender;

@end
