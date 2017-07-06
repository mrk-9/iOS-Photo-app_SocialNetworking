//
//  ESPhotoDetailsFooterView.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

@interface ESPhotoDetailsFooterView : UIView
/**
 *  Textfield in which the comment is typed
 */
@property (nonatomic, strong) UITextField *commentField;
/**
 *  Wether we hide the shadow or not
 */
@property (nonatomic) BOOL hideDropShadow;
/**
 *  Container view of the header
 */
@property (nonatomic, strong) UIView *mainView;
/**
 *  Defining the size of the footer
 *
 *  @return size of the footer
 */
+ (CGRect)rectForView;

@end
