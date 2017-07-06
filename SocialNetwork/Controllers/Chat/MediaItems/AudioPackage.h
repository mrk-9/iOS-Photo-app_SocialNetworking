//
//  AudioPackage.h
//  GasIT
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "JSQMediaItem.h"

@interface AudioPackage : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>
 
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSNumber *duration;

- (instancetype)initWithFileURL:(NSURL *)fileURL Duration:(NSNumber *)duration;

@end
