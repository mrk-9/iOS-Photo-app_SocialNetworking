//
//  ESDeleteAccountNonFacebookViewController.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.09.14.
//
//

#import "ESDeleteAccountNonFacebookViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "PXAlertView.h"
#import "AppDelegate.h"
#import "ESLogInViewController.h"
#import "ESSignUpViewController.h"
#import "ESSettingsViewController.h"
#import "ESConstants.h"

BOOL _delete = NO;


@implementation ESDeleteAccountNonFacebookViewController

@synthesize _tableView;
@synthesize tf,tf2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]) {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        self.navigationController.navigationBar.barTintColor = color;
    }
    else {
//        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHue:204.0f/360.0f saturation:76.0f/100.0f brightness:86.0f/100.0f alpha:1];
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xcc0900);
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    self.navigationItem.title = NSLocalizedString(@"Delete Account", nil);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    [self._tableView setDelegate:self];
    [self._tableView setDataSource:self];
    [self.view addSubview:self._tableView];
    
    [self.view addSubview:_tableView];
    
    
}


#pragma mark - UINavigationBar-based actions

- (void)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
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
        return 180;
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
            tf.placeholder = NSLocalizedString(@"Enter Username", nil);
            tf.secureTextEntry = NO;
            tf.delegate = self;
            tf.autocorrectionType = UITextAutocorrectionTypeNo ;
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf.adjustsFontSizeToFitWidth = YES;
            tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            [cell addSubview:tf];
        }
        else {
            tf2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 200, 40)];
            tf2.placeholder = NSLocalizedString(@"Enter Password", nil);
            tf2.secureTextEntry = YES;
            tf2.delegate = self;
            tf2.autocorrectionType = UITextAutocorrectionTypeNo ;
            tf2.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf2.adjustsFontSizeToFitWidth = YES;
            tf2.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            [cell addSubview:tf2];
        }
        
        return cell;
    } else {
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        // Configure the cell.
        cell.textLabel.text = NSLocalizedString(@"Delete Account", nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    if (section == 0) {
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, 18);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 150)];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 20;
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textColor = [UIColor darkGrayColor];
        NSString *string = NSLocalizedString(@"In compliance with our terms and general philosophy, deleting your account will:\n\n• delete all of your data on our servers permanently\n\n• prevent you from recovering any data afterwards.", nil);
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
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you really want to delete your account? All of your data will be lost", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete Account", nil) otherButtonTitles: nil];
        [action showInView:self.view];
        action.tag = 2;
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    PFQuery *sensitiveDataQuery = [PFQuery queryWithClassName:@"SensitiveData"];
    [sensitiveDataQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    PFObject *sensitiveData = [sensitiveDataQuery getFirstObject];
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
        }
    }
    else if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            PFUser *currentUser = [PFUser currentUser];
            NSString *currentName = [sensitiveData objectForKey:@"email"];
            if ([[currentUser objectForKey:@"username"] isEqualToString:[tf text]]) {
                MBProgressHUD *hud = [[MBProgressHUD alloc]init];
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [PFUser logInWithUsernameInBackground:tf.text password:tf2.text block:^(PFUser *user, NSError *error) {
                    if (!error) {
                        NSLog(@"Login user!");
                        if ([currentName isEqualToString:[sensitiveData objectForKey:@"email"]]) {
                            _delete = YES;
                            [self deleteAccount:user];
                        }
                    }
                    if (error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                [PXAlertView showAlertWithTitle:NSLocalizedString(@"Ooops!", nil)
                                        message:NSLocalizedString(@"This is not the correct user you're entering.\n\nAre you trying to cheat, evil hacker?", nil)
                                    cancelTitle:@"I guess, no"
                                     completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                         if (cancelled) {
                                             NSLog(@"Simple Alert View cancelled");
                                         } else {
                                             NSLog(@"Simple Alert View dismissed, but not cancelled");
                                         }
                                     }];
                
                
            }
            
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
    NSLog(@"retun");
    [textField resignFirstResponder];
    return YES;
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    return;
}

- (void)deleteAccount:(PFUser *)user{
    /**
     *  Log the user in and then delete everything related to him.
     */
    if (_delete == NO) {
        return;
    }
    PFQuery *sensitiveQuery = [PFQuery queryWithClassName:@"SensitiveData"];
    [sensitiveQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [sensitiveQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
        }
    }];
    //Activity query
    PFQuery *query = [PFQuery queryWithClassName:kESActivityClassKey];
    [query whereKey:kESActivityToUserKey equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
            PFQuery *query = [PFQuery queryWithClassName:
                              kESActivityClassKey];
            [query whereKey:kESActivityFromUserKey equalTo:user];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        [object deleteInBackground];
                    }
                    //Photo query
                    PFQuery *photoquery = [PFQuery queryWithClassName:kESPhotoClassKey];
                    [photoquery whereKey:kESPhotoUserKey equalTo:user];
                    [photoquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            // The find succeeded.
                            // Do something with the found objects
                            for (PFObject *object in objects) {
                                [object deleteInBackground];
                            }
                            //Last query, the user, this is the beast
                            [user deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AccountDeletion"];
                                    [[NSUserDefaults standardUserDefaults]synchronize];
                                    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                    
                                    /*
                                     [PXAlertView showAlertWithTitle:nil
                                     message:NSLocalizedString(@"Your account has been completely deleted from our servers", nil)
                                     cancelTitle:@"Thank you."
                                     completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     if (cancelled) {
                                     NSLog(@"Simple Alert View cancelled");
                                     } else {
                                     NSLog(@"Simple Alert View dismissed, but not cancelled");
                                     }
                                     }];
                                     */
                                }
                                else {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [PXAlertView showAlertWithTitle:NSLocalizedString(@"Ooops!", nil)
                                                            message:NSLocalizedString(@"An error occurred, while tryying to delete your user. Try again or contact us.", nil)
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
                        } else {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            // Log details of the failure
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                            [PXAlertView showAlertWithTitle:NSLocalizedString(@"Ooops!", nil)
                                                    message:NSLocalizedString(@"An error occurred while trying to delete your photos Try again or contact us.", nil)
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
                    
                    
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    [PXAlertView showAlertWithTitle:NSLocalizedString(@"Ooops!", nil)
                                            message:NSLocalizedString(@"An error occurred while trying to delete your comments Try again or contact us.", nil)
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
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [PXAlertView showAlertWithTitle:NSLocalizedString(@"Ooops!", nil)
                                    message:NSLocalizedString(@"An error occurred while trying to delete your comments Try again or contact us.", nil)
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


@end
