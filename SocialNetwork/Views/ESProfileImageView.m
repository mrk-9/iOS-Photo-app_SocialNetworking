//
//  ESProfileImageView.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESProfileImageView.h"

@interface ESProfileImageView ()
/**
 *  Border around the profile picture
 */
@property (nonatomic, strong) UIImageView *borderImageview;
@end

@implementation ESProfileImageView

@synthesize borderImageview;
@synthesize profileImageView;
@synthesize profileButton;


#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.profileImageView = [[PFImageView alloc] initWithFrame:frame];
        [self addSubview:self.profileImageView];
        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.profileButton];
        
        if (frame.size.width < 35.0f) {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-29.png"]];
        } else if (frame.size.width < 43.0f) {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-35.png"]];
        } else {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowProfilePicture-43.png"]];
        }
        
        //[self addSubview:self.borderImageview];
    }
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.borderImageview];
    
    self.profileImageView.frame = CGRectMake( 1.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.borderImageview.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}


#pragma mark - ESProfileImageView

- (void)setFile:(PFFile *)file {
    if (!file) {
        return;
    }
    
    self.profileImageView.image = [UIImage imageNamed:@"AvatarPlaceholder.png"];
    self.profileImageView.file = file;
    [self.profileImageView loadInBackground];
}

@end
