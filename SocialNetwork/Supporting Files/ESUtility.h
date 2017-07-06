//
//  ESUtility.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//




//Now comes the utility for the feed - handling all the actions (like, comment, post) in the background...
@interface ESUtility : NSObject

/**
 *  Likes a photo in the background and gives a feedback via completion block.
 *
 *  @param photo           photo that should be liked
 *  @param completionBlock notifying that the photo has been liked
 */
+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)likePostInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 *  Likes a video in the background and gives a feedback via completion block.
 *
 *  @param photo           video that should be liked
 *  @param completionBlock notifying that the video has been liked
 */
+ (void)likeVideoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 *  Unlikes a photo in the background and gives a feedback via completion block.
 *
 *  @param photo           photo that should be unliked
 *  @param completionBlock notifying that the photo has been unliked
 */
+ (void)unlikePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unlikePostInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 *  Unlikes a video in the background and gives a feedback via completion block.
 *
 *  @param photo           video that should be unliked
 *  @param completionBlock notifying that the video has been unliked
 */
+ (void)unlikeVideoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;


/**
 *  Likes a photo in the background and gives a feedback via completion block.
 *
 *  @param photo           photo that should be liked
 *  @param completionBlock notifying that the photo has been liked
 */
+ (void)repostPhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 *  Processing the data of the Facebook profile picture. This method saves a rounded version of the Facebook profile picture on Parse.
 *
 *  @param data data of the profile picture
 */
+ (void)processProfilePictureData:(NSData *)data;

/**
 *  Checking if a user has a valid Facebook data.
 *
 *  @param user PFUser of the user we check for Facebook data
 *
 *  @return YES if the user has valid data, NO if not
 */
+ (BOOL)userHasValidFacebookData:(PFUser *)user;
/**
 *  Checking if a user has a valid profile picture data.
 *
 *  @param user PFUser of the user we check for profile picture
 *
 *  @return YES if the user has valid profile picture, NO if not
 */
+ (BOOL)userHasProfilePictures:(PFUser *)user;

/**
 *  Getting the first name of a user
 *
 *  @param displayName user's full name
 *
 *  @return first name
 */
+ (NSString *)firstNameForDisplayName:(NSString *)displayName;

/**
 *  Calculate the elapsed period for a given number of secons.
 *
 *  @param seconds time interval in secons
 *
 *  @return time interval in a certain format, not in secons but rather in minutes or hours or even days of weeks
 */
+ (NSString *)calculateElapsedPeriod:(NSTimeInterval)seconds;

/**
 *  Create a messenger conversation on Parse.
 *
 *  @param users array of users taking part of the conversation
 *
 *  @return groupId of the new conversation
 */
+ (NSString *)createConversation:(NSMutableArray *)users;

/**
 *  Get the duration of an audio message
 *
 *  @param path path of the audio message
 *
 *  @return nsnumber of the duration of the audio message
 */
+ (NSNumber *)durationAudioMessage:(NSString *)path;

/**
 *  Get the duration of an video message
 *
 *  @param path path of the video message
 *
 *  @return nsnumber of the duration of the video message
 */
+ (NSNumber *)durationForVideo:(NSURL *)video;

/**
 *  Creates a thumbnail image of the video. This image is used to display the video as long is it doesn't play.
 *
 *  @param video url of the video
 *
 *  @return thumbnail image
 */
+ (UIImage *)createThumbnailForVideo:(NSURL *)video;

/**
 *  Create a squared copy of a given image.
 *
 *  @param image image we need to square
 *  @param size  size of the square
 *
 *  @return squared image
 */
+ (UIImage *)createSquareImageForImage:(UIImage *)image withSize:(CGFloat)size;

/**
 *  Resize the image.
 *
 *  @param image  image we want to resize
 *  @param width  desired width
 *  @param height desired height
 *
 *  @return resized image
 */
+ (UIImage *)resizeImage:(UIImage *)image withWidth:(CGFloat)width andHeight:(CGFloat)height;
/**
 *  Crop image
 *
 *  @param image  image we want to crop
 *  @param x      x point where the crop begins
 *  @param y      y point where the crop begins
 *  @param width  width of the crop
 *  @param height height of the crop
 *
 *  @return cropped image
 */
+ (UIImage *)cropImage:(UIImage *)image withX:(CGFloat)x withY:(CGFloat)y withWidth:(CGFloat)width andHeight:(CGFloat)height;

/**
 *  Follow a user in the background.
 *
 *  @param user            user that should be followed in the backgroun
 *  @param completionBlock notifying that the user has been followed
 */
+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
 *  Follow a user eventually.
 *
 *  @param user            user that should be eventually followed
 *  @param completionBlock
 */
+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user;
+ (void)unfollowUsersEventually:(NSArray *)users;
+ (void)createConversationItemWitUser:(PFUser *)user groupId:(NSString *)groupId members:(NSArray *)members andDescription:(NSString *)description;

+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)addBottomDropShadowToNavigationBarForNavigationController:(UINavigationController *)navigationController;
+ (void)reportUser:(int)i withUser:(PFUser *)user andObject:(PFObject *)object;
+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy;
+ (PFQuery *)queryForActivitiesOnVideo:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy;
+ (PFQuery *)queryForActivitiesOnPost:(PFObject *)photo cachePolicy:(PFCachePolicy)cachePolicy;
+ (void)processHeaderPhotoWithData:(NSData *)newProfilePictureData;

+ (void)deliverPushTo:(NSString *)groupId withText:(NSString *)text;
+ (void)clearUnreadMessagesCounterFor:(NSString *)groupId;

+ (void)resetUnreadMessagesCounterFor:(NSString *)groupId withCounter:(NSInteger)amount andLastMessage:(NSString *)lastMessage;
+ (void)setReadForMessage:(NSString *)groupId andString:(NSString *)read;
+ (void)setDeliveredForMessage:(NSString *)groupId andString:(NSString *)read;
+ (BOOL)shouldPresentPhotoAndVideoCamera:(id)target editable:(BOOL)editable;
+ (BOOL)shouldPresentPhotoLibrary:(id)target editable:(BOOL)editable;
+ (BOOL)shouldPresentVideoLibrary:(id)target editable:(BOOL)editable;
@end

