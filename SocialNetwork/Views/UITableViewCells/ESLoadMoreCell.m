//
//  ESLoadMoreCell.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)

#import "ESLoadMoreCell.h"
#import "ESUtility.h"

@implementation ESLoadMoreCell

@synthesize cellInsetWidth;
@synthesize mainView;
@synthesize separatorImageTop;
@synthesize separatorImageBottom;
@synthesize loadMoreImageView;
@synthesize hideSeparatorTop;
@synthesize hideSeparatorBottom;


#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.cellInsetWidth = 0.0f;
        hideSeparatorTop = NO;
        hideSeparatorBottom = NO;
        
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        
        mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        [mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
        
        self.loadMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellLoadMore.png"]];
        self.loadMoreImageView.frame = CGRectMake(0, 20, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        if (IS_IPHONE6) {
            self.loadMoreImageView.frame = CGRectMake(0, 20, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
            
        }
        [mainView addSubview:self.loadMoreImageView];
        
        self.separatorImageTop.backgroundColor = [UIColor whiteColor];
        self.separatorImageTop.tintColor = [UIColor whiteColor];
        self.separatorImageBottom.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, 0);
        
        [mainView addSubview:separatorImageTop];
        
        self.separatorImageBottom = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0.0f, 1.0f, 0.0f, 1.0f)]];
        [mainView addSubview:separatorImageBottom];
        
        [self.contentView addSubview:mainView];
    }
    
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [mainView setFrame:CGRectMake( self.cellInsetWidth, self.contentView.frame.origin.y, self.contentView.frame.size.width-2*self.cellInsetWidth, self.contentView.frame.size.height)];
    
    // Layout load more text
    [self.loadMoreImageView setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 90, 10.0f, 180.0f, 25.0f)];
    
    // Layout separator
    [self.separatorImageBottom setFrame:CGRectMake( 0.0f, self.frame.size.height - 2.0f, self.frame.size.width-self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageBottom setHidden:hideSeparatorBottom];
    
    [self.separatorImageTop setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - self.cellInsetWidth * 2.0f, 10.0f)];
    [self.separatorImageTop setHidden:hideSeparatorTop];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.cellInsetWidth != 0.0f) {
        [ESUtility drawSideDropShadowForRect:mainView.frame inContext:UIGraphicsGetCurrentContext()];
    }
}


#pragma mark - ESLoadMoreCell

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    cellInsetWidth = insetWidth;
    [mainView setFrame:CGRectMake( insetWidth, mainView.frame.origin.y, mainView.frame.size.width - 2.0f * insetWidth, mainView.frame.size.height)];
    [self setNeedsDisplay];
}

@end
