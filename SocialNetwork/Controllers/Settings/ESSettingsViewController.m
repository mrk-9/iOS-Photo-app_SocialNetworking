//
//  ESSettingsViewController.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 06.09.14.
//
//

#import "ESSettingsViewController.h"
#import "AppDelegate.h"
#import "PXAlertView.h"
#import "ESDeleteAccountViewController.h"
#import "ESChangePasswordViewController.h"
#import "ESChangePINViewController.h"
#import "ESDeleteAccountNonFacebookViewController.h"
#import "SCLAlertView.h"
#import "ColorPickerViewController.h"
#import "TOWebViewController.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


// UITableView enum-based configuration via Fraser Speirs: http://speirs.org/blog/2008/10/11/a-technique-for-using-uitableview-and-retaining-your-sanity.html
typedef enum {
    kPAWSettingsTableViewDistance = 0,
    kPAWSettingsTableViewLogout,
    kPAWSettingsTableViewNumberOfSections
} kPAWSettingsTableViewSections;

typedef enum {
    kPAWSettingsLogoutDialogLogout = 0,
    kPAWSettingsLogoutDialogCancel,
    kPAWSettingsLogoutDialogNumberOfButtons
} kPAWSettingsLogoutDialogButtons;

typedef enum {
    kPAWSettingsTableViewDistanceSection250FeetRow = 0,
    kPAWSettingsTableViewDistanceSection1000FeetRow,
    kPAWSettingsTableViewDistanceSection4000FeetRow,
    kPAWSettingsTableViewDistanceNumberOfRows
} kPAWSettingsTableViewDistanceSectionRows;

@implementation ESSettingsViewController

@synthesize _tableView, switchview, switchviewPush, switchviewRead;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

#pragma mark - UIViewController

-(void)viewDidAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"AccountDeletion"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        NSString *notificationName = @"ESNotification";
        NSString *key = @"CommunicationStringValue";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"AccountDeletion" forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dictionary];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xcc0900)];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]) {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        //self.view.backgroundColor = color;

        
        
        self.navigationController.navigationBar.barTintColor = color;
    }
    else {
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xcc0900);
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    [self._tableView setDelegate:self];
    [self._tableView setDataSource:self];
    [self.view addSubview:self._tableView];
    
    [self.view addSubview:_tableView];
    
    CGRect footerRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    UIView *wrapperView = [[UIView alloc] initWithFrame:footerRect];
    
    UILabel *tableFooter = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    tableFooter.textColor = [UIColor darkGrayColor];
    tableFooter.backgroundColor = [self._tableView backgroundColor];
    tableFooter.opaque = YES;
    tableFooter.textAlignment = NSTextAlignmentCenter;
    tableFooter.font = [UIFont systemFontOfSize:12];
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *string = [NSString stringWithFormat:@"v%@ ", appVersionString];
    tableFooter.text = string;
    
    UIButton *spaceInvader = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 25, 0, 30, 40)];
    [spaceInvader addTarget:self action:@selector(spaceInvaderTap) forControlEvents:UIControlEventTouchDown];
    [spaceInvader setTitle:@"" forState:UIControlStateNormal];
    spaceInvader.titleLabel.font = [UIFont systemFontOfSize:12];
    [wrapperView addSubview:tableFooter];
    [wrapperView addSubview:spaceInvader];
        
    self._tableView.tableFooterView = wrapperView;
    
    
}

#pragma mark - UINavigationBar-based actions

- (void)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        return 1;
        break;
        case 1:
        return 7;
        break;
      //  case 2:
        //return 1;
        break;
        case 3:
        return 1;
        case 4:
            return 0;
            break;
        case 5:
            return 0;
            break;
        case 6:
            return 0;
        break;
        default:
        return 0;
    };
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        return 50;
        break;
            case 3:
            return 20;
        default:
        return 30;
    };
    
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
            cell.textLabel.text = NSLocalizedString(@"Security Settings", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Terms of Use", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Location Services", nil);
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
            [switchview addTarget:self action:@selector(switchToggled) forControlEvents: UIControlEventValueChanged];
            if([[[PFUser currentUser] objectForKey:@"locationServices"] isEqualToString:@"YES"]){
                [switchview setOn:YES animated:YES];
            }
            else {
                [switchview setOn:NO animated:YES];
            }
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Contact Us", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 5) {
            cell.textLabel.text = NSLocalizedString(@"Privacy Policy", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
     //   else if (indexPath.row == 6) {
       //     cell.textLabel.text = NSLocalizedString(@"Community Guidelines", nil);
         //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //}
        else if (indexPath.row == 6) {
            cell.textLabel.text = NSLocalizedString(@"Open Source Libraries", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        else if (indexPath.row == 3) {
            cell.textLabel.text = NSLocalizedString(@"Send read receipt", nil);
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            switchviewRead = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchviewRead;
            [switchviewRead addTarget:self action:@selector(switchToggledRead) forControlEvents: UIControlEventValueChanged];
            if([[[PFUser currentUser] objectForKey:@"readreceipt"] isEqualToString:@"YES"]){
                [switchviewRead setOn:YES animated:YES];
            }
            else {
                [switchviewRead setOn:NO animated:YES];
            }
        }
        else if (indexPath.row == 4) {
            cell.textLabel.text = NSLocalizedString(@"Push notifications", nil);
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            switchviewPush = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchviewPush;
            [switchviewPush addTarget:self action:@selector(switchToggledPush) forControlEvents: UIControlEventValueChanged];
            if([[[PFUser currentUser] objectForKey:@"pushnotification"] isEqualToString:@"YES"]){
                [switchviewPush setOn:YES animated:YES];
            }
            else {
                [switchviewPush setOn:NO animated:YES];
            }
        }
        // Configure the cell.
        
        
        return cell;
    }
   /* else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        // Configure the cell.
        cell.textLabel.text = NSLocalizedString(@"Make a donation", nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
        return cell;
    }*/

    else  {
        
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
- (void) switchToggled {
    
    if (![switchview isOn]) {
        // [switchview setOn:NO animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"locationServices"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        PFUser *user = [PFUser currentUser];
        [user setObject:@"NO" forKey:@"locationServices"];
        [user saveInBackground];
        
    } else {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.backgroundType = Blur;
            [alert showNotice:self.parentViewController title:NSLocalizedString(@"Notice", nil) subTitle:NSLocalizedString(@"Location Service has been disabled - please go to your Settings and turn on Location Service for this app", nil) closeButtonTitle:@"OK" duration:0.0f];
            [switchview setOn:NO animated:YES];
        }
        else {
            // [switchview setOn:YES animated:YES];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"locationServices"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            PFUser *user = [PFUser currentUser];
            [user setObject:@"YES" forKey:@"locationServices"];
            [user saveInBackground];
        }
    }
}
- (void) switchToggledRead {
    
    if (![switchviewRead isOn]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"readreceipt"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        PFUser *user = [PFUser currentUser];
        [user setObject:@"NO" forKey:@"readreceipt"];
        [user saveInBackground];
        
    } else {
        // [switchview setOn:YES animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"readreceipt"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        PFUser *user = [PFUser currentUser];
        [user setObject:@"YES" forKey:@"readreceipt"];
        [user saveInBackground];
    }
}
- (void) switchToggledPush {
    
    if (![switchviewPush isOn]) {
        // [switchview setOn:NO animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"pushnotification"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        PFUser *user = [PFUser currentUser];
        [user setObject:@"NO" forKey:@"pushnotification"];
        [user saveInBackground];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        
    } else {
        // [switchview setOn:YES animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"pushnotification"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        PFUser *user = [PFUser currentUser];
        [user setObject:@"YES" forKey:@"pushnotification"];
        [user saveInBackground];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        return NSLocalizedString(@"Profile", nil);
        break;
        case 1:
        return NSLocalizedString(@"Privacy Policy", nil);
        break;
        case 2:
        return @"";
        break;
        default:
        return @"";
    }
}

#pragma mark - UITableViewDelegate methods

// Called after the user changes the selection.
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
        }
        else if (indexPath.row == 0) {
            if ([[PFUser currentUser] objectForKey:kESUserFacebookIDKey]) {
                //Facebook guy ...
                ESChangePINViewController *settingsViewController = [[ESChangePINViewController alloc] initWithNibName:nil bundle:nil];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
                navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:navController animated:YES completion:nil];
                
            }
            else {
                ESChangePasswordViewController *settingsViewController = [[ESChangePasswordViewController alloc] initWithNibName:nil bundle:nil];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
                navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:navController animated:YES completion:nil];
            }
        }
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
        /*    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.google.com"]];
            webViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewController animated:YES];
       */
            
        //GasITTermsofService
            
            
            CGRect rect = [[UIScreen mainScreen] bounds];
            CGSize screenSize = rect.size;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"GasITTermsofService" ofType:@"pdf"];
            NSURL *targetURL = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            [webView loadRequest:request];
            
            [self.view addSubview:webView];

        }
        else if (indexPath.row == 2) {
            //user has to tap the switch not the cell...
        }  else if (indexPath.row == 5) {
            
            CGRect rect = [[UIScreen mainScreen] bounds];
            CGSize screenSize = rect.size;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"GasITPrivacyPolicy" ofType:@"pdf"];
            NSURL *targetURL = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            [webView loadRequest:request];
            
            [self.view addSubview:webView];        }
    /*    else if (indexPath.row == 6) {
            
            CGRect rect = [[UIScreen mainScreen] bounds];
            CGSize screenSize = rect.size;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"GasITCommunityGuidelines" ofType:@"pdf"];
            NSURL *targetURL = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            [webView loadRequest:request];
            
            [self.view addSubview:webView];        }
*/        else if (indexPath.row == 6) {
            
            CGRect rect = [[UIScreen mainScreen] bounds];
            CGSize screenSize = rect.size;
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"GasITWebandApplicationsCredits" ofType:@"pdf"];
            NSURL *targetURL = [NSURL fileURLWithPath:path];
            NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
            [webView loadRequest:request];
            
            [self.view addSubview:webView];        }

        else if (indexPath.row == 1) {
            if ([MFMailComposeViewController canSendMail]) {
                NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
                NSString *model = [[UIDevice currentDevice] model];
                NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
                mailComposer.mailComposeDelegate = self;
                [mailComposer setToRecipients:[NSArray arrayWithObjects: @"GasITHelp@gmail.com",nil]];
                [mailComposer setSubject:[NSString stringWithFormat: @"v%@ Support",appVersionString]];
                NSString *supportText = [NSString stringWithFormat:@"Device: %@\niOS Version: %@\nRequester ID: %@\n               _________________\n\n",model,iOSVersion,[[PFUser currentUser]objectId]];
                supportText = [supportText stringByAppendingString: @"Please describe your problem or question. We will answer you within 24 hours. For a flawless treatment of your query, make sure to not delete the above indicated iOS Version and Requester ID.\n               _________________"];
                [mailComposer setMessageBody:supportText isHTML:NO];
                mailComposer.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:mailComposer animated:YES completion:nil];
                
            } else {
                [PXAlertView showAlertWithTitle:nil
                                        message:NSLocalizedString(@"You have no active email account on your device - but you can still contact us under:\n\ngasithelp@gmail.com", nil)
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
    
    else if (indexPath.section == 2)
    {
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.netzwierk.lu/donate"]];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];

    }
    else if (indexPath.section == 3)
    {
        if ([[PFUser currentUser] objectForKey:kESUserFacebookIDKey]) {
            //Facebook guy ...
            ESDeleteAccountViewController *settingsViewController = [[ESDeleteAccountViewController alloc] initWithNibName:nil bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:navController animated:YES completion:nil];
            
        }
        else {
            ESDeleteAccountNonFacebookViewController *settingsViewController = [[ESDeleteAccountNonFacebookViewController alloc] initWithNibName:nil bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:navController animated:YES completion:nil];
        }
        
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
        }
    }
}
#pragma mark - UIAlertViewDelegate methods

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == kPAWSettingsLogoutDialogLogout) {
        // Log out.
        [PFUser logOut];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate logOut];
    } else if (buttonIndex == kPAWSettingsLogoutDialogCancel) {
        return;
    }
}

// Nil implementation to avoid the default UIAlertViewDelegate method, which says:
// "Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button"
// Since we have "Log out" at the cancel index (to get it out from the normal "Ok whatever get this dialog outta my face"
// position, we need to deal with the consequences of that.
- (void)alertViewCancel:(UIAlertView *)alertView {
    return;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)spaceInvaderTap {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"spaceInvader1"]) {
        SCLAlertView *alert =[[SCLAlertView alloc]init];
        UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
        [alert showCustom:self.parentViewController image:[UIImage imageNamed:@"spaceInvader.png"] color:color title:@"Space Invader" subTitle:NSLocalizedString(@"You found one of the rare space invaders! Go and find the others to see what happens!", nil) closeButtonTitle:@"OK" duration:0.0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"spaceInvader1"];
    }
}

@end
