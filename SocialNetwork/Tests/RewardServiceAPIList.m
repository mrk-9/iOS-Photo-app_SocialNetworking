//
//  RewardServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 17/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "RewardServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface RewardServiceAPIList ()
{
    RewardService *rewardService;
    NSString *rewardName;
    NSString *gameName;
    NSString *userName;
}
@end

@implementation RewardServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Reward Service";
   
    rewardService = [App42API buildRewardService];
    
    rewardName = @"RewardName";
    gameName = @"StarOfWar";
    userName = @"Shephertz";
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
    if ([cell.textLabel.text isEqualToString:@"CreateReward"])
    {
        [self createReward];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllRewardsCount"])
    {
        [self getAllRewardsCount];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllRewards"])
    {
        [self getAllRewards];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllRewardsByPaging"])
    {
        [self getAllRewardsByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetRewardByName"])
    {
        [self getRewardByName];
    }
    else if ([cell.textLabel.text isEqualToString:@"EarnRewards"])
    {
        [self earnRewards];
    }
    else if ([cell.textLabel.text isEqualToString:@"RedeemRewards"])
    {
        [self redeemRewards];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetGameRewardPointsForUser"])
    {
        [self getGameRewardPointsForUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopNRewardEarners"])
    {
        [self getTopNRewardEarners];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllRewardsByUser"])
    {
        [self getAllRewardsByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopNRewardEarnersByGroup"])
    {
        [self getTopNRewardEarnersByGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetUserRankingOnReward"])
    {
        [self getUserRankingOnReward];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
    
}

-(void)createReward
{
    NSString *rewardDesription = @"RewardDesription";
    [rewardService createReward:rewardName rewardDescription:rewardDesription completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Reward *reward = (Reward*)responseObj;
            NSLog(@"RewardName = %@",reward.name);
            NSLog(@"Description = %@",reward.description);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}
-(void)getAllRewardsCount
{
    [rewardService getAllRewardsCount:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Total Rewards = %d",app42Response.totalRecords);
            NSLog(@"Response = %@",app42Response.strResponse);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}
-(void)getAllRewards
{
    [rewardService getAllRewards:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *rewards = (NSArray*)responseObj;
            for (Reward *reward in rewards)
            {
                NSLog(@"RewardName = %@",reward.name);
                NSLog(@"Description = %@",reward.description);
            }
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}
-(void)getAllRewardsByPaging
{
    int max = 5;
    int offset = 0;
    [rewardService getAllRewards:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *rewards = (NSArray*)responseObj;
            for (Reward *reward in rewards)
            {
                NSLog(@"RewardName = %@",reward.name);
                NSLog(@"Description = %@",reward.description);
            }
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}
-(void)getRewardByName
{
    [rewardService getRewardByName:rewardName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Reward *reward = (Reward*)responseObj;
            NSLog(@"RewardName = %@",reward.name);
            NSLog(@"Description = %@",reward.description);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}
-(void)earnRewards
{
    int rewardPoint = 500;
    [rewardService earnRewards:gameName gameUserName:userName rewardName:rewardName rewardPoints:rewardPoint completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Reward *reward = (Reward*)responseObj;
            NSLog(@"RewardName = %@",reward.name);
            NSLog(@"UserName = %@",reward.userName);
            NSLog(@"GameName = %@",reward.gameName);
            NSLog(@"Points = %f",reward.points);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}
-(void)redeemRewards
{
    int rewardPoint = 300;
    [rewardService redeemRewards:gameName gameUserName:userName rewardName:rewardName rewardPoints:rewardPoint completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Reward *reward = (Reward*)responseObj;
            NSLog(@"RewardName = %@",reward.name);
            NSLog(@"UserName = %@",reward.userName);
            NSLog(@"GameName = %@",reward.gameName);
            NSLog(@"Points = %f",reward.points);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}
-(void)getGameRewardPointsForUser
{
    [rewardService getGameRewardPointsForUser:gameName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Reward *reward = (Reward*)responseObj;
            NSLog(@"RewardName = %@",reward.name);
            NSLog(@"UserName = %@",reward.userName);
            NSLog(@"GameName = %@",reward.gameName);
            NSLog(@"Points = %f",reward.points);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}

-(void)getTopNRewardEarners
{
    int max = 5;
    [rewardService getTopNRewardEarners:gameName rewardName:rewardName max:max completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *rewards = (NSArray*)responseObj;
            for (Reward *reward in rewards)
            {
                NSLog(@"RewardName = %@",reward.name);
                NSLog(@"UserName = %@",reward.userName);
                NSLog(@"GameName = %@",reward.gameName);
                NSLog(@"Description = %@",reward.description);
                NSLog(@"Points = %f",reward.points);
            }
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}

-(void)getAllRewardsByUser
{
    [rewardService getAllRewardsByUser:userName rewardName:rewardName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *rewards = (NSArray*)responseObj;
            for (Reward *reward in rewards)
            {
                NSLog(@"RewardName = %@",reward.name);
                NSLog(@"UserName = %@",reward.userName);
                NSLog(@"GameName = %@",reward.gameName);
                NSLog(@"Description = %@",reward.description);
                NSLog(@"Points = %f",reward.points);
            }
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}

-(void)getTopNRewardEarnersByGroup
{
    [rewardService getTopNRewardEarnersByGroup:gameName rewardName:rewardName userList:[NSArray arrayWithObjects:userName, nil] completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *rewards = (NSArray*)responseObj;
            for (Reward *reward in rewards)
            {
                NSLog(@"RewardName = %@",reward.name);
                NSLog(@"UserName = %@",reward.userName);
                NSLog(@"GameName = %@",reward.gameName);
                NSLog(@"Description = %@",reward.description);
                NSLog(@"Points = %f",reward.points);
            }
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}

-(void)getUserRankingOnReward
{
    [rewardService getUserRankingOnReward:gameName rewardName:rewardName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Reward *reward = (Reward*)responseObj;
            NSLog(@"RewardName = %@",reward.name);
            NSLog(@"UserName = %@",reward.userName);
            NSLog(@"GameName = %@",reward.gameName);
            NSLog(@"Points = %f",reward.points);
            NSLog(@"Rank = %f",reward.rank);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}

@end
