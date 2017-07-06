//
//  ESPhotoFooterView.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 17.06.14.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>


typedef enum {
    ESPhotoFooterButtonsNone = 0,
    ESPhotoFooterButtonsLike = 1 << 0,
    ESPhotoFooterButtonsComment = 1 << 1,
    ESPhotoFooterButtonsUser = 1 << 2,
    ESPhotoFooterButtonsLabel = 1 << 3,
    ESPhotoFooterButtonsLabelComment = 1 << 4,
    ESPhotoFooterButtonsLikeImage = 1 << 5,
    ESPhotoFooterButtonsCommentImage = 1 << 6,
    ESPhotoFooterButtonsShareButton = 1 << 7,
    ESPhotoFooterButtonsCommentLikeButton = 1 << 8,
    ESPhotoFooterButtonsExclusiveButton = 1 << 9,
    ESPhotoFooterButtonsRepostButton = 1 << 10,
    
    ESPhotoFooterButtonsDefault = ESPhotoFooterButtonsLike | ESPhotoFooterButtonsComment | ESPhotoFooterButtonsUser | ESPhotoFooterButtonsLabel | ESPhotoFooterButtonsLabelComment | ESPhotoFooterButtonsCommentImage | ESPhotoFooterButtonsLikeImage | ESPhotoFooterButtonsShareButton | ESPhotoFooterButtonsCommentLikeButton,
    ESPhotoFooterButtonsDefault1 = ESPhotoFooterButtonsDefault | ESPhotoFooterButtonsExclusiveButton,
    ESPhotoFooterButtonsDefault2 = ESPhotoFooterButtonsDefault | ESPhotoFooterButtonsRepostButton
} ESPhotoFooterButtons;

@protocol ESPhotoFooterViewDelegate;

@interface ESPhotoFooterView : UIView

/*! @name Creating Photo Footer View */
/*!
 Initializes the view with the specified interaction elements.
 @param buttons A bitmask specifying the interaction elements which are enabled in the view
 */
- (id)initWithFrame:(CGRect)frame buttons:(ESPhotoFooterButtons)otherButtons;

/// The photo associated with this view
@property (nonatomic,strong) PFObject *photo;

/// The bitmask which specifies the enabled interaction elements in the view
@property (nonatomic, readonly, assign) ESPhotoFooterButtons buttons;

/*! @name Accessing Interaction Elements */

/// The Like Photo button
@property (nonatomic,readonly) UIButton *likeButton;

/// The Comment label Photo button
@property (nonatomic,readonly) UIButton *labelComment;

/// The Like Label Photo button
@property (nonatomic,readonly) UIButton *labelButton;

/// The Comment On Photo button
@property (nonatomic,readonly) UIButton *commentButton;
/**
 *  Button where the number of likes are displayed. It is in fact a simple label that should take the user to the likes and comments when tapped.
 */
@property (nonatomic,readonly) UIButton *likeImage;
/**
 *  Button where the number of comments are displayed. It is in fact a simple label that should take the user to the likes and comments when tapped.
 */
@property (nonatomic,readonly) UIButton *commentImage;
/**
 *  Share button
 */
@property (nonatomic,readonly) UIButton *shareButton;
/**
 *  Actual button above the likeImage and commentImage. Takes the user to the detail view of the photo if tapped.
 */
@property (nonatomic,readonly) UIButton *commentLikeButton;
/**
 *  Exclusive button
 */
@property (nonatomic,readonly) UIButton *exclusiveButton;

/// The RePost Photo button
@property (nonatomic,readonly) UIButton *repostButton;

/*! @name Delegate */
@property (nonatomic,weak) id <ESPhotoFooterViewDelegate> delegate;

/*! @name Modifying Interaction Elements Status */

/*!
 Configures the Like Button to match the given like status.
 @param liked a BOOL indicating if the associated photo is liked by the user
 */
- (void)setLikeStatus:(BOOL)liked;
- (void)setExclusiveStatus:(BOOL)excl;

/*!
 Enable the like button to start receiving actions.
 @param enable a BOOL indicating if the like button should be enabled.
 */
- (void)shouldEnableLikeButton:(BOOL)enable;
/**
 *  We disable the like button after it has been hit, preventing multiple hits overloading the connection. This method reenables the button again.
 *
 *  @param enable used to identify the respective like button
 */
- (void)shouldReEnableLikeButton:(NSNumber*)enable;
/**
 *  Setting a photo in the profile picture imageview
 *
 *  @param aPhoto the profile picture photo
 */
- (void)setPhoto:(PFObject *)aPhoto;


- (void)shouldEnableRepostButton:(BOOL)enable;
- (void)shouldReEnableRepostButton:(NSNumber*)enable;
@end


/*!
 The protocol defines methods a delegate of a ESPhotoFooterView should implement.
 All methods of the protocol are optional.
 */
@protocol ESPhotoFooterViewDelegate <NSObject>
@optional


/*!
 Sent to the delegate when the like photo button is tapped
 @param photo the PFObject for the photo that is being liked or disliked
 */
- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapLikePhotoButton:(UIButton *)button photo:(PFObject *)photo;

/*!
 Sent to the delegate when the comment on photo button is tapped
 @param photo the PFObject for the photo that will be commented on
 */
- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapCommentOnPhotoButton:(UIButton *)button photo:(PFObject *)photo;
/**
 *  Sent to the delegate when the share button is tapped
 *
 *  @param photoFooterView the photoFooterView where the like button is in
 *  @param button          the actual like button
 *  @param photo           the photo the user wants to share
 */
- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapSharePhotoButton:(UIButton *)button photo:(PFObject *)photo;

/*!
 Sent to the delegate when the exclusive button is tapped
 @param photo the PFObject for the photo that is being showed or hidden to
 */
- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapExclusiveButton:(UIButton *)button photo:(PFObject *)photo;
/**
 *  Sent to the delegate when the repost button is tapped
 *
 *  @param photoFooterView the photoFooterView where the like button is in
 *  @param button          the actual like button
 *  @param photo           the photo the user wants to share
 */
- (void)photoFooterView:(ESPhotoFooterView *)photoFooterView didTapRepostPhotoButton:(UIButton *)button photo:(PFObject *)photo;

@end