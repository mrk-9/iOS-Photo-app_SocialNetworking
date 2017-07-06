//
//  ESBaseTextCell.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#import "KILabel.h"

@class ESProfileImageView;
@protocol ESBaseTextCellDelegate;

@interface ESBaseTextCell : UITableViewCell {
    NSUInteger horizontalTextSpace;
    id _delegate;
}

/*!
 Unfortunately, objective-c does not allow you to redefine the type of a property,
 so we cannot set the type of the delegate here. Doing so would mean that the subclass
 of would not be able to define new delegate methods (which we do in ESActivityCell).
 */
@property (nonatomic, strong) id delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;

/*! The cell's views. These shouldn't be modified but need to be exposed for the subclass */
@property (nonatomic, strong) UIView *mainView;
/**
 *  Button containing the name of the user
 */
@property (nonatomic, strong) UIButton *nameButton;
/**
 *  Button containing the profile picture of the user
 */
@property (nonatomic, strong) UIButton *avatarImageButton;
/**
 *  Button that is used when the ESBaseTextCell as comment cell. Allows us to directly reply to the user that left the comment.
 */
@property (nonatomic, strong) UIButton *replyButton;
/**
 *  Profile picture of the user
 */
@property (nonatomic, strong) ESProfileImageView *avatarImageView;
/**
 *  Containing the actual text of the item (comment, etc.)
 */
@property (nonatomic, strong) KILabel *contentLabel;
/**
 *  Indicating when the comment (activity, etc) has been posted
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  ImageView that separates two different cells
 */
@property (nonatomic, strong) UIImageView *separatorImage;
/**
 *  Stylish clockview to represent the notion of 'time'
 */
@property (nonatomic, strong) UIImageView *clockView;

/*! The horizontal inset of the cell */
@property (nonatomic) CGFloat cellInsetWidth;

/**
 *  Setting the content to the cell
 *
 *  @param contentString containing the actual content string
 */
- (void)setContentText:(NSString *)contentString;
/**
 *  Setting the date to the timelabel
 *
 *  @param date containing the actual date
 */
- (void)setDate:(NSDate *)date;
/**
 *  Setting the inset of the cell
 *
 *  @param insetWidth actual inset float
 */
- (void)setCellInsetWidth:(CGFloat)insetWidth;
/**
 *  Wether the separator should be hidden or not
 *
 *  @param hide YES for hidden, NO for unhidden
 */
- (void)hideSeparator:(BOOL)hide;

/**
 *  Get the height of a cell if it had a certain name and content
 *
 *  @param name    name of the user
 *  @param content actual content text
 *
 *  @return height of the cell
 */
+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content;
/**
 *  Get the height of a cell if it had a certain name, content and inset
 *
 *  @param name      name of the user
 *  @param content   actual content text
 *  @param cellInset inset of the cell
 *
 *  @return height of the cell
 */
+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content cellInsetWidth:(CGFloat)cellInset;
+ (NSString *)padString:(NSString *)string withFont:(UIFont *)font toWidth:(CGFloat)width;

@end

/*! Layout constants */
#define vertBorderSpacing 5.0f
#define vertElemSpacing 0.0f

#define horiBorderSpacing 3.0f
#define horiBorderSpacingBottom 9.0f
#define horiElemSpacing 5.0f

#define vertTextBorderSpacing 10.0f

#define avatarX horiBorderSpacing
#define avatarY vertBorderSpacing
#define avatarDim 40.0f

#define nameX avatarX+avatarDim+horiElemSpacing
#define nameY vertTextBorderSpacing
#define nameMaxWidth 200.0f

#define timeX avatarX+avatarDim+horiElemSpacing

/*!
 The protocol defines methods a delegate of a ESBaseTextCell should implement.
 */
@protocol ESBaseTextCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(ESBaseTextCell *)cellView didTapUserButton:(PFUser *)aUser;
/**
 *  Sent to the delegate when a reply button is tapped
 *
 *  @param cellView actual cellview
 *  @param aUser    the PFUser of the user that was tapped
 */
- (void)cell:(ESBaseTextCell *)cellView didTapReplyButton:(PFUser *)aUser;

@end

