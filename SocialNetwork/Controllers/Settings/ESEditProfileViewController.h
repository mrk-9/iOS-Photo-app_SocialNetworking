//
//  ESEditProfileViewController.h
//  d'Netzwierk
//
//  Created by Eric Schanet on 08.11.14.
//
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "PXAlertView.h"
#import "ESDeleteAccountViewController.h"
#import "ESChangePasswordViewController.h"
#import "ESChangePINViewController.h"
#import "ESDeleteAccountNonFacebookViewController.h"
#import "ESEditProfileTableViewCell.h"
#import "ESEditProfilePhotoTableViewCell.h"
#import "ESEditProfilePrivateTableViewCell.h"
#import "MBProgressHUD.h"
#import "NonPasteUITextField.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ResizeAdditions.h"
#import "SCLAlertView.h"
#import "ColorPickerViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

/**
 *  Interface of the ESEditProfileViewController, a tableview controller with custom cells containing the information of the user.
 */
@interface ESEditProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

/**
 *  The tableview that didplays the cells.
 */
@property (nonatomic, strong) UITableView *_tableView;
/**
 *  We request a background task to upload the profile picture and header picture and save it in this variable.
 */
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
/**
 *  Actual PFFile of the profile picture or header picture the user wants to upload.
 */
@property (nonatomic, strong) PFFile *photoFile;
/**
 *  Thumbnail file of the profile picture or header picture the user wants to upload.
 */
@property (nonatomic, strong) PFFile *thumbnailFile;
/**
 *  Imageview containing the header picture of the user.
 */
@property (nonatomic, strong) PFImageView *imageView1;
/**
 *  Imageview containing the profile picture of the user.
 */
@property (nonatomic, strong) PFImageView *imageView2;
/**
 *  Imageview containing the color of the navigation bar on the user's profile page.
 */
@property (nonatomic, strong) UIImageView *imageView3;
/**
 *  Once the user has chosen a new profile or header picture, we save it into this UIImage and then upload it.
 */
@property (nonatomic, strong) UIImage *imageUser;
/**
 *  TextField containing the user's display name. Editable.
 */
@property (nonatomic, strong) UITextField *nameTextField;
/**
 *  TextField containing the user's mention name. Editable.
 */
@property (nonatomic, strong) UITextField *mentionTextField;
/**
 *  TextField containing the user's city. Editable.
 */
@property (nonatomic, strong) UITextField *cityTextField;
/**
 *  TextField containing the user's website. Editable.
 */
@property (nonatomic, strong) UITextField *websiteTextField;
/**
 *  TextField containing the user's email. Editable.
 */
@property (nonatomic, strong) UITextField *emailTextField;
/**
 *  TextField containing the user's birthday. Editable through a pickercontroller. No paste.
 */
@property (nonatomic, strong) NonPasteUITextField *birthdayTextField;
/**
 *  TextField containing the user's gender. Editable through a pickercontroller. No paste.
 */
@property (nonatomic, strong) NonPasteUITextField *genderTextField;
/**
 *  Personal color of the user's profile page.
 */
@property (nonatomic, strong) UIImageView *colorProfileView;
/**
 *  TextView containing the bio of the user. Editable.
 */
@property (nonatomic, strong) UITextView *bioTextview;
/**
 *  Save button in the navigation bar. When tapped, we check if the necessary information has been provided and the email is correct and then we save the user.
 */
@property (nonatomic, strong) UIBarButtonItem *saveInfoBtn;
/**
 *  PFObject containing all the private data of the user.
 */
@property (nonatomic, strong) PFObject *sensitiveData;
/**
 *  DatePickerView used to pick the birthday of the user.
 */
@property (nonatomic, strong) UIDatePicker *pickerView;
/**
 *  PickerView used to choose the gender of the user.
 */
@property (nonatomic, strong) UIPickerView *genderPicker;
/**
 *  Init method with an option for firstLaunch.
 *
 *  @param string YES if it's the user's first login, NO if not
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptionForTutorial:(NSString *)string;
/**
 *  Dismissing the controller without saving the information.
 */
- (void)done:(id)sender;
/**
 *  Called when the birthday has been picked, filling out the birthdayTextField programmatically.
 */
-(void) birthdayInputDidFinish;
/**
 *  Called when the gender has been picked, filling out the genderTextField programmatically.
 */
-(void) genderInputDidFinish;
/**
 *  User wants to change his profile picture, we're doing this here.
 */
-(void) changeProfilePicture;
/**
 *  Decides wether the image contains all the necessary informations.
 *
 *  @param anImage the actual image the user wants to upload
 *
 *  @return YES when the picture presents no errors, NO if not
 */
- (BOOL)shouldUploadImage:(UIImage *)anImage;
/**
 *  Check wether a string is a valid email.
 *
 *  @param checkString the string we want to check
 *
 *  @return YES if it is a valid mail, NO if not
 */
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
/**
 *  Called when the save button is tapped, we do scroll down to the email cell to force it to appear, so that we can check wether it's a valid email or not.
 */
- (void) presaveInformation;
/**
 *  The actual save method, used to save all the information.
 */
- (void)saveInformation;
/**
 *  Formatter method, changing the date to our desired format.
 *
 *  @param date the date that comes out of the datepicker, and has not our desired format
 *
 *  @return string with our desired date in an DD:MM:YYYY format
 */
- (NSString *)formatDate:(NSDate *)date;
/**
 *  Changes the color of the navigationbar in the user's profile picture.
 */
- (void) changeProfileColor;

@end
