//
//  ESDeleteAccountNonFacebookViewController.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.09.14.
//
//

#import <UIKit/UIKit.h>

@interface ESDeleteAccountNonFacebookViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
/**
 *  Actual tableview we display in the viewcontroller.
 */
@property (nonatomic, strong) UITableView *_tableView;
/**
 *  Username textfield.
 */
@property (nonatomic, strong) UITextField *tf;
/**
 *  Password textfield.
 */
@property (nonatomic, strong) UITextField *tf2;
/**
 *  Delete the PFUser an his account.
 *
 *  @param user PFUser that sould be deleted
 */
- (void)deleteAccount:(PFUser *)user;

@end

