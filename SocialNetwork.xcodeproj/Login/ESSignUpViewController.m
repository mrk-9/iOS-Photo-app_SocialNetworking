//
//  ESSignUpViewController.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "AFNetworking.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "ESSignUpViewController.h"

@implementation ESSignUpViewController

@synthesize cellPassword, cellEmail, cellButton;
@synthesize fieldNameFirst,fieldNameLast,cellNameFirst,cellNameLast, fieldPassword, fieldEmail, cellFacebook;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Sign up", nil);
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.3412 green:0.6902 blue:0.9294 alpha:1];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIColor *backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    self.tableView.backgroundView.backgroundColor = backgroundColor;
    
    UIImage *buttonImage = [UIImage imageNamed:@"navbar-back-arrow.png"];
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:buttonImage forState:UIControlStateNormal];
    [forwardButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    forwardButton.font = [UIFont systemFontOfSize:16];
    forwardButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [forwardButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
}
- (void) back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[fieldName becomeFirstResponder];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark- User actions

- (void)actionRegister
{
    PFUser *user = [PFUser user];
    
    NSString *nameFirst		= fieldNameFirst.text;
    NSString *nameLast		= fieldNameLast.text;
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", nameFirst,nameLast];
    NSString *password	= fieldPassword.text;
    NSString *email		= [fieldEmail.text lowercaseString];
    if ([fullName length] < 5)		{ [ProgressHUD showError:NSLocalizedString(@"Name is too short.", nil)]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:NSLocalizedString(@"Password must be set.", nil)]; return; }
    if ([email length] == 0)	{ [ProgressHUD showError:NSLocalizedString(@"Email must be set.", nil)]; return; }
    [ProgressHUD show:NSLocalizedString(@"Please wait...", nil) Interaction:NO];
    user.username = fullName;
    user.password = password;
    user.email = email;
    user[kESUserEmailKey] = email;
    user[kESUserDisplayNameKey] = fullName;
    user[kESUserDisplayNameLowerKey] = [fullName lowercaseString];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             PFInstallation *installation = [PFInstallation currentInstallation];
             installation[kESInstallationUserKey] = [PFUser currentUser];
             [installation saveInBackground];
             
             PFObject *sensitiveData = [PFObject objectWithClassName:@"SensitiveData"];
             [sensitiveData setObject:user forKey:@"user"];
             [sensitiveData setObject:email forKey:@"email"];
             PFACL *sensitive = [PFACL ACLWithUser:user];
             [sensitive setReadAccess:YES forUser:user];
             [sensitive setWriteAccess:YES forUser:user];
             sensitiveData.ACL = sensitive;
             [sensitiveData saveEventually];
             
             [user setObject:@YES forKey:kESUserAlreadyAutoFollowedFacebookFriendsKey];
             
             if (![user objectForKey:@"usernameFix"]) {
                 NSString *nameWithoutSpaces = [fullName stringByReplacingOccurrencesOfString:@" " withString:@""];
                 NSString *finalName = [nameWithoutSpaces lowercaseString];
                 [self checkUserExistance:finalName withZusatz:0 withCopy:finalName];
                 
             }
             
             NSError *error = nil;
             NSMutableArray *netzwierkEmployees = [[NSMutableArray alloc] initWithArray:kESNetzwierkEmployeeAccounts];
             PFQuery *netzwierkEmployeeQuery = [PFUser query];
             [netzwierkEmployeeQuery whereKey:kESUserFacebookIDKey containedIn:netzwierkEmployees];
             [self performSelector:@selector(eventuallyLogin) withObject:nil afterDelay:2.5];
             NSArray *netzwierkFriends = [netzwierkEmployeeQuery findObjects:&error];
             [netzwierkFriends enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop) {
                 PFObject *joinActivity = [PFObject objectWithClassName:kESActivityClassKey];
                 [joinActivity setObject:user forKey:kESActivityFromUserKey];
                 [joinActivity setObject:newFriend forKey:kESActivityToUserKey];
                 [joinActivity setObject:kESActivityTypeJoined forKey:kESActivityTypeKey];
                 
                 PFACL *joinACL = [PFACL ACL];
                 [joinACL setPublicReadAccess:YES];
                 [joinACL setWriteAccess:YES forUser:[PFUser currentUser]];
                 joinActivity.ACL = joinACL;
                 
                 // make sure our join activity is always earlier than a follow
                 [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     [ESUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                         // This block will be executed once for each friend that is followed.
                         // We need to refresh the timeline when we are following at least a few friends
                         // Use a timer to avoid refreshing innecessarily
                         
                     }];
                 }];
             }];
             
         }
         else [ProgressHUD showError:error.userInfo[@"error"]];
     }];
}

#pragma mark- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    if (section == 4) {
        return [UIScreen mainScreen].bounds.size.height- 495;
    }
    if (section == 5) {
        return 5;
    }
    else return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        return 60;
    }
    else if (indexPath.section == 5) {
        return 60;
    }
    else return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        fieldNameFirst.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width- 40, cellNameFirst.frame.size.height);
        fieldNameFirst.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        fieldNameFirst.placeholder = NSLocalizedString(@"First name", nil);
        UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(20, cellNameFirst.frame.size.height-1, [UIScreen mainScreen].bounds.size.width- 40, 1)];
        thinLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [cellNameFirst addSubview:thinLine];
        return cellNameFirst;
    } else if (indexPath.section == 1) {
        fieldNameLast.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width- 40, cellNameLast.frame.size.height);
        fieldNameLast.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        fieldNameLast.placeholder = NSLocalizedString(@"Last name", nil);
        
        UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(0, cellNameLast.frame.size.height-1, [UIScreen mainScreen].bounds.size.width- 40, 1)];
        thinLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [fieldNameLast addSubview:thinLine];
        return cellNameLast;
    }
    else if (indexPath.section == 2) {
        fieldPassword.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width- 40, cellPassword.frame.size.height);
        fieldPassword.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        fieldPassword.placeholder = NSLocalizedString(@"Password", nil);
        
        UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(20, cellPassword.frame.size.height-1, [UIScreen mainScreen].bounds.size.width- 40, 1)];
        thinLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [cellPassword addSubview:thinLine];
        return cellPassword;
    }
    else if (indexPath.section == 3) {
        fieldEmail.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width- 40, cellEmail.frame.size.height);
        fieldEmail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(20, cellEmail.frame.size.height-1, [UIScreen mainScreen].bounds.size.width- 40, 1)];
        thinLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [cellEmail addSubview:thinLine];
        return cellEmail;
    }
    else if (indexPath.section == 4) {
        cellFacebook.backgroundColor = [UIColor clearColor];
        UIButton *facebookLogin = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, cellFacebook.frame.size.height)];
        [facebookLogin setTitle:NSLocalizedString(@"Sign up with Facebook", nil) forState: UIControlStateNormal];
        [facebookLogin addTarget:self action:@selector(actionFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
        facebookLogin.titleLabel.tintColor = [UIColor whiteColor];
        facebookLogin.layer.cornerRadius = 4;
        facebookLogin.backgroundColor = [UIColor colorWithRed:109.0f/255.0f green:132.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
        [cellFacebook addSubview:facebookLogin];
        cellFacebook.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellFacebook;
    }
    else if (indexPath.section == 5) {
        cellButton.backgroundColor = [UIColor clearColor];
        UIButton *loginLabel = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, cellButton.frame.size.height)];
        [loginLabel setTitle:NSLocalizedString(@"Sign up",nil) forState: UIControlStateNormal];
        [loginLabel addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
        loginLabel.titleLabel.tintColor = [UIColor whiteColor];
        loginLabel.layer.cornerRadius = 4;
        loginLabel.backgroundColor = [UIColor colorWithRed:189.0f/255.0f green:195.0f/255.0f blue:199.0f/255.0f alpha:1.0f];
        [cellButton addSubview:loginLabel];
        cellButton.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellButton;
    }
    
    return nil;
}

#pragma mark- Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == fieldNameFirst)
    {
        [fieldNameLast becomeFirstResponder];
    }
    if (textField == fieldNameLast)
    {
        [fieldPassword becomeFirstResponder];
    }
    if (textField == fieldPassword)
    {
        [fieldEmail becomeFirstResponder];
    }
    if (textField == fieldEmail)
    {
        [self actionRegister];
    }
    return YES;
}
- (void)actionFacebookLogin {
    [ProgressHUD show:NSLocalizedString(@"Logging in...", nil) Interaction:NO];
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             if (user[kESUserFacebookIDKey] == nil)
             {
                 [self requestFacebook:user];
             }
             else [self userLoggedIn:user];
         }
         else [ProgressHUD showError:@"Facebook login error."];
     }];
}
- (void)requestFacebook:(PFUser *)user
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error == nil)
         {
             NSDictionary *userData = (NSDictionary *)result;
             [self processFacebook:user UserData:userData];
         }
         else
         {
             [PFUser logOut];
             [ProgressHUD showError:@"Failed to fetch Facebook user data."];
         }
     }];
}

- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData
{
    NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         UIImage *image = (UIImage *)responseObject;
         [ESUtility processFacebookProfilePictureData:UIImageJPEGRepresentation(image, 1.0)];
         if (![user objectForKey:@"usernameFix"]) {
             NSString *name = [[NSString alloc]init];
             name = userData[@"name"];
             NSString *nameWithoutSpaces = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
             NSString *finalName = [nameWithoutSpaces lowercaseString];
             [self checkUserExistance:finalName withZusatz:0 withCopy:finalName];
             
         }
         user[kESUserEmailKey] = userData[@"email"];
         user[kESUserDisplayNameKey] = userData[@"name"];
         user[kESUserDisplayNameLowerKey] = [userData[@"name"] lowercaseString];
         user[kESUserFacebookIDKey] = userData[@"id"];
         
         
         [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
          {
              if (error != nil)
              {
                  [PFUser logOut];
                  [ProgressHUD showError:error.userInfo[@"error"]];
              }
              else [self userLoggedIn:user];
          }];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [PFUser logOut];
         [ProgressHUD showError:@"Failed to fetch Facebook profile picture."];
     }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}
- (void)userLoggedIn:(PFUser *)user
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[kESInstallationUserKey] = [PFUser currentUser];
    [installation saveInBackground];
    
    if (![user objectForKey:kESUserAlreadyAutoFollowedFacebookFriendsKey]) {
        PFObject *sensitiveData = [PFObject objectWithClassName:@"SensitiveData"];
        [sensitiveData setObject:user forKey:@"user"];
        PFACL *sensitive = [PFACL ACLWithUser:user];
        [sensitive setReadAccess:YES forUser:user];
        [sensitive setWriteAccess:YES forUser:user];
        sensitiveData.ACL = sensitive;
        [sensitiveData saveEventually];
        
        [user setObject:@YES forKey:kESUserAlreadyAutoFollowedFacebookFriendsKey];
        [self performSelector:@selector(eventuallyLogin) withObject:self afterDelay:2.5];
        NSMutableArray *netzwierkEmployees = [[NSMutableArray alloc] initWithArray:kESNetzwierkEmployeeAccounts];
        PFQuery *netzwierkEmployeeQuery = [PFUser query];
        [netzwierkEmployeeQuery whereKey:kESUserFacebookIDKey containedIn:netzwierkEmployees];
        [netzwierkEmployeeQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            if (!error) {
                NSArray *netzwierkFriends = results;
                if ([netzwierkFriends count] > 0) {
                    [netzwierkFriends enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop) {
                        PFObject *joinActivity = [PFObject objectWithClassName:kESActivityClassKey];
                        [joinActivity setObject:user forKey:kESActivityFromUserKey];
                        [joinActivity setObject:newFriend forKey:kESActivityToUserKey];
                        [joinActivity setObject:kESActivityTypeJoined forKey:kESActivityTypeKey];
                        
                        PFACL *joinACL = [PFACL ACL];
                        [joinACL setPublicReadAccess:YES];
                        [joinACL setWriteAccess:YES forUser:[PFUser currentUser]];
                        joinActivity.ACL = joinACL;
                        
                        // make sure our join activity is always earlier than a follow
                        [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [ESUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                                // This block will be executed once for each friend that is followed.
                                // We need to refresh the timeline when we are following at least a few friends
                                // Use a timer to avoid refreshing innecessarily
                                
                            }];
                        }];
                    }];
                }

            }
        }];
        
    }
    else {
        [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Good to see you %@!",nil), user[kESUserDisplayNameKey]]];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentTabBarController];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [[PFUser currentUser] fetch];
    }
    
}
- (void) eventuallyLogin {
    [[PFUser currentUser] saveInBackground];
    [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Good to see you %@!",nil), [[PFUser currentUser]objectForKey:kESUserDisplayNameKey]]];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentTabBarController];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)checkUserExistance:(NSString *)usernameFix withZusatz:(int)i withCopy:(NSString *)usernameFixCopy{
    //check if finalname exists
    PFQuery *query=[PFUser query];
    [query whereKey:@"usernameFix" equalTo:usernameFix];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            NSString *newFinalName = [NSString stringWithFormat:@"%@%i",usernameFixCopy,(int)i];
            int newInt = i+1;
            [self checkUserExistance:newFinalName withZusatz:newInt withCopy:usernameFixCopy];
            
        }else{
            //name not existant, save that dammit name now
            PFUser *user = [PFUser currentUser];
            [user setObject:usernameFix forKey:@"usernameFix"];
            [user saveEventually];
        }
    }];
    
}
@end
