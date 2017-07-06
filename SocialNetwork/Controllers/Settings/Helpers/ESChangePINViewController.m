//
//  ESChangePINViewController.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.09.14.
//
//

#import "ESChangePINViewController.h"
#import "MBProgressHUD.h"
#import "PXAlertView.h"
#import "SCLAlertView.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



@implementation ESChangePINViewController

@synthesize _tableView;
@synthesize tf, tf2, doneButton;

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
        //self.view.backgroundColor = color;
        self.navigationController.navigationBar.barTintColor = color;
    }
    else {
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xcc0900);
;
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    self.navigationItem.title = NSLocalizedString(@"Security PIN", nil);
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xcc0900)];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    [self._tableView setDelegate:self];
    [self._tableView setDataSource:self];
    [self.view addSubview:self._tableView];
    [self.view addSubview:_tableView];
    
}


#pragma mark - UINavigationBar-based actions
- (void) viewWillDisappear:(BOOL)animated {
    [self doneButtonTap];
}
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
            tf.placeholder = NSLocalizedString(@"Enter security PIN", nil);
            tf.secureTextEntry = YES;
            tf.keyboardType = UIKeyboardTypeNumberPad;
            tf.delegate = self;
            tf.autocorrectionType = UITextAutocorrectionTypeNo ;
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf.adjustsFontSizeToFitWidth = YES;
            tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            [cell addSubview:tf];
        }
        else  {
            tf2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 2, 200, 40)];
            tf2.placeholder = NSLocalizedString(@"Enter new security PIN", nil);
            tf2.secureTextEntry = YES;
            tf2.keyboardType = UIKeyboardTypeNumberPad;
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
        cell.textLabel.text = NSLocalizedString(@"Change Security PIN", nil);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        return cell;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    if (section == 0) {
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, 18);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 100)];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 20;
        [label setFont:[UIFont systemFontOfSize:14]];
        label.textColor = [UIColor darkGrayColor];
        label.numberOfLines = 4;
        NSString *string = NSLocalizedString(@"You are logged in with your facebook account. Since you have no password, you need a PIN in order to delete your account or verify your identity.", nil);
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
         *  We check if the user has entered the correct PIN and change it to the new one.
         */
        PFQuery *sensitiveDataQuery = [PFQuery queryWithClassName:@"SensitiveData"];
        [sensitiveDataQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        PFObject *sensitiveData = [sensitiveDataQuery getFirstObject];
        [self doneButton];
        if (tf2.text.length != 4) {
            [PXAlertView showAlertWithTitle:NSLocalizedString(@"Ooops!", nil)
                                    message:NSLocalizedString(@"Your PIN must be four digits long", nil)
                                cancelTitle:@"OK"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     if (cancelled) {
                                         NSLog(@"Simple Alert View cancelled");
                                     } else {
                                         NSLog(@"Simple Alert View dismissed, but not cancelled");
                                     }
                                 }];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...", nil)
                    subTitle:NSLocalizedString(@"Wrong security PIN", nil)
            closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
        if ([[sensitiveData objectForKey:@"PIN"] isEqualToString:[tf text]]) {
            [sensitiveData setObject:[tf2 text] forKey:@"PIN"];
            [sensitiveData saveInBackground];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            [alert showSuccess:self.parentViewController title:NSLocalizedString(@"Eureka", nil)
                      subTitle:NSLocalizedString(@"Security PIN successfully changed", nil)
              closeButtonTitle:@"OK" duration:0.0f];
            
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...", nil)
                    subTitle:NSLocalizedString(@"Wrong security PIN", nil)
            closeButtonTitle:@"OK" duration:0.0f];
        }
        tf.text = nil;
        tf2.text = nil;
        
        
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
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}
- (void)keyboardWillShow:(NSNotification *)note {
    // create custom button
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setHidden:NO];
    [doneButton setTitle:NSLocalizedString(@"Done",nil)  forState:UIControlStateNormal];
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
    [tf2 resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 12) ? NO : YES;
}
@end
