//
//  ESEditProfilePrivateTableViewCell.m
//  Netzwierk
//
//  Created by Eric Schanet on 28.02.15.
//
//

#import "ESEditProfilePrivateTableViewCell.h"

@implementation ESEditProfilePrivateTableViewCell

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
    [[self textLabel] setFrame:CGRectMake(10,15,140,20)];
    [[self detailTextLabel] setFrame:CGRectMake(150,15,250,20)];
}
@end
