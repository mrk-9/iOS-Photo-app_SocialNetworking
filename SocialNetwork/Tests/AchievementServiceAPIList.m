//
//  AchievementServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "AchievementServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface AchievementServiceAPIList ()
{
    AchievementService *achievementService;
    NSString *achievementName;
    NSString *description;
    NSString *gameName;
    NSString *userName;
}
@end

@implementation AchievementServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Achievement Service";
   
    achievementService = [App42API buildAchievementService];
    achievementName= @"GoldenRewards";
    userName= @"GoldenRewards";
    description= @"description";
    gameName= @"StarOFWar";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [apiList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        int index = (int)indexPath.row;
        NSLog(@"Index : %d",index);
        cell.textLabel.text = [apiList objectAtIndex:index];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    // Configure the cell...
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:@"CreateAchievementWithName"])
    {
        [self createAchievementWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"EarnAchievementWithName"])
    {
        [self earnAchievementWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllAchievementsForUser"])
    {
        [self getAllAchievementsForUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllAchievementsForUserInAGame"])
    {
        [self getAllAchievementsForUserInAGame];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllAchievements"])
    {
        [self getAllAchievements];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAchievementByName"])
    {
        [self getAchievementByName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllUsersWithAchievement"])
    {
        [self getAllUsersWithAchievement];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)createAchievementWithName
{
    
    [achievementService createAchievementWithName:achievementName description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Achievement *response = (Achievement*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            NSLog(@"achievedOn is %@" , response.achievedOn);
            NSLog(@"name is %@" , response.name);
            NSLog(@"description is %@" , response.description);
            [self showResponse:response.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)earnAchievementWithName
{
    [achievementService earnAchievementWithName:achievementName userName:userName gameName:gameName description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Achievement *response = (Achievement*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            NSLog(@"achievedOn is %@" , response.achievedOn);
            NSLog(@"name is %@" , response.name);
            NSLog(@"description is %@" , response.description);
            [self showResponse:response.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getAllAchievementsForUser
{
    [achievementService getAllAchievementsForUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *achievementList = (NSArray*)responseObj;
            for (Achievement *achievement in achievementList) {
                NSLog(@"Response is %@" , achievement.strResponse);
                NSLog(@"isResponseSuccess is %d" , achievement.isResponseSuccess);
                NSLog(@"achievedOn is %@" , achievement.achievedOn);
                NSLog(@"name is %@" , achievement.name);
                NSLog(@"User Name is %@" , achievement.userName);
                NSLog(@"Game Name is %@" , achievement.gameName);
                NSLog(@"description is %@" , achievement.description);
            }
            [self showResponse:[achievementList description]];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}

-(void)getAllAchievementsForUserInAGame
{
    [achievementService getAllAchievementsForUser:achievementName inGame:gameName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *achievementList = (NSArray*)responseObj;
            for (Achievement *achievement in achievementList) {
                NSLog(@"Response is %@" , achievement.strResponse);
                NSLog(@"isResponseSuccess is %d" , achievement.isResponseSuccess);
                NSLog(@"achievedOn is %@" , achievement.achievedOn);
                NSLog(@"name is %@" , achievement.name);
                NSLog(@"User Name is %@" , achievement.userName);
                NSLog(@"Game Name is %@" , achievement.gameName);
                NSLog(@"description is %@" , achievement.description);
            }
            
            [self showResponse:[achievementList description]];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
    
}
-(void)getAllAchievements
{
    [achievementService getAllAchievements:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *achievementList = (NSArray*)responseObj;
            for (Achievement *achievement in achievementList) {
                NSLog(@"Response is %@" , achievement.strResponse);
                NSLog(@"isResponseSuccess is %d" , achievement.isResponseSuccess);
                NSLog(@"achievedOn is %@" , achievement.achievedOn);
                NSLog(@"name is %@" , achievement.name);
                NSLog(@"User Name is %@" , achievement.userName);
                NSLog(@"Game Name is %@" , achievement.gameName);
                NSLog(@"description is %@" , achievement.description);
            }
            
            [self showResponse:[achievementList description]];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getAchievementByName
{
    [achievementService getAchievementByName:achievementName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Achievement *response = (Achievement*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            NSLog(@"achievedOn is %@" , response.achievedOn);
            NSLog(@"name is %@" , response.name);
            NSLog(@"description is %@" , response.description);
            [self showResponse:response.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getAllUsersWithAchievement
{
    [achievementService getAllUsersWithAchievement:achievementName inGame:gameName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *achievementList = (NSArray*)responseObj;
            for (Achievement *achievement in achievementList) {
                NSLog(@"Response is %@" , achievement.strResponse);
                NSLog(@"isResponseSuccess is %d" , achievement.isResponseSuccess);
                NSLog(@"achievedOn is %@" , achievement.achievedOn);
                NSLog(@"name is %@" , achievement.name);
                NSLog(@"User Name is %@" , achievement.userName);
                NSLog(@"Game Name is %@" , achievement.gameName);
                NSLog(@"description is %@" , achievement.description);
            }
            
            [self showResponse:[achievementList description]];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}

@end
