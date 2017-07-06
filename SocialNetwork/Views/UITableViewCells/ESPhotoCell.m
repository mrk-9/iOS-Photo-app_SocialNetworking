//
//  ESPhotoCell.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESPhotoCell.h"
#import "ESUtility.h"

@implementation ESPhotoCell
@synthesize mediaItemButton, singleTap, doubleTap;

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        self.imageView.backgroundColor = [UIColor blackColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.mediaItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mediaItemButton.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        self.mediaItemButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.mediaItemButton];
        
        [self.contentView bringSubviewToFront:self.imageView];
        singleTap = [[UITapGestureRecognizer alloc] init];
        singleTap.numberOfTapsRequired = 1;
        [self.contentView addGestureRecognizer:singleTap];
        
        doubleTap = [[UITapGestureRecognizer alloc] init];
        doubleTap.numberOfTapsRequired = 2;
        [self.contentView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    self.mediaItemButton.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    
}

@end
