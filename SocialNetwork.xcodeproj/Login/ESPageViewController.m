//
//  ESPageViewController.m
//  app
//
//  Created by Eric Schanet on 30.05.15.
//  Copyright (c) 2015 KZ. All rights reserved.
//
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)

#import "ESPageViewController.h"

@interface ESPageViewController ()

@end

@implementation ESPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.3412 green:0.6902 blue:0.9294 alpha:1];
    self.lblScreenLabel = [[UILabel alloc]init];
    self.ivScreenImage = [[UIImageView alloc]init];
    [self.view addSubview:self.ivScreenImage];
    [self.view addSubview:self.lblScreenLabel];
    self.lblScreenLabel.textColor = [UIColor whiteColor];

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName : paragraph,
                                  NSFontAttributeName : self.lblScreenLabel.font,
                                  NSBaselineOffsetAttributeName : [NSNumber numberWithFloat:0] };
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.txtTitle
                                                              attributes:attributes];
    
    self.lblScreenLabel.attributedText = str;
    
    self.lblScreenLabel.numberOfLines = 5;
    self.lblScreenLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.lblScreenLabel.frame = CGRectMake(30, 30, [UIScreen mainScreen].bounds.size.width - 60, 120);
    if (IS_IPHONE6) {
        self.ivScreenImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 110, 140, 220, [UIScreen mainScreen].bounds.size.height-280);
    } else if (IS_IPHONE5) {
        self.ivScreenImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/4.5, 110, [UIScreen mainScreen].bounds.size.width/1.8, [UIScreen mainScreen].bounds.size.height-250);
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.ivScreenImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/3.35, 210, [UIScreen mainScreen].bounds.size.width/2.5, [UIScreen mainScreen].bounds.size.height-450);
    } else {
        self.ivScreenImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 60, 140, 120, [UIScreen mainScreen].bounds.size.height-280);
    }
    self.ivScreenImage.image = [UIImage imageNamed:self.imgFile];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
