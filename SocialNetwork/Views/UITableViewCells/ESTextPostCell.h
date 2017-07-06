//
//  ESTextPostCell.h
//  SocialNetwork
//
//  Created by Eric Schanet on 12.08.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KILabel.h"

@interface ESTextPostCell : UITableViewCell
@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic, strong) KILabel *postText;

@end
