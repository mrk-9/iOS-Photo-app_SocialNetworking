//
//  ESTabBarController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ESEditPhotoViewController.h"
#import "MMDrawerController.h"
#import "CLImageEditor.h"
#import "ESConstants.h"
#import "MBProgressHUD.h"


@protocol ESTabBarControllerDelegate;

@interface ESTabBarController : UITabBarController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>
/**
 *  Navigation controller pushing the other viewcontrollers.
 */
@property (nonatomic,strong) UINavigationController *navController;
/**
 *  Progress hud to show that something is going on.
 */
@property (nonatomic, strong) MBProgressHUD *hud;
/**
 *  Decide wether the PhotoCaptureController is available or not.
 */
- (BOOL)shouldPresentPhotoCaptureController;
- (void)useNotificationWithString:(NSNotification *)notification;
@end

@protocol ESTabBarControllerDelegate <NSObject>
/**
 *  Camera button touch action.
 */
- (void)tabBarController:(UITabBarController *)tabBarController cameraButtonTouchUpInsideAction:(UIButton *)button;
/**
 *  Decide wether the PhotoLibraryPickerController is available and should be started.
 */
- (BOOL)shouldStartPhotoLibraryPickerController;
/**
 *  Decide if the camera controller is available and can be presented.
 */
- (BOOL)shouldStartCameraController;
/**
 *  Photo button action
 */
- (void)photoCaptureButtonAction:(id)sender;
/**
 *  Decide if the PhotoCaptureController should be presented.
 */
- (BOOL)shouldPresentPhotoCaptureController;
- (void) videoUploadBegins;
- (void) videoUploadEnds;
- (void) videoUploadSucceeds;
- (void) videoUploadFails;

@end