//
//  ESConversationViewController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESSelectRecipientsViewController.h"
#import "ESPhoneContacts.h"

/**
 *  Interface of the ESConversationviewcontroller
 */
@interface ESConversationViewController : UITableViewController <UIActionSheetDelegate, ESSelectContactsDelegate, ESPhoneContactsDelegate>
{
    /**
     *  Mutable array containing the conversations of the user.
     */
    NSMutableArray *conversations;
    Firebase *firebase;
    
}
/**
 *  Load all the available conversations of the user.
 */
- (void)loadChatRooms;
/**
 *  Create a new conversation.
 */
- (void)composeNewMessage;
/**
 *  User has selected one or multiple recipients
 *
 *  @param users selected user(s)
 */
- (void)selectedRecipients:(NSMutableArray *)users;
/**
 *  User has selected an registered user from his contacts.
 *
 *  @param secondUser registered PFUser
 */
- (void)selectedFromContacts:(PFUser *)secondUser;
/**
 *  Update the red badge in the tabbar, indicating how many messages haven't been read.
 */
- (void)updateBadgeTabbar;
@end
