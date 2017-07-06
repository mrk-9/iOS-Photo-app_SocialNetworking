//
//  ESChangePINViewController.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 07.09.14.
//
//

#import <UIKit/UIKit.h>

@interface ESChangePINViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
/**
 *  Actual tableview we display in the viewcontroller.
 */
@property (nonatomic, strong) UITableView *_tableView;
/**
 *  Old PIN.
 */
@property (nonatomic, strong) UITextField *tf;
/**
 *  New PIN.
 */
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UIButton *doneButton;
/**
 *  Change the PIN if everything has been entered correctly.
 */
- (void)doneButtonTap;

@end


