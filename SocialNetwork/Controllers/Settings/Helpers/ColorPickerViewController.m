//
//  ColorPickerViewController.m
//  Netzwierk
//
//  Created by Eric Schanet on 18.03.15.
//
//

#import "ColorPickerViewController.h"

@implementation ColorPickerViewController
@synthesize colorPickerView, colorButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(chooseColor)];

    self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    colorButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width/2, 40)];
    colorButton.layer.cornerRadius = 5;
    [colorButton addTarget:self action:@selector(chooseColor) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:colorButton];
    [colorButton setBackgroundColor:colorPickerView.color];
    [colorButton setTitle:NSLocalizedString(@"Choose color", nil) forState:UIControlStateNormal];
    
    
    //Color did change block declaration
    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color){
        [self colorChanged:colorPickerView.color];
    };
    colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(10, 120,[UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 200) color:[UIColor blueColor] andDidChangeColorBlock:colorDidChangeBlock];
    //Add color picker to your view
    [self.view addSubview:colorPickerView];
    [colorButton setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}
- (void) colorChanged:(UIColor *)color {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = color;
    self.parentViewController.navigationController.navigationBar.barTintColor = color;
    colorButton.backgroundColor = color;
    
    
}
- (void) chooseColor {
    
        SCLAlertView *alert = [[SCLAlertView alloc]init];
        [alert showSuccess:self.parentViewController title:NSLocalizedString(@"Congratulations", nil) subTitle:NSLocalizedString(@"You successfully changed the design color", nil) closeButtonTitle:@"OK" duration:0];

        [(AppDelegate *)[[UIApplication sharedApplication] delegate] wouldYouPleaseChangeTheDesign:colorPickerView.color];
        //[self.navigationController dismissViewControllerAnimated:NO completion:nil];

}

@end
