//
//  ESVideoTableViewCell.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.12.14.
//
//

#import "ESVideoTableViewCell.h"

@implementation ESVideoTableViewCell
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
        
        self.movie = [[MPMoviePlayerController alloc] init];
        self.movie.controlStyle = MPMovieControlStyleEmbedded;
        self.movie.scalingMode = MPMovieScalingModeAspectFit;
        [self.contentView addSubview:self.movie.view];
        [self.contentView bringSubviewToFront:self.imageView];
        
        self.mediaItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mediaItemButton.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        self.mediaItemButton.backgroundColor = [UIColor clearColor];
        [self.mediaItemButton setImage:[UIImage imageNamed:@"play_alt-512.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.mediaItemButton];
        
    }
    
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    self.movie.view.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
}

@end
