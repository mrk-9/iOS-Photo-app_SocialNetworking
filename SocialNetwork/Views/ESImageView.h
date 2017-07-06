//
//  ESImageView.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
/**
 *  Interface of the ESImageView
 */
@interface ESImageView : UIImageView
/**
 *  Placeholder image in case no image from Parse is available
 */
@property (nonatomic, strong) UIImage *placeholderImage;
/**
 *  Setting an image to the view
 *
 *  @param file This is the PFFile of the image
 */
- (void) setFile:(PFFile *)file;

@end
