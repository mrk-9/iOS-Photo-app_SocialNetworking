//
//  ESPhotoDetailsHeaderView.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Parse/Parse.h>
#import "KILabel.h"

@protocol ESPhotoDetailsHeaderViewDelegate;

@interface ESPhotoDetailsHeaderView : UIView

/*! @name Managing View Properties */

/// The photo displayed in the view
@property (nonatomic, strong, readonly) PFObject *photo;

/// The user that took the photo
@property (nonatomic, strong, readonly) PFUser *photographer;

/// Array of the users that liked the photo
@property (nonatomic, strong) NSArray *likeUsers;

/// Heart-shaped like button
@property (nonatomic, strong, readonly) UIButton *likeButton;
/**
 *  Imageview with a clock image
 */
@property (nonatomic, strong) UIImageView *clockView;
/**
 *  Imageview containing the location
 */
@property (nonatomic, strong) UIImageView *locationView;

/*! @name Delegate */
@property (nonatomic, strong) id<ESPhotoDetailsHeaderViewDelegate> delegate;
@property (nonatomic, strong) PFImageView *photoImageView;
@property (nonatomic, strong) UIButton *photoImageViewButton;
@property (nonatomic, strong) KILabel *textlabel;

+ (CGRect)rectForView;

+ (CGRect)rectForViewTextPost;
/**
 *  Init method of the header
 *
 *  @param frame  size of the header
 *  @param aPhoto the photo we display in the viewcontroller
 *
 *  @return self
 */
- (id)initWithFrame:(CGRect)frame photo:(PFObject*)aPhoto;
/**
 *  Init method of the header if we have a photographer and a likeUsers array
 *
 *  @param frame         Size of the header
 *  @param aPhoto        The actual photo we display
 *  @param aPhotographer The user that took the photo
 *  @param theLikeUsers  Array of users that liked the video
 *
 *  @return self
 */
- (id)initWithFrame:(CGRect)frame photo:(PFObject*)aPhoto photographer:(PFUser*)aPhotographer likeUsers:(NSArray*)theLikeUsers;
- (void) didTapPhoto:(id)target;


- (void)setLikeButtonState:(BOOL)selected;
- (void)reloadLikeBar;
@end

/*!
 The protocol defines methods a delegate of a ESPhotoDetailsHeaderView should implement.
 */
@protocol ESPhotoDetailsHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the photgrapher's name/avatar is tapped
 @param button the tapped UIButton
 @param user the PFUser for the photograper
 */
- (void)photoDetailsHeaderView:(ESPhotoDetailsHeaderView *)headerView didTapUserButton:(UIButton *)button user:(PFUser *)user;
- (void)photoDetailsHeaderView:(ESPhotoDetailsHeaderView *)headerView didTapPhotoButton:(UIButton *)button;
@end