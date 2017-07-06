//
//  ColorPickerViewController.h
//  Netzwierk
//
//  Created by Eric Schanet on 18.03.15.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NKOColorPickerView.h"
#import "SCLAlertView.h"
/**
 *  Interface of the ColorPickerViewController.
 */
@interface ColorPickerViewController : UIViewController
/**
 *  NKOColorPickerView, the colorpickerview used in this viewcontroller.
 */
@property (nonatomic, strong) NKOColorPickerView *colorPickerView;
/**
 *  Colorbutton at the bottom of the controller.
 */
@property (nonatomic, strong) UIButton *colorButton;
/**
 *  The color has been chosen, now set it as the navigation bar controller in the profile page.
 */
- (void) chooseColor;
/**
 *  The colorpicker has picked a new color, so set it as the temporary navbar color to illustrate it.
 */
- (void) colorChanged:(UIColor *)color;
/**
 *  Dismiss the viewcontroller.
 */
- (void)done:(id)sender;
@end
