//
//  ESTextPostCell.m
//  SocialNetwork
//
//  Created by Eric Schanet on 12.08.15.
//  Copyright (c) 2015 Eric Schanet. All rights reserved.
//

#import "ESTextPostCell.h"
#import "TOWebViewController.h"

@implementation ESTextPostCell

@synthesize itemButton;

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 50);
        self.imageView.backgroundColor = [UIColor whiteColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.itemButton.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 50);
        self.itemButton.backgroundColor = [UIColor clearColor];
        
        self.postText = [[KILabel alloc]init];
        [self.postText setTextColor:[UIColor colorWithRed:55./255. green:55./255. blue:35./255. alpha:1.000]];
        [self.postText setTintColor:[UIColor colorWithRed:54.0f/255.0f green:86.0f/255.0f blue:133.0f/255.0f alpha:1.0f]];
        self.postText.frame = CGRectMake( 15.0f, 0.0f, [UIScreen mainScreen].bounds.size.width - 28, 50);
        self.postText.backgroundColor = [UIColor whiteColor];
        self.postText.textColor = [UIColor darkGrayColor];
        self.postText.numberOfLines = 5;
        self.postText.layer.borderColor = [UIColor whiteColor].CGColor;
        self.postText.layer.borderWidth = 1.0f;
        self.postText.font= [UIFont fontWithName:@"HelveticaNeue" size:15];
        
        [self.contentView addSubview:self.postText];
        [self.contentView addSubview:self.itemButton];
        [self.contentView bringSubviewToFront:self.imageView];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        self.postText.linkTapHandler = ^(KILinkType linkType, NSString *string, NSRange range) {
            if (linkType == KILinkTypeURL)
            {
                // Open URLs
                [weakSelf attemptOpenURL:[NSURL URLWithString:string]];
                NSLog(@"URL:%@",string);
            }
            else if (linkType == KILinkTypeHashtag) {
                NSString *str = [string stringByReplacingOccurrencesOfString:@"#"
                                                                  withString:@""];
                NSString *lowstr = [str lowercaseString];
                [weakSelf postNotificationWithString:lowstr];
            }
            else
            {
                NSString *mention = [string stringByReplacingOccurrencesOfString:@"@" withString: @""];
                
                [weakSelf postNotificationWithMentionString:mention];
            }
        };
    }
    
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 50);
    self.itemButton.frame = CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width,50);
    
}
- (void)attemptOpenURL:(NSURL *)url
{
    [self postNotificationWithWebsiteString:[url absoluteString]];
}
- (void)postNotificationWithString:(NSString *)notification //post notification method and logic
{
    /*--
     * Prefixing a notification name with a unique identifier,
     such as 'HT' for Hashtag, reduces the chances of a message name conflict.
     * Be sure to use a unique and description name for the dictionary's key.
     --*/
    
    NSString *notificationName = @"Hashtag";
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:notification forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}
- (void)postNotificationWithMentionString:(NSString *)notification //post notification method and logic
{
    /*--
     * Prefixing a notification name with a unique identifier,
     such as 'HT' for Hashtag, reduces the chances of a message name conflict.
     * Be sure to use a unique and description name for the dictionary's key.
     --*/
    
    NSString *notificationName = @"Mention";
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:notification forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}
- (void)postNotificationWithWebsiteString:(NSString *)notification //post notification method and logic
{
    /*--
     * Prefixing a notification name with a unique identifier,
     such as 'HT' for Hashtag, reduces the chances of a message name conflict.
     * Be sure to use a unique and description name for the dictionary's key.
     --*/
    
    NSString *notificationName = @"Website";
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:notification forKey:key];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
}
@end

