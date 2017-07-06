//
//  ESHomeViewController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESPhotoTimelineViewController.h"
#import "MMDrawerController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "ESSettingsActionSheetDelegate.h"
#import "MBProgressHUD.h"

@interface ESHomeViewController : ESPhotoTimelineViewController <MFMailComposeViewControllerDelegate> {
        UIView *rootView;
}
/**
 *  Detecting if this is the first ever launch of the user on this device.
 */
@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;
/**
 *  Custom action sheet delegate
 */
@property (nonatomic, strong) ESSettingsActionSheetDelegate *settingsActionSheetDelegate;
/**
 *  View that is being displayed when the timeline is blank
 */
@property (nonatomic, strong) UIView *blankTimelineView;
/**
 *  Classic progresshud indicating that something is going on.
 */
@property (nonatomic, strong) MBProgressHUD *hud;
/**
 *  Taking the user to the invite friends page.
 *
 *  @param sender id of the button, we don't need it here in fact.
 */
- (void)inviteFriendsButtonAction:(id)sender;
/**
 *  The ESHomeViewController is target of all the notifications we post to the notification center. This viewcontroller executes all the commands.
 *
 *  @param notification string describing the notification type
 */
- (void)useNotificationWithString:(NSNotification *)notification;
/**
 *  Logout helper method, calling the logout method from the AppDelegate.
 */
- (void)logoutHelper;
/**
 *  Called when the rightBarButton is tapped, the user wants to search his timeline for a specific hashtag.
 */
- (void)newHashtagSearch;
/**
 *  Hot fix for a bug in the Parse SDK causing a crash when we use a section based tableview with the LoadMoreCell
 */
- (NSIndexPath *)_indexPathForPaginationCell;
/**
 *  Tiny easter egg 
 */
- (void)easterButtonTap;

@end

