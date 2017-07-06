//
//  ESSideTableViewCell.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 10.08.14.
//
//

#import "ESSideTableViewCell.h"

@implementation ESSideTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) layoutSubviews
{
    [super layoutSubviews];
    [[self textLabel] setFrame:CGRectMake(45,10,250,20)];
    [[self detailTextLabel] setFrame:CGRectMake(75,30,250,20)];
}

@end
