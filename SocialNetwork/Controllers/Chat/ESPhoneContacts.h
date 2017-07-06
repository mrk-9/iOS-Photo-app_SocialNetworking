//
//  ESPhoneContacts.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@protocol ESPhoneContactsDelegate
/**
 *  User has selected a user that is already registered.
 *
 *  @param user registered user that has been selected
 */
- (void)selectedFromContacts:(PFUser *)user;
@end

/**
 *  Interface of the ESPhoneContacts ViewController
 */
@interface ESPhoneContacts : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    /**
     *  Index of the selected user cell.
     */
    NSIndexPath *selectedIndex;
}
/**
 *  Mutable array of users that are not registered
 */
@property (strong, nonatomic) NSMutableArray *users1;
/**
 *  Mutable array of users that are registered to the social network
 */
@property (strong, nonatomic) NSMutableArray *users2;

/**
 *  Delegate of the ESPhoneContacts ViewController
 */
@property (nonatomic, assign) IBOutlet id<ESPhoneContactsDelegate>delegate;

/**
 *  User is not yet registered, thus we can invite him to sign himself up.
 *
 *  @param user dictionary containing the information about the user
 */
- (void)userInviteAction:(NSDictionary *)user;

/**
 *  Once we're done, we can dismiss the phone book by calling this method.
 */
- (void)done;
@end
