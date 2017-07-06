//
//  ESPhotoDetailsHeaderView.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#import "ESPhotoDetailsHeaderView.h"
#import "ESProfileImageView.h"
#import "TTTTimeIntervalFormatter.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "ESAccountViewController.h"
#import "TOWebViewController.h"
#import "ESTravelTimeline.h"

#define baseHorizontalOffset 0.0f //10
#define baseWidth [UIScreen mainScreen].bounds.size.width //300

#define horizontalBorderSpacing 6.0f
#define horiMediumSpacing 8.0f

#define verticalBorderSpacing 6.0f
#define vertSmallSpacing 2.0f


#define nameHeaderX baseHorizontalOffset
#define nameHeaderY 0.0f
#define nameHeaderWidth baseWidth
#define nameHeaderHeight 46.0f

#define avatarImageX horizontalBorderSpacing
#define avatarImageY verticalBorderSpacing
#define avatarImageDim 35.0f

#define nameLabelX avatarImageX+avatarImageDim+horiMediumSpacing
#define nameLabelY avatarImageY+vertSmallSpacing
#define nameLabelMaxWidth 280.0f - (horizontalBorderSpacing+avatarImageDim+horiMediumSpacing+horizontalBorderSpacing)

#define timeLabelX nameLabelX
#define timeLabelMaxWidth nameLabelMaxWidth

#define mainImageX 0.0f //5
#define mainImageY nameHeaderHeight
#define mainImageWidth [UIScreen mainScreen].bounds.size.width //310
#define mainImageHeight [UIScreen mainScreen].bounds.size.width //310
#define mainTextHeight 80.0f //310

#define likeBarX baseHorizontalOffset
#define likeBarY nameHeaderHeight + mainImageHeight
#define likeBarYText nameHeaderHeight + mainTextHeight
#define likeBarWidth baseWidth
#define likeBarHeight 43.0f

#define likeButtonX 9.0f
#define likeButtonY 7.0f
#define likeButtonDim 28.0f

#define likeProfileXBase 46.0f
#define likeProfileXSpace 3.0f
#define likeProfileY 6.0f
#define likeProfileDim 30.0f

#define viewTotalHeight likeBarY+likeBarHeight
#define viewTotalHeightForTextPost nameHeaderHeight + mainTextHeight+likeBarHeight
#define numLikePics 7.0f

@interface ESPhotoDetailsHeaderView ()

// View components
@property (nonatomic, strong) UIView *nameHeaderView;
@property (nonatomic, strong) UIView *likeBarView;
@property (nonatomic, strong) NSMutableArray *currentLikeAvatars;

// Redeclare for edit
@property (nonatomic, strong, readwrite) PFUser *photographer;

// Private methods
- (void)createView;

@end


static TTTTimeIntervalFormatter *timeFormatter;

@implementation ESPhotoDetailsHeaderView

@synthesize photo;
@synthesize photographer;
@synthesize likeUsers;
@synthesize nameHeaderView;
@synthesize photoImageView;
@synthesize likeBarView;
@synthesize likeButton;
@synthesize delegate;
@synthesize currentLikeAvatars;
@synthesize clockView, locationView,photoImageViewButton;

#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame photo:(PFObject*)aPhoto {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        self.photo = aPhoto;
        if ([[aPhoto objectForKey:@"type"] isEqualToString:@"text"]) {
            
        }
        self.photographer = [self.photo objectForKey:kESPhotoUserKey];
        self.likeUsers = nil;
        
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame photo:(PFObject*)aPhoto photographer:(PFUser*)aPhotographer likeUsers:(NSArray*)theLikeUsers {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        self.photo = aPhoto;
        self.photographer = aPhotographer;
        self.likeUsers = theLikeUsers;
        
        self.backgroundColor = [UIColor clearColor];
        
        if (self.photo && self.photographer && self.likeUsers) {
            [self createView];
        }
        
    }
    return self;
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}


#pragma mark - ESPhotoDetailsHeaderView

+ (CGRect)rectForView {
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, viewTotalHeight);
}
+ (CGRect)rectForViewTextPost {
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, viewTotalHeightForTextPost);
}

- (void)setPhoto:(PFObject *)aPhoto {
    photo = aPhoto;
    
    if (self.photo && self.photographer && self.likeUsers) {
        [self createView];
        [self setNeedsDisplay];
    }
}

- (void)setLikeUsers:(NSMutableArray *)anArray {
    likeUsers = [anArray sortedArrayUsingComparator:^NSComparisonResult(PFUser *liker1, PFUser *liker2) {
        NSString *displayName1 = [liker1 objectForKey:kESUserDisplayNameKey];
        NSString *displayName2 = [liker2 objectForKey:kESUserDisplayNameKey];
        
        if ([[liker1 objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return NSOrderedAscending;
        } else if ([[liker2 objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return NSOrderedDescending;
        }
        
        return [displayName1 compare:displayName2 options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    }];;
    
    for (ESProfileImageView *image in currentLikeAvatars) {
        [image removeFromSuperview];
    }
    
    [likeButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.likeUsers.count] forState:UIControlStateNormal];
    
    self.currentLikeAvatars = [[NSMutableArray alloc] initWithCapacity:likeUsers.count];
    NSInteger i;
    NSInteger numOfPics = numLikePics > self.likeUsers.count ? self.likeUsers.count : numLikePics;
    
    for (i = 0; i < numOfPics; i++) {
        ESProfileImageView *profilePic = [[ESProfileImageView alloc] init];
        [profilePic setFrame:CGRectMake(likeProfileXBase + i * (likeProfileXSpace + likeProfileDim), likeProfileY, likeProfileDim, likeProfileDim)];
        [profilePic.profileButton addTarget:self action:@selector(didTapLikerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        profilePic.profileButton.tag = i;
        [profilePic setFile:[[self.likeUsers objectAtIndex:i] objectForKey:kESUserProfilePicSmallKey]];
        [likeBarView addSubview:profilePic];
        [currentLikeAvatars addObject:profilePic];
    }
    
    [self setNeedsDisplay];
}

- (void)setLikeButtonState:(BOOL)selected {
    if (selected) {
        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake( -1.0f, 0.0f, 0.0f, 0.0f)];
        [[likeButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
    } else {
        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 0.0f, 0.0f, 0.0f)];
        [[likeButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
    }
    [likeButton setSelected:selected];
}

- (void)reloadLikeBar {
    self.likeUsers = [[ESCache sharedCache] likersForPhoto:self.photo];
    [self setLikeButtonState:[[ESCache sharedCache] isPhotoLikedByCurrentUser:self.photo]];
    [likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - ()

- (void)createView {
    /*
     Create middle section of the header view; the image
     */
    self.photoImageView = [[PFImageView alloc] initWithFrame:CGRectMake(mainImageX, mainImageY, mainImageWidth, mainImageHeight)];
    self.photoImageView.image = [UIImage imageNamed:@"PlaceholderPhoto"];
    self.photoImageView.backgroundColor = [UIColor blackColor];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.photoImageViewButton = [[UIButton alloc]initWithFrame:self.photoImageView.frame];
    [self.photoImageViewButton addTarget:self action:@selector(didTapPhoto:) forControlEvents:UIControlEventTouchDown];
    
    clockView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockIcon"]];
    locationView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"locationIcon"]];
    
    PFFile *imageFile = [self.photo objectForKey:kESPhotoPictureKey];
    
    if (imageFile) {
        self.photoImageView.file = imageFile;
        [self.photoImageView loadInBackground];
    }
    if ([[self.photo objectForKey:@"type"] isEqualToString:@"text"]) {
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, mainImageY, mainImageWidth, 100)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        self.textlabel = [[KILabel alloc]initWithFrame:CGRectMake(mainImageX+10, mainImageY, mainImageWidth-20, 100)];
        self.textlabel.backgroundColor = [UIColor whiteColor];
        [self.textlabel setTextColor:[UIColor colorWithRed:55./255. green:55./255. blue:35./255. alpha:1.000]];
        [self.textlabel setTintColor:[UIColor colorWithRed:54.0f/255.0f green:86.0f/255.0f blue:133.0f/255.0f alpha:1.0f]];
        
        CGSize labelSize = [[self.photo objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                         constrainedToSize:self.textlabel.frame.size
                                                             lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat labelHeight = labelSize.height;
        self.textlabel.frame = CGRectMake(10, mainImageY, mainImageWidth-20, labelHeight+20);
        bgView.frame = CGRectMake(0, mainImageY, mainImageWidth, labelHeight+20);
        self.textlabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        self.textlabel.numberOfLines = 5;
        self.textlabel.textColor = [UIColor colorWithWhite:0.35 alpha:1];
        self.textlabel.text = [self.photo objectForKey:@"text"];
        [self addSubview:self.textlabel];
        
        
        self.textlabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.textlabel.layer.borderWidth = 1.0f;
        __unsafe_unretained typeof(self) weakSelf = self;
        self.textlabel.linkTapHandler = ^(KILinkType linkType, NSString *string, NSRange range) {
            if (linkType == KILinkTypeURL)
            {
                // Open URLs
                [weakSelf attemptOpenURL:[NSURL URLWithString:string]];
                NSLog(@"URL:%@",string);
            }
            else if (linkType == KILinkTypeHashtag) {
                NSString *str = [string stringByReplacingOccurrencesOfString:@"#"
                                                                  withString:@""];
                NSString *lowstr = [str lowercaseString];
                [weakSelf postNotificationWithString:lowstr];
            }
            else
            {
                NSString *mention = [string stringByReplacingOccurrencesOfString:@"@" withString: @""];
                
                [weakSelf postNotificationWithMentionString:mention];
            }
        };
    }
    else {
        [self addSubview:self.photoImageView];
        [self addSubview:self.photoImageViewButton];
    }
    
    
    /*
     Create top of header view with name and avatar
     */
    self.nameHeaderView = [[UIView alloc] initWithFrame:CGRectMake(nameHeaderX, nameHeaderY, nameHeaderWidth, nameHeaderHeight)];
    self.nameHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]];
    [self addSubview:self.nameHeaderView];
    
    CALayer *layer = self.nameHeaderView.layer;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.masksToBounds = NO;
    layer.shadowRadius = 1.0f;
    layer.shadowOffset = CGSizeMake( 0.0f, 2.0f);
    layer.shadowOpacity = 0.0f;
    layer.shouldRasterize = YES;
    
    layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake( 0.0f, self.nameHeaderView.frame.size.height - 4.0f, self.nameHeaderView.frame.size.width, 4.0f)].CGPath;
    
    // Load data for header
    [self.photographer fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        // Create avatar view
        ESProfileImageView *avatarImageView = [[ESProfileImageView alloc] initWithFrame:CGRectMake(avatarImageX, avatarImageY, avatarImageDim, avatarImageDim)];
        [avatarImageView setFile:[self.photographer objectForKey:kESUserProfilePicSmallKey]];
        [avatarImageView setBackgroundColor:[UIColor clearColor]];
        [avatarImageView setOpaque:NO];
        [avatarImageView.profileButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [nameHeaderView addSubview:avatarImageView];
        
        // Create name label
        NSString *nameString = [self.photographer objectForKey:kESUserDisplayNameKey];
        UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameHeaderView addSubview:userButton];
        [userButton setBackgroundColor:[UIColor clearColor]];
        [[userButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [userButton setTitle:nameString forState:UIControlStateNormal];
        [userButton setTitleColor:[UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [userButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [[userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
        [[userButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [userButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
        [userButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // we resize the button to fit the user's name to avoid having a huge touch area
        CGPoint userButtonPoint = CGPointMake(50.0f, 12.0f);
        if ([self.photo objectForKey:kESPhotoLocationKey]) {
            userButtonPoint = CGPointMake(50.0f, 6.0f);
        }
        CGFloat constrainWidth = self.nameHeaderView.bounds.size.width - (avatarImageView.bounds.origin.x + avatarImageView.bounds.size.width);
        CGSize constrainSize = CGSizeMake(constrainWidth, self.nameHeaderView.bounds.size.height - userButtonPoint.y*2.0f);
        CGSize userButtonSize = [userButton.titleLabel.text boundingRectWithSize:constrainSize
                                                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:userButton.titleLabel.font}
                                                                         context:nil].size;
        
        
        CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
        [userButton setFrame:userButtonFrame];
        
        // Create time label
        timeFormatter.usesAbbreviatedCalendarUnits = YES;
        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[self.photo createdAt]];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 12.0f, 40, 18.0f)];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [timeLabel setText:timeString];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [timeLabel setTextColor:[UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f]];
        [timeLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [timeLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameHeaderView addSubview:timeLabel];
        [self.nameHeaderView addSubview:clockView];
        [self.nameHeaderView addSubview:locationView];
        [clockView setFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width + 1, timeLabel.frame.origin.y + 3, 12, 12)];
        
        
        //Create Geolocation
        // geostamp
        UILabel *geostampLabel = [[UILabel alloc] init];
        [geostampLabel setTextColor:[UIColor colorWithRed:84.0f/255.0f green:84.0f/255.0f blue:84.0f/255.0f alpha:1.0f]];
        [geostampLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
        [geostampLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [geostampLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
        [geostampLabel setBackgroundColor:[UIColor clearColor]];
        CGRect geostampLabelFrame = CGRectMake(userButtonPoint.x + 14, userButtonPoint.y + userButtonFrame.size.height, 200, 18);
        [geostampLabel setFrame:geostampLabelFrame];
        
        if ([self.photo objectForKey:kESPhotoLocationKey]) {
            NSString *locality = [NSString stringWithFormat:@"%@",[self.photo objectForKey:kESPhotoLocationKey]];
            [geostampLabel setText:locality];
            [locationView setFrame:CGRectMake(userButtonPoint.x, geostampLabel.frame.origin.y+2, 12, 12)];
            locationView.hidden = NO;
        }
        else {
            [geostampLabel setText:@""];
            locationView.hidden = YES;
            
        }
        [self.nameHeaderView addSubview:geostampLabel];
        
        
        
        [self setNeedsDisplay];
    }];
    
    /*
     Create bottom section fo the header view; the likes
     */
    likeBarView = [[UIView alloc] initWithFrame:CGRectMake(likeBarX, likeBarY, likeBarWidth, likeBarHeight)];
    [likeBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
    [self addSubview:likeBarView];
    if ([[self.photo objectForKey:@"type"] isEqualToString:@"text"]) {
        CGSize labelSize = [[self.photo objectForKey:@"text"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:16]
                                                         constrainedToSize:self.textlabel.frame.size
                                                             lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat labelHeight = labelSize.height;
        
        likeBarView.frame = CGRectMake(likeBarX, nameHeaderHeight + labelHeight + 20, likeBarWidth, likeBarHeight);
    }
    
    // Create the heart-shaped like button
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setFrame:CGRectMake(likeButtonX, likeButtonY, likeButtonDim, likeButtonDim)];
    [likeButton setBackgroundColor:[UIColor clearColor]];
    [likeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [[likeButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [[likeButton titleLabel] setMinimumScaleFactor:0.8f];
    [[likeButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
    [[likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [likeButton setAdjustsImageWhenDisabled:NO];
    [likeButton setAdjustsImageWhenHighlighted:NO];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"ButtonLike.png"] forState:UIControlStateNormal];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"ButtonLikeSelected.png"] forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [likeBarView addSubview:likeButton];
    
    [self reloadLikeBar];
}

- (void)didTapLikePhotoButtonAction:(UIButton *)button {
    BOOL liked = !button.selected;
    [button removeTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setLikeButtonState:liked];
    
    NSArray *originalLikeUsersArray = [NSArray arrayWithArray:self.likeUsers];
    NSMutableSet *newLikeUsersSet = [NSMutableSet setWithCapacity:[self.likeUsers count]];
    
    for (PFUser *likeUser in self.likeUsers) {
        // add all current likeUsers BUT currentUser
        if (![[likeUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            [newLikeUsersSet addObject:likeUser];
        }
    }
    
    if (liked) {
        [[ESCache sharedCache] incrementLikerCountForPhoto:self.photo];
        [newLikeUsersSet addObject:[PFUser currentUser]];
    } else {
        [[ESCache sharedCache] decrementLikerCountForPhoto:self.photo];
    }
    
    [[ESCache sharedCache] setPhotoIsLikedByCurrentUser:self.photo liked:liked];
    
    [self setLikeUsers:[newLikeUsersSet allObjects]];
    
    if (liked) {
        if ([photo objectForKey:kESVideoFileKey]) {
            [ESUtility likeVideoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:NO];
                }
            }];
        }else if ([[photo objectForKey:@"type"] isEqualToString:@"text"]) {
            [ESUtility likePostInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:NO];
                }
            }];
        } else {
            [ESUtility likePhotoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:NO];
                }
            }];
        }
        
    } else {
        if ([photo objectForKey:kESVideoFileKey]) {
            [ESUtility unlikeVideoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:YES];
                }
            }];
        }else if ([[photo objectForKey:@"type"] isEqualToString:@"text"]) {
            [ESUtility unlikePhotoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:YES];
                }
            }];
        } else {
            [ESUtility unlikePhotoInBackground:self.photo block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:YES];
                }
            }];
            
        }
        
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:self.photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:liked] forKey:ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
}

- (void)didTapLikerButtonAction:(UIButton *)button {
    PFUser *user = [self.likeUsers objectAtIndex:button.tag];
    if (delegate && [delegate respondsToSelector:@selector(photoDetailsHeaderView:didTapUserButton:user:)]) {
        [delegate photoDetailsHeaderView:self didTapUserButton:button user:user];
    }
}
- (void)didTapPhoto:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(photoDetailsHeaderView:didTapPhotoButton:)]) {
        [delegate photoDetailsHeaderView:self didTapPhotoButton:button];
    }
}
- (void)didTapUserNameButtonAction:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(photoDetailsHeaderView:didTapUserButton:user:)]) {
        [delegate photoDetailsHeaderView:self didTapUserButton:button user:self.photographer];
    }
}

- (void)postNotificationWithString:(NSString *)notification //post notification method and logic
{
    /*--
     * Prefixing a notification name with a unique identifier,
     such as 'HT' for Hashtag, reduces the chances of a message name conflict.
     * Be sure to use a unique and description name for the dictionary's key.
     --*/
    
    NSString *notificationName = @"Hashtag";
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:notification forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}
- (void)postNotificationWithMentionString:(NSString *)notification //post notification method and logic
{
    /*--
     * Prefixing a notification name with a unique identifier,
     such as 'HT' for Hashtag, reduces the chances of a message name conflict.
     * Be sure to use a unique and description name for the dictionary's key.
     --*/
    
    NSString *notificationName = @"Mention";
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:notification forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}
- (void)postNotificationWithWebsiteString:(NSString *)notification //post notification method and logic
{
    /*--
     * Prefixing a notification name with a unique identifier,
     such as 'HT' for Hashtag, reduces the chances of a message name conflict.
     * Be sure to use a unique and description name for the dictionary's key.
     --*/
    
    NSString *notificationName = @"Website";
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:notification forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}
- (void)attemptOpenURL:(NSURL *)url
{
    [self postNotificationWithWebsiteString:[url absoluteString]];
    
}
@end
