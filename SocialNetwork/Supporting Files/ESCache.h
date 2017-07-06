//
//  ESCache.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCache : NSObject
/**
 *  shared cache id
 */
+ (id)sharedCache;
/**
 *  Clear the cache
 */
- (void)clear;
/**
 *  Setting attributes for a specific photo
 *
 *  @param photo              PFObject of the photo
 *  @param likers             array of likers
 *  @param commenters         array of commenters
 *  @param likedByCurrentUser is the photo liked by the current user?
 */
- (void)setAttributesForPhoto:(PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;
/**
 *  Setting attributes for a specific photo
 *
 *  @param photo              PFObject of the photo
 *  @param likers             array of likers
 *  @param commenters         array of commenters
 *  @param likedByCurrentUser is the photo liked by the current user?
 *  @param exclusiev          exclusive of photo
 */
- (void)setAttributesForPhoto:(PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser exclusive:(BOOL)exclusive;
/**
 *  Get the attributes for a specific photo.
 *
 *  @param photo PFObject of the photo
 *
 *  @return dictionary of the attributes
 */
- (NSDictionary *)attributesForPhoto:(PFObject *)photo;
/**
 *  Get the exclusive for a photo.
 *
 *  @param photo PFObject of the photo
 *
 *  @return boolean of exclusive
 */
- (NSNumber *)exclusiveForPhoto:(PFObject *)photo;
/**
 *  Get the like count for a photo.
 *
 *  @param photo PFObject of the photo
 *
 *  @return number of likes
 */
- (NSNumber *)likeCountForPhoto:(PFObject *)photo;
/**
 *  Get the comment count for a photo.
 *
 *  @param photo PFObject of the photo
 *
 *  @return number of comments
 */
- (NSNumber *)commentCountForPhoto:(PFObject *)photo;
/**
 *  Get the users that have liked a photo
 *
 *  @param photo PFObject of the photo
 *
 *  @return array of users that liked the photo
 */
- (NSArray *)likersForPhoto:(PFObject *)photo;
/**
 *  Get the users that have commented on a photo
 *
 *  @param photo PFObject of the photo
 *
 *  @return array of users that commented on the photo
 */
- (NSArray *)commentersForPhoto:(PFObject *)photo;
/**
 *  Set the like state for a certain photo and the current user.
 *
 *  @param photo PFObject of the photo
 *  @param liked boolean of the like state
 */
- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked;
/**
 *  Decide if the photo is liked by the current user or not.
 *
 *  @param photo PFObject of the photo
 *
 *  @return boolean of the like state
 */
- (BOOL)isPhotoLikedByCurrentUser:(PFObject *)photo;
- (void)setPhoto:(PFObject *)photo exclusive:(BOOL)exclusive;
- (BOOL)exclusiveFromPhoto:(PFObject *)photo;
/**
 *  Increment the like count for a photo.
 *
 *  @param photo PFObject of the photo
 */
- (void)incrementLikerCountForPhoto:(PFObject *)photo;
/**
 *  Decrement the like count for a photo.
 *
 *  @param photo PFObject of the photo
 */
- (void)decrementLikerCountForPhoto:(PFObject *)photo;
/**
 *  Increment the comment count for a photo.
 *
 *  @param photo PFObject of the photo
 */
- (void)incrementCommentCountForPhoto:(PFObject *)photo;
/**
 *  Decrement the comment count for a photo.
 *
 *  @param photo PFObject of the photo
 */
- (void)decrementCommentCountForPhoto:(PFObject *)photo;
/**
 *  Get the attributes for a certain user.
 *
 *  @param user PFUser of the user we want the attributes from
 *
 *  @return dictionary of the attributes
 */
- (NSDictionary *)attributesForUser:(PFUser *)user;
/**
 *  Count the number of photos a certain user has uploaded.
 *
 *  @param user PFUser of the respective user
 *
 *  @return number of uploaded photos
 */
- (NSNumber *)photoCountForUser:(PFUser *)user;
/**
 *  Check the followstatus for a certain user
 *
 *  @param user PFUser of the respective user
 *
 *  @return boolean of the follow status
 */
- (BOOL)followStatusForUser:(PFUser *)user;
/**
 *  Set the photo count for a user
 *
 *  @param count number of uploaded photos
 *  @param user  PFUser of the user
 */
- (void)setPhotoCount:(NSNumber *)count user:(PFUser *)user;
/**
 *  Set the follow status for a certain user
 *
 *  @param following boolean of the follow status we should set
 *  @param user      PFUser of the user
 */
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;
/**
 *  Set the Facebook friends for a user.
 *
 *  @param friends array of Facebook friends
 */
- (void)setFacebookFriends:(NSArray *)friends;
/**
 *  Get the Facebook friends.
 *
 *  @return array of Facebook friends
 */
- (NSArray *)facebookFriends;
@end
