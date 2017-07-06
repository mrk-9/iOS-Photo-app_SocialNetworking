//
//  ScoreboardServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 17/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "ScoreboardServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface ScoreboardServiceAPIList ()
{
    ScoreBoardService *scoreboardService;
    NSString *gameName;
    NSString *userName;
    int max;
    int offset;
    NSDate *startDate;
    NSDate *endDate;
    double gameScore;
    NSArray *group;
    NSString *scoreId;
}
@end

@implementation ScoreboardServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Scoreboard Service";
    [App42API setOfflineStorage:YES];
    scoreboardService = [App42API buildScoreBoardService];
    
    gameName = @"Words Junkie5";
    userName = @"Shephertz1";
    max = 5;
    offset = 0;
    startDate = [NSDate dateWithTimeIntervalSinceNow:-4*60*60];
    endDate = [NSDate date];
    gameScore = 450.123456;
    group = [NSArray arrayWithObjects:userName,@"Shephertz1", nil];
    scoreId = @"BrWWWYn83l3zVH3NwbbuQWcadPE=";
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
    if ([cell.textLabel.text isEqualToString:@"SaveUserScore"])
    {
        [self saveUserScore];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetScoresByUser"])
    {
        [self getScoresByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetHighestScoreByUser"])
    {
        [self getHighestScoreByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetLowestScoreByUser"])
    {
        [self getLowestScoreByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopRankings"])
    {
        [self getTopRankings];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAverageScoreByUser"])
    {
        [self getAverageScoreByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopNRankings"])
    {
        [self getTopNRankings];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopRankersByGroup"])
    {
        [self getTopRankersByGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopRankingsByGroup"])
    {
        [self getTopRankingsByGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopRankingsInDateRange"])
    {
        [self getTopRankingsInDateRange];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopNRankersInDateRange"])
    {
        [self getTopNRankersInDateRange];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetLastGameScore"])
    {
        [self getLastGameScore];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetUserRanking"])
    {
        [self getUserRanking];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetLastScoreByUser"])
    {
        [self getLastScoreByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"EditScoreValueById"])
    {
        [self editScoreValueById];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopRankersFromBuddyGroup"])
    {
        [self getTopRankersFromBuddyGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopNRankersFromFacebook"])
    {
        [self getTopNRankersFromFacebook];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopNRankersFromFacebookInDateRange"])
    {
        [self getTopNRankersFromFacebookInDateRange];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopNTargetRankers"])
    {
        [self getTopNTargetRankers];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetUsersWithScoreRange"])
    {
        [self getUsersWithScoreRange];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTopNRankers"])
    {
        [self getTopNRankers];
    }
}
-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
    
}

-(void)saveUserScore
{
    //gameScore += 1;
    [scoreboardService saveUserScore:gameName gameUserName:userName gameScore:gameScore completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
     {
        if (success)
        {
            Game *game = (Game*)responseObj;
            
            if (game.isOfflineSync)
            {
                //Request is saved in cache
                NSLog(@"Offline Response = %@",game.strResponse);
            }
            else
            {
                //Response Received From Server and is Succeseful
                NSLog(@"Game Name=%@",game.name);
                NSLog(@"Description =%@",game.description);
                
                for (Score *score in game.scoreList)
                {
                    NSLog(@"UserName=%@",score.userName);
                    NSLog(@"ScoreId=%@",score.scoreId);
                    NSLog(@"CreatedOn=%@",score.createdOn);
                    NSLog(@"Score=%f",score.value);
                    
                    for (JSONDocument *doc in score.jsonDocArray)
                    {
                        NSLog(@"CreatedAt=%@",doc.createdAt);
                        NSLog(@"UpdatedAt=%@",doc.updatedAt);
                        NSLog(@"DocId=%@",doc.docId);
                        NSLog(@"Owner=%@",doc.owner);
                        NSLog(@"Doc=%@",doc.jsonDoc);
                    }
                }
            }
            
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getScoresByUser
{
    [scoreboardService getScoresByUser:gameName gameUserName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getHighestScoreByUser
{
    [scoreboardService getHighestScoreByUser:gameName gameUserName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getLowestScoreByUser
{
    [scoreboardService getLowestScoreByUser:gameName gameUserName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopRankings
{
    [scoreboardService getTopRankings:gameName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getAverageScoreByUser
{
    [scoreboardService getAverageScoreByUser:gameName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopNRankings
{
    max = 1;
    [scoreboardService getTopNRankings:gameName max:max completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopNRankers
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"score",@"orderByAscending",nil];
    [scoreboardService setOtherMetaHeaders:dict];
    
    [scoreboardService getTopNRankers:gameName max:max completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopRankersByGroup
{
    [scoreboardService getTopRankersByGroup:gameName group:group completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopRankingsByGroup
{
    [scoreboardService getTopRankingsByGroup:gameName group:group completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopRankingsInDateRange
{
    [scoreboardService getTopRankings:gameName startDate:startDate endDate:endDate completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopNRankersInDateRange
{
    [scoreboardService getTopNRankers:gameName startDate:startDate endDate:endDate max:max completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getLastGameScore
{
    [scoreboardService getLastGameScore:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getUserRanking
{
    [scoreboardService getUserRanking:gameName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getLastScoreByUser
{
    [scoreboardService getLastScoreByUser:gameName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)editScoreValueById
{
    
    [scoreboardService editScoreValueById:scoreId gameScore:gameScore/2 completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopRankersFromBuddyGroup
{
    NSString *ownerName = @"Rajeev";
    NSString *groupName = @"Shephertzians";
    
    [scoreboardService getTopRankersFromBuddyGroup:gameName userName:ownerName ownerName:ownerName groupName:groupName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}

-(void)getTopNRankersFromFacebook
{
    NSString *fbAccessToken = @"CAADBZBGAg6a4BAJnbyabI7Nzhcf7nqLvVDikGX7BMExlCwvBZBPzYP7MUKphP6BhqCrIXLWOeGWwOLTCt7hOeFqivZB935Qsa0csXYqj5kOpLujhpO59XsHR0dXKl8h5UiBb0B5ZCaeOozgLQXnCzZC0HSsyZCP4O3DYAYBxTnyvIlK0Ix1CWeljEA58DLKoK04DKRgWV1HfmGL3f68ZAzr";
    
    [scoreboardService getTopNRankersFromFacebook:gameName fbAccessToken:fbAccessToken max:max completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}

-(void)getTopNRankersFromFacebookInDateRange
{
    NSString *fbAccessToken = @"";
    [scoreboardService getTopNRankersFromFacebook:gameName fbAccessToken:fbAccessToken startDate:startDate endDate:endDate max:max completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getTopNTargetRankers
{
    [scoreboardService getTopNTargetRankers:gameName max:max completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}
-(void)getUsersWithScoreRange
{
    double minScore = 10;
    double maxScore = 1000;
    
    [scoreboardService getUsersWithScoreRange:gameName minScore:minScore maxScore:maxScore completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
            
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"ScoreId=%@",score.scoreId);
                NSLog(@"CreatedOn=%@",score.createdOn);
                NSLog(@"Score=%f",score.value);
                
                for (JSONDocument *doc in score.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Owner=%@",doc.owner);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            [self showResponse:game.strResponse];
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP Error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
            [self showResponse:[exception reason]];
        }
    }];
}

@end
