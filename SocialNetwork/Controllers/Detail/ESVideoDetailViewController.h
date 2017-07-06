//
//  ESVideoDetailViewController.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 11.12.14.
//
//
#import <Parse/Parse.h>
#import "ESVideoDetailsHeaderView.h"
#import "ESBaseTextCell.h"

/**
 *  Interface of the VideoDettailViewController, used to show a video and his likes and comments.
 */
@interface ESVideoDetailViewController : PFQueryTableViewController <UITextFieldDelegate, UIActionSheetDelegate, ESVideoDetailsHeaderViewDelegate, ESBaseTextCellDelegate, UIScrollViewDelegate>
{
    /**
     *  When the user wants to delete one of his comments, we have to call several methods and have to remember which comment (at which index) should be deleted.
     */
    NSIndexPath *savedIndexPath;
}
/**
 *  UITextField that lets the user enter his comment.
 */
@property (nonatomic, strong) UITextField *commentTextField;
/**
 *  Header view containing the photo as well as the photo header with the profile picture and the name of the user who uploaded the photo.
 */
@property (nonatomic, strong) ESVideoDetailsHeaderView *headerView;
/**
 *  YES when we are currently querying the likers of the photo, NO if not. We need to keep track of this in order to save time and resources.
 */
@property (nonatomic, assign) BOOL likersQueryInProgress;
/**
 *  PFObject of the photo the viewcontroller is all about.
 */
@property (nonatomic, strong) PFObject *video;
/**
 *  Custom init method
 *
 *  @param aPhoto the actual photo that we'll display in the viewcontroller.
 */
- (id)initWithPhoto:(PFObject*)aVideo;
/**
 *  RightBarButton has been tapped, showing a UIActionSheet where the user can choose wether he wants to report or share the photo.
 */
- (void)actionButtonAction:(id)sender;
/**
 *  After 8 seconds of inactivity, the comment isn't posted anymore because the connection failed or produced a timeout. We try to post it as soon as there is a stable connection again.
 */
- (void)handleCommentTimeout:(NSTimer *)aTimer;
/**
 *  A username of profile picture has been tapped, thus we should present the profile page of that respective user.
 *
 *  @param user PFUser of the user whose name or profile picture has been tapped
 */
- (void)shouldPresentAccountViewForUser:(PFUser *)user;
/**
 *  User wants to dismiss the photodetails viewcontroller, thus we dismiss it.
 */
- (void)backButtonAction:(id)sender;
/**
 *  The user has liked or unliked the photo, thus we should reload the likebar and display or remove his profile picture from it.
 */
- (void)userLikedOrUnlikedPhoto:(NSNotification *)note;
/**
 *  Load all the users that have liked the photo and display their profile pictures in the likebar.
 */
- (void)loadLikers;
/**
 *  Decides wether the current user owns the displayed photo or not.
 *
 *  @return YES if the current user owns the photo, NO else.
 */
- (BOOL)currentUserOwnsPhoto;
/**
 *  User owns the photo and wants to delete it, and that's what we do for him.
 */
- (void)shouldDeleteVideo;
/**
 *  The user does not own the photo and wants to report it, and that's what we do for him.
 */
- (void)shouldReportVideo;
@end
