//
//  ESSettingsActionSheetDelegate.h
//  D'Netzwierk
//
//  Created by Eric Schanet on 6/05/2014.
//  Copyright (c) 2014 Eric Schanet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSettingsActionSheetDelegate : NSObject <UIActionSheetDelegate>

/// Navigation controller of calling view controller
@property (nonatomic, strong) UINavigationController *navController;

- (id)initWithNavigationController:(UINavigationController *)navigationController;

@end
