//
//  AudioPackage.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "AudioPackage.h"
#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "UIImage+JSQMessages.h"

@interface AudioPackage()
@property (strong, nonatomic) UIImageView *audioImg;
@end

@implementation AudioPackage

@synthesize audioImg;

- (instancetype)initWithFileURL:(NSURL *)fileURL Duration:(NSNumber *)duration {
	self = [super init];
	if (self) {
		_fileURL = [fileURL copy];
		_duration = duration;
		audioImg = nil;
	}
	return self;
}

- (void)dealloc {
	_fileURL = nil;
	audioImg = nil;
}

- (void)setFileURL:(NSURL *)fileURL {
	_fileURL = [fileURL copy];
	audioImg = nil;
}

- (void)setDuration:(NSNumber *)duration {
	_duration = duration;
	audioImg = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing {
	[super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
	audioImg = nil;
}

- (UIView *)mediaView {
	if (self.fileURL == nil) {
		return nil;
	}
	if (self.audioImg == nil) {
		CGSize size = CGSizeMake(140.0f, 40.0f);
		BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
		UIColor *colorBackground = outgoing ? MESSAGE_OUT_COLOUR : MESSAGE_IN_COLOUR;
		UIColor *colorContent = outgoing ? [UIColor whiteColor] : [UIColor grayColor];

		UIImage *playIcon = [[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:colorContent];
		UIImageView *iconView = [[UIImageView alloc] initWithImage:playIcon];
		CGFloat posY = (size.height- playIcon.size.height) / 2;
		CGFloat posX = outgoing ? posY : posY + 6;
		iconView.frame = CGRectMake(posX, posY, playIcon.size.width, playIcon.size.height);

		CGRect frame = outgoing ? CGRectMake(45, 10, 60, 20) : CGRectMake(51, 10, 60, 20);
		UILabel *label = [[UILabel alloc] initWithFrame:frame];
		label.textAlignment = NSTextAlignmentRight;
		label.textColor = colorContent;
		int min	= [self.duration intValue] / 60;
		int sec	= [self.duration intValue] % 60;
		label.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];

		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
		imageView.backgroundColor = colorBackground;
		imageView.clipsToBounds = YES;
		[imageView addSubview:iconView];
		[imageView addSubview:label];

		[JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:outgoing];
		self.audioImg = imageView;
	}
	return self.audioImg;
}
- (CGSize)mediaViewDisplaySize {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return CGSizeMake(140.0f, 40.0f);
    }
    return CGSizeMake(140.0f, 40.0f);
}
- (NSUInteger)mediaHash {
	return self.hash;
}

- (BOOL)isEqual:(id)object {
	if (![super isEqual:object]) {
		return NO;
	}

	AudioPackage *audioItem = (AudioPackage *)object;

	return [self.fileURL isEqual:audioItem.fileURL] && [self.duration isEqualToNumber:audioItem.duration];
}

- (NSUInteger)hash {
	return super.hash ^ self.fileURL.hash;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: fileURL=%@, duration=%@, appliesMediaViewMaskAsOutgoing=%@>",
			[self class], self.fileURL, self.duration, @(self.appliesMediaViewMaskAsOutgoing)];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		_fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
		_duration = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(duration))];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:self.fileURL forKey:NSStringFromSelector(@selector(fileURL))];
	[aCoder encodeObject:self.duration forKey:NSStringFromSelector(@selector(duration))];
}

- (instancetype)copyWithZone:(NSZone *)zone {
	AudioPackage *copy = [[[self class] allocWithZone:zone] initWithFileURL:self.fileURL Duration:self.duration];
	copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
	return copy;
}

@end
