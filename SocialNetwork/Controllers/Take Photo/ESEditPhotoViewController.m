//
//  ESEditPhotoViewController.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import "ESEditPhotoViewController.h"
#import "ESPhotoDetailsFooterView.h"
#import "UIImage+ResizeAdditions.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "PXAlertView.h"
#import <CoreLocation/CoreLocation.h>


@implementation ESEditPhotoViewController
@synthesize scrollView;
@synthesize image;
@synthesize commentTextField;
@synthesize photoFile;
@synthesize thumbnailFile;
@synthesize fileUploadBackgroundTaskId;
@synthesize photoPostBackgroundTaskId;
@synthesize photoImageView;

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithImage:(UIImage *)aImage {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (!aImage) {
            return nil;
        }
        
        self.image = aImage;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIViewController

- (void)loadView {
    self.navigationController.navigationBar.translucent = YES;

    self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.scrollView.delegate = self;
    self.view = self.scrollView;
    if ([UIScreen mainScreen].bounds.size.height > 500) {
        photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    }
    else {
        photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -15.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    }
    [photoImageView setBackgroundColor:[UIColor blackColor]];
    [photoImageView setImage:self.image];
    [photoImageView setContentMode:UIViewContentModeScaleAspectFit];

    CALayer *layer = photoImageView.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = 3.0f;
    layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    layer.shadowOpacity = 0.5f;
    layer.shouldRasterize = YES;
    
    [self.scrollView addSubview:photoImageView];
    
    CGRect footerRect = [ESPhotoDetailsFooterView rectForView];
    footerRect.origin.y = photoImageView.frame.origin.y + photoImageView.frame.size.height;

    footerRect.size.height = footerRect.size.height + 50;
    
    ESPhotoDetailsFooterView *footerView = [[ESPhotoDetailsFooterView alloc] initWithFrame:footerRect];
    self.commentTextField = footerView.commentField;
    self.commentTextField.delegate = self;
    [self.scrollView addSubview:footerView];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, photoImageView.frame.origin.y + photoImageView.frame.size.height + footerView.frame.size.height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];;
    [self.navigationItem setHidesBackButton:YES];

    self.navigationItem.titleView = nil;//[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoNavigationBar.png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Publish", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self shouldUploadImage:self.image];
    
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
#ifdef __IPHONE_8_0
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
#endif
    [locationManager startUpdatingLocation];

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doneButtonAction:textField];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.commentTextField resignFirstResponder];  
}


#pragma mark - ()

- (BOOL)shouldUploadImage:(UIImage *)anImage {    
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:42.0f interpolationQuality:kCGInterpolationDefault];
    
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
        if (succeeded) {
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            }];
        } else {
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
        }
    }];
    
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height += keyboardFrameEnd.size.height;
    [self.scrollView setContentSize:scrollViewContentSize];
    
    CGPoint scrollViewContentOffset = self.scrollView.contentOffset;
    // Align the bottom edge of the photo with the keyboard
    scrollViewContentOffset.y = scrollViewContentOffset.y + keyboardFrameEnd.size.height*3.0f - [UIScreen mainScreen].bounds.size.height;
    
    [self.scrollView setContentOffset:scrollViewContentOffset animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize scrollViewContentSize = self.scrollView.bounds.size;
    scrollViewContentSize.height -= keyboardFrameEnd.size.height;
    [UIView animateWithDuration:0.200f animations:^{
        [self.scrollView setContentSize:scrollViewContentSize];
    }];
}

- (void)doneButtonAction:(id)sender {
    NSDictionary *userInfo = [NSDictionary dictionary];
    NSString *trimmedComment = [self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  trimmedComment,kESEditPhotoViewControllerUserInfoCommentKey,
                                  nil];
    }
    
    // Make sure there were no errors creating the image files
    if (!self.photoFile || !self.thumbnailFile) {
        [PXAlertView showAlertWithTitle:nil
                                message:NSLocalizedString(@"Couldn't post your photo, a network error occurred.", nil)
                            cancelTitle:@"OK"
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                 if (cancelled) {
                                     NSLog(@"Simple Alert View cancelled");
                                 } else {
                                     NSLog(@"Simple Alert View dismissed, but not cancelled");
                                 }
                             }];
        return;
    }
    
    // both files have finished uploading
    
    // create a photo object
    PFObject *photo = [PFObject objectWithClassName:kESPhotoClassKey];
    [photo setObject:[PFUser currentUser] forKey:kESPhotoUserKey];
    [photo setObject:self.photoFile forKey:kESPhotoPictureKey];
    [photo setObject:self.thumbnailFile forKey:kESPhotoThumbnailKey];
    if (localityString && [[[PFUser currentUser] objectForKey:@"locationServices"] isEqualToString:@"YES"]) {
        [photo setObject:localityString forKey:kESPhotoLocationKey];
    }
        
    // photos are public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    [photoACL setPublicWriteAccess:YES]; // forUser:[PFUser currentUser]];
    photo.ACL = photoACL;
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];

    // Save the Photo PFObject
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[ESCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:[NSArray array] likedByCurrentUser:NO];
            
            if ([[[[PFUser currentUser] objectForKey:@"verified"] lowercaseString] isEqualToString:@"yes"]) {
                PFObject *sponsored = [PFObject objectWithClassName:@"Sponsored"];
                [sponsored setObject:self.photoFile forKey:kESPhotoPictureKey];
                [sponsored setObject:self.thumbnailFile forKey:kESPhotoThumbnailKey];
                [sponsored setObject:[PFUser currentUser] forKey:kESPhotoUserKey];
                [sponsored saveInBackground];
            }
            
            // userInfo might contain any caption which might have been posted by the uploader
            if (userInfo) {
                NSString *commentText = [userInfo objectForKey:kESEditPhotoViewControllerUserInfoCommentKey];
                
                if (commentText && commentText.length != 0) {
                    // create and save photo caption
                    NSRegularExpression *_regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:nil];
                    NSArray *_matches = [_regex matchesInString:trimmedComment options:0 range:NSMakeRange(0, trimmedComment.length)];
                    NSMutableArray *hashtagsArray = [[NSMutableArray alloc]init];
                    for (NSTextCheckingResult *match in _matches) {
                        NSRange wordRange = [match rangeAtIndex:1];
                        NSString* word = [trimmedComment substringWithRange:wordRange];
                        [hashtagsArray addObject:[word lowercaseString]];
                    }
                    
                    PFObject *comment = [PFObject objectWithClassName:kESActivityClassKey];
                    if ([photo objectForKey:kESVideoFileKey]) {
                        [comment setObject:kESActivityTypeCommentVideo forKey:kESActivityTypeKey];
                    } else if ([[photo objectForKey:@"type"] isEqualToString:@"text"]) {
                        [comment setObject:kESActivityTypeCommentPost forKey:kESActivityTypeKey];
                    }
                    else [comment setObject:kESActivityTypeCommentPhoto forKey:kESActivityTypeKey];
                    [comment setObject:photo forKey:kESActivityPhotoKey];
                    [comment setObject:[PFUser currentUser] forKey:kESActivityFromUserKey];
                    [comment setObject:[PFUser currentUser] forKey:kESActivityToUserKey];
                    [comment setObject:commentText forKey:kESActivityContentKey];
                    if (hashtagsArray.count > 0) {
                        [comment setObject:hashtagsArray forKey:@"hashtags"];
                        
                        for (int i = 0; i < hashtagsArray.count; i++) {
                            NSString *hash = [[hashtagsArray objectAtIndex:i] lowercaseString];
                            PFQuery *hashQuery = [PFQuery queryWithClassName:@"Hashtags"];
                            [hashQuery whereKey:@"hashtag" equalTo:hash];
                            [hashQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (!error) {
                                    if (objects.count == 0) {
                                        PFObject *hashtag = [PFObject objectWithClassName:@"Hashtags"];
                                        [hashtag setObject:hash forKey:@"hashtag"];
                                        [hashtag saveInBackground];
                                    }
                                }
                            }];
                        }
                    }

                    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    [ACL setPublicReadAccess:YES];
                    [ACL setWriteAccess:YES forUser:[PFUser currentUser]];
                    comment.ACL = ACL;
                    
                    [comment saveInBackgroundWithBlock:^(BOOL result, NSError *error){
                        if (error) {
                            [comment saveEventually];
                        }
                    }];
                    [[ESCache sharedCache] incrementCommentCountForPhoto:photo];
                    
                    PFObject *mention = [PFObject objectWithClassName:kESActivityClassKey];
                    [mention setObject:[PFUser currentUser] forKey:kESActivityFromUserKey]; // Set fromUser
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:nil];
                    NSArray *matches = [regex matchesInString:trimmedComment options:0 range:NSMakeRange(0, trimmedComment.length)];
                    NSMutableArray *mentionsArray = [[NSMutableArray alloc]init];
                    for (NSTextCheckingResult *match in matches) {
                        NSRange wordRange = [match rangeAtIndex:1];
                        NSString* word = [trimmedComment substringWithRange:wordRange];
                        [mentionsArray addObject:word];
                        
                        
                    }
                    if (mentionsArray.count > 0 ) {
                        PFQuery *mentionQuery = [PFUser query];
                        [mentionQuery whereKey:@"usernameFix" containedIn:mentionsArray];
                        [mentionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if (!error) {
                                [mention setObject:objects forKey:@"mentions"]; // Set toUser
                                [mention setObject:kESActivityTypeMention forKey:kESActivityTypeKey];
                                [mention setObject:photo forKey:kESActivityPhotoKey];
                                [mention saveInBackgroundWithBlock:^(BOOL result, NSError *error){
                                    if (error) {
                                        [mention saveEventually];
                                    }
                                }];
                            }
                        }];
                    }
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ESTabBarControllerDidFinishEditingPhotoNotification object:photo];
        } else {
            [PXAlertView showAlertWithTitle:nil
                                    message:NSLocalizedString(@"Couldn't post your photo, a network error occurred.", nil)
                                cancelTitle:@"OK"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     if (cancelled) {
                                         NSLog(@"Simple Alert View cancelled");
                                     } else {
                                         NSLog(@"Simple Alert View dismissed, but not cancelled");
                                     }
                                 }];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    // Dismiss this screen
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonAction:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            localityString = [placemark locality];
            NSLog(@"%@", [placemark locality]);
            [locationManager stopUpdatingLocation];
        }
    }];
	
}
// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}
@end