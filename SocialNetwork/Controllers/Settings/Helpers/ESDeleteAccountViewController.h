//
//  ESDeleteAccountViewController.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.09.14.
//
//

#import <UIKit/UIKit.h>

@interface ESDeleteAccountViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
/**
 *  Actual tableview displayed in the viewcontroller.
 */
@property (nonatomic, strong) UITableView *_tableView;
/**
 *  PIN textfield.
 */
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UIButton *doneButton;
/**
 *  Dismiss the viewcontroller.
 */
- (void)done:(id)sender;
/**
 *  Check if the PIN is correct and then delete the PFUser and the account.
 *
 *  @param user PFUser that should be deleted
 */
- (void)deleteAccount:(PFUser *)user;
@end

