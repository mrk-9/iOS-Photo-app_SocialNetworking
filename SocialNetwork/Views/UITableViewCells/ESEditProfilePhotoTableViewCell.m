//
//  ESEditProfilePhotoTableViewCell.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 10.11.14.
//
//

#import "ESEditProfilePhotoTableViewCell.h"

@implementation ESEditProfilePhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) layoutSubviews
{
    [super layoutSubviews];
    [[self textLabel] setFrame:CGRectMake(60,10,250,30)];
}
@end
