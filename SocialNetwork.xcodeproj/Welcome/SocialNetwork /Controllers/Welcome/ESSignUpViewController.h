//
//  ESSignUpViewController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSignUpViewController : UITableViewController <UITextFieldDelegate>

/**
 *  Cell with a textfield for the user's first name.
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *cellNameFirst;
/**
 *  Cell with a textfield for the user's last name.
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *cellNameLast;
/**
 *  Cell with a ntextfield for the user's password.
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *cellPassword;
/**
 *  Cell with a ntextfield for the user's email.
 */

@property (strong, nonatomic) IBOutlet UITableViewCell *cellEmail;
/**
 *  Cell with with the actual sign up button.
 */

@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;
/**
 *  Cell with the facebook login button
 */
@property (strong, nonatomic) IBOutlet UITableViewCell *cellFacebook;
/**
 *  Textfield for the first name.
 */
@property (strong, nonatomic) IBOutlet UITextField *fieldNameFirst;
/**
 *  Textfield for the last name.
 */
@property (strong, nonatomic) IBOutlet UITextField *fieldNameLast;
/**
 *  Textfield for the password.
 */
@property (strong, nonatomic) IBOutlet UITextField *fieldPassword;
/**
 *  Textfield for the email.
 */
@property (strong, nonatomic) IBOutlet UITextField *fieldEmail;
/**
 *  Classic user tries to register, fetch his name, password and email and do exactly what he came for.
 */
- (void)actionRegister;
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
