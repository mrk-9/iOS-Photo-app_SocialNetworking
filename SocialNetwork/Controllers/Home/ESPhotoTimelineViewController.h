//
//  ESPhotoTimelineViewController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESPhotoHeaderView.h"
#import "ESPhotoFooterView.h"


@interface ESPhotoTimelineViewController : PFQueryTableViewController <ESPhotoHeaderViewDelegate,UITableViewDelegate,ESPhotoFooterViewDelegate>
/**
 *  Spinner wheel indicating if we're loading something or not.
 */
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
/**
 *  Defining if the timeline should be reloaded on appear.
 */
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
/**
 *  Mutable set of reusable section headers. We want to reuse them once they're out of view and not create a unnecessary huge number of them.
 */
@property (nonatomic, strong) NSMutableSet *reusableSectionHeaderViews;
/**
 *  Mutable set of reusable section footers. We want to reuse them once they're out of view and not create a unnecessary huge number of them.
 */
@property (nonatomic, strong) NSMutableSet *reusableSectionFooterViews;
/**
 *  Mutable dictionary of section header queries that are still outstanding.
 */
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionHeaderQueries;
/**
 *  Mutable dictionary of section footer queries that are still outstanding.
 */
@property (nonatomic, strong) NSMutableDictionary *outstandingSectionFooterQueries;
/**
 *  Mutable dictionary of followerqueries stil outstanding.
 */
@property (nonatomic, strong) NSMutableDictionary *outstandingFollowQueries;
/**
 *  Mutable dictionary of photo count queries still outstanding.
 */
@property (nonatomic, strong) NSMutableDictionary *outstandingCountQueries;
/**
 *  The style of the scroll indicator on the right side of the view
 */
@property(nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
/**
 *  Gesture recognizer used to recognize a single tap on a photo.
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapOnce;
/**
 *  Gesture recognizer used to recognize a double tap on a photo.
 *  Note: an instagram-like double tap like could be implemented here.
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapTwice;
/**
 *  Dequeueing a section header that is out of view and can be reused.
 *
 *  @return header that is out of view
 */
- (ESPhotoHeaderView *)dequeueReusableSectionHeaderView;
/**
 *  Dequeueing a section footer that is out of view and can be reused.
 *
 *  @return footer that is out of view
 */
- (ESPhotoFooterView *)dequeueReusableSectionFooterView;
/**
 *  We want to implement a section based timeline, thus we need to override this method to return the correct indexPath (esp. the correct section).
 *
 *  @param targetObject the targeted object in an array of PFObjects
 *
 *  @return new indexPath allowing us to create a section based timeline because the row is always set to 0
 */
- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject;
/**
 *  Dummy method used to play a video. We need to change some things before actually calling the tableview delegate method.
 *
 *  @param sender id of the tapped video button
 */
- (void) dummyTapForVideo:(id)sender;
/**
 *  User has liked or unliked a photo, thus the tableview should be updated.
 */
- (void)userDidLikeOrUnlikePhoto:(NSNotification *)note;
/**
 *  User has commented on a photo, thus the tableview should be updated.
 */
- (void)userDidCommentOnPhoto:(NSNotification *)note;
/**
 *  User deleted a photo, thus the tableview should be updated.
 */
- (void)userDidDeletePhoto:(NSNotification *)note;
/**
 *  User did publish a photo, thus the tableview should be updated.
 */
- (void)userDidPublishPhoto:(NSNotification *)note;
/**
 *  Following status change, thus the tableview should be updated
 */
- (void)userFollowingChanged:(NSNotification *)note;
/**
 *  Open the photo details viewcontroller as the users taps on a photo
 *
 *  @param sender id of the photo button used to open the correct detail viewcontroller
 */
- (void)didTapOnPhotoAction:(UIButton *)sender;
/**
 *  Posting notification to the notification center in order to communicate with other viewcontrollers
 *
 *  @param orientation the actual notification string
 */
- (void)postNotificationWithString:(NSString *)notif;
@end
