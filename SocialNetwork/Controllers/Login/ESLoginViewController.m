//
//  ESLoginViewController.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "AFNetworking.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "ProgressHUD.h"
#import "ESLoginViewController.h"
#import "AppDelegate.h"
#import "ESUtility.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//#import "SCSettings.h"


@implementation ESLoginViewController
{
    BOOL _viewDidAppear;
    BOOL _viewIsVisible;
}

@synthesize cellEmail, cellPassword, cellButton;
@synthesize fieldEmail, fieldPassword,cellFacebook;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchUserInfo];

    self.title = NSLocalizedString(@"Login", nil);
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.3412 green:0.6902 blue:0.9294 alpha:1];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIColor *backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    self.tableView.backgroundView.backgroundColor = backgroundColor;
[[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xcc0900)];
    
    UIImage *buttonImage = [UIImage imageNamed:@"navbar-back-arrow.png"];
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:buttonImage forState:UIControlStateNormal];
    [forwardButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    forwardButton.font = [UIFont systemFontOfSize:16];
    forwardButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [forwardButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    //self.loginButton.readPermissions =@[@"public_profile", @"email", @"user_friends"];

    }
#pragma mark - Object lifecycle

- (void)_logOut  {
    [PFUser logOut]; // Log out
}
- (void) back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    
    if (![PFUser currentUser] || // Check if user is cached
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //[fieldEmail becomeFirstResponder];
    if (![PFUser currentUser] || // Check if user is cached
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        
    }
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - User actions

- (void)actionLogin
{
    NSString *email = fieldEmail.text;
    NSString *password = fieldPassword.text;
    
    if ([email length] == 0)	{ [ProgressHUD showError:NSLocalizedString(@"Email must be set.", nil) ]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:NSLocalizedString(@"Password must be set.", nil)]; return; }
    
    [ProgressHUD show:NSLocalizedString(@"Logging in...",nil) Interaction:NO];
    
    [self loginWithEmail:email andPassword:password];
}

-(void) getUserInfo {
    static NSString* szFieldParams = @"id, email, name, gender";
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": szFieldParams}];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString* email = userData[@"email"];
            NSString* password = @"facebook";
            
            [self loginWithEmail:email andPassword:password];
        } else {
            [ProgressHUD showError:error.userInfo[@"error"]];
        }
    }];
}

-(void) loginWithEmail:(NSString*)email andPassword:(NSString*)password {
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             PFInstallation *installation = [PFInstallation currentInstallation];
             installation[kESInstallationUserKey] = [PFUser currentUser];
             [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (error) {
                     [installation saveEventually];
                 }
             }];

             NSString *firstName = [[user[kESUserDisplayNameKey] componentsSeparatedByString:@" "] objectAtIndex:0];
             [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Good to see you %@!",nil), firstName]];
             [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentTabBarController];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         else [ProgressHUD showError:error.userInfo[@"error"]];
     }];
}

-(void) actionForgot
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Reset your password" message:@"Please enter your email:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
    alertTextField.placeholder = @"Input email";
    alertView.tag = 101;
    [alertView show];
}

-(void) showAlert:(NSString*)msg withTag:(NSInteger)tag
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:msg
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.tag = tag;
    [alertView show];
}

-(BOOL)isValidAddress:(NSString*)address
{
    BOOL isValid = YES;
    
    if ([address isEqualToString:@""]){
        isValid = NO;
    }
    else {
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
        @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:address]){
            isValid = NO;
        }
    }
    return isValid;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 101) {
        UITextField * textField = [alertView textFieldAtIndex:0];
        
        NSString* emailString = textField.text;
        NSLog(@"String is: %@", emailString); //Put it on the debugger
        
        if (buttonIndex == 1) {
            
            if (![self isValidAddress:emailString])
            {
                [self showAlert:@"Invalid email address. Please input again" withTag:102];
                
                return;
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [PFUser requestPasswordResetForEmailInBackground: emailString block:^(BOOL succeeded, NSError* error) {
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                
                NSString* strMessage = @"";
                if(succeeded)
                {
                    strMessage = @"Please check your email for instructions to reset your password";
                }
                else
                {
                    strMessage = @"Email doesn't exists in our database";
                }
                
                [self showAlert:strMessage withTag:103];
            }];
        }
    } else if (alertView.tag == 102) {
        
        [self performSelector:@selector(actionForgot) withObject:nil afterDelay:0.01f];
        
    }
}

- (void)actionFacebookLogin {
    [ProgressHUD show:NSLocalizedString(@"Logging in...",nil) Interaction:NO];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [self getUserInfo];
    } else {
        FBSDKLoginManager *loginMngr = [[FBSDKLoginManager alloc] init];
        
        NSArray *permissionArray = @[@"public_profile", @"user_friends", @"email"];
        
        [loginMngr logInWithReadPermissions:permissionArray handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error) {
                if ([PFUser currentUser]) {
                    [PFUser logOut];
                }
                
                if (![FBSDKAccessToken currentAccessToken]) {
                    [ProgressHUD showError:@"Failed to login Facebook."];
                    return;
                }
                
                [self getUserInfo];
            } else {
                [ProgressHUD showError:error.userInfo[@"error"]];
            }
        }];
    }
//
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray
//                                                    block:^(PFUser *user, NSError *error)
//     {
//         if (user != nil)
//         {
//             if (user[kESUserFacebookIDKey] == nil)
//             {
//                 [self requestFacebook:user];
//             }
//             else [self userLoggedIn:user];
//         }
//         else [ProgressHUD showError:@"Facebook login error."];
//     }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    if (section == 2) {
        return [UIScreen mainScreen].bounds.size.height - 355-25;
    }
    else return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    else if (indexPath.section == 1) {
        return 50;
    }
    else if (indexPath.section == 2) {
        return 75;
    }
    else return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        fieldEmail.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, cellEmail.frame.size.height);
        fieldEmail.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        fieldEmail.placeholder = NSLocalizedString(@"Email", nil);
        
        UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(20, cellEmail.frame.size.height-1, [UIScreen mainScreen].bounds.size.width - 40, 1)];
        thinLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [cellEmail addSubview:thinLine];
        return cellEmail;
    }
    else if (indexPath.section == 1) {
        fieldPassword.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, cellPassword.frame.size.height);
        fieldPassword.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        fieldPassword.placeholder = NSLocalizedString(@"Password", nil);
        
        UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(20, cellPassword.frame.size.height-1, [UIScreen mainScreen].bounds.size.width - 40, 1)];
        thinLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [cellPassword addSubview:thinLine];
        return cellPassword;
    }
    else if (indexPath.section == 2){
        
        cellButton.backgroundColor = [UIColor clearColor];
        
        CGFloat height = cellButton.frame.size.height;
        
        UIButton *loginLabel = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, height*2/3)];
        [loginLabel setTitle: NSLocalizedString(@"Login",nil) forState: UIControlStateNormal];
        [loginLabel addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
        loginLabel.titleLabel.tintColor = [UIColor whiteColor];
        loginLabel.layer.cornerRadius = 4;
        loginLabel.backgroundColor = [UIColor colorWithRed:189.0f/255.0f green:195.0f/255.0f blue:199.0f/255.0f alpha:1.0f];
        [cellButton addSubview:loginLabel];
        
        UIButton *forgotButton = [[UIButton alloc]initWithFrame:CGRectMake(20, height*12/15, [UIScreen mainScreen].bounds.size.width-40, height*4/15)];
        [forgotButton setTitle: @"Forgot Password" forState: UIControlStateNormal];
        [forgotButton addTarget:self action:@selector(actionForgot) forControlEvents:UIControlEventTouchUpInside];
        forgotButton.titleLabel.tintColor = [UIColor whiteColor];
        [forgotButton setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:131.0f/255.0f blue:215.0f/255.0f alpha:1.0f]  forState:UIControlStateNormal];
        forgotButton.backgroundColor = [UIColor clearColor];
        [cellButton addSubview:forgotButton];
        
        cellButton.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellButton;
    }
    else {
        
        cellFacebook.backgroundColor = [UIColor clearColor];
        UIButton *facebookLogin = [[UIButton alloc]initWithFrame:CGRectMake(25, 5, [UIScreen mainScreen].bounds.size.width-40, cellFacebook.frame.size.height)];
        [facebookLogin setTitle: @"    Log in with Facebook" forState: UIControlStateNormal];
        [facebookLogin addTarget:self action:@selector(actionFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
        facebookLogin.titleLabel.tintColor = [UIColor whiteColor];
        facebookLogin.layer.cornerRadius = 4;
        // [facebookLogin setTitleColor:[UIColor colorWithRed:109.0f/255.0f green:132.0f/255.0f blue:180.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        facebookLogin.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        [facebookLogin setTitleColor:[UIColor colorWithRed:65.0f/255.0f green:131.0f/255.0f blue:215.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        facebookLogin.backgroundColor = [UIColor clearColor];
        UIImageView *fbIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"facebookIcon"]];
        fbIcon.frame = CGRectMake(facebookLogin.frame.size.width/4 - 25, 15 , 20, 20);
        [facebookLogin addSubview:fbIcon];
        [cellFacebook addSubview:facebookLogin];
        UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, 0.5)];
        thinLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
        [cellFacebook addSubview:thinLine];
        
        cellFacebook.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellFacebook;
        
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == fieldEmail)
    {
        [fieldPassword becomeFirstResponder];
    }
    if (textField == fieldPassword)
    {
        [self actionLogin];
    }
    return YES;
}

#pragma mark - ()



- (void)requestFacebook:(PFUser *)user
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // TODO: handle results or error of request.
        
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

        //FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // handle successful response
            } else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
                [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
            } else {
                NSLog(@"Some other error: %@", error);
            }
        }];
    }];
    
    
    /*
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
*/}


- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData
{
    NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         UIImage *image = (UIImage *)responseObject;
         [ESUtility processProfilePictureData:UIImageJPEGRepresentation(image, 1.0)];
         if (![user objectForKey:@"usernameFix"]) {
             NSString *name = [[NSString alloc]init];
             name = userData[@"name"];
             NSString *nameWithoutSpaces = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
             NSString *finalName = [nameWithoutSpaces lowercaseString];
             [self checkUserExistance:finalName withZusatz:0 withCopy:finalName];
             
         }
         if (userData[@"email"]) {
             user[kESUserEmailKey] = userData[@"email"];
         }
         else {
             NSString *name = [[userData[@"name"] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
             user[kESUserEmailKey] = [NSString stringWithFormat:@"%@@facebook.com",name];
         }
         user[kESUserDisplayNameKey] = userData[@"name"];
         user[kESUserDisplayNameLowerKey] = [userData[@"name"] lowercaseString];
         user[kESUserFacebookIDKey] = userData[@"id"];
         [user setObject:@"YES" forKey:@"pushnotification"];
         [user setObject:@"YES" forKey:@"readreceipt"];
         [user setObject:@"NO" forKey:@"verified"];
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"readreceipt"];
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"pushnotification"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         
         
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
    [installation saveInBackground]; //   PostNotification(NOTIFICATION_USER_LOGGED_IN);
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
            else [ProgressHUD showError:@"Connection failed"];
        }];
    }
    else {
        NSString *firstName = [[user[kESUserDisplayNameKey] componentsSeparatedByString:@" "] objectAtIndex:0];
        [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Good to see you %@!",nil), firstName]];
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentTabBarController];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void) eventuallyLogin {
    [[PFUser currentUser] saveInBackground];
    PFUser *user = [PFUser currentUser];
    NSString *firstName = [[user[kESUserDisplayNameKey] componentsSeparatedByString:@" "] objectAtIndex:0];
    [ProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"Good to see you %@!",nil), firstName]];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] presentTabBarController];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchUserInfo
    {
        if ([FBSDKAccessToken currentAccessToken])
        {
            NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error)
                 {
                     NSLog(@"resultis:%@",result);
                 }
                 else
                 {
                     NSLog(@"Error %@",error);
                 }
             }];
            
        }
        
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
