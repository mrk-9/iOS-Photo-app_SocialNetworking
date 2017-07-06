//
//  ESDeleteAccountViewController.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.09.14.
//
//

#import "ESDeleteAccountViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "PXAlertView.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

BOOL delete = NO;

@implementation ESDeleteAccountViewController

@synthesize _tableView;
@synthesize tf,doneButton;

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
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
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
        
        tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 200, 40)];
        tf.placeholder = NSLocalizedString(@"Enter security PIN", nil);
        tf.secureTextEntry = YES;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.delegate = self;
        tf.autocorrectionType = UITextAutocorrectionTypeNo ;
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        tf.adjustsFontSizeToFitWidth = YES;
        tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        [cell addSubview:tf];
        return cell;
    } else {
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        // Configure the cell.
        cell.textLabel.text = NSLocalizedString(@"Delete Account", nil);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
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
        [action showInView:self.view];        action.tag = 2;
        
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
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
        }
    }
    else if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            MBProgressHUD *hud = [[MBProgressHUD alloc]init];
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            PFQuery *sensitiveDataQuery = [PFQuery queryWithClassName:@"SensitiveData"];
            [sensitiveDataQuery whereKey:@"user" equalTo:[PFUser currentUser]];
            PFObject *sensitiveData = [sensitiveDataQuery getFirstObject];
            
            if ([[sensitiveData objectForKey:@"PIN"] isEqualToString:[tf text]]) {
                delete = YES;
                [self deleteAccount:[PFUser currentUser]];
            }
            else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [PXAlertView showAlertWithTitle:NSLocalizedString(@"Ooops!", nil)
                                        message:NSLocalizedString(@"Wrong security PIN", nil)
                                    cancelTitle:@"OK"
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

- (void)alertViewCancel:(UIAlertView *)alertView {
    return;
}

- (void)deleteAccount:(PFUser *)user{
    if (delete == NO) {
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
            PFQuery *query = [PFQuery queryWithClassName:kESActivityClassKey];
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
- (void)keyboardWillShow:(NSNotification *)note {
    // create custom button
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setHidden:NO];
    [doneButton setTitle:NSLocalizedString(@"Done",nil) forState:UIControlStateNormal];
    [doneButton setTitle:NSLocalizedString(@"Done",nil) forState:UIControlStateHighlighted];
    doneButton.titleLabel.textColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(doneButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
            [doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
            [keyboardView addSubview:doneButton];
            [keyboardView bringSubviewToFront:doneButton];
            
            [UIView animateWithDuration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]-.02
                                  delay:.0
                                options:[[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                             animations:^{
                                 self.view.frame = CGRectOffset(self.view.frame, 0, 0);
                             } completion:nil];
        });
    }else {
        // locate keyboard view
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
            UIView* keyboard;
            for(int i=0; i<[tempWindow.subviews count]; i++) {
                keyboard = [tempWindow.subviews objectAtIndex:i];
                // keyboard view found; add the custom button to it
                if([[keyboard description] hasPrefix:@"UIKeyboard"] == YES)
                    [keyboard addSubview:doneButton];
            }
        });
    }
}
- (void)doneButtonTap {
    [doneButton setHidden:YES];
    [tf resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

@end
