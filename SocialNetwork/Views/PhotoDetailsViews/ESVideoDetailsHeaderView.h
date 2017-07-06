//
//  ESVideoDetailsHeaderView.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 11.12.14.
//
//
#import <Parse/Parse.h>

#import <MediaPlayer/MediaPlayer.h>

@protocol ESVideoDetailsHeaderViewDelegate;

@interface ESVideoDetailsHeaderView : UIView

/*! @name Managing View Properties */

/// The photo displayed in the view
@property (nonatomic, strong, readonly) PFObject *video;
/**
 *  The MoviePlayerController in which the video is played
 */
@property (nonatomic, strong) MPMoviePlayerController *movie;
/**
 *  Button starting the video
 */
@property (nonatomic, strong) UIButton *playButton;

/// The user that took the photo
@property (nonatomic, strong, readonly) PFUser *photographer;

/// Array of the users that liked the photo
@property (nonatomic, strong) NSArray *likeUsers;
/**
 *  View with a clock image
 */
@property (nonatomic, strong) UIImageView *clockView;
/**
 *  View with the location in it
 */
@property (nonatomic, strong) UIImageView *locationView;

/// Heart-shaped like button
@property (nonatomic, strong, readonly) UIButton *likeButton;

/*! @name Delegate */
@property (nonatomic, strong) id<ESVideoDetailsHeaderViewDelegate> delegate;
/**
 *  Defining the frame of the headerview
 *
 *  @return frame of the header
 */
+ (CGRect)rectForView;
/**
 *  Init method of the header
 *
 *  @param frame  size of the header
 *  @param avideo the video we display in the viewcontroller
 *
 *  @return self
 */
- (id)initWithFrame:(CGRect)frame video:(PFObject*)avideo;
/**
 *  Init method of the header if we have a photographer and a likeUsers array
 *
 *  @param frame         Size of the header
 *  @param avideo        The actual video we display
 *  @param aPhotographer The user that took the video
 *  @param theLikeUsers  Array of users that liked the video
 *
 *  @return self
 */
- (id)initWithFrame:(CGRect)frame video:(PFObject*)avideo photographer:(PFUser*)aPhotographer likeUsers:(NSArray*)theLikeUsers;
/**
 *  Set the state of the like button
 *
 *  @param selected Returning YES if the button is set to liked, NO otherwise
 */
- (void)setLikeButtonState:(BOOL)selected;
/**
 *  Reloading the like in order to fetch new ones
 */
- (void)reloadLikeBar;


@end

/*!
 The protocol defines methods a delegate of a ESPhotoDetailsHeaderView should implement.
 */
@protocol ESVideoDetailsHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the photgrapher's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the photograper
 */
- (void)videoDetailsHeaderView:(ESVideoDetailsHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user;

@end