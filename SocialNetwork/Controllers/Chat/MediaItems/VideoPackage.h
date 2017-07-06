//
//  VideoPackage.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "JSQMediaItem.h"

@interface VideoPackage : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>
 
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, assign) BOOL rdyToPlay;

@property (copy, nonatomic) UIImage *img;

- (instancetype)initWithFileURL:(NSURL *)fileURL rdyToPlay:(BOOL)rdyToPlay;

@end
