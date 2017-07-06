//
//  VideoPackage.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "VideoPackage.h"
#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "UIImage+JSQMessages.h"

@interface VideoPackage()

@property (strong, nonatomic) UIImageView *cachedVideoImageView;
@end
 
@implementation VideoPackage


- (instancetype)initWithFileURL:(NSURL *)fileURL rdyToPlay:(BOOL)rdyToPlay {
	self = [super init];
	if (self) {
		_fileURL = [fileURL copy];
		_rdyToPlay = rdyToPlay;
		_cachedVideoImageView = nil;
	}
	return self;
}

- (void)dealloc {
	_fileURL = nil;
	_cachedVideoImageView = nil;
}

- (void)setFileURL:(NSURL *)fileURL {
	_fileURL = [fileURL copy];
	_cachedVideoImageView = nil;
}

- (void)setrdyToPlay:(BOOL)rdyToPlay {
	_rdyToPlay = rdyToPlay;
	_cachedVideoImageView = nil;
}

- (void)setImage:(UIImage *)image {
	_img = [image copy];
	_cachedVideoImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing {
	[super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
	_cachedVideoImageView = nil;
}

- (UIView *)mediaView {
	if (self.fileURL == nil || !self.rdyToPlay) {
		return nil;
	}
	
	if (self.cachedVideoImageView == nil) {
		CGSize size = [self mediaViewDisplaySize];
		BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;

		UIImage *playIcon = [[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:[UIColor whiteColor]];
		UIImageView *iconView = [[UIImageView alloc] initWithImage:playIcon];
		iconView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
		iconView.contentMode = UIViewContentModeCenter;

		UIImageView *imageView = [[UIImageView alloc] initWithImage:self.img];
		imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		[imageView addSubview:iconView];

		[JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:outgoing];
		self.cachedVideoImageView = imageView;
	}
	
	return self.cachedVideoImageView;
}

- (NSUInteger)mediaHash {
	return self.hash;
}

- (BOOL)isEqual:(id)object {
	if (![super isEqual:object]) {
		return NO;
	}
	
	VideoPackage *videoItem = (VideoPackage *)object;
	
	return [self.fileURL isEqual:videoItem.fileURL] && self.rdyToPlay == videoItem.rdyToPlay;
}

- (NSUInteger)hash {
	return super.hash ^ self.fileURL.hash;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: fileURL=%@, rdyToPlay=%@, appliesMediaViewMaskAsOutgoing=%@>", [self class], self.fileURL, @(self.rdyToPlay), @(self.appliesMediaViewMaskAsOutgoing)];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		_fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
		_rdyToPlay = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(rdyToPlay))];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	[coder encodeObject:self.fileURL forKey:NSStringFromSelector(@selector(fileURL))];
	[coder encodeBool:self.rdyToPlay forKey:NSStringFromSelector(@selector(rdyToPlay))];
}


- (instancetype)copyWithZone:(NSZone *)zone {
	VideoPackage *copy = [[[self class] allocWithZone:zone] initWithFileURL:self.fileURL rdyToPlay:self.rdyToPlay];
	copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
	return copy;
}

@end
