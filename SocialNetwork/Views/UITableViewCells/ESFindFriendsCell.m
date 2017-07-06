//
//  ESFindFriendsCell.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESFindFriendsCell.h"
#import "ESProfileImageView.h"
#import "ESConstants.h"

@interface ESFindFriendsCell ()
/**
 *  Button containing the display name of a user
 */
@property (nonatomic, strong) UIButton *nameButton;
/**
 *  Button that is floating above the actual profile picture to catch taps
 */
@property (nonatomic, strong) UIButton *avatarImageButton;
/**
 *  Actual profile picture of a user, not sensitive to taps
 */
@property (nonatomic, strong) ESProfileImageView *avatarImageView;

@end


@implementation ESFindFriendsCell
@synthesize delegate;
@synthesize user;
@synthesize avatarImageView;
@synthesize avatarImageButton;
@synthesize nameButton;
@synthesize photoLabel;
@synthesize followButton;

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundFindFriendsCell.png"]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.avatarImageView = [[ESProfileImageView alloc] init];
        self.avatarImageView.frame = CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f);
        [self.contentView addSubview:self.avatarImageView];
        
        self.avatarImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.avatarImageButton.backgroundColor = [UIColor clearColor];
        self.avatarImageButton.frame = CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f);
        [self.avatarImageButton addTarget:self action:@selector(didTapUserButtonAction:)
                         forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarImageButton];
        
        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nameButton.backgroundColor = [UIColor clearColor];
        self.nameButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.nameButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.nameButton setTitleColor:[UIColor darkGrayColor]
                              forState:UIControlStateNormal];
        [self.nameButton setTitleColor:[UIColor lightGrayColor]
                              forState:UIControlStateHighlighted];
        [self.nameButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.nameButton];
        
        self.photoLabel = [[UILabel alloc] init];
        self.photoLabel.font = [UIFont systemFontOfSize:11.0f];
        self.photoLabel.textColor = [UIColor grayColor];
        self.photoLabel.backgroundColor = [UIColor clearColor];
        self.photoLabel.shadowOffset = CGSizeMake( 0.0f, 1.0f);
        [self.contentView addSubview:self.photoLabel];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.followButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.followButton.titleEdgeInsets = UIEdgeInsetsMake( 0.0f, 10.0f, 0.0f, 0.0f);
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"ButtonFollow.png"]
                                     forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"ButtonFollowing.png"]
                                     forState:UIControlStateSelected];
        [self.followButton setImage:[UIImage imageNamed:@"IconTick.png"]
                           forState:UIControlStateSelected];
        [self.followButton setTitle:NSLocalizedString(@"Follow  ", @"Follow string, with spaces added for centering")
                           forState:UIControlStateNormal];
        [self.followButton setTitle:@"Following"
                           forState:UIControlStateSelected];
        [self.followButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateSelected];
        [self.followButton setTitleShadowColor:[UIColor clearColor]
                                      forState:UIControlStateNormal];
        [self.followButton setTitleShadowColor:[UIColor clearColor]
                                      forState:UIControlStateSelected];
        self.followButton.titleLabel.shadowOffset = CGSizeMake( 0.0f, -1.0f);
        
        [self.followButton addTarget:self action:@selector(didTapFollowButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.followButton];
    }
    return self;
}


#pragma mark - ESFindFriendsCell

- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    // Configure the cell
    if (![self.user objectForKey:kESUserProfilePicSmallKey]) {
        NSData* data = UIImageJPEGRepresentation([UIImage imageNamed:@"AvatarPlaceholder.png"], 0.5f);
        PFFile *imageFile = [PFFile fileWithName:@"AvatarPlaceholder.png" data:data];
        [self.avatarImageView setFile:imageFile];
    }
    else {
        [self.avatarImageView setFile:[self.user objectForKey:kESUserProfilePicSmallKey]];
        
    }
    
    // Set name
    NSString *nameString = [self.user objectForKey:kESUserDisplayNameKey];
    
    CGSize nameSize = [nameString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f]}
                                               context:nil].size;
    [nameButton setTitle:[self.user objectForKey:kESUserDisplayNameKey] forState:UIControlStateNormal];
    [nameButton setTitle:[self.user objectForKey:kESUserDisplayNameKey] forState:UIControlStateHighlighted];
    
    [nameButton setFrame:CGRectMake( 60.0f, 22.0f, nameSize.width, nameSize.height)];
    
    // Set photo number label
    CGSize photoLabelSize = [@"photos" boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, CGFLOAT_MAX)
                                                    options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}
                                                    context:nil].size;
    [photoLabel setFrame:CGRectMake( 60.0f, 17.0f + nameSize.height, 140.0f, photoLabelSize.height)];
    
    // Set follow button
    [followButton setFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 120, 20.0f, 103.0f, 32.0f)];
}

#pragma mark - ()

+ (CGFloat)heightForCell {
    return 67.0f;
}

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}

/* Inform delegate that the follow button was tapped */
- (void)didTapFollowButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapFollowButton:)]) {
        [self.delegate cell:self didTapFollowButton:self.user];
    }
}

@end
