//
//  ESChangePasswordViewController.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.09.14.
//
//

#import "ESChangePasswordViewController.h"
#import "MBProgressHUD.h"
#import "PXAlertView.h"


// UITableView enum-based configuration via Fraser Speirs: http://speirs.org/blog/2008/10/11/a-technique-for-using-uitableview-and-retaining-your-sanity.html


@implementation ESChangePasswordViewController

@synthesize _tableView;
@synthesize tf, tf2, tf3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillDisappear:(BOOL)animated {
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]) {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        self.navigationController.navigationBar.barTintColor = color;
    }
    else {
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xcc0900);
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    self.navigationItem.title = NSLocalizedString(@"Change Password", nil);

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    [self._tableView setDelegate:self];
    [self._tableView setDataSource:self];
    [self.view addSubview:self._tableView];
    
    [self.view addSubview:_tableView];
    
    
}


#pragma mark - UINavigationBar-based actions

- (void)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
    };
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 100;
    }
    else
        return 30;
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SettingsTableView";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.row == 0) {
            tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 200, 40)];
            tf.placeholder = NSLocalizedString(@"Enter email address", nil);
            tf.secureTextEntry = NO;
            tf.delegate = self;
            tf.autocorrectionType = UITextAutocorrectionTypeNo ;
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf.adjustsFontSizeToFitWidth = YES;
            tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            [cell addSubview:tf];
        }
        else if (indexPath.row == 1) {
            tf2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 200, 40)];
            tf2.placeholder = NSLocalizedString(@"Enter old Password", nil);
            tf2.secureTextEntry = YES;
            tf2.delegate = self;
            tf2.autocorrectionType = UITextAutocorrectionTypeNo ;
            tf2.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf2.adjustsFontSizeToFitWidth = YES;
            tf2.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            [cell addSubview:tf2];
        }
        else {
            tf3 = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 200, 40)];
            tf3.placeholder = NSLocalizedString(@"Enter new Password", nil);
            tf3.secureTextEntry = YES;
            tf3.delegate = self;
            tf3.autocorrectionType = UITextAutocorrectionTypeNo ;
            tf3.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf3.adjustsFontSizeToFitWidth = YES;
            tf3.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            [cell addSubview:tf3];
        }
        
        
        return cell;
    } else {
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        // Configure the cell.
        cell.textLabel.text = NSLocalizedString(@"Change Password", nil);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    if (section == 0) {
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, 18);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 100)];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 20;
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textColor = [UIColor darkGrayColor];
        NSString *string = NSLocalizedString(@"Enter your username and password, then set a new password.", nil);
        [label setText:string];
        [view addSubview:label];
    }
    return view;
    
}
#pragma mark - UITableViewDelegate methods
// Called after the user changes the selection.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }
    else if (indexPath.section == 1) {
        /**
         *  Log the user in and, if successful, change the password and save the user.
         */
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *sensitiveDataQuery = [PFQuery queryWithClassName:@"SensitiveData"];
        [sensitiveDataQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        [sensitiveDataQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            MBProgressHUD *hud = [[MBProgressHUD alloc]init];
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (!error) {
                PFObject *sensitiveData = [sensitiveDataQuery getFirstObject];
                NSString *currentName = [sensitiveData objectForKey:@"email"];
                if ([[currentUser objectForKey:@"username"] isEqualToString:[tf text]] || [[currentUser objectForKey:@"email"] isEqualToString:[tf text]]) {
                    
                    if (tf3.text.length < 6) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ooops!", nil) message:NSLocalizedString(@"Your new password must be at least 6 characters long", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        return;
                    }
                    if ([tf3.text rangeOfString:@" "].location == NSNotFound) {
                        //alright then
                    } else {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ooops!", nil) message:NSLocalizedString(@"Your new password must not contain any empty spaces", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        return;
                    }
                    [PFUser logInWithUsernameInBackground:tf.text password:tf2.text block:^(PFUser *user, NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (!error) {
                            NSLog(@"Login user!");
                            if ([currentName isEqualToString:[sensitiveData objectForKey:@"email"]]) {
                                user.password = tf3.text;
                                [user saveInBackground];
                                tf.text = nil;
                                tf2.text = nil;
                                tf3.text = nil;
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Eureka!", nil) message:NSLocalizedString(@"Password successfully changed", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alert show];
                                
                            }
                        }
                        if (error) {
                            [PXAlertView showAlertWithTitle:NSLocalizedString(@"Ooops!", nil)
                                                    message:NSLocalizedString(@"Wrong username or password", nil)
                                                cancelTitle:@"OK"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                     if (cancelled) {
                                                         NSLog(@"Simple Alert View cancelled");
                                                     } else {
                                                         NSLog(@"Simple Alert View dismissed, but not cancelled");
                                                     }
                                                 }];
                            
                        }
                    }];
                    
                }
                else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Ooops!", nil) message:NSLocalizedString(@"Wrong username or password", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    
                }
            }
            else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
        }];
        
        
        
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
        }
    }
}
#pragma mark - UIAlertViewDelegate methods

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Log out.
        
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
        
    } else if (buttonIndex == 0) {
        return;
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// Nil implementation to avoid the default UIAlertViewDelegate method, which says:
// "Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button"
// Since we have "Log out" at the cancel index (to get it out from the normal "Ok whatever get this dialog outta my face"
// position, we need to deal with the consequences of that.
- (void)alertViewCancel:(UIAlertView *)alertView {
    return;
}
@end
