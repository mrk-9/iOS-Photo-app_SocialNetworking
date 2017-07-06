//
//  ESVideoDetailsHeaderView.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 11.12.14.
//
//
#import "ESVideoDetailsHeaderView.h"
#import "ESProfileImageView.h"
#import "TTTTimeIntervalFormatter.h"

#define baseHorizontalOffset 0.0f //10
#define baseWidth [UIScreen mainScreen].bounds.size.width //300

#define horiBorderSpacing 6.0f
#define horiMediumSpacing 8.0f

#define vertBorderSpacing 6.0f
#define vertSmallSpacing 2.0f


#define nameHeaderX baseHorizontalOffset
#define nameHeaderY 0.0f
#define nameHeaderWidth baseWidth
#define nameHeaderHeight 46.0f

#define avatarImageX horiBorderSpacing
#define avatarImageY vertBorderSpacing
#define avatarImageDim 35.0f

#define nameLabelX avatarImageX+avatarImageDim+horiMediumSpacing
#define nameLabelY avatarImageY+vertSmallSpacing
#define nameLabelMaxWidth 280.0f - (horiBorderSpacing+avatarImageDim+horiMediumSpacing+horiBorderSpacing)

#define timeLabelX nameLabelX
#define timeLabelMaxWidth nameLabelMaxWidth

#define mainImageX 0.0f //5
#define mainImageY nameHeaderHeight
#define mainImageWidth [UIScreen mainScreen].bounds.size.width
#define mainImageHeight [UIScreen mainScreen].bounds.size.width

#define likeBarX baseHorizontalOffset
#define likeBarY nameHeaderHeight + mainImageHeight
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
#define numLikePics 7.0f

@interface ESVideoDetailsHeaderView ()

/**
 *  Containerview for the profile picture and username
 */
@property (nonatomic, strong) UIView *nameHeaderView;
/**
 *  Imageview that contains the video
 */
@property (nonatomic, strong) PFImageView *videoImageView;
/**
 *  Containerview of the like button and profile picture of the user that liked the video
 */
@property (nonatomic, strong) UIView *likeBarView;
/**
 *  Array of profile pictures of users that liked the video
 */
@property (nonatomic, strong) NSMutableArray *currentLikeAvatars;
/**
 *  The user that uploaded the video
 */
@property (nonatomic, strong, readwrite) PFUser *photographer;

/**
 Responsible for creating the view and its subviews
 */
- (void)createView;
/**
 *  Method that is called when a user hits the like button
 *
 *  @param button the button that called the method
 */
- (void)didTapLikeVideoButtonAction:(UIButton *)button;

@end


static TTTTimeIntervalFormatter *timeFormatter;

@implementation ESVideoDetailsHeaderView

@synthesize video;
@synthesize photographer;
@synthesize likeUsers;
@synthesize nameHeaderView;
@synthesize videoImageView;
@synthesize likeBarView;
@synthesize likeButton;
@synthesize delegate;
@synthesize currentLikeAvatars;
@synthesize clockView,locationView;

#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame video:(PFObject*)avideo {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        video = avideo;
        self.photographer = [self.video objectForKey:kESPhotoUserKey];
        self.likeUsers = nil;
        
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame video:(PFObject*)avideo photographer:(PFUser*)aPhotographer likeUsers:(NSArray*)theLikeUsers {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        video = avideo;
        self.photographer = aPhotographer;
        self.likeUsers = (NSMutableArray *)theLikeUsers;
        
        self.backgroundColor = [UIColor clearColor];
        
        if (self.video && self.photographer && self.likeUsers) {
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

- (void)setvideo:(PFObject *)avideo {
    video = avideo;
    
    if (self.video && self.photographer && self.likeUsers) {
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
    self.likeUsers = (NSMutableArray *)[[ESCache sharedCache] likersForPhoto:self.video];
    [self setLikeButtonState:[[ESCache sharedCache] isPhotoLikedByCurrentUser:self.video]];
    [likeButton addTarget:self action:@selector(didTapLikeVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - ()

- (void)createView {
    /*
     Create middle section of the header view; the image
     */
    self.movie = [[MPMoviePlayerController alloc] init];
    self.movie.view.frame = CGRectMake(mainImageX, mainImageY, mainImageWidth, mainImageHeight);
    self.movie.controlStyle = MPMovieControlStyleEmbedded;
    self.movie.scalingMode = MPMovieScalingModeAspectFit;
    [self addSubview:self.movie.view];
    clockView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockIcon"]];
    locationView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"locationIcon"]];
    
    
    self.videoImageView = [[PFImageView alloc] initWithFrame:CGRectMake(mainImageX, mainImageY, mainImageWidth, mainImageHeight)];
    self.videoImageView.image = [UIImage imageNamed:@"PlaceholderPhoto"];
    self.videoImageView.backgroundColor = [UIColor blackColor];
    self.videoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    PFFile *imageFile = [self.video objectForKey:kESVideoFileThumbnailKey];
    
    if (imageFile) {
        self.videoImageView.file = imageFile;
        [self.videoImageView loadInBackground];
    }
    
    PFFile *_video =[self.video objectForKey:kESVideoFileKey];
    if (_video) {
        [_video getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.m4v"];
                [data writeToFile:appFile atomically:YES];
                NSURL *movieUrl = [NSURL fileURLWithPath:appFile];
                [self.movie setContentURL:movieUrl];
            }
        }];
    }
    
    [self addSubview:self.videoImageView];
    
    self.playButton = [[UIButton alloc]initWithFrame:CGRectMake(mainImageX, mainImageY, mainImageWidth, mainImageHeight)];
    [self.playButton addTarget:self action:@selector(tapPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton setImage:[UIImage imageNamed:@"play_alt-512.png"] forState:UIControlStateNormal];
    [self addSubview:self.playButton];
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
        if ([self.video objectForKey:kESPhotoLocationKey]) {
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
        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[self.video createdAt]];
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
        
        if ([self.video objectForKey:kESPhotoLocationKey]) {
            NSString *locality = [NSString stringWithFormat:@"%@",[self.video objectForKey:kESPhotoLocationKey]];
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
    [likeButton addTarget:self action:@selector(didTapLikeVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [likeBarView addSubview:likeButton];
    
    [self reloadLikeBar];
    
}

- (void)didTapLikeVideoButtonAction:(UIButton *)button {
    BOOL liked = !button.selected;
    [button removeTarget:self action:@selector(didTapLikeVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setLikeButtonState:liked];
    
    NSMutableArray *originalLikeUsersArray = [NSMutableArray arrayWithArray:self.likeUsers];
    NSMutableSet *newLikeUsersSet = [NSMutableSet setWithCapacity:[self.likeUsers count]];
    
    for (PFUser *likeUser in self.likeUsers) {
        // add all current likeUsers BUT currentUser
        if (![[likeUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            [newLikeUsersSet addObject:likeUser];
        }
    }
    
    if (liked) {
        [[ESCache sharedCache] incrementLikerCountForPhoto:self.video];
        [newLikeUsersSet addObject:[PFUser currentUser]];
    } else {
        [[ESCache sharedCache] decrementLikerCountForPhoto:self.video];
    }
    
    [[ESCache sharedCache] setPhotoIsLikedByCurrentUser:self.video liked:liked];
    
    [self setLikeUsers:(NSMutableArray *)[newLikeUsersSet allObjects]];
    
    if (liked) {
        if ([video objectForKey:kESVideoFileKey]) {
            [ESUtility likeVideoInBackground:self.video block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikeVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:NO];
                }
            }];
        } else {
            [ESUtility likePhotoInBackground:self.video block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikeVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:NO];
                }
            }];
        }
        
    } else {
        if ([video objectForKey:kESVideoFileKey]) {
            [ESUtility unlikeVideoInBackground:self.video block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikeVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:YES];
                }
            }];
        } else {
            [ESUtility unlikePhotoInBackground:self.video block:^(BOOL succeeded, NSError *error) {
                if (!succeeded) {
                    [button addTarget:self action:@selector(didTapLikeVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self setLikeUsers:originalLikeUsersArray];
                    [self setLikeButtonState:YES];
                }
            }];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification object:self.video userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:liked] forKey:ESPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
}

- (void)didTapLikerButtonAction:(UIButton *)button {
    PFUser *user = [self.likeUsers objectAtIndex:button.tag];
    if (delegate && [delegate respondsToSelector:@selector(videoDetailsHeaderView:didTapUserButton:user:)]) {
        [delegate videoDetailsHeaderView:self didTapUserButton:button user:user];
    }
}

- (void)didTapUserNameButtonAction:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(videoDetailsHeaderView:didTapUserButton:user:)]) {
        [delegate videoDetailsHeaderView:self didTapUserButton:button user:self.photographer];
    }
}
- (void) tapPlay {
    if (self.movie.playbackState != MPMoviePlaybackStatePlaying) {
        [self.videoImageView setHidden:YES];
        [self.playButton setHidden:YES];
        [self.movie prepareToPlay];
        [self.movie play];
    }
    
}
@end
