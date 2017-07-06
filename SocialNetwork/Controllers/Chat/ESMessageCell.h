//
//  ESMessageCell.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "JSBadgeView.h"

/**
 *  Interface of the ESMessageCell
 */
@interface ESMessageCell : UITableViewCell
{
    /**
     *  Message object, containing the chatroom Id, the users, their profile pictures and the last message.
     */
    NSDictionary *message;
}
/**
 *  Imageview containing the other user's profile picture.
 */
@property (strong, nonatomic) IBOutlet PFImageView *imgUser;
/**
 *  Usually the name of the user, could also be a group name if one implemented such a functionality.
 */
@property (strong, nonatomic) IBOutlet UILabel *description;
/**
 *  The last message that has been sent in the conversation.
 */
@property (strong, nonatomic) IBOutlet UILabel *lastMessage;
/**
 *  Time that has elapsed since the last message.
 */
@property (strong, nonatomic) IBOutlet UILabel *elapsed;
/**
 *  Small label indicating if the message has been delivered or sent.
 */
@property (strong, nonatomic) IBOutlet UILabel *readLabel;
/**
 *  A small badge we add to the profile picture of the user, indicating that there are unread messages.
 */
@property (strong, nonatomic) JSBadgeView *badgeView;
/**
 *  A dummyview used to show the badges
 */
@property (strong, nonatomic) UIView *dummyView;

/**
 *  Feeding the cell with the information it needs.
 *
 *  @param dummy_message Message object containg the needed information
 */
- (void)feedTheCell:(PFObject *)dummy_message;

@end
