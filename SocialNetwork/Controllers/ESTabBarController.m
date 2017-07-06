//
//  ESTabBarController.m
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)


#import "ESTabBarController.h"
#import "UIImage+ImageEffects.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "RecorderViewController.h"
#import "SCLAlertView.h"
#import "ESConstants.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RNGridMenu.h"
#import "REComposeViewController.h"

@interface ESTabBarController ()<RNGridMenuDelegate>
@end

@implementation ESTabBarController
@synthesize navController;


#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navController = [[UINavigationController alloc] init];
    //[[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xcc0900)];

    //Notification listen
    NSString *notificationName = @"ESNotification";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(useNotificationWithString:) name:notificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUploadBegins) name:@"videoUploadBegins" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUploadEnds) name:@"videoUploadEnds" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUploadSucceeds) name:@"videoUploadSucceeds" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUploadFails) name:@"videoUploadFails" object:nil];
    
}
- (void) videoUploadBegins {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = NSLocalizedString(@"Uploading", nil);
}

- (void) videoUploadEnds {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void) videoUploadSucceeds {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];
    [alert showSuccess:self.parentViewController title:NSLocalizedString(@"Congratulations", nil) subTitle:NSLocalizedString(@"Successfully uploaded the video", nil) closeButtonTitle:NSLocalizedString(@"Done", nil) duration:0.0f];
}
- (void) videoUploadFails {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self.parentViewController title:NSLocalizedString(@"Hold On...", nil)
            subTitle:NSLocalizedString(@"A problem occurred, try again later", nil)
    closeButtonTitle:@"OK" duration:0.0f];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITabBarController

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_IPHONE6) {
        cameraButton.frame = CGRectMake( 162.0f, 0.0f, 50.0f, self.tabBar.bounds.size.height);
    }
    else {
        cameraButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2 - 40/2, 5.0f, 40, self.tabBar.bounds.size.height - 10);
    }
    [cameraButton setImage:[UIImage imageNamed:@"ButtonCamera.png"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"ButtonCameraSelected.png"] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(photoCaptureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:cameraButton];
    
    //[[UITabBar appearance]setTintColor:[UIColor yellowColor]];
    //[[UITabBar appearance]setBarTintColor:[UIColor yellowColor]];
    
    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeUpGestureRecognizer setNumberOfTouchesRequired:1];
    [cameraButton addGestureRecognizer:swipeUpGestureRecognizer];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    if (!image && url) {
        [ProgressHUD show:NSLocalizedString(@"Uploading", nil)];
        [[ALAssetsLibrary new] assetForURL:info[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
            UIImage *thumbnailImage = [image thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:42.0f interpolationQuality:kCGInterpolationDefault];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
            PFFile *thumbnail = [PFFile fileWithData:imageData];
            NSData *_imageData = UIImageJPEGRepresentation(thumbnailImage, 0.8f);
            PFFile *_thumbnail = [PFFile fileWithData:_imageData];
            
            NSData *videoData = [[NSData alloc] initWithContentsOfURL:url];
            PFFile *videoFile = [PFFile fileWithData:videoData];
            NSLog(@"%@",[NSByteCountFormatter stringFromByteCount:videoData.length countStyle:NSByteCountFormatterCountStyleFile]);
            
            PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [ACL setPublicReadAccess:YES];
            [ACL setWriteAccess:YES forUser:[PFUser currentUser]];
            
            
            PFObject *videoObject = [PFObject objectWithClassName:kESPhotoClassKey];//,kESStoryClassKey];
            
            [videoObject setObject:videoFile forKey:kESVideoFileKey];
            [videoObject setObject:thumbnail forKey:kESVideoFileThumbnailKey];
            [videoObject setObject:_thumbnail forKey:kESVideoFileThumbnailRoundedKey];
            [videoObject setObject:kESVideoTypeKey forKey:kESVideoOrPhotoTypeKey];
            [videoObject setACL:ACL];
            [videoObject setObject:[PFUser currentUser] forKey:@"user"];
            
            [videoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"videoUploadEnds" object:nil];
                if (succeeded) {
                    [ProgressHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoUploadSucceeds" object:nil];
                }
                else if (error) {
                    [ProgressHUD showError:NSLocalizedString(@"Internet connection failed", nil)];
                }
            }];
            
            
        } failureBlock:^(NSError *error) {
            [ProgressHUD showError:@"Error creating thumbnail"];
        }];
        
        
    }
    else {
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
        editor.delegate = self;
        [[CLImageEditorTheme theme] setBackgroundColor:[UIColor blackColor]];
        [[CLImageEditorTheme theme] setToolbarColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
        [[CLImageEditorTheme theme] setToolbarTextColor:[UIColor whiteColor]];
        [[CLImageEditorTheme theme] setToolIconColor:@"white"];
        [self presentViewController:editor animated:YES completion:nil];
    }
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        [self shouldStartPhotoLibraryPickerController];
    }
    else if (buttonIndex == 2) {
        RecorderViewController *viewController = [[RecorderViewController alloc] init];
        [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self.navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self.navController pushViewController:viewController animated:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:self.navController animated:YES completion:nil];
        });
        
    }    else if (buttonIndex == 3) {
        [self shouldPresentVideoCaptureController];
        
    }
}
#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    if (itemIndex == 0) {
        [self shouldStartCameraController];
    }
    else if (itemIndex == 1) {
        RecorderViewController *viewController = [[RecorderViewController alloc] init];
        [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self.navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self.navController pushViewController:viewController animated:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:self.navController animated:YES completion:nil];
        });
        }
    else if (itemIndex == 2) {
        [self shouldStartPhotoLibraryPickerController];
    }
    else if (itemIndex == 3) {
        [self shouldPresentVideoCaptureController];
    }
    else if (itemIndex == 4) {
        REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
        composeViewController.title = @"Compose new post";
        composeViewController.hasAttachment = NO;
        composeViewController.attachmentImage = nil;
        composeViewController.text = @"";
        [composeViewController presentFromRootViewController];
        
        composeViewController.completionHandler = ^(REComposeViewController *composeViewController, REComposeResult result) {
            
            if (result == REComposeResultCancelled) {
                NSLog(@"Cancelled");
                [composeViewController dismissViewControllerAnimated:YES completion:nil];
                
            }
            
            if (result == REComposeResultPosted) {
                [composeViewController dismissViewControllerAnimated:YES completion:nil];
                [ProgressHUD show:@"Posting"];
                PFObject *post = [PFObject objectWithClassName:@"Photo"];
                [post setObject:@"text" forKey:@"type"];
                PFACL *defaultACL = [PFACL ACL];
                [defaultACL setPublicReadAccess:YES];
                [defaultACL setPublicWriteAccess:YES];
                [post setACL:defaultACL];
                [post setObject:composeViewController.text forKey:@"text"];
                [post setObject:[PFUser currentUser] forKey:@"user"];
                
                NSRegularExpression *_regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:nil];
                NSArray *_matches = [_regex matchesInString:composeViewController.text options:0 range:NSMakeRange(0, composeViewController.text.length)];
                NSMutableArray *hashtagsArray = [[NSMutableArray alloc]init];
                for (NSTextCheckingResult *match in _matches) {
                    NSRange wordRange = [match rangeAtIndex:1];
                    NSString* word = [composeViewController.text substringWithRange:wordRange];
                    [hashtagsArray addObject:[word lowercaseString]];
                }
                PFObject *comment = [PFObject objectWithClassName:kESActivityClassKey];
                [comment setObject:composeViewController.text forKey:kESActivityContentKey]; // Set comment text
                [comment setObject:[PFUser currentUser] forKey:kESActivityFromUserKey]; // Set fromUser
                [comment setObject:kESActivityTypeCommentPost forKey:kESActivityTypeKey];
                [comment setObject:post forKey:kESActivityPhotoKey];
                
                if (hashtagsArray.count > 0) {
                    
                    [comment setObject:hashtagsArray forKey:@"hashtags"];
                    [comment setObject:@"YES" forKey:@"noneread"];
                    [comment saveInBackground];
                    
                    for (int i = 0; i < hashtagsArray.count; i++) {
                        
                        //In the Hashtags class, if the hashtag doesn't already exist, we add it to the list a user can search through.
                        
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
                
                PFObject *mention = [PFObject objectWithClassName:kESActivityClassKey];
                [mention setObject:[PFUser currentUser] forKey:kESActivityFromUserKey]; // Set fromUser
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:nil];
                NSArray *matches = [regex matchesInString:composeViewController.text options:0 range:NSMakeRange(0, composeViewController.text.length)];
                NSMutableArray *mentionsArray = [[NSMutableArray alloc]init];
                for (NSTextCheckingResult *match in matches) {
                    NSRange wordRange = [match rangeAtIndex:1];
                    NSString* word = [composeViewController.text substringWithRange:wordRange];
                    [mentionsArray addObject:word];
                }
                if (mentionsArray.count > 0 ) {
                    PFQuery *mentionQuery = [PFUser query];
                    [mentionQuery whereKey:@"usernameFix" containedIn:mentionsArray];
                    [mentionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            [mention setObject:objects forKey:@"mentions"]; // Set toUser
                            [mention setObject:kESActivityTypeMention forKey:kESActivityTypeKey];
                            [mention setObject:post forKey:kESActivityPhotoKey];
                            [mention saveEventually];
                        }
                    }];
                }
                
                
                [post saveInBackgroundWithBlock:^(BOOL result, NSError *error){
                    if (!error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:ESTabBarControllerDidFinishEditingPhotoNotification object:post];
                        [ProgressHUD dismiss];
                    }
                    else {
                        [ProgressHUD showError:@"Connection error!"];
                    }
                }];
                
            }
            
        };
    }
}

#pragma mark - ESTabBarController

- (BOOL)shouldPresentPhotoCaptureController {
    BOOL presentedPhotoCaptureController = [self shouldStartCameraController];
    
    if (!presentedPhotoCaptureController) {
        presentedPhotoCaptureController = [self shouldStartPhotoLibraryPickerController];
    }
    
    return presentedPhotoCaptureController;
}

#pragma mark - ()

- (void)photoCaptureButtonAction:(id)sender {
    //This is a fix for the simulator, to test tweets. We don't want the camera to automatically pop up.
    //    BOOL cameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    //    BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    //    if (cameraDeviceAvailable && photoLibraryAvailable) {
    NSArray *menuItems = @[[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ButtonCamera"] title:NSLocalizedString(@"Take Photo", nil)],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"video_camera"] title:NSLocalizedString(@"Take Video", nil)],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"photo_image"] title:NSLocalizedString(@"Choose Photo", nil)],
                           [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"Video"] title:NSLocalizedString(@"Choose Video", nil)],[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"pencil-icon"] title:NSLocalizedString(@"Text", nil)]];
                           //,[[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"pencil-icon"] title:NSLocalizedString(@"Gif", nil)]];
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:menuItems];
    gridMenu.delegate = self;
    gridMenu.menuStyle = RNGridMenuStyleGrid;
    gridMenu.itemSize = CGSizeMake(100, 100);
    [gridMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
    //    } else {
    //        // if we don't have at least two options, we automatically show whichever is available (camera or roll)
    //        [self shouldPresentPhotoCaptureController];
    //    }
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
    
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:cameraUI animated:YES completion:nil];
    });
    
    
    
    return YES;
}
- (BOOL) shouldPresentVideoCaptureController
{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) return NO;
    NSString *type = (NSString *)kUTTypeMovie;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.videoMaximumDuration = VIDEO_LENGTH;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:type])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObject:type];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
             && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:type])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.mediaTypes = [NSArray arrayWithObject:type];
    }
    else return NO;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:imagePicker animated:YES completion:nil];
    });
    //---------------------------------------------------------------------------------------------------------------------------------------------
    return YES;
}
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    [self shouldPresentPhotoCaptureController];
}
- (void)useNotificationWithString:(NSNotification *)notification //use notification method and logic
{
    // This key must match the key in postNotificationWithString: exactly.
    
    NSString *key = @"CommunicationStringValue";
    NSDictionary *dictionary = [notification userInfo];
    NSString *stringValueToUse = [dictionary valueForKey:key];
    if([stringValueToUse isEqualToString:@"ChangeTheme"])
    {
        
        
    }
}
#pragma mark - CLImageEditor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    
    ESEditPhotoViewController *viewController = [[ESEditPhotoViewController alloc] initWithImage:image];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navController pushViewController:viewController animated:NO];
    [editor dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:self.navController animated:YES completion:nil];
    
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    
}

@end
