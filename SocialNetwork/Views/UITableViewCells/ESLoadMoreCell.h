//
//  ESLoadMoreCell.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

/**
 *  Interface of the LoadMoreCell, the cell that is displayed at the end of a page of queried results
 */
@interface ESLoadMoreCell : UITableViewCell
/**
 *  The containterview of the load more cell
 */
@property (nonatomic, strong) UIView *mainView;
/**
 *  Separator line at the top of the load more cell
 */
@property (nonatomic, strong) UIImageView *separatorImageTop;
/**
 *  Separator line at the bottom of the load more cell
 */
@property (nonatomic, strong) UIImageView *separatorImageBottom;
/**
 *  Actual image of the load more cell, currently a simple arrow pointing downwards
 */
@property (nonatomic, strong) UIImageView *loadMoreImageView;
/**
 *  YES if the top separator shall be hidden, NO if not
 */
@property (nonatomic, assign) BOOL hideSeparatorTop;
/**
 *  YES if the bottom separator shall be hidden, NO if not
 */
@property (nonatomic, assign) BOOL hideSeparatorBottom;
/**
 *  Inset of the cell
 */
@property (nonatomic) CGFloat cellInsetWidth;

@end
