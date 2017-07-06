//
//  ESSettingsButtonItem.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

@interface ESSettingsButtonItem : UIBarButtonItem

/**
 *  Init method of the custom bar button
 *
 *  @param target target of the button
 *  @param action action that the button shall call
 *
 *  @return self
 */
- (id)initWithTarget:(id)target action:(SEL)action;

@end
