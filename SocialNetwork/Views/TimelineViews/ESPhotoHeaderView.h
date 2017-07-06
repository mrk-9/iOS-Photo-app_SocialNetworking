//
//  ESPhotoHeaderView.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Parse/Parse.h>
typedef enum {
    ESPhotoHeaderButtonsNone = 0,
    ESPhotoHeaderButtonsLike = 1 << 0,
    ESPhotoHeaderButtonsComment = 1 << 1,
    ESPhotoHeaderButtonsUser = 1 << 2,
    ESPhotoHeaderButtonsReport = 1 << 3,
    
    ESPhotoHeaderButtonsDefault = ESPhotoHeaderButtonsLike | ESPhotoHeaderButtonsComment | ESPhotoHeaderButtonsUser | ESPhotoHeaderButtonsReport
} ESPhotoHeaderButtons;

@protocol ESPhotoHeaderViewDelegate;

@interface ESPhotoHeaderView : UIView

/*! @name Creating Photo Header View */
/*!
 Initializes the view with the specified interaction elements.
 @param buttons A bitmask specifying the interaction elements which are enabled in the view
 */
- (id)initWithFrame:(CGRect)frame buttons:(ESPhotoHeaderButtons)otherButtons;

/// The photo associated with this view
@property (nonatomic,strong) PFObject *photo;

/// The bitmask which specifies the enabled interaction elements in the view
@property (nonatomic, readonly, assign) ESPhotoHeaderButtons buttons;

/*! @name Accessing Interaction Elements */

/// The Like Photo button
@property (nonatomic,readonly) UIButton *likeButton;

/// The Comment On Photo button
@property (nonatomic,readonly) UIButton *commentButton;

//A stylish clock icon for the timelabel
@property (nonatomic, readonly) UIImageView *clockView;
/**
 *  Container view of the location where the photo has been taken
 */
@property (nonatomic, readonly) UIImageView *locationView;

/*! @name Delegate */
@property (nonatomic,weak) id <ESPhotoHeaderViewDelegate> delegate;

/*! @name Modifying Interaction Elements Status */


@end


/*!
 The protocol defines methods a delegate of a ESPhotoHeaderView should implement.
 All methods of the protocol are optional.
 */
@protocol ESPhotoHeaderViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the user button is tapped
 @param user the PFUser associated with this button
 */
- (void)photoHeaderView:(ESPhotoHeaderView *)photoHeaderView didTapUserButton:(UIButton *)button user:(PFUser *)user;



@end