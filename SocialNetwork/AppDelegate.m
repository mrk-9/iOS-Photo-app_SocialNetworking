//
//  AppDelegate.m
//  GasIT
//
//  Created by OrbinV on 6/05/2014.
//  Copyright (c) 2014 OrbinV. All rights reserved.
//
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Geotification.h"
#import "GeotificationsViewController.h"
#import "Utilities.h"
#import "ESMyTravels.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <Parse/Parse.h>
#import "SCSettings.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKShareKit/FBSDKShareKit.h>



//Apr29,2016
#import <Parse/Parse.h>

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)

@import CoreLocation;

@interface AppDelegate()<CLLocationManagerDelegate>


@property (nonatomic, strong) ESHomeViewController *homeViewController;
@property (nonatomic, strong) ESActivityFeedViewController *activityViewController;
@property (nonatomic, strong) ESWelcomeViewController *welcomeViewController;
@property (nonatomic, strong) ESAccountViewController *accountViewController;
@property (nonatomic, strong) ESTravelTimeline *accountsViewController;
@property (nonatomic, strong) ESConversationViewController *messengerViewController;

@end


@implementation AppDelegate
@synthesize cameraButton;
#pragma mark - Class Methods

+ (void)initialize
{
    // Nib files require the type to have been loaded before they can do the wireup successfully.
    // http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime
    [FBSDKLoginButton class];
    [FBSDKProfilePictureView class];
 
}

#pragma mark - UIApplicationDelegate
- (void)crash {
    [NSException raise:NSGenericException format:@"Everything is ok. This is just a test crash."];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
[PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [FBSDKAccessToken currentAccessToken];

    [FBSDKLoginButton class];

    self.locationManager = [CLLocationManager new];
    [self.locationManager setDelegate:self];
    [self.locationManager requestAlwaysAuthorization];
    
   // [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil]];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // ****************************************************************************
    // Parse initialization
    //PARSE NOTIFICATION
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    //[Parse setApplicationId:@"K5CbRYD1DTLyUKi1uRpFb91EX4PM1OZp1tEcKhnw" clientKey:@"lvl5zB9YwA9TjB8Kw3eNCJFloqfrlsm7nJhVSmAg"];
   [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
      configuration.applicationId = @"K5CbRYD1DTLyUKi1uRpFb91EX4PM1OZp1tEcKhnw";
        configuration.clientKey = @"lvl5zB9YwA9TjB8Kw3eNCJFloqfrlsm7nJhVSmAg";
       configuration.server = @"https://parseapi.back4app.com";

    
    // ****************************************************************************
    [Firebase setOption:@"persistence" to:@YES];
    // Track app open.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.badge = 0;
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [currentInstallation saveEventually];
        }
    } ];
   }]];
    PFACL *defaultACL = [PFACL ACL];
    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    // PFObject *privateData = [PFObject objectWithClassName:@"kESStoryClassKey"];
    //privateData.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    //[privateData setObject:[PFUser currentUser] forKey:@"user"];
    
    //[[PFUser currentUser] setObject:privateData forKey:@"privateData"];
    
    
    // Set up our app's global UIAppearance
    [self setupAppearance];

#ifdef __IPHONE_8_0
    
    if(IS_OS_8_OR_LATER) {
        //Right, that is the point
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"pushnotifications"]){
            if ([defaults boolForKey:@"pushnotifications"] == NO ) {
                [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            }
        }
    }
#endif
    
    if(IS_OS_8_OR_LATER) {
        //Right, that is the point, no need to do anything here
        
    }
    else {
        //register to receive notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
         UIRemoteNotificationTypeAlert|
         UIRemoteNotificationTypeSound];
    }
    
    // Use Reachability to monitor connectivity
    [self monitorReachability];
    
    self.welcomeViewController = [[ESWelcomeViewController alloc] init];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.welcomeViewController];
    self.navController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    [self handlePush:launchOptions];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    [[PFUser currentUser] setObject:language forKey:@"language"];
    [[PFUser currentUser] saveEventually];
    
    [self.window makeKeyAndVisible];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    imageView.image = [UIImage imageNamed:@"BackgroundLeather.png"];
    
    self.locationManager = [CLLocationManager new];
    [self.locationManager setDelegate:self];
    [self.locationManager requestAlwaysAuthorization];
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil]];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self handlePush:launchOptions]; // Call the handle push method with the payload

    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

/*- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([self handleActionURL:url]) {
        return YES;
    }
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils bsdsession]];
}*/

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [currentInstallation saveEventually];
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:ESAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        // Track app opens due to a push notification being acknowledged while the app wasn't active.
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
    NSString *remoteNotificationPayload = [userInfo objectForKey:kESPushPayloadPayloadTypeKey];
    if ([PFUser currentUser]) {
        if ([remoteNotificationPayload isEqualToString:@"m"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receivedMessage" object:nil userInfo:nil];
            /*
             UITabBarItem *tabBarItem = [[self.tabBarController.viewControllers objectAtIndex:ESChatTabBarItemIndex] tabBarItem];
             
             NSString *currentBadgeValue = tabBarItem.badgeValue;
             
             if (currentBadgeValue && currentBadgeValue.length > 0) {
             NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
             NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
             NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
             tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
             } else {
             tabBarItem.badgeValue = @"1";
             }*/
            
        }
        else if ([self.tabBarController viewControllers].count > ESActivityTabBarItemIndex) {
            UITabBarItem *tabBarItem = [[self.tabBarController.viewControllers objectAtIndex:ESActivityTabBarItemIndex] tabBarItem];
            
            NSString *currentBadgeValue = tabBarItem.badgeValue;
            
            if (currentBadgeValue && currentBadgeValue.length > 0) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
                NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
                tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
            } else {
                tabBarItem.badgeValue = @"1";
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];

    
    // Clear badge and update installation, required for auto-incrementing badges.
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveInBackground];
    }
    
    // Clears out all notifications from Notification Center.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.badge = 0;
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [currentInstallation saveEventually];
        }
    }];
//    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    if ([PFUser currentUser]) {
        if (![[[PFUser currentUser] objectForKey:@"acceptedTerms"] isEqualToString:@"Yes"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Terms of Use", nil) message:NSLocalizedString(@"Please accept the terms of use before using this app",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"I accept", nil), NSLocalizedString(@"Show terms", nil), nil];
            [alert show];
            alert.tag = 99;
            
            
            [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
                if (error) {
                    NSLog(@"Received error while fetching deferred app link %@", error);
                }
                if (url) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];

            
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        [self handleRegionEvent:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        [self handleRegionEvent:region];
    }
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)aTabBarController shouldSelectViewController:(UIViewController *)viewController {
    // The empty UITabBarItem behind our Camera button should not load a view controller
    return ![viewController isEqual:aTabBarController.viewControllers[ESEmptyTabBarItemIndex]];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (![[PFUser currentUser] objectForKey:@"uploadedProfilePicture"]) {
        [ESUtility processProfilePictureData:_data];
    }
    else {
        //nothing to do here, actually
    }
}


#pragma mark - AppDelegate

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}
- (void)presentTabBarController {
    
    self.tabBarController = [[ESTabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.homeViewController = [[ESHomeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.homeViewController setFirstLaunch:firstLaunch];
    self.activityViewController = [[ESActivityFeedViewController alloc] initWithStyle:UITableViewStylePlain];
    self.accountViewController = [[ESAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
    // self.accountsViewController = [[ESTravelTimeline alloc] initWithStyle:UITableViewStyleGrouped];
    self.accountViewController.user = [PFUser currentUser];
    self.accountsViewController.user = [PFUser currentUser];
    
    self.messengerViewController = [[ESConversationViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    UINavigationController *emptyNavigationController = [[UINavigationController alloc] init];
    UINavigationController *activityFeedNavigationController = [[UINavigationController alloc] initWithRootViewController:self.activityViewController];
    UINavigationController *accountNavigationController = [[UINavigationController alloc] initWithRootViewController:self.accountViewController];
    //UINavigationController *accountsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.accountsViewController];
    UINavigationController *chatNavigationController = [[UINavigationController alloc] initWithRootViewController:self.messengerViewController];
    
    UIImage *image1 = [[UIImage alloc]init];
    image1 = [self imageNamed:@"IconHome.png" withColor:[UIColor colorWithRed:204.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0]];
    
    UIGraphicsBeginImageContext(self.window.frame.size);
    UIImage *homeImage1 = [UIImage imageNamed:@"IconHome.png"];
    UIImage *homeImage2 = [UIImage imageNamed:@"IconHomeSelected.png"];
    UIGraphicsEndImageContext();
    
    
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Home", nil) image:[homeImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[homeImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeTabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor lightGrayColor] } forState:UIControlStateNormal];
    [homeTabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor colorWithRed:204.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0] } forState:UIControlStateSelected];
    
    UIImage *activityImage1 = [UIImage imageNamed:@"IconActivity.png"];
    UIImage *activityImage2 = [UIImage imageNamed:@"IconActivitySelected.png"];
    UITabBarItem *activityFeedTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Activity", nil) image:[activityImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[activityImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [activityFeedTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor lightGrayColor] } forState:UIControlStateNormal];
    [activityFeedTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:204.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0] } forState:UIControlStateSelected];
    
    UIImage *profileImage1 = [UIImage imageNamed:@"IconProfile.png"];
    UIImage *profileImage2 = [UIImage imageNamed:@"IconProfileSelected.png"];
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Profile", nil) image:[profileImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[profileImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [profileTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor lightGrayColor] } forState:UIControlStateNormal];
    [profileTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:204.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0] } forState:UIControlStateSelected];
    
    UIImage *chatImage1 = [UIImage imageNamed:@"IconChat.png"];
    UIImage *chatImage2 = [UIImage imageNamed:@"IconChatSelected.png"];
    UITabBarItem *chatTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Messenger", nil) image:[chatImage1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[chatImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [chatTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor lightGrayColor] } forState:UIControlStateNormal];
    [chatTabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:204.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0] } forState:UIControlStateSelected];
    
    [homeNavigationController setTabBarItem:homeTabBarItem];
    [activityFeedNavigationController setTabBarItem:activityFeedTabBarItem];
    [accountNavigationController setTabBarItem:profileTabBarItem];
    [chatNavigationController setTabBarItem:chatTabBarItem];
    
    [[UITabBar appearance] setTranslucent:NO];
    UIViewController * leftDrawer = [[SideViewController alloc] init];
    
    [self.tabBarController.tabBar setClipsToBounds:YES];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[ homeNavigationController, accountNavigationController, emptyNavigationController, chatNavigationController, activityFeedNavigationController];
    
    self.container = [MFSideMenuContainerViewController
                      containerWithCenterViewController:self.tabBarController
                      leftMenuViewController:leftDrawer
                      rightMenuViewController:nil];
    
    [self.navController setViewControllers:@[ self.welcomeViewController, self.container ] animated:NO];
    
}

- (void)logOut {
    // clear cache
    [[ESCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kESUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kESUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] removeObjectForKey:kESInstallationUserKey];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [currentInstallation saveEventually];
        }
    }];
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];

    // clear out cached data, view controllers, etc
    [self.navController popToRootViewControllerAnimated:NO];
    
    [ProgressHUD dismiss];
    self.homeViewController = nil;
    self.activityViewController = nil;
}

#pragma mark - location methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.coordinate = newLocation.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

#pragma mark - manager methods

- (void)refreshESConversationViewController {
    [self.messengerViewController loadChatRooms];
}
- (void)locationManagerStart {
    
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManagerStop {
    
    [self.locationManager stopUpdatingLocation];
}
#pragma mark - ()

// Set up appearance parameters to achieve Netzwierk's custom look and feel
- (void)setupAppearance {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f]
     forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:32.0f/255.0f green:19.0f/255.0f blue:16.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHue:204.0f/360.0f saturation:76.0f/100.0f brightness:86.0f/100.0f alpha:1]];
    UIColor *color = [UIColor colorWithHue:204.0f/360.0f saturation:76.0f/100.0f brightness:86.0f/100.0f alpha:1];
    if (IS_IPHONE6) {
        cameraButton = [[UIImageView alloc]initWithImage:[self imageFromColor:color forSize:CGSizeMake(75, 49) withCornerRadius:0]];
        cameraButton.frame = CGRectMake( 150.0f, 0.0f, 75.0f, 49);
    }
    else {
        cameraButton = [[UIImageView alloc]initWithImage:[self imageFromColor:color forSize:CGSizeMake(64, 49) withCornerRadius:0]];
        cameraButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2 - 64/2, 0.0f, 64.0f, 49);
    }
    cameraButton.tag = 1;
    [[UITabBar appearance] insertSubview:cameraButton atIndex:1];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    NSDictionary * navBarTitleTextAttributes =
    @{ NSForegroundColorAttributeName : [UIColor whiteColor],
       NSShadowAttributeName          : shadow,
       NSFontAttributeName            : [UIFont fontWithName:@"Helvetica Neue" size:18] };
    
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
    
    
}

- (void)monitorReachability {
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];
    
    hostReach.reachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
        
        if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
            // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
            // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
            [self.homeViewController loadObjects];
        }
    };
    
    hostReach.unreachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
    };
    
    [hostReach startNotifier];
}

- (void)handlePush:(NSDictionary *)launchOptions {
    
    // If the app was launched in response to a push notification, we'll handle the payload here
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ESAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:remoteNotificationPayload];
        
        if (![PFUser currentUser]) {
            return;
        }
        
        // If the push notification payload references a photo, we will attempt to push this view controller into view
        NSString *photoObjectId = [remoteNotificationPayload objectForKey:kESPushPayloadPhotoObjectIdKey];
        if (photoObjectId && photoObjectId.length > 0) {
            [self shouldNavigateToPhoto:[PFObject objectWithoutDataWithClassName:kESPhotoClassKey objectId:photoObjectId]];
            return;
        }
        
        // If the push notification payload references a user, we will attempt to push their profile into view
        NSString *fromObjectId = [remoteNotificationPayload objectForKey:kESPushPayloadFromUserObjectIdKey];
        if (fromObjectId && fromObjectId.length > 0) {
            PFQuery *query = [PFUser query];
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [query getObjectInBackgroundWithId:fromObjectId block:^(PFObject *user, NSError *error) {
                if (!error) {
                    UINavigationController *homeNavigationController = self.tabBarController.viewControllers[ESHomeTabBarItemIndex];
                    self.tabBarController.selectedViewController = homeNavigationController;
                    
                    ESTravelTimeline *accountsViewController = [[ESTravelTimeline alloc] initWithStyle:UITableViewStyleGrouped];
                    accountsViewController.user = (PFUser *)user;
                    [homeNavigationController pushViewController:accountsViewController animated:YES];
                    
                    ESAccountViewController *accountViewController = [[ESAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    accountViewController.user = (PFUser *)user;
                    [homeNavigationController pushViewController:accountViewController animated:YES];
                }
            }];
        }
    }
}

- (BOOL)handleActionURL:(NSURL *)url {
    if ([[url host] isEqualToString:kESLaunchURLHostTakePicture]) {
        if ([PFUser currentUser]) {
            return [self.tabBarController shouldPresentPhotoCaptureController];
        }
    } else {
        if ([[url fragment] rangeOfString:@"^pic/[A-Za-z0-9]{10}$" options:NSRegularExpressionSearch].location != NSNotFound) {
            NSString *photoObjectId = [[url fragment] substringWithRange:NSMakeRange(4, 10)];
            if (photoObjectId && photoObjectId.length > 0) {
                [self shouldNavigateToPhoto:[PFObject objectWithoutDataWithClassName:kESPhotoClassKey objectId:photoObjectId]];
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)shouldNavigateToPhoto:(PFObject *)targetPhoto {
    for (PFObject *photo in self.homeViewController.objects) {
        if ([photo.objectId isEqualToString:targetPhoto.objectId]) {
            targetPhoto = photo;
            break;
        }
    }
    
    // if we have a local copy of this photo, this won't result in a network fetch
    [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            UINavigationController *homeNavigationController = [[self.tabBarController viewControllers] objectAtIndex:ESHomeTabBarItemIndex];
            [self.tabBarController setSelectedViewController:homeNavigationController];
            
            ESPhotoDetailsViewController *detailViewController = [[ESPhotoDetailsViewController alloc] initWithPhoto:object];
            [homeNavigationController pushViewController:detailViewController animated:YES];
        }
    }];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}
- (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.02, 0.0)
                               green:MAX(g - 0.02, 0.0)
                                blue:MAX(b - 0.02, 0.0)
                               alpha:a];
    return nil;
}

- (void) wouldYouPleaseChangeTheDesign: (UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
    [[PFUser currentUser] setObject:colorAsString forKey:@"profileColor"];
    [[PFUser currentUser] saveEventually];
    
}
- (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color {
    // load the image
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{  CGRect rect = [[UIScreen mainScreen] bounds];
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
        else [[UIApplication sharedApplication] openURL:[NSURL URLWithString: path]];//Your link here
        
        /*               
         */
        
    }
}
#pragma mark - Helpers

- (void)handleRegionEvent:(CLRegion *)region{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSString *message = [self noteFromRegionIdentifier:region.identifier];
        if (message) {
            UIViewController *viewController = self.window.rootViewController;
            if (viewController) {
                [Utilities showSimpleAlertWithTitle:nil message:message viewController:viewController];
            }
        }
    }else{
        UILocalNotification *notification = [UILocalNotification new];
        [notification setAlertBody:[self noteFromRegionIdentifier:region.identifier]];
        [notification setSoundName:@"Default"];
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

- (NSString *)noteFromRegionIdentifier:(NSString *)identifier{
    NSArray *savedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kSavedItemsKey];
    if(savedItems){
        for (id savedItem in savedItems) {
            Geotification *geotification = [NSKeyedUnarchiver unarchiveObjectWithData:savedItem];
            if ([geotification isKindOfClass:[Geotification class]]) {
                if ([geotification.identifier isEqualToString:identifier]) {
                    return geotification.note;
                }
            }
        }
    }
    return nil;
}



@end