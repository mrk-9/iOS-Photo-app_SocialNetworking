//
//  ESBaseTextCell.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#import "AppDelegate.h"
#import "ESBaseTextCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "ESProfileImageView.h"
#import "ESUtility.h"
#import "KILabel.h"
#import "ESHashtagTimelineViewController.h"
#import "TOWebViewController.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface ESBaseTextCell () {
    BOOL hideSeparator; // True if the separator shouldn't be shown
}

/* Private static helper to obtain the horizontal space left for name and content after taking the inset and image in consideration */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;
/**
 *  Setting the user to the cell
 *
 *  @param aUser PFUser of the actual user
 */
- (void)setUser:(PFUser *)aUser;
/**
 *  Inform the delegate that the userbutton has been tapped
 *
 *  @param sender id of the tapped button
 */
- (void)didTapUserButtonAction:(id)sender;
/**
 *  Inform the delegate that the reply button has been tapped
 *
 *  @param sender id of the tapped reply button
 */
- (void) didTapReplyButtonAction:(id)sender;
@end

@implementation ESBaseTextCell

@synthesize mainView;
@synthesize cellInsetWidth;
@synthesize avatarImageView;
@synthesize replyButton;
@synthesize avatarImageButton;
@synthesize nameButton;
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize separatorImage;
@synthesize delegate;
@synthesize user;
@synthesize clockView;

#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
            timeFormatter.usesAbbreviatedCalendarUnits = YES;
        }
        
        cellInsetWidth = 0.0f;
        hideSeparator = NO;
        self.clipsToBounds = YES;
        horizontalTextSpace =  [ESBaseTextCell horizontalTextSpaceForInsetWidth:cellInsetWidth];
        
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        
        mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        [mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
        
        self.avatarImageView = [[ESProfileImageView alloc] init];
        [self.avatarImageView setBackgroundColor:[UIColor clearColor]];
        [self.avatarImageView setOpaque:YES];
        [mainView addSubview:self.avatarImageView];
        
        self.contentLabel = [[KILabel alloc] init];
        [self.contentLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [self.contentLabel setTextColor:[UIColor colorWithRed:55./255. green:55./255. blue:35./255. alpha:1.000]];
        [self.contentLabel setTintColor:[UIColor colorWithRed:54.0f/255.0f green:86.0f/255.0f blue:133.0f/255.0f alpha:1.0f]];
        [self.contentLabel setNumberOfLines:0];
        [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [mainView addSubview:self.contentLabel];
        
        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nameButton setBackgroundColor:[UIColor clearColor]];
        [self.nameButton setTitleColor:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.nameButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:130.0f/255.0f blue:105.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [self.nameButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [self.nameButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        //[self.nameButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        //[self.nameButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateSelected];
        //[self.nameButton.titleLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
        [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:self.nameButton];
        
        self.replyButton = [[UIButton alloc]init];
        [self.replyButton setBackgroundColor:[UIColor clearColor]];
        [self.replyButton setTitleColor:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.replyButton setTitleColor:[UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [self.replyButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-light" size:10]];
        [self.replyButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.replyButton addTarget:self action:@selector(didTapReplyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:self.replyButton];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.timeLabel setFont:[UIFont boldSystemFontOfSize:11]];
        [self.timeLabel setTextColor:[UIColor grayColor]];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.70f]];
        [self.timeLabel setShadowOffset:CGSizeMake(0, 1)];
        [mainView addSubview:self.timeLabel];
        
        self.avatarImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.avatarImageButton setBackgroundColor:[UIColor clearColor]];
        [self.avatarImageButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [mainView addSubview:self.avatarImageButton];
        
        self.clockView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clockIcon"]];
        [mainView addSubview:self.clockView];
        
        
        self.separatorImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)]];
        //[mainView addSubview:separatorImage]; //mod:
        __unsafe_unretained typeof(self) weakSelf = self;
        self.contentLabel.linkTapHandler = ^(KILinkType linkType, NSString *string, NSRange range) {
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
        [self.contentView addSubview:mainView];
    }
    
    return self;
}
- (void)attemptOpenURL:(NSURL *)url
{
    [self postNotificationWithWebsiteString:[url absoluteString]];
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [mainView setFrame:CGRectMake(cellInsetWidth, self.contentView.frame.origin.y, self.contentView.frame.size.width-2*cellInsetWidth, self.contentView.frame.size.height)];
    
    // Layout avatar image
    [self.avatarImageView setFrame:CGRectMake(avatarX, avatarY, avatarDim, avatarDim)];
    [self.avatarImageButton setFrame:CGRectMake(avatarX, avatarY, avatarDim, avatarDim)];
    
    // Layout the name button
    CGSize nameSize = [self.nameButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                    options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                 attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                                    context:nil].size;
    [self.nameButton setFrame:CGRectMake(nameX, nameY, nameSize.width, nameSize.height)];
    
    // Layout the content
    CGSize contentSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                                              context:nil].size;
    [self.contentLabel setFrame:CGRectMake(nameX, vertTextBorderSpacing, contentSize.width, contentSize.height)];
    
    // Layout the timestamp label
    CGSize timeSize = [self.timeLabel.text boundingRectWithSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX)
                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}
                                                        context:nil].size;
    [self.timeLabel setFrame:CGRectMake(timeX, contentLabel.frame.origin.y + contentLabel.frame.size.height + vertElemSpacing, timeSize.width, timeSize.height)];
    [self.replyButton setTitle:NSLocalizedString(@" Reply", nil) forState:UIControlStateNormal];
    [self.replyButton setFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width + 8 , timeLabel.frame.origin.y, 80, 15)];
    [self.replyButton setImage:[UIImage imageNamed:@"IconArrow"] forState:UIControlStateNormal];
    [self.replyButton setImage:[UIImage imageNamed:@"IconArrow"] forState:UIControlStateSelected];
    
    
    // Layour separator
    [self.separatorImage setFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width-cellInsetWidth*2, 1)];
    [self.separatorImage setHidden:hideSeparator];
    
    [self.clockView setFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width, timeLabel.frame.origin.y+2, 10, 10)];
}

- (void)drawRect:(CGRect)rect {
    // Add a drop shadow in core graphics on the sides of the cell
    [super drawRect:rect];
    if (self.cellInsetWidth != 0) {
        [ESUtility drawSideDropShadowForRect:mainView.frame inContext:UIGraphicsGetCurrentContext()];
    }
}


#pragma mark - Delegate methods

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:(ESFindFriendsCell *)self didTapUserButton:self.user];
    }
}

- (void) didTapReplyButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapReplyButton:)]) {
        [self.delegate cell:self didTapReplyButton:self.user];
    }
}

#pragma mark - ESBaseTextCell

/* Static helper to get the height for a cell if it had the given name and content */
+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content {
    return [ESBaseTextCell heightForCellWithName:name contentString:content cellInsetWidth:0];
}

/* Static helper to get the height for a cell if it had the given name, content and horizontal inset */
+ (CGFloat)heightForCellWithName:(NSString *)name contentString:(NSString *)content cellInsetWidth:(CGFloat)cellInset {
    CGSize nameSize = [name boundingRectWithSize:nameSize
                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                         context:nil].size;
    
    NSString *paddedString = [ESBaseTextCell padString:content withFont:[UIFont systemFontOfSize:13] toWidth:nameSize.width];
    CGFloat horizontalTextSpace = [ESBaseTextCell horizontalTextSpaceForInsetWidth:cellInset];
    
    CGSize contentSize = [paddedString boundingRectWithSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                                    context:nil].size;
    
    CGFloat singleLineHeight = [@"test" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                                     context:nil].size.height;
    
    // Calculate the added height necessary for multiline text. Ensure value is not below 0.
    CGFloat multilineHeightAddition = (contentSize.height - singleLineHeight) > 0 ? (contentSize.height - singleLineHeight) : 0;
    
    return horiBorderSpacing + avatarDim + horiBorderSpacingBottom + multilineHeightAddition;
}

/* Static helper to obtain the horizontal space left for name and content after taking the inset and image in consideration */
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth {
    return ([UIScreen mainScreen].bounds.size.width-(insetWidth*2)) - (horiBorderSpacing+avatarDim+horiElemSpacing+horiBorderSpacing);
}

/* Static helper to pad a string with spaces to a given beginning offset */
+ (NSString *)padString:(NSString *)string withFont:(UIFont *)font toWidth:(CGFloat)width {
    // Find number of spaces to pad
    NSMutableString *paddedString = [[NSMutableString alloc] init];
    while (true) {
        [paddedString appendString:@" "];
        CGSize resultSize = [paddedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                       options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:font}
                                                       context:nil].size;
        if (resultSize.width >= width) {
            break;
        }
    }
    
    // Add final spaces to be ready for first word
    [paddedString appendString:[NSString stringWithFormat:@" %@",string]];
    return paddedString;
}
- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    // Set name button properties and avatar image
    if (![self.user objectForKey:kESUserProfilePicSmallKey]) {
        NSData* data = UIImageJPEGRepresentation([UIImage imageNamed:@"AvatarPlaceholder.png"], 0.5f);
        PFFile *imageFile = [PFFile fileWithName:@"AvatarPlaceholder.png" data:data];
        [self.avatarImageView setFile:imageFile];
    }
    else {
        [self.avatarImageView setFile:[self.user objectForKey:kESUserProfilePicSmallKey]];
        
    }    [self.nameButton setTitle:[self.user objectForKey:kESUserDisplayNameKey] forState:UIControlStateNormal];
    [self.nameButton setTitle:[self.user objectForKey:kESUserDisplayNameKey] forState:UIControlStateHighlighted];
    
    // If user is set after the contentText, we reset the content to include padding
    if (self.contentLabel.text) {
        [self setContentText:self.contentLabel.text];
    }
    [self setNeedsDisplay];
}

- (void)setContentText:(NSString *)contentString {
    // If we have a user we pad the content with spaces to make room for the name
    if (self.user) {
        CGSize nameSize = [self.nameButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                                        context:nil].size;
        NSString *paddedString = [ESBaseTextCell padString:contentString withFont:[UIFont systemFontOfSize:13] toWidth:nameSize.width];
        [self.contentLabel setText:paddedString];
    } else { // Otherwise we ignore the padding and we'll add it after we set the user
        [self.contentLabel setText:contentString];
    }
    [self setNeedsDisplay];
}

- (void)setDate:(NSDate *)date {
    // Set the label with a human readable time
    [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date]];
    [self setNeedsDisplay];
}

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    // Change the mainView's frame to be insetted by insetWidth and update the content text space
    cellInsetWidth = insetWidth;
    [mainView setFrame:CGRectMake(insetWidth, mainView.frame.origin.y, mainView.frame.size.width-2*insetWidth, mainView.frame.size.height)];
    horizontalTextSpace = [ESBaseTextCell horizontalTextSpaceForInsetWidth:insetWidth];
    [self setNeedsDisplay];
}

/* Since we remove the compile-time check for the delegate conforming to the protocol
 in order to allow inheritance, we add run-time checks. */
- (id<ESBaseTextCellDelegate>)delegate {
    return (id<ESBaseTextCellDelegate>)delegate;
}

- (void)setDelegate:(id<ESBaseTextCellDelegate>)aDelegate {
    if (delegate != aDelegate) {
        delegate = aDelegate;
    }
}

- (void)hideSeparator:(BOOL)hide {
    hideSeparator = hide;
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
