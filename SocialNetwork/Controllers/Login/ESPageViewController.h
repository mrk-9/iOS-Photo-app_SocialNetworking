//
//  ESPageViewController.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 30.05.15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESPageViewController : UIViewController
/**
 *  Index of the PageController.
 */
@property NSUInteger pageIndex;
/**
 *  Name of the image we display on the viewcontroller.
 */
@property NSString *imgFile;
/**
 *  The label we display above the image.
 */
@property (strong, nonatomic) IBOutlet UILabel *lblScreenLabel;
/**
 *  The text in the label above the image.
 */
@property NSString *txtTitle;
/**
 *  The image on the viewcontroller.
 */
@property (strong, nonatomic) IBOutlet UIImageView *ivScreenImage;
@end
