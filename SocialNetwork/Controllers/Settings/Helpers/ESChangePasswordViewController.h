//
//  ESChangePasswordViewController.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.09.14.
//
//

#import <UIKit/UIKit.h>

@interface ESChangePasswordViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
/**
 *  The actual tableview that is displayed in the viewcontroller.
 */
@property (nonatomic, strong) UITableView *_tableView;
/**
 *  Username textfield.
 */
@property (nonatomic, strong) UITextField *tf;
/**
 *  Old password textfield.
 */
@property (nonatomic, strong) UITextField *tf2;
/**
 *  New password textfield.
 */
@property (nonatomic, strong) UITextField *tf3;

@end


