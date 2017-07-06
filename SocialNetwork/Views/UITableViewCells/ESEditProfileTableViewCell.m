//
//  ESEditProfileTableViewCell.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 10.11.14.
//
//

#import "ESEditProfileTableViewCell.h"

@implementation ESEditProfileTableViewCell

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
    [[self textLabel] setFrame:CGRectMake(10,15,80,20)];
    [[self detailTextLabel] setFrame:CGRectMake(90,15,250,20)];
}
@end
