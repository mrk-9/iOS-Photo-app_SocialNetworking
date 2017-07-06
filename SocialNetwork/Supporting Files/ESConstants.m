//
//  ESConstants.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESConstants.h"

NSString *const kESUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.parse.Netzwierk.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kESUserDefaultsCacheFacebookFriendsKey                     = @"com.parse.Netzwierk.userDefaults.cache.facebookFriends";


#pragma mark - Launch URLs

NSString *const kESLaunchURLHostTakePicture = @"camera";


#pragma mark - NSNotification

NSString *const ESAppDelegateApplicationDidReceiveRemoteNotification           = @"com.parse.Netzwierk.appDelegate.applicationDidReceiveRemoteNotification";
NSString *const ESUtilityUserFollowingChangedNotification                      = @"com.parse.Netzwierk.utility.userFollowingChanged";
NSString *const ESUtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = @"com.parse.Netzwierk.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const ESUtilityDidFinishProcessingProfilePictureNotification         = @"com.parse.Netzwierk.utility.didFinishProcessingProfilePictureNotification";
NSString *const ESTabBarControllerDidFinishEditingPhotoNotification            = @"com.parse.Netzwierk.tabBarController.didFinishEditingPhoto";
NSString *const ESTabBarControllerDidFinishImageFileUploadNotification         = @"com.parse.Netzwierk.tabBarController.didFinishImageFileUploadNotification";
NSString *const ESPhotoDetailsViewControllerUserDeletedPhotoNotification       = @"com.parse.Netzwierk.photoDetailsViewController.userDeletedPhoto";
NSString *const ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification  = @"com.parse.Netzwierk.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification";
NSString *const ESPhotoDetailsViewControllerUserCommentedOnPhotoNotification   = @"com.parse.Netzwierk.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";
NSString *const ESPhotoDetailsViewControllerUserReportedPhotoNotification   = @"com.parse.Netzwierk.photoDetailsViewController.userReportedPhotoInDetailsViewNotification";


#pragma mark - User Info Keys
NSString *const ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey = @"liked";
NSString *const kESEditPhotoViewControllerUserInfoCommentKey = @"comment";

#pragma mark - Installation Class

// Field keys
NSString *const kESInstallationUserKey = @"user";
NSString *const kESChatFirebaseCredentialKey  =  @"https://gasit.firebaseio.com";

#pragma mark - Activity Class
// Class key
NSString *const kESActivityClassKey = @"Activity";

// Field keys
NSString *const kESActivityTypeKey        = @"type";
NSString *const kESActivityFromUserKey    = @"fromUser";
NSString *const kESActivityToUserKey      = @"toUser";
NSString *const kESActivityContentKey     = @"content";
NSString *const kESActivityPhotoKey       = @"photo";
NSString *const kESActivityExclusiveKey   = @"exclusive";

// Type values
NSString *const kESActivityTypeLikePhoto       = @"like";
NSString *const kESActivityTypeLikeVideo       = @"like-video";
NSString *const kESActivityTypeLikePost       = @"like-post";
NSString *const kESActivityTypeFollow     = @"follow";
NSString *const kESActivityTypeCommentPhoto    = @"comment";
NSString *const kESActivityTypeCommentVideo    = @"comment-video";
NSString *const kESActivityTypeCommentPost    = @"comment-post";
NSString *const kESActivityTypeMention    = @"mention";
NSString *const kESActivityTypeJoined     = @"joined";

#pragma mark - User Class
// Field keys
NSString *const kESUserDisplayNameKey                          = @"displayName";
NSString *const kESUserDisplayNameLowerKey                          = @"displayName_lower";
NSString *const kESUserClassNameKey                            = @"_User";
NSString *const kESUserObjectIdKey                             = @"objectId";
NSString *const kESUserFacebookIDKey                           = @"facebookId";
NSString *const kESUserPhotoIDKey                              = @"photoId";
NSString *const kESUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kESUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kESUserEmailKey                                    = @"email";
NSString *const kESUserHeaderPicSmallKey                      = @"headerPictureSmall";
NSString *const kESUserHeaderPicMediumKey                     = @"headerPictureMedium";
NSString *const kESUserFacebookFriendsKey                      = @"facebookFriends";
NSString *const kESUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";

#pragma mark - Chat Class

NSString *const kESChatClassNameKey                            = @"Messenger";
NSString *const kESChatUserKey                                  = @"user";
NSString *const kESChatRoomIdKey                              = @"roomId";
NSString *const kESChatDescriptionKey                           = @"description";
NSString *const kESChatLastUserKey                           = @"lastUser";
NSString *const kESChatLastMessageKey                      = @"lastMessage";
NSString *const kESChatUnseenMessagesKey                     = @"unseenCounter";
NSString *const kESChatUpdateRoomKey                      = @"updateRoom";
NSString *const kESChatBlockedUserKey                       = @"blockedUser";
NSString *const kESChatMessageReadKey                       = @"messageRead";
NSString *const kESChatInviteUserMessage                       = @"Check out GasIt, the social network! Available here: https://itunes.apple.com/us/app/gasit/id659093855";
#pragma mark - Story Class

NSString *const kESStoryClassKey = @"Stories";

NSString *const kESStoryPictureKey         = @"image";
NSString *const kESStoryThumbnailKey       = @"thumbnail";
NSString *const kESStoryUserKey            = @"user";
NSString *const kESStoryLocationKey        = @"location";
NSString *const kESStoryOpenGraphIDKey     = @"fbOpenGraphID";
NSString *const kESStoryPopularPointsKey   = @"popularPoints";
NSString *const kESStoryExclusiveKey   = @"exclusive";

#pragma mark - Photo Class
// Class key
NSString *const kESPhotoClassKey = @"Photo";

// Field keys
NSString *const kESPhotoPictureKey         = @"image";
NSString *const kESPhotoThumbnailKey       = @"thumbnail";
NSString *const kESPhotoUserKey            = @"user";
NSString *const kESPhotoLocationKey        = @"location";
NSString *const kESPhotoOpenGraphIDKey     = @"fbOpenGraphID";
NSString *const kESPhotoPopularPointsKey   = @"popularsPoints";
NSString *const kESPhotoExclusiveKey   = @"exclusive";
NSString *const kESPhotoIsSponsored        = @"isSponsored";
NSString *const kESPhotoRepostKey           = @"repost";

#pragma mark - Cached Photo Attributes
// keys
NSString *const kESPhotoAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kESPhotoAttributesLikeCountKey            = @"likeCount";
NSString *const kESPhotoAttributesLikersKey               = @"likers";
NSString *const kESPhotoAttributesCommentCountKey         = @"commentCount";
NSString *const kESPhotoAttributesCommentersKey           = @"commenters";
NSString *const kESPhotoAttributesExclusiveKey            = @"exclusive";
NSString *const kESVideoOrPhotoTypeKey                             = @"type";
NSString *const kESVideoTypeKey                             = @"video";
NSString *const kESVideoFileKey                             = @"file";
NSString *const kESVideoFileThumbnailKey                    = @"videoThumbnail";
NSString *const kESVideoFileThumbnailRoundedKey           = @"videoThumbnailRound";


#pragma mark - Cached User Attributes
// keys
NSString *const kESUserAttributesPhotoCountKey                 = @"photoCount";
NSString *const kESUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";


#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey = @"alert";
NSString *const kAPNSBadgeKey = @"badge";
NSString *const kAPNSSoundKey = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kESPushPayloadPayloadTypeKey          = @"p";
NSString *const kESPushPayloadPayloadTypeActivityKey  = @"a";

NSString *const kESPushPayloadActivityTypeKey     = @"t";
NSString *const kESPushPayloadActivityLikeKey     = @"l";
NSString *const kESPushPayloadActivityCommentKey  = @"c";
NSString *const kESPushPayloadActivityFollowKey   = @"f";

NSString *const kESPushPayloadFromUserObjectIdKey = @"fu";
NSString *const kESPushPayloadToUserObjectIdKey   = @"tu";
NSString *const kESPushPayloadPhotoObjectIdKey    = @"pid";