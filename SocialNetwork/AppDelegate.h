//
//  AppDelegate.h
//  GasIT
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ESTabBarController.h"
#import "MFSideMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "ESHomeViewController.h"
#import "ESLogInViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "ESAccountViewController.h"
#import "ESWelcomeViewController.h"
#import "ESActivityFeedViewController.h"
#import "ESPhotoDetailsViewController.h"
#import "ESSignUpViewController.h"
#import "MMDrawerController.h"
#import "SideViewController.h"
#import "MFSideMenu.h"
#import "SCLAlertView.h"
#import "ESConversationViewController.h"
#import "ESHashtagTimelineViewController.h"
#import "ESTravelTimeline.h"
@class ESMyTravels;

@interface AppDelegate : UIResponder <CLLocationManagerDelegate,UIApplicationDelegate, NSURLConnectionDataDelegate, UITabBarControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    /**
     *  Data of the Facebook Profile Picture
     */
    NSMutableData *_data;
    /**
     *  Whether or not this a first launch
     */
    BOOL firstLaunch;
    }


/**
 *  The window of the main controller
 */
@property (nonatomic, strong) UIWindow *window;
/**
 *  The tabbarcontroller containing all the other controllers.
 */
@property (nonatomic, strong) ESTabBarController *tabBarController;
/**
 *  A navigationcontroller used to push new viewcontrollers
 */
@property (strong, nonatomic) ESMyTravels *viewController;


@property (nonatomic, strong) UINavigationController *navController;
/**
 *  Containing the tabbarcontroller and a sidebarcontroller
 */
@property (strong, nonatomic) MFSideMenuContainerViewController *container;
/**
 *  Is there an internet connection or not?
 */
@property (nonatomic, readonly) int networkStatus;
/**
 *  Location manager for location services
 */
@property (strong, nonatomic) CLLocationManager *locationManager;
/**
 *  Coordinates of the user
 */
@property (nonatomic) CLLocationCoordinate2D coordinate;
/**
 *  The big blue camera button in the tabbar
 */
@property (nonatomic, strong) UIImageView *cameraButton;
/**
 *  Sets the main appearance of the app
 */
- (void)setupAppearance;
/**
 *  Used to get the user back to the app when logging in through facebook
 */
- (BOOL)handleActionURL:(NSURL *)url;
/**
 *  Boolean checking if the Parse services are currently available
 */
- (BOOL)isParseReachable;
/**
 *  Inits and presents the tabbarcontroller, the main controller of the app.
 */
- (void)presentTabBarController;
/**
 *  Logging a user out an showing the welcomviewcontroller.
 */
- (void)logOut;
/**
 *  Creates and returns an image from a given color
 *
 *  @param color  color of the image
 *  @param size   size of the image
 *  @param radius cornerradius of the image
 *
 *  @return the created image
 */
//@property(nonatomic,retain) NSString *deviceToken;
//@property(nonatomic,retain)NSString *userName;

//-(void)registerUserForPushNotificationToApp42Cloud:(NSString*)deviceToken;
- (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;
/**
 *  The design of the profile page navbar has been changed, now save the respective color.
 */
- (void) wouldYouPleaseChangeTheDesign: (UIColor *)color;
- (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;
//-(NSString*)getDeviceToken1;

@end
