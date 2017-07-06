//
//  Welcomeview.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESWelcomeViewController : UIViewController <UIPageViewControllerDataSource>
/**
 *  The pageviewcontroller containing and displaying the other viewcontrollers
 */
@property (strong, nonatomic) UIPageViewController *pageController;
/**
 *  Array of texts. Change these texts to match your own.
 */
@property (nonatomic,strong) NSArray *arrPageTitles;
/**
 *  Array of image names. Change these image names to match your own.
 */
@property (nonatomic,strong) NSArray *arrPageImages;
/**
 *  Takes the user to the login page
 */
@property (strong, nonatomic)  UIButton *loginButton;
/**
 *  Takes the user to the signup page
 */
@property (strong, nonatomic)  UIButton *signupButton;
/**
 *  User wants to sign up, take him to the sign up page.
 */
- (IBAction)actionRegister:(id)sender;
/**
 *  User wants to login, take him to the login page.
 */
- (IBAction)actionLogin:(id)sender;

@end
