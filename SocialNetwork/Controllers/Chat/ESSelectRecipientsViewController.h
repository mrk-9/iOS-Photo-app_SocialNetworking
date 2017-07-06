//
//  ESSelectRecipientsViewController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

@protocol ESSelectContactsDelegate
/**
 *  User selected one or multiple recipients for his conversation.
 *
 *  @param users mutable array containing the recipient(s)
 */
- (void)selectedRecipients:(NSMutableArray *)users;
@end

@interface ESSelectRecipientsViewController : UITableViewController <UISearchBarDelegate>
{
    /**
     *  Mutable array of the selected recipients.
     */
    NSMutableArray *users;
    /**
     *  Current selection of recipients.
     */
    NSMutableArray *selection;
}
/**
 *  Header of the tableview. We display a searchbar in it.
 */
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
/**
 *  Searchbar that is displayed in the header and used to search for users.
 */
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
/**
 *  Delegate of the ESSelctRecipientsViewController.
 */
@property (nonatomic, assign) IBOutlet id<ESSelectContactsDelegate>delegate;

/**
 *  Load all the users and display them
 */
- (void)loadUsers;
/**
 *  User wants to cancel the selection, thus we dismiss the viewcontroller.
 */
- (void)cancel;
/**
 *  User is done with his selection, save the users and create a new chatroom.
 */
- (void)done;
/**
 *  Searching for a specific user by filtering their display names.
 *
 *  @param search_lower string that is used to perform the search
 */
- (void)searchUsers:(NSString *)search_lower;
/**
 *  The search has been cancelled, thus reload all the users and display them again instead of filtering them.
 */
- (void)searchBarCancel;

@end
