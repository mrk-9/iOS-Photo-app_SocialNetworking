//
//  SideViewController.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 26.06.14.
//
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "MBProgressHUD.h"


@interface SideViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
/**
 *  Actual navigationcontroller that is displayed.
 */
@property (nonatomic, strong) UINavigationController *navController;
/**
 *  Tableview we add to the view and where we display the different cells
 */
@property (nonatomic, strong) UITableView * _tableView;
/**
 *  Activity indicator showing that something is going on.
 */
@property (nonatomic, strong) UIActivityIndicatorView *hud;
/**
 *  Progress hud indicating an activity.
 */
@property (nonatomic, strong) MBProgressHUD *mbhud;
/**
 *  Dummy method for the Logout action. We use this method to be able to call it after a short delay to avoid to present unloaded viewcontrollers in case the device is not fast enough.
 */
- (void) dummyLogout;
- (void)postNotificationWithString:(NSString *)notification;
@end
