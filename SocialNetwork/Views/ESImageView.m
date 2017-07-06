//
//  ESImageView.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESImageView.h"

@interface ESImageView ()
/**
 *  URL of the file
 */
@property (nonatomic, strong) NSString *url;

@end

@implementation ESImageView

@synthesize url;
@synthesize placeholderImage;

#pragma mark - ESImageView

- (void) setFile:(PFFile *)file {
    UIImageView *border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowsProfilePicture-43.png"]];
    [self addSubview:border];
    
    NSString *requestURL = file.url; // Save copy of url locally (will not change in block)
    [self setUrl:file.url]; // Save copy of url on the instance
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            if ([requestURL isEqualToString:self.url]) {
                [self setImage:image];
                [self setNeedsDisplay];
            }
        } else {
            NSLog(@"Error on fetching file");
        }
    }];
}

@end
