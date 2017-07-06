//
//  ESEditProfileViewController.m
//  d'Netzwierk
//
//  Created by Eric Schanet on 08.11.14.
//
//

#import "ESEditProfileViewController.h"
#import "TOWebViewController.h"

#define kOFFSET_FOR_KEYBOARD 80.0
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)

#define MAXLENGTH 40
#define MAX_LENGTH 110


BOOL changeHeader = YES;
BOOL tutorial;
CGFloat animatedDistance;

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

@implementation ESEditProfileViewController

@synthesize _tableView;
@synthesize nameTextField,cityTextField,websiteTextField,mentionTextField,bioTextview,saveInfoBtn, emailTextField,birthdayTextField,genderTextField, sensitiveData,pickerView,genderPicker,colorProfileView, imageView3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOptionForTutorial:(NSString *)string{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ([string isEqualToString:@"YES"]) {
        tutorial = YES;
    }
    else tutorial = NO;
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[[PFUser currentUser] objectForKey:@"acceptedTerms"] isEqualToString:@"Yes"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Terms of Use", nil) message:NSLocalizedString(@"Please accept the terms of use before using this app",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"I accept", nil), NSLocalizedString(@"Show terms", nil), nil];
        [alert show];
        alert.tag = 99;
        
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]) {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
        UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        self.navigationController.navigationBar.barTintColor = color;
    }
    else {
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xcc0900);
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    saveInfoBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(presaveInformation)];
    self.navigationItem.rightBarButtonItem = saveInfoBtn;
    saveInfoBtn.enabled = NO;
    saveInfoBtn.tintColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    if (tutorial == NO) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    }
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    
    [self._tableView setDelegate:self];
    [self._tableView setDataSource:self];
    [self.view addSubview:self._tableView];
    
    [self.view addSubview:_tableView];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SensitiveData"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *result, NSError *error) {
        if (!error) {
            sensitiveData = result;
        } else {
            if (tutorial == NO) {
                [ProgressHUD showError:NSLocalizedString(@"Connection error...", nil)];
            }
        }
    }];
    
}

#pragma mark - UINavigationBar-based actions

- (void)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SecondViewControllerDismissed" object:nil userInfo:nil];
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 3;
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
        default:
            return 30;
    };
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if (IS_IPHONE6) {
                return  85;
            }
            else return  105;
            
        }
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SettingsTableView1";
    static NSString *identifier2 = @"SettingsTableView2";
    if (indexPath.section == 0) {
        
        ESEditProfilePhotoTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        
        if ( cell == nil )
        {
            cell = [[ESEditProfilePhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Header Photo", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            self.imageView1 = [[PFImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
            self.imageView1.image = [UIImage imageNamed:@"AvatarPlaceholder.png"]; // placeholder image
            self.imageView1.file = (PFFile *)[[PFUser currentUser] objectForKey:kESUserHeaderPicSmallKey]; // remote image
            [cell addSubview:self.imageView1];
            [self.imageView1 loadInBackground];
        }
        
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Profile Photo", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            self.imageView2 = [[PFImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
            self.imageView2.image = [UIImage imageNamed:@"AvatarPlaceholder.png"]; // placeholder image
            self.imageView2.file = (PFFile *)[[PFUser currentUser] objectForKey:kESUserProfilePicSmallKey]; // remote image
            [cell addSubview:self.imageView2];
            [self.imageView2 loadInBackground];
            
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Personal color", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            NSArray *components = [[[PFUser currentUser] objectForKey:@"profileColor"] componentsSeparatedByString:@","];
            CGFloat r = [[components objectAtIndex:0] floatValue];
            CGFloat g = [[components objectAtIndex:1] floatValue];
            CGFloat b = [[components objectAtIndex:2] floatValue];
            CGFloat a = [[components objectAtIndex:3] floatValue];
            UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:a];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            self.imageView3 = [[PFImageView alloc] initWithFrame:CGRectMake(12, 7, 36, 36)];
            self.imageView3.backgroundColor = color;
            self.imageView3.layer.cornerRadius = 6;
            [cell addSubview:self.imageView3];
            
            
            [cell.contentView addSubview:colorProfileView];
            
            
        }
        return cell;
        
    }
    
    else if (indexPath.section == 1) {
        
        ESEditProfileTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[ESEditProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        
        
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Name", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
            nameTextField.adjustsFontSizeToFitWidth = YES;
            nameTextField.textColor = [UIColor blackColor];
            nameTextField.backgroundColor = [UIColor whiteColor];
            nameTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            nameTextField.textAlignment = UITextAlignmentLeft;
            nameTextField.delegate = self;
            nameTextField.placeholder = NSLocalizedString(@"Your name", nil);
            
            nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
            [nameTextField setEnabled: YES];
            if ([[PFUser currentUser] objectForKey:kESUserDisplayNameKey]) {
                nameTextField.text = [[PFUser currentUser] objectForKey:kESUserDisplayNameKey];
            }
            nameTextField.textColor = [UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
            nameTextField.font = [UIFont systemFontOfSize:16];;
            nameTextField.keyboardType = UIKeyboardTypeDefault;
            nameTextField.returnKeyType = UIReturnKeyDone;
            nameTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            nameTextField.tag = 0;
            [cell.contentView addSubview:nameTextField];
            
            
            
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Mention", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            NSString * string = [[PFUser currentUser] objectForKey:@"usernameFix"];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            mentionTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
            mentionTextField.adjustsFontSizeToFitWidth = YES;
            mentionTextField.textColor = [UIColor blackColor];
            mentionTextField.backgroundColor = [UIColor whiteColor];
            mentionTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            mentionTextField.textAlignment = UITextAlignmentLeft;
            mentionTextField.delegate = self;
            mentionTextField.placeholder = NSLocalizedString(@"Your mention name", nil);
            
            mentionTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
            [mentionTextField setEnabled: YES];
            if ([[PFUser currentUser] objectForKey:@"usernameFix"]) {
                mentionTextField.text = [NSString stringWithFormat:@"@%@",string];
            }
            mentionTextField.textColor = [UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
            mentionTextField.font = [UIFont systemFontOfSize:16];;
            mentionTextField.keyboardType = UIKeyboardTypeDefault;
            mentionTextField.returnKeyType = UIReturnKeyDone;
            mentionTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            mentionTextField.tag = 1;
            [cell.contentView addSubview:mentionTextField];
            
            
        }
        
        return cell;
    }
    else if (indexPath.section == 2) {
        
        ESEditProfileTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
        if ( cell == nil )
        {
            cell = [[ESEditProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Bio", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            NSString *string = [[PFUser currentUser] objectForKey:@"UserInfo"];
            CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100,FLT_MAX);
            CGSize expectedLabelSize = [string sizeWithFont:[UIFont systemFontOfSize:16]
                                          constrainedToSize:maximumLabelSize
                                              lineBreakMode:NSLineBreakByWordWrapping];
            
            bioTextview=[[UITextView alloc] initWithFrame:CGRectMake(90, 5, [UIScreen mainScreen].bounds.size.width - 100, expectedLabelSize.height+40)];
            bioTextview.font = [UIFont systemFontOfSize:16.0];
            bioTextview.text = NSLocalizedString(@"Place your bio here", nil);
            if ([[PFUser currentUser] objectForKey:@"UserInfo"]) {
                bioTextview.text= string;
            }
            bioTextview.backgroundColor = [UIColor clearColor];
            bioTextview.textColor=[UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
            bioTextview.editable=YES;
            bioTextview.keyboardType = UIKeyboardTypeDefault;
            bioTextview.returnKeyType = UIReturnKeyDone;
            bioTextview.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            bioTextview.textAlignment = UITextAlignmentLeft;
            bioTextview.delegate = self;
            
            
            [cell.contentView addSubview:bioTextview];
            
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"City", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
            cityTextField.adjustsFontSizeToFitWidth = YES;
            cityTextField.textColor = [UIColor blackColor];
            cityTextField.backgroundColor = [UIColor whiteColor];
            cityTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            cityTextField.textAlignment = UITextAlignmentLeft;
            cityTextField.delegate = self;
            cityTextField.placeholder = NSLocalizedString(@"New York", nil);
            
            cityTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
            [cityTextField setEnabled: YES];
            if ([[PFUser currentUser] objectForKey:@"Location"]) {
                cityTextField.text = [[PFUser currentUser] objectForKey:@"Location"];
            }
            cityTextField.textColor = [UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
            cityTextField.font = [UIFont systemFontOfSize:16];;
            cityTextField.keyboardType = UIKeyboardTypeDefault;
            cityTextField.returnKeyType = UIReturnKeyDone;
            cityTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            cityTextField.tag = 2;
            
            [cell.contentView addSubview:cityTextField];
            
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Website", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            websiteTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
            websiteTextField.adjustsFontSizeToFitWidth = YES;
            websiteTextField.textColor = [UIColor blackColor];
            websiteTextField.backgroundColor = [UIColor whiteColor];
            websiteTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            websiteTextField.textAlignment = UITextAlignmentLeft;
            websiteTextField.delegate = self;
            websiteTextField.placeholder = NSLocalizedString(@"www.princeton.edu", nil);
            
            websiteTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
            [websiteTextField setEnabled: YES];
            if ([[PFUser currentUser] objectForKey:@"Website"]) {
                websiteTextField.text = [[PFUser currentUser] objectForKey:@"Website"];
            }
            websiteTextField.textColor = [UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
            websiteTextField.font = [UIFont systemFontOfSize:16];;
            websiteTextField.keyboardType = UIKeyboardTypeDefault;
            websiteTextField.returnKeyType = UIReturnKeyDone;
            websiteTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            websiteTextField.tag = 3;
            
            [cell.contentView addSubview:websiteTextField];
            
        }
        
        return cell;
    }
    else if (indexPath.section == 3) {
        ESEditProfilePrivateTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier2];
        if ( cell == nil )
        {
            cell = [[ESEditProfilePrivateTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2];
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Birthday", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.textLabel.lineBreakMode = NSLineBreakByClipping;
            cell.textLabel.numberOfLines = 2;
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            NSString *string = [sensitiveData objectForKey:@"Birthday"];
            
            birthdayTextField = [[NonPasteUITextField alloc] initWithFrame:CGRectMake(130, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
            birthdayTextField.adjustsFontSizeToFitWidth = YES;
            birthdayTextField.textColor = [UIColor blackColor];
            birthdayTextField.backgroundColor = [UIColor whiteColor];
            birthdayTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            birthdayTextField.textAlignment = UITextAlignmentLeft;
            birthdayTextField.delegate = self;
            birthdayTextField.placeholder = NSLocalizedString(@"01.05.1918",nil);
            
            birthdayTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
            [birthdayTextField setEnabled: YES];
            if ([sensitiveData objectForKey:@"Birthday"]) {
                birthdayTextField.text = string;
            }
            birthdayTextField.textColor = [UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
            birthdayTextField.font = [UIFont systemFontOfSize:16];;
            birthdayTextField.keyboardType = UIKeyboardTypeDefault;
            birthdayTextField.returnKeyType = UIReturnKeyDone;
            birthdayTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            birthdayTextField.tag = 4;
            
            [cell.contentView addSubview:birthdayTextField];
            
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Gender", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            NSString *string = [sensitiveData objectForKey:@"Gender"];
            genderTextField = [[NonPasteUITextField alloc] initWithFrame:CGRectMake(130, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
            genderTextField.adjustsFontSizeToFitWidth = YES;
            genderTextField.textColor = [UIColor blackColor];
            genderTextField.backgroundColor = [UIColor whiteColor];
            genderTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            genderTextField.textAlignment = UITextAlignmentLeft;
            genderTextField.delegate = self;
            genderTextField.placeholder = NSLocalizedString(@"Male", nil);
            
            genderTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
            [genderTextField setEnabled: YES];
            if ([sensitiveData objectForKey:@"Gender"]) {
                genderTextField.text = string;
            }
            genderTextField.textColor = [UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
            genderTextField.font = [UIFont systemFontOfSize:16];;
            genderTextField.keyboardType = UIKeyboardTypeDefault;
            genderTextField.returnKeyType = UIReturnKeyDone;
            genderTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            genderTextField.tag = 5;
            
            [cell.contentView addSubview:genderTextField];
            
        }
        else if (indexPath.row == 0) {
            
            cell.textLabel.text = NSLocalizedString(@"Email", nil);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            
            
            emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, [UIScreen mainScreen].bounds.size.width - 100, 30)];
            emailTextField.adjustsFontSizeToFitWidth = YES;
            emailTextField.textColor = [UIColor blackColor];
            emailTextField.backgroundColor = [UIColor whiteColor];
            emailTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            emailTextField.textAlignment = UITextAlignmentLeft;
            emailTextField.delegate = self;
            emailTextField.placeholder = NSLocalizedString(@"qed@mit.edu", nil);
            emailTextField.text = [[PFUser currentUser]objectForKey:kESUserEmailKey];
            
            emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing; // no clear 'x' button to the right
            [emailTextField setEnabled: YES];
            emailTextField.textColor = [UIColor colorWithRed:32.0f/255.0f green:131.0f/255.0f blue:251.0f/255.0f alpha:1];
            emailTextField.font = [UIFont systemFontOfSize:16];;
            emailTextField.keyboardType = UIKeyboardTypeDefault;
            emailTextField.returnKeyType = UIReturnKeyDone;
            emailTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            emailTextField.tag = 6;
            
            [cell.contentView addSubview:emailTextField];
            
        }
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return NSLocalizedString(@"", nil);
            break;
        case 2:
            return @"";
            break;
        case 3:
            return NSLocalizedString(@"Private information, only you see this", nil);
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
        if (indexPath.row == 0){
            changeHeader = YES;
            [self changeProfilePicture];
        }
        else if (indexPath.row == 1){
            changeHeader = NO;
            [self changeProfilePicture];
        }
        else if (indexPath.row == 2){
            changeHeader = NO;
            [self changeProfileColor];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        }
        else if (indexPath.row == 1) {
        }
        else {
            
        }
        
        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
        }
        else if (indexPath.row == 1) {
        }
        else if (indexPath.row == 2) {
        }
    }
    
    else if (indexPath.section == 3)
    {
        
        
    }
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        
        if (buttonIndex == 0) {
            [self shouldStartCameraController];
        } else if (buttonIndex == 1) {
            [self shouldStartPhotoLibraryPickerController];
        }
        
    }
}
#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    CGRect rect = [[UIScreen mainScreen] bounds];
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
- (void)alertViewCancel:(UIAlertView *)alertView {
    return;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:birthdayTextField]) {
        pickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        [pickerView setDatePickerMode:UIDatePickerModeDate];
        if (![birthdayTextField.text isEqualToString:@""]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            NSDate *date = [dateFormatter dateFromString:birthdayTextField.text];
            [pickerView setDate:date];
        }
        textField.inputView = pickerView;
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:
                                CGRectMake(0,0, 320, 44)]; //should code with variables to support view resizing
        UIBarButtonItem *doneButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:self action:@selector(birthdayInputDidFinish)];
        [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        textField.inputAccessoryView = myToolbar;
        
    }
    else if ([textField isEqual:genderTextField]) {
        genderPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        genderPicker.delegate = self;
        genderPicker.dataSource = self;
        textField.inputView = genderPicker;
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:
                                CGRectMake(0,0, 320, 44)]; //should code with variables to support view resizing
        UIBarButtonItem *doneButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:self action:@selector(genderInputDidFinish)];
        [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        textField.inputAccessoryView = myToolbar;
        
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    else {
        saveInfoBtn.enabled = YES;
        saveInfoBtn.tintColor = [UIColor whiteColor];
    }
    
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    if(newLength <= MAX_LENGTH)
    {
        return YES;
    } else {
        NSUInteger emptySpace = MAX_LENGTH - (textView.text.length - range.length);
        textView.text = [[[textView.text substringToIndex:range.location]
                          stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
- (void)textViewDidEndEditing:(UITextView *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    saveInfoBtn.enabled = YES;
    saveInfoBtn.tintColor = [UIColor whiteColor];
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}

#pragma mark - PhotoLibraryPickerController

- (BOOL)shouldStartPhotoLibraryPickerController {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:cameraUI animated:YES completion:nil];
    });
    
    return YES;
}
- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:cameraUI animated:YES completion:nil];
    });
    
    return YES;
}
- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *_image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageUser = _image;
    
    [self shouldUploadImage:self.imageUser];
    
}

#pragma mark - ()

-(void) birthdayInputDidFinish
{
    [birthdayTextField resignFirstResponder];
    birthdayTextField.text = [self formatDate:pickerView.date];
    saveInfoBtn.enabled = YES;
    saveInfoBtn.tintColor = [UIColor whiteColor];
}
-(void) genderInputDidFinish
{
    [genderTextField resignFirstResponder];
    saveInfoBtn.enabled = YES;
    saveInfoBtn.tintColor = [UIColor whiteColor];
}
-(void) changeProfilePicture {
    
    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    if (cameraDeviceAvailable && photoLibraryAvailable) {
        if (changeHeader) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Change header picture", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", nil), NSLocalizedString(@"Choose Photo", nil), nil];
            //actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            actionSheet.tag = 1;
            [actionSheet showInView:self.view];
        }
        else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Change profile picture", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", nil), NSLocalizedString(@"Choose Photo", nil), nil];
            //actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            actionSheet.tag = 1;
            [actionSheet showInView:self.view];
        }
        
    } else {
        // if we don't have at least two options, we automatically show whichever is available (camera or roll)
        [self shouldPresentPhotoCaptureController];
    }
    
}
- (BOOL)shouldUploadImage:(UIImage *)anImage {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640.0f, 640.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (succeeded) {
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSData *imageData = UIImageJPEGRepresentation(self.imageUser, 0.7);
                if (changeHeader) {
                    [ESUtility processHeaderPhotoWithData:imageData];
                    self.imageView1.image = self.imageUser;
                }
                else {
                    [ESUtility processProfilePictureData:imageData];
                    self.imageView2.image = self.imageUser;
                }
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (void) presaveInformation {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:3];
    [self._tableView scrollToRowAtIndexPath:indexPath
                           atScrollPosition:UITableViewScrollPositionTop
                                   animated:YES];
    [self performSelector:@selector(saveInformation) withObject:nil afterDelay:0.5];
}
- (void)saveInformation {
    NSString *string = [nameTextField text];
    [nameTextField resignFirstResponder];
    [mentionTextField resignFirstResponder];
    [bioTextview resignFirstResponder];
    [cityTextField resignFirstResponder];
    [websiteTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [genderTextField resignFirstResponder];
    [birthdayTextField resignFirstResponder];
    
    if ([string isEqualToString:@""] || [string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location == NSNotFound || [[string substringToIndex:1]isEqualToString:@" "] || [string rangeOfString:@"  "].location != NSNotFound) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ProgressHUD showError:@"Username invalid"];
        return;
    }
    if (emailTextField.text == (id)[NSNull null] || emailTextField.text.length == 0 ) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ProgressHUD showError:@"Incorrect email"];
        
        return;
    }
    if (![self NSStringIsValidEmail:emailTextField.text] && ![emailTextField text].length != 0) {
        [ProgressHUD showError:@"Incorrect email"];
        
        return;
    }
    NSString *mentionString = [[mentionTextField text] stringByReplacingOccurrencesOfString:@"@" withString:@""];
    if ([mentionString isEqualToString:@""]  || [[mentionString substringToIndex:1]isEqualToString:@" "] || [mentionString rangeOfString:@" "].location != NSNotFound) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ProgressHUD showError:@"Invalid mention name"];
        
        return;
    }
    
    
    if ([genderTextField text]) {
        [sensitiveData setObject:[genderTextField text] forKey:@"Gender"];
        
    }
    [sensitiveData setObject:[emailTextField text] forKey:@"email"];
    if ([genderTextField text]) [sensitiveData setObject:[birthdayTextField text] forKey:@"Birthday"];
    [sensitiveData saveInBackground];
    
    
    PFQuery *mentionQuery = [PFUser query];
    [mentionQuery whereKey:@"usernameFix" equalTo:mentionString];
    [mentionQuery whereKey:kESUserObjectIdKey notEqualTo:[PFUser currentUser].objectId];
    [mentionQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (number == 0) {
                [[PFUser currentUser] setObject:[nameTextField text] forKey:kESUserDisplayNameKey];
                [[PFUser currentUser] setObject:mentionString forKey:@"usernameFix"];
                [[PFUser currentUser] setObject:[string lowercaseString] forKey:kESUserDisplayNameLowerKey];
                [[PFUser currentUser] setObject:[bioTextview text] forKey:@"UserInfo"];
                [[PFUser currentUser] setObject:[cityTextField text] forKey:@"Location"];
                [[PFUser currentUser] setObject:[websiteTextField text] forKey:@"Website"];
                [[PFUser currentUser] setObject:[emailTextField text] forKey:@"email"];
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [ProgressHUD showSuccess:@"Success"];
                        
                        saveInfoBtn.enabled = NO;
                        saveInfoBtn.tintColor = [UIColor lightGrayColor];
                        if (tutorial == YES) {
                            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                            PFUser *user = [PFUser currentUser];
                            [user setObject:@"Yes" forKey:@"firstLaunch"];
                            [user saveInBackground];
                            [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"firstLaunch"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"SecondViewControllerDismissed"
                                                                                object:nil
                                                                              userInfo:nil];
                        }
                    }
                    else {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [ProgressHUD showError:@"Operation failed"];
                    }
                }];
            }
            else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [ProgressHUD showError:@"Mention name taken"];
                
            }
            
        }
        else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [ProgressHUD showError:@"Operation failed"];
        }
        
    }];
    
    
}

#pragma mark - UIPickerView data source
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 3;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            return NSLocalizedString(@"Male", nil);
            break;
        case 1:
            return NSLocalizedString(@"Female", nil);
            break;
        case 2:
            return NSLocalizedString(@"Other", nil);
            break;
        default:
            return 0;
    };
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    switch(row)
    {
            
        case 0:
            genderTextField.text = NSLocalizedString(@"Male", nil);
            break;
        case 1:
            genderTextField.text = NSLocalizedString(@"Female", nil);
            break;
        case 2:
            genderTextField.text = NSLocalizedString(@"Other", nil);
            break;
            
    }
}
// Formats the date chosen with the date picker.
- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd'.'MM'.'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
- (void) changeProfileColor {
    ColorPickerViewController *colorpickercontroller = [[ColorPickerViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:colorpickercontroller];
    [self presentViewController:navController animated:YES completion:nil];
}

@end

