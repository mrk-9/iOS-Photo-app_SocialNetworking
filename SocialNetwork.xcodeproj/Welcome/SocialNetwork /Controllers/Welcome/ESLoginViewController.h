//
//  ESLoginViewController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESLoginViewController : UITableViewController <UITextFieldDelegate>

/**
 *  Cell containing a textfield for the username.
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *cellUsername;
/**
 *  Cell containing a textfield for the password.
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
/**
 *  The actual login button.
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;
/**
 *  The facebook login button.
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFacebook;
/**
 *  Textfield where the user should enter his username.
 */
@property (strong, nonatomic) IBOutlet UITextField *fieldUsername;
/**
 *  Textfield where the user should enter his password.
 */
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;
/**
 *  Fetch the username and password from the textfields and log the user in.
 */
- (void)actionLogin;
/**
 *  User requested to login via Facebook.
 */
- (void)actionFacebookLogin;
/**
 *  Fetch the facebook data of the user.
 *
 *  @param user PFUser of the user
 */
- (void)requestFacebook:(PFUser *)user;
/**
 *  Process the facebook data of the user.
 *
 *  @param user     PFUser of the user
 *  @param userData the user's facebook data like friends and profile picture
 */
- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData;
/**
 *  User has successfully logged in.
 */
- (void)userLoggedIn:(PFUser *)user;
/**
 *  Check if the unique mention name of the user already exists. If not, give him that mention name, if yes, try a new one.
 *
 *  @param usernameFix     the current unique mention name we want to be sure of that it is indeed unique
 *  @param i               a parameter added to the name in case it is not unique
 *  @param usernameFixCopy the original mention name before adding the parameters to make it unique
 */
- (void)checkUserExistance:(NSString *)usernameFix withZusatz:(int)i withCopy:(NSString *)usernameFixCopy;
@end
