//
//  ESConstants.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

typedef enum {
    ESHomeTabBarItemIndex = 0,
    ESAccountTabBarItemIndex = 1,
    ESEmptyTabBarItemIndex = 2,
    ESChatTabBarItemIndex = 3,
    ESActivityTabBarItemIndex = 4,

}
ESTabBarControllerViewControllerIndex;
#define     POPULARITY_POINTS_MINS                      0

#define kESNetzwierkEmployeeAccounts [NSArray arrayWithObjects:@"825596744144470", nil]

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define		MESSAGE_OUT_COLOUR						HEXCOLOR(0x007AFFFF)
#define		MESSAGE_IN_COLOUR						HEXCOLOR(0xE6E5EAFF)
#define		VIDEO_LENGTH                                20
#define     POPULARITY_POINTS_MIN                       10
#define EXCLUSIVE = YES 
#define EXCLUSIVES =                                     0

#pragma mark - NSUserDefaults
extern NSString *const kESUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kESUserDefaultsCacheFacebookFriendsKey;

#pragma mark - Launch URLs

extern NSString *const kESLaunchURLHostTakePicture;


#pragma mark - NSNotification
extern NSString *const ESAppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const ESUtilityUserFollowingChangedNotification;
extern NSString *const ESUtilityUserLikedUnlikedPhotoCallbackFinishedNotification;
extern NSString *const ESUtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const ESTabBarControllerDidFinishEditingPhotoNotification;
extern NSString *const ESTabBarControllerDidFinishImageFileUploadNotification;
extern NSString *const ESPhotoDetailsViewControllerUserDeletedPhotoNotification;
extern NSString *const ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification;
extern NSString *const ESPhotoDetailsViewControllerUserCommentedOnPhotoNotification;
extern NSString *const ESPhotoDetailsViewControllerUserReportedPhotoNotification;


#pragma mark - User Info Keys
extern NSString *const ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey;
extern NSString *const kESEditPhotoViewControllerUserInfoCommentKey;


#pragma mark - Installation Class

// Field keys
extern NSString *const kESInstallationUserKey;


#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kESActivityClassKey;

// Field keys
extern NSString *const kESActivityTypeKey;
extern NSString *const kESActivityFromUserKey;
extern NSString *const kESActivityToUserKey;
extern NSString *const kESActivityContentKey;
extern NSString *const kESActivityPhotoKey;
extern NSString *const kESActivityExclusiveKey;

// Type values
extern NSString *const kESActivityTypeLikePhoto;
extern NSString *const kESActivityTypeLikeVideo;
extern NSString *const kESActivityTypeLikePost;
extern NSString *const kESActivityTypeFollow;
extern NSString *const kESActivityTypeCommentPhoto;
extern NSString *const kESActivityTypeCommentVideo;
extern NSString *const kESActivityTypeCommentPost;
extern NSString *const kESActivityTypeMention;
extern NSString *const kESActivityTypeJoined;


#pragma mark - PFObject User Class
// Field keys
extern NSString *const kESUserDisplayNameKey;
extern NSString *const kESUserClassNameKey;
extern NSString *const kESUserObjectIdKey;
extern NSString *const kESUserDisplayNameKey;
extern NSString *const kESUserDisplayNameLowerKey;
extern NSString *const kESUserFacebookIDKey;
extern NSString *const kESUserPhotoIDKey;
extern NSString *const kESUserEmailKey;
extern NSString *const kESUserProfilePicSmallKey;
extern NSString *const kESUserProfilePicMediumKey;
extern NSString *const kESUserHeaderPicSmallKey;
extern NSString *const kESUserHeaderPicMediumKey;
extern NSString *const kESUserFacebookFriendsKey;
extern NSString *const kESUserAlreadyAutoFollowedFacebookFriendsKey;

#pragma mark - PFObject Chat Class
// Field keys
extern NSString *const kESChatClassNameKey;
extern NSString *const kESChatUserKey;
extern NSString *const kESChatLastUserKey;
extern NSString *const kESChatLastMessageKey;
extern NSString *const kESChatUpdateRoomKey;
extern NSString *const kESChatBlockedUserKey;
extern NSString *const kESChatDescriptionKey;
extern NSString *const kESChatRoomIdKey;
extern NSString *const kESChatMessageReadKey;
extern NSString *const kESChatUnseenMessagesKey;
extern NSString *const kESChatFirebaseCredentialKey;
extern NSString *const kESChatInviteUserMessage;

#pragma mark - PFObject Photo Class
// Class key
extern NSString *const kESPhotoClassKey;
extern NSString *const kESStoryClassKey;

// Field keys
extern NSString *const kESStoryPictureKey;
extern NSString *const kESStoryThumbnailKey;
extern NSString *const kESStoryUserKey;
extern NSString *const kESStoryLocationKey;
extern NSString *const kESStoryOpenGraphIDKey;
extern NSString *const kESStoryPopularPointsKey;
extern NSString *const kESStoryExclusiveKey;

extern NSString *const kESPhotoPictureKey;
extern NSString *const kESPhotoIsSponsored;
extern NSString *const kESVideoOrPhotoTypeKey;
extern NSString *const kESVideoTypeKey;
extern NSString *const kESVideoFileKey;
extern NSString *const kESVideoFileThumbnailKey;
extern NSString *const kESVideoFileThumbnailRoundedKey;
extern NSString *const kESPhotoThumbnailKey;
extern NSString *const kESPhotoUserKey;
extern NSString *const kESPhotoLocationKey;
extern NSString *const kESPhotoOpenGraphIDKey;
extern NSString *const kESPhotoPopularPointsKey;
extern NSString *const kESPhotoExclusiveKey;
extern NSString *const kESPhotoRepostKey;

#pragma mark - Cached Photo Attributes
// keys
extern NSString *const kESPhotoAttributesIsLikedByCurrentUserKey;
extern NSString *const kESPhotoAttributesLikeCountKey;
extern NSString *const kESPhotoAttributesLikersKey;
extern NSString *const kESPhotoAttributesCommentCountKey;
extern NSString *const kESPhotoAttributesCommentersKey;
extern NSString *const kESPhotoAttributesExclusiveKey;

#pragma mark - Cached User Attributes
// keys
extern NSString *const kESUserAttributesPhotoCountKey;
extern NSString *const kESUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - PFPush Notification Payload Keys

extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kESPushPayloadPayloadTypeKey;
extern NSString *const kESPushPayloadPayloadTypeActivityKey;

extern NSString *const kESPushPayloadActivityTypeKey;
extern NSString *const kESPushPayloadActivityLikeKey;
extern NSString *const kESPushPayloadActivityCommentKey;
extern NSString *const kESPushPayloadActivityFollowKey;

extern NSString *const kESPushPayloadFromUserObjectIdKey;
extern NSString *const kESPushPayloadToUserObjectIdKey;
extern NSString *const kESPushPayloadPhotoObjectIdKey;