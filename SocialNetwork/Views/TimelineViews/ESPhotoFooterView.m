//
//  ESPhotoFooterView.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 17.06.14.
//
//

#import "ESPhotoFooterView.h"
#import "ESProfileImageView.h"
#import "TTTTimeIntervalFormatter.h"
#import "ESUtility.h"
#import "ESConstants.h"

#define N_BTN_WID   70.f
#define N_BTN_HEI   29.f

@interface ESPhotoFooterView ()
/**
 *  Containerview of the footer
 */
@property (nonatomic, strong) UIView *containerView2;
/**
 *  ImageView of the user's profile picture
 */
@property (nonatomic, strong) ESProfileImageView *avatarImageView;
/**
 *  Button with the username as title
 */
@property (nonatomic, strong) UIButton *userButton;
/**
 *  A timestamp indicating when the photo has been uploaded
 */
@property (nonatomic, strong) UILabel *timestampLabel;
/**
 *  Formatter used to create standardized time stamps
 */
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
@end


@implementation ESPhotoFooterView
@synthesize containerView2;
@synthesize avatarImageView;
@synthesize userButton;
@synthesize timestampLabel;
@synthesize timeIntervalFormatter;
@synthesize photo;
@synthesize buttons;
@synthesize likeButton;
@synthesize commentButton;
@synthesize repostButton;
@synthesize delegate;
@synthesize labelButton;
@synthesize labelComment;
@synthesize likeImage;
@synthesize commentImage;
@synthesize shareButton;
@synthesize commentLikeButton;
@synthesize exclusiveButton;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame buttons:(ESPhotoFooterButtons)otherButtons {
    self = [super initWithFrame:frame];
    if (self) {
        [ESPhotoFooterView validateButtons:otherButtons];
        buttons = otherButtons;
        
        self.clipsToBounds = NO;
        self.containerView2.clipsToBounds = NO;
        self.superview.clipsToBounds = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        
        // translucent portion
        self.containerView2 = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.containerView2];
        
        [self.containerView2 setOpaque:NO];
        self.opaque = NO;
        [self.containerView2 setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        self.superview.opaque = NO;
        
        UIImageView *containerImage = [[UIImageView alloc]initWithImage:nil];
        containerImage.backgroundColor = [UIColor whiteColor];
        [containerImage setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 84)];
        [self.containerView2 addSubview:containerImage];
        
        UIImageView *straightLine = [[UIImageView alloc]initWithImage:nil];
        straightLine.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:80.0f/255.0f blue:114.0f/255 alpha:1.0f];
        [straightLine setFrame:CGRectMake(5, 70, 310, 1)];
        straightLine.layer.cornerRadius = 3;
        straightLine.alpha = 0.0;
        [self.containerView2 addSubview:straightLine];
        
        UIButton *backgroundHeart = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, 30.0f, N_BTN_WID, N_BTN_HEI)];
        if (IS_IPHONE6) {
            backgroundHeart.frame = CGRectMake(15.f, 30.0f, N_BTN_WID, N_BTN_HEI);
        }
        [backgroundHeart setImage:[UIImage imageNamed:@"ButtonLike.png"] forState:UIControlStateNormal];
        backgroundHeart.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        backgroundHeart.layer.cornerRadius = 2;
        [containerView2 addSubview:backgroundHeart];
        backgroundHeart.userInteractionEnabled = NO;
        
        
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [containerView2 addSubview:self.shareButton];
        if (IS_IPHONE6) {
            [self.shareButton setFrame:CGRectMake( 15.f +(N_BTN_WID+15), 30.0f, N_BTN_WID, N_BTN_HEI)]; // 143
        }
        else {
            [self.shareButton setFrame:CGRectMake( 10+(N_BTN_WID+5), 30.0f, N_BTN_WID, N_BTN_HEI)]; // 115
        }
        [self.shareButton setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f]];
        [self.shareButton setImageEdgeInsets:UIEdgeInsetsMake(0.0f,0.0f, 0.0f, 0.0f)];
        [self.shareButton setImage:[UIImage imageNamed:@"ShareButton.png"] forState:UIControlStateNormal];
        [self.shareButton setSelected:NO];
        self.shareButton.layer.cornerRadius = 3;
        
        if (self.buttons & ESPhotoFooterButtonsComment) {
            
            commentButton = [self createLabelButton:@"" rect:CGRectMake( 10+(N_BTN_WID+5)*2, 30.0f, N_BTN_WID, N_BTN_HEI)];
            [containerView2 addSubview:commentButton];
            if (IS_IPHONE6) {
                [commentButton setFrame:CGRectMake( 15.f +(N_BTN_WID+15)*2, 30.0f, N_BTN_WID, N_BTN_HEI)]; // 256
            }
            [commentButton setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f]];
            commentButton.layer.cornerRadius = 3;
            [commentButton setImage:[UIImage imageNamed:@"IconComment.png"] forState:UIControlStateNormal];
            [commentButton setSelected:NO];
            
            labelComment = [self createLabelButton:NSLocalizedString(@"comments", nil) rect:CGRectMake( 138.0f, 0.0f, 80.0f, 29.0f)];
            [containerView2 addSubview:self.labelComment];
            labelComment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            commentImage = [self createLabelButton:@"0" rect:CGRectMake( 95.0f, 0.0f, 40.0f, 29.0f)];
            [containerView2 addSubview:commentImage];
            commentImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
        }
        
        if (self.buttons & ESPhotoFooterButtonsLike) {
            // like button
            UIImage *image = [UIImage imageNamed:@"ButtonLike.png"];
            UIImage *image2 = [UIImage imageNamed:@"ButtonLikeSelected.png"];
            
            
            likeButton = [self createLabelButton:@"" rect:CGRectMake(10.0f, 30.0f, N_BTN_WID, N_BTN_HEI)];
            [containerView2 addSubview:likeButton];
            if (IS_IPHONE6) {
                [self.likeButton setFrame:CGRectMake(30.0f, 30.0f, N_BTN_WID, N_BTN_HEI)];
            }
            [likeButton setImage:image forState:UIControlStateNormal];
            [likeButton setImage:image2 forState:UIControlStateSelected];
            [likeButton setSelected:NO];
            
            likeButton.tag = 3;
            
            
            labelButton = [self createLabelButton:NSLocalizedString(@"likes", nil) rect:CGRectMake(28.0f, 0.0f, 60.0f, 29.0f)];
            [containerView2 addSubview:labelButton];
            labelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [labelButton setSelected:NO];
            
            likeImage = [self createLabelButton:@"0" rect:CGRectMake(-15.0f, 0.0f, 40.0f, 29.0f)];
            [containerView2 addSubview:likeImage];
            likeImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            }
        
///////////
        if (self.buttons & ESPhotoFooterButtonsRepostButton) {
            repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [containerView2 addSubview:self.repostButton];
            if (IS_IPHONE6) {
                [self.repostButton setFrame:CGRectMake( 15.f +(N_BTN_WID+15)*3, 30.0f, N_BTN_WID, N_BTN_HEI)]; // 143
            } else {
                [self.repostButton setFrame:CGRectMake( 10+(N_BTN_WID+5)*3, 30.0f, N_BTN_WID, N_BTN_HEI)]; // 115
        }
            [self.repostButton setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f]];
            [self.repostButton setImageEdgeInsets:UIEdgeInsetsMake(0.0f,0.0f, 0.0f, 0.0f)];
            [self.repostButton setImage:[UIImage imageNamed:@"repost.png"] forState:UIControlStateNormal];
            [self.repostButton setSelected:NO];
            self.repostButton.layer.cornerRadius = 3;
        }
    /////////////////
        
        
        commentLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [containerView2 addSubview:self.commentLikeButton];
        [self.commentLikeButton setFrame:CGRectMake(10, 3, 140, 20)];
        [self.commentLikeButton setBackgroundColor:[UIColor clearColor]];
        [self.commentLikeButton addTarget:self action:@selector(didTapCommentOnPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.buttons & ESPhotoFooterButtonsExclusiveButton) {
            
            UIImage *image = [UIImage imageNamed:@"show1.png"];
            UIImage *image2 = [UIImage imageNamed:@"show0.png"];
            
            exclusiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [containerView2 addSubview:self.exclusiveButton];
            
            if (IS_IPHONE6) {
                [self.exclusiveButton setFrame:CGRectMake(360 - 50, 3, 40, 28)];
            }
            else {
                [self.exclusiveButton setFrame:CGRectMake(320-40, 3, 36, 28.0f)];
            }
            [self.exclusiveButton setTitle:@"" forState:UIControlStateNormal];
            [self.exclusiveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [self.exclusiveButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self.exclusiveButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateSelected];
            [self.exclusiveButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [self.exclusiveButton setImageEdgeInsets:UIEdgeInsetsMake(0.0f,0.0f, 0.0f, 0.0f)];
            [[self.exclusiveButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 0.0f)];
            [[self.exclusiveButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
            [[self.exclusiveButton titleLabel] setMinimumScaleFactor:0.8f];
            [[self.exclusiveButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
            [self.exclusiveButton setAdjustsImageWhenHighlighted:NO];
            [self.exclusiveButton setAdjustsImageWhenDisabled:NO];
            [self.exclusiveButton setImage:image forState:UIControlStateNormal];
            [self.exclusiveButton setImage:image2 forState:UIControlStateSelected];
            [self.exclusiveButton setSelected:YES];
        }
        
    }
    
    return self;
}

-(UIButton*) createLabelButton:(NSString*)title rect:(CGRect)rect {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:rect];
    
    [button setBackgroundColor:[UIColor clearColor]];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];

    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateSelected];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0f,0.0f, 0.0f, 0.0f)];
    
    UILabel* label = [button titleLabel];
    
    [label setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];

    [label setMinimumScaleFactor:0.8f];

    [label setAdjustsFontSizeToFitWidth:YES];

    [button setAdjustsImageWhenHighlighted:NO];

    [button setAdjustsImageWhenDisabled:NO];

    return button;
}


#pragma mark - ESPhotoFooterView

- (void)setPhoto:(PFObject *)aPhoto {
    
    photo = aPhoto;
    
    [self.shareButton addTarget:self action:@selector(didTapSharePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat constrainWidth = containerView2.bounds.size.width;
    
    if (self.buttons & ESPhotoFooterButtonsComment) {
        constrainWidth = self.commentButton.frame.origin.x;
        [self.commentButton addTarget:self action:@selector(didTapCommentOnPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.buttons & ESPhotoFooterButtonsLike) {
        constrainWidth = self.likeButton.frame.origin.x;
        [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    if (self.buttons & ESPhotoFooterButtonsExclusiveButton) {
        [self.exclusiveButton addTarget:self action:@selector(didTapExclusiveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    if (self.buttons & ESPhotoFooterButtonsRepostButton) {
        constrainWidth = self.repostButton.frame.origin.x;
        [self.repostButton addTarget:self action:@selector(didTapRepostPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    [self setNeedsDisplay];
}

- (void)setLikeStatus:(BOOL)liked {
    [self.likeButton setSelected:liked];
    
    if (liked) {
        //        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [[self.likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    } else {
        //        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [[self.likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    }
}

- (void)shouldEnableLikeButton:(BOOL)enable {
    
    if (enable) {
        [self.likeButton removeTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)shouldReEnableLikeButton:(NSNumber*)enable {
    
    if (enable == [NSNumber numberWithInt:1]) {
        self.likeButton.userInteractionEnabled = YES;
    } else {
        self.likeButton.userInteractionEnabled = NO;
    }
}


- (void)setExclusiveStatus:(BOOL)excl {
    [self.exclusiveButton setSelected:excl];
    
//    if (excl) {
//        //        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
//        [[self.likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, -1.0f)];
//    } else {
//        //        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
//        [[self.likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
//    }
}

- (void)shouldEnableRepostButton:(BOOL)enable {
    if (enable) {
        [self.repostButton removeTarget:self action:@selector(didTapRepostPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.repostButton addTarget:self action:@selector(didTapRepostPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)shouldReEnableRepostButton:(NSNumber*)enable {
    if (enable == [NSNumber numberWithInt:1]) {
        self.repostButton.userInteractionEnabled = YES;
    } else {
        self.repostButton.userInteractionEnabled = NO;
    }
}

#pragma mark - ()

+ (void)validateButtons:(ESPhotoFooterButtons)buttons {
    if (buttons == ESPhotoFooterButtonsNone) {
        [NSException raise:NSInvalidArgumentException format:@"Buttons must be set before initializing ESPhotoFooterView."];
    }
}

- (void)didTapLikePhotoButtonAction:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(photoFooterView:didTapLikePhotoButton:photo:)]) {
        [delegate photoFooterView:self didTapLikePhotoButton:button photo:self.photo];
    }
}

- (void)didTapCommentOnPhotoButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoFooterView:didTapCommentOnPhotoButton:photo:)]) {
        [delegate photoFooterView:self didTapCommentOnPhotoButton:sender photo:self.photo];
    }
}
- (void)didTapSharePhotoButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoFooterView:didTapSharePhotoButton:photo:)]) {
        [delegate photoFooterView:self didTapSharePhotoButton:sender photo:self.photo];
    }
}

- (void)didTapExclusiveButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoFooterView:didTapExclusiveButton:photo:)]) {
        [delegate photoFooterView:self didTapExclusiveButton:sender photo:self.photo];
    }
}

- (void)didTapRepostPhotoButtonAction:(UIButton *)button {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure to repost?" delegate:self
                                          cancelButtonTitle:@"Repost" otherButtonTitles:@"Cancel", nil];
    alert.tag = 1001;
    [alert show];
}


#pragma mark - UIAlertViewDelegate methods

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            if (delegate && [delegate respondsToSelector:@selector(photoFooterView:didTapRepostPhotoButton:photo:)]) {
                [delegate photoFooterView:self didTapRepostPhotoButton:self.repostButton photo:self.photo];
            }
        }
    }
}


@end

