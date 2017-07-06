//
//  ESPhotoHeaderView.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESPhotoHeaderView.h"
#import "ESProfileImageView.h"
#import "TTTTimeIntervalFormatter.h"
#import "ESUtility.h"

@interface ESPhotoHeaderView ()
/**
 *  Containing all the subviews of the header
 */
@property (nonatomic, strong) UIView *containerView;
/**
 *  Imageview of the profile picture
 */
@property (nonatomic, strong) ESProfileImageView *avatarImageView;
/**
 *  Button with the user's name as title. If a user taps on it, he is taken to the user's profile page
 */
@property (nonatomic, strong) UIButton *userButton;
/**
 *  Used to report a photo
 */
@property (nonatomic, strong) UIButton *reportButton;
/**
 *  Indicating when the photo has been taken
 */
@property (nonatomic, strong) UILabel *timestampLabel;
/**
 *  Indicating where the photo has been taken
 */
@property (nonatomic, strong) UILabel *geostampLabel;
/**
 *  Helping us to create the timeStampLabel
 */
@property (nonatomic, strong) TTTTimeIntervalFormatter *timeIntervalFormatter;
/**
 *  Sponsored badge
 */
@property (nonatomic, strong) UIImageView *sponsoredBadge;


@property (nonatomic, strong) UILabel *repostLabel;
@property (nonatomic, strong) UIImageView *repostImage;
@end


@implementation ESPhotoHeaderView
@synthesize containerView;
@synthesize avatarImageView;
@synthesize userButton;
@synthesize reportButton;
@synthesize timestampLabel, geostampLabel;
@synthesize timeIntervalFormatter;
@synthesize photo;
@synthesize buttons;
@synthesize likeButton;
@synthesize commentButton;
@synthesize delegate;
@synthesize clockView, locationView;
@synthesize sponsoredBadge;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame buttons:(ESPhotoHeaderButtons)otherButtons {
    self = [super initWithFrame:frame];
    if (self) {
        [ESPhotoHeaderView validateButtons:otherButtons];
        buttons = otherButtons;
        
        self.clipsToBounds = NO;
        self.containerView.clipsToBounds = NO;
        self.superview.clipsToBounds = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        
        // translucent portion
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.containerView];
        
        [self.containerView setOpaque:NO];
        self.opaque = NO;
        [self.containerView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        self.superview.opaque = NO;
        
        UIImageView *containerImage = [[UIImageView alloc]initWithImage:nil];
        containerImage.backgroundColor = [UIColor whiteColor];
        [containerImage setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        [self.containerView addSubview:containerImage];
        
        
        self.avatarImageView = [[ESProfileImageView alloc] init];
        self.avatarImageView.frame = CGRectMake( 3.0f, 3.0f, 38.0f, 38.0f);
        [self.avatarImageView.profileButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.avatarImageView];
        clockView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockIcon"]];
        locationView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"locationIcon"]];
        [self.containerView addSubview:clockView];
        [self.containerView addSubview:locationView];
        
        if (self.buttons & ESPhotoHeaderButtonsUser) {
            // This is the user's display name, on a button so that we can tap on it
            self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [containerView addSubview:self.userButton];
            [self.userButton setBackgroundColor:[UIColor clearColor]];
            [[self.userButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
            [self.userButton setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:55.0f/255.0f blue:45.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [self.userButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [[self.userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
            [[self.userButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
            [self.userButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
            
            sponsoredBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sponsoredBadge"]];

        }
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        self.timeIntervalFormatter.usesAbbreviatedCalendarUnits = YES;
        
        // timestamp
        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 68, 12.0f, 50, 18.0f)];
        self.timestampLabel.textAlignment = NSTextAlignmentRight;
        [containerView addSubview:self.timestampLabel];
        [self.timestampLabel setTextColor:[UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f]];
        [self.timestampLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [self.timestampLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.timestampLabel setFont:[UIFont systemFontOfSize:12]];
        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
        [clockView setFrame:CGRectMake(self.timestampLabel.frame.origin.x + self.timestampLabel.frame.size.width + 1, self.timestampLabel.frame.origin.y + 3, 12, 12)];
        
        // geostamp
        self.geostampLabel = [[UILabel alloc] init];
        [containerView addSubview:self.geostampLabel];
        [self.geostampLabel setTextColor:[UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f]];
        [self.geostampLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [self.geostampLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.geostampLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
        [self.geostampLabel setBackgroundColor:[UIColor clearColor]];
        
        _repostImage = nil;
        _repostLabel = nil;
        
    }
    
    return self;
}


#pragma mark - ESPhotoHeaderView

- (void)setPhoto:(PFObject *)aPhoto {
    
    photo = aPhoto;
    

    // user's avatar
    PFUser *user = [self.photo objectForKey:kESPhotoUserKey];
    PFFile *profilePictureSmall = [user objectForKey:kESUserProfilePicSmallKey];
    [self.avatarImageView setFile:profilePictureSmall];
    CGPoint userButtonPoint = CGPointMake(50.0f, 6.0f);
    NSString *authorName = [user objectForKey:kESUserDisplayNameKey];
    [self.userButton setTitle:authorName forState:UIControlStateNormal];
    
    if ([photo objectForKey:kESPhotoIsSponsored] == [NSNumber numberWithBool:YES]) {
        [self.containerView addSubview:sponsoredBadge];
    } else {
        [self.sponsoredBadge removeFromSuperview];
    }
    
    
    //check for timestamp
    if ([self.photo objectForKey:kESPhotoLocationKey]) {
        NSString *locality = [NSString stringWithFormat:@"%@", [self.photo objectForKey:kESPhotoLocationKey]];
        [self.geostampLabel setText:locality];
        locationView.hidden = NO;
        
    }
    else {
        [self.geostampLabel setText:@""];
        userButtonPoint = CGPointMake(50.0f, 11.0f);
        locationView.hidden = YES;
        
    }
    CGFloat constrainWidth = containerView.bounds.size.width;
    
    //associate the methods to the buttons
    if (self.buttons & ESPhotoHeaderButtonsUser) {
        [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // we resize the button to fit the user's name to avoid having a huge touch area
    constrainWidth -= userButtonPoint.x;
    CGSize constrainSize = CGSizeMake(constrainWidth, containerView.bounds.size.height - userButtonPoint.y*2.0f);
    
    CGSize userButtonSize = [self.userButton.titleLabel.text boundingRectWithSize:constrainSize
                                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:self.userButton.titleLabel.font}
                                                                          context:nil].size;
    
    CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
    CGRect geostampLabelFrame = CGRectMake(userButtonPoint.x+14, userButtonPoint.y + userButtonFrame.size.height, containerView.bounds.size.width - 50.0f - 72.0f, 18);
    [self.userButton setFrame:userButtonFrame];
    [self.geostampLabel setFrame:geostampLabelFrame];
    
    CGRect labelRect = [self.userButton.titleLabel.text boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:15] } context:nil];
    CGRect verifiedLabelFrame = CGRectMake(userButtonPoint.x + labelRect.size.width + 6, userButtonPoint.y-2, 22, 22);
    [self.sponsoredBadge setFrame:verifiedLabelFrame];

    [locationView setFrame:CGRectMake(userButtonPoint.x, self.geostampLabel.frame.origin.y+2, 12, 12)];
    
    NSTimeInterval timeInterval = [[self.photo createdAt] timeIntervalSinceNow];
    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
    [self.timestampLabel setText:timestamp];
    
    PFObject* repostObj = [photo objectForKey:kESPhotoRepostKey];
    if (repostObj != nil) {
        
        if (_repostLabel == nil) {
            _repostLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.f+28, 30, 120, 14)];
            [_repostLabel setTextColor:[UIColor colorWithRed:57/255.f green:105/255.f blue:232/255.f alpha:1.0]];
            [_repostLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
            [self.containerView addSubview:_repostLabel];
        }
        
        [_repostLabel setText:@"Reposted"];

        if (_repostImage == nil) {
            _repostImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"repost1"]];
            _repostImage.frame = CGRectMake(52.f, 31, 12, 12);
            [self.containerView addSubview:_repostImage];
        }

    } else {
        if (_repostLabel != nil) {
            [_repostLabel removeFromSuperview];
            _repostLabel = nil;
        }
        
        if (_repostImage != nil) {
            [_repostImage removeFromSuperview];
            _repostImage = nil;
        }
    }
    
    [self setNeedsDisplay];
}


#pragma mark - ()

+ (void)validateButtons:(ESPhotoHeaderButtons)buttons {
    if (buttons == ESPhotoHeaderButtonsNone) {
        [NSException raise:NSInvalidArgumentException format:@"Buttons must be set before initializing ESPhotoHeaderView."];
    }
}

- (void)didTapUserButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(photoHeaderView:didTapUserButton:user:)]) {
        [delegate photoHeaderView:self didTapUserButton:sender user:[self.photo objectForKey:kESPhotoUserKey]];
    }
}


@end
