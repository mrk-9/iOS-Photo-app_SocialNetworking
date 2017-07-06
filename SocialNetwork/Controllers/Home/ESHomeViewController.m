//
//  ESHomeViewController.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESHomeViewController.h"
#import "ESSettingsActionSheetDelegate.h"
#import "ESSettingsButtonItem.h"
#import "ESFindFriendsViewController.h"
#import "MBProgressHUD.h"
#import "UIViewController+ScrollingNavbar.h"
#import <QuartzCore/CALayer.h>
#import "MMDrawerBarButtonItem.h"
#import "SideViewController.h"
#import "MFSideMenu.h"
#import "ESAccountViewController.h"
#import "AppDelegate.h"
#import "ESSettingsViewController.h"
#import "ESSearchHashtagTableViewController.h"
#import "ESEditProfileViewController.h"
#import "SCLAlertView.h"
#import "ESPopularViewController.h"
#import "ESRecentViewController.h"
#import "TOWebViewController.h"
#import "Geotification.h"
#import "GeotificationsViewController.h"
#import "AddGeotificationViewController.h"
#import "Utilities.h"
#import "ESMyTravels.h"
#import "ESTravelTimeline.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

BOOL monster = NO;

@interface ESHomeViewController () 

@end


@implementation ESHomeViewController
@synthesize firstLaunch;
@synthesize settingsActionSheetDelegate;
@synthesize blankTimelineView;




-(void)tapBtn {
  
    [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen completion:^{}];
    
}
-(void)viewDidAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"AccountDeletion"]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AccountDeletion"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //[(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];        
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    rootView = self.tabBarController.view;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(tapBtn)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(newHashtagSearch)];

    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xcc0900)];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xcc0900);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2 - 253/2, 96.0f, 253.0f, 165.0f);
    [button setBackgroundImage:[UIImage imageNamed:@"HomeTimelineBlank.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//LogoNavigationBar.png"]];
    //self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view.backgroundColor = [UIColor whiteColor];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    //Notification listen
    NSString *notificationName = @"ESNotification";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useNotificationWithString:) name:notificationName object:nil];

    // recognise taps on navigation bar to hide
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(easterButtonTap)];
    gestureRecognizer.numberOfTapsRequired = 1;
    // create a view which covers most of the tap bar to
    // manage the gestures - if we use the navigation bar
    // it interferes with the nav buttons
    CGRect frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, 44);
    UIView *navBarTapView = [[UIView alloc] initWithFrame:frame];
    [self.navigationController.navigationBar addSubview:navBarTapView];
    navBarTapView.backgroundColor = [UIColor clearColor];
    [navBarTapView setUserInteractionEnabled:YES];
    [navBarTapView addGestureRecognizer:gestureRecognizer];
 
    
    if (![[[PFUser currentUser] objectForKey:@"firstLaunch"] isEqualToString:@"Yes"] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] isEqualToString:@"Yes"]) {
        // On first launch, this block will execute
        [self firstLogin];
    }
}
- (void)firstLogin {
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        ESEditProfileViewController *profileViewController = [[ESEditProfileViewController alloc] initWithNibName:nil bundle:nil andOptionForTutorial:@"YES"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        [self presentViewController:navController animated:YES completion:nil];
    });
    
    PFQuery *sensitiveDataQuery = [PFQuery queryWithClassName:@"SensitiveData"];
    [sensitiveDataQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    PFObject *sensitiveData = [sensitiveDataQuery getFirstObject];
    BOOL isLinkedToFacebook = [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];

    if (isLinkedToFacebook) {
        int i1 = arc4random() % 10;
        int i2 = arc4random() % 10;
        int i3 = arc4random() % 10;
        int i4 = arc4random() % 10;
        
        NSString *pin = [NSString stringWithFormat:@"%i%i%i%i",i1,i2,i3,i4];
        
        if (sensitiveData) {
            
            [sensitiveData setObject:pin forKey:@"PIN"];
            [sensitiveData saveInBackgroundWithBlock:^(BOOL result, NSError *error){
                if (error) {
                    [sensitiveData saveEventually];
                }
            }];
        }
        else {
            PFObject *_sensitiveData = [PFObject objectWithClassName:@"SensitiveData"];
            [_sensitiveData setObject:[PFUser currentUser] forKey:@"user"];
            [_sensitiveData setObject:pin forKey:@"PIN"];
            PFACL *sensitive = [PFACL ACLWithUser:[PFUser currentUser]];
            [sensitive setReadAccess:YES forUser:[PFUser currentUser]];
            [sensitive setWriteAccess:YES forUser:[PFUser currentUser]];
            _sensitiveData.ACL = sensitive;
            [_sensitiveData saveEventually];
            
        }
        
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Since you have logged in with your Facebook Account, you have no classic username and password to log in. But, in certain cases, we need to verify your identity. We do this by asking you the following personal PIN \n\n\n   %i%i%i%i  \n\n\nYou can change this PIN in your settings. Do not forget it.",nil),i1,i2,i3,i4];
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        alert.shouldDismissOnTapOutside = YES;
        
        [alert alertIsDismissed:^{
            NSLog(@"SCLAlertView dismissed!");
        }];
        
        [alert showInfo:self.tabBarController title:@"Info" subTitle:message closeButtonTitle:@"OK." duration:0.0f];
    }

}
- (void)easterButtonTap {
    if (monster == NO) {
        UILabel *titleLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)]; //<<---- Actually will be auto-resized according to frame of navigation bar;
        [titleLabelView setBackgroundColor:[UIColor clearColor]];
        [titleLabelView setTextAlignment: NSTextAlignmentCenter];
        [titleLabelView setTextColor:[UIColor whiteColor]];
        [titleLabelView setFont:[UIFont systemFontOfSize: 27]]; //<<--- Greatest font size
        [titleLabelView setAdjustsFontSizeToFitWidth:YES]; //<<---- Allow shrink
        // [titleLabelView setAdjustsLetterSpacingToFitWidth:YES];  //<<-- Another option for iOS 6+
        titleLabelView.text = @"";
        self.navigationItem.titleView = titleLabelView;
        monster = YES;
    }
    else if (monster == YES) {
        UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//LogoNavigationBar.png"]];
        self.navigationItem.titleView = title;
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"spaceInvader2"]) {
            SCLAlertView *alert =[[SCLAlertView alloc]init];
            UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
            [alert showCustom:self.tabBarController image:[UIImage imageNamed:@"spaceInvader.png"] color:color title:@"Space Invader" subTitle:NSLocalizedString(@"You found one of the rare space invaders! Go and find the others to see what happens!", nil) closeButtonTitle:@"OK" duration:0.0];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"spaceInvader2"];
        }
        monster = NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    self.tableView.tag = 0;
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.tableView.tag = 1;
    [self loadObjects];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xcc0900);

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.container.panMode = MFSideMenuPanModeDefault;
    
}

#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        
        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        [self.blankTimelineView removeFromSuperview];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
        [self.tableView reloadData];
    }
    [self.refreshControl endRefreshing];
}


#pragma mark - ()

- (void)inviteFriendsButtonAction:(id)sender {
    ESFindFriendsViewController *detailViewController = [[ESFindFriendsViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (void)useNotificationWithString:(NSNotification *)notification //use notification method and logic
{
    // This key must match the key in postNotificationWithString: exactly.
    
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [notification userInfo];
    NSString *stringValueToUse = [dictionary valueForKey:key];

    if ([stringValueToUse isEqualToString:@"OpenMyTasks"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        GeotificationsViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"VDI"];
        [self.navigationController pushViewController:dest animated:YES];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
 
    }
    else if ([stringValueToUse isEqualToString:@"OpenMyTravels"]) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
        ESMyTravels *popularView = [[ESMyTravels alloc] initWithStyle:UITableViewStyleGrouped];
       [self.navigationController pushViewController:popularView animated:YES];
        
        /*
        */
       /* ESMyTravels *popularView = [[ESMyTravels alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:popularView animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    */
      /*  dispatch_async(dispatch_get_main_queue(), ^{
            ESEditProfileViewController *profileViewController = [[ESEditProfileViewController alloc] initWithNibName:nil bundle:nil andOptionForTutorial:@"YES"];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
            [self presentViewController:navController animated:YES completion:nil];
            
            
            */
    }
    if([stringValueToUse isEqualToString:@"ProfileOpen"])
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
        
    }
    else if ([stringValueToUse isEqualToString:@"LogHimOut"])
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
        
    }
    else if ([stringValueToUse isEqualToString:@"FindFriendsOpen"])
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        ESFindFriendsViewController *findFriendsVC = [[ESFindFriendsViewController alloc] init];
        [self.navigationController pushViewController:findFriendsVC animated:YES];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
    }
    else if ([stringValueToUse isEqualToString:@"OpenRecentFeed"]) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
        ESRecentViewController *popularView = [[ESRecentViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:popularView animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    else if ([stringValueToUse isEqualToString:@"MailUs"]) {
        if ([MFMailComposeViewController canSendMail]) {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
            NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
            NSString *model = [[UIDevice currentDevice] model];
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
            mailComposer.mailComposeDelegate = self;
            [mailComposer setToRecipients:[NSArray arrayWithObjects: @"support@yourcustommail.com",nil]];
            [mailComposer setSubject:[NSString stringWithFormat: @"v%@ Support",version]];
            NSString *supportText = [NSString stringWithFormat:@"Device: %@\niOS Version: %@\nRequest ID: %@\n               _________________\n\n",model,iOSVersion,[[PFUser currentUser]objectId]];
            supportText = [supportText stringByAppendingString:NSLocalizedString(@"Please describe your problem or question. We will answer you within 24 hours. For a flawless treatment of your query, make sure to not delete the above indicated iOS Version and Request ID.\n               _________________", nil)];
            [mailComposer setMessageBody:supportText isHTML:NO];
            mailComposer.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:mailComposer animated:YES completion:nil];
            
        } else {
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            [alert showError:self.tabBarController title:NSLocalizedString(@"Hold On...", nil)
                    subTitle:NSLocalizedString(@"You have no active email account on your device - but you can still contact us under:\n\nsupport@yourdomain.com",nil)
            closeButtonTitle:@"OK" duration:0.0f];
        }
        
        
    }
    else if ([stringValueToUse isEqualToString:@"OpenSettings"])
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            ESSettingsViewController *settingsViewController = [[ESSettingsViewController alloc] initWithNibName:nil bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            [self presentViewController:navController animated:YES completion:nil];
        });
        
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
        
    }
    
    else if ([stringValueToUse isEqualToString:@"AccountDeletion"]) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        [self performSelector:@selector(logoutHelper) withObject:nil afterDelay:0.8];
    }
    else if ([stringValueToUse isEqualToString:@"OpenPopularFeed"]) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
        ESPopularViewController *popularView = [[ESPopularViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:popularView animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        
    }

}
#pragma mark - Alertview

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = rect.size;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GasITTermsofService" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];

    
    
    if (alertView.tag == 99) {
        if (buttonIndex == 0) {
            PFUser *user= [PFUser currentUser];
            [user setObject:@"Yes" forKey:@"acceptedTerms"];
            [user saveInBackground];
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: path]];
            //TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.google.com"]];
            //webViewController.hidesBottomBarWhenPushed = YES;
            //[self.navigationController pushViewController:webViewController animated:YES];
        }
    }
    
}
#pragma mark - MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)logoutHelper {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
}
- (void)newHashtagSearch {
    ESSearchHashtagTableViewController *privateview = [[ESSearchHashtagTableViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:privateview];
    [self presentViewController:navController animated:YES completion:nil];
}
- (NSIndexPath *)_indexPathForPaginationCell {
    return [NSIndexPath indexPathForRow:0 inSection:[self.objects count]];
    
}
@end
