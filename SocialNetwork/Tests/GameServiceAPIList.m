//
//  GameServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 17/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "GameServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"



@interface GameServiceAPIList ()
{
    GameService *gameService;
    NSString *gameName ;
    NSString *gameDescription ;
}
@end

@implementation GameServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Game Service";
    
    gameService = [App42API buildGameService];
    
    gameName = @"StarOFWar";
    gameDescription = @"StarOFWar";
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
    if ([cell.textLabel.text isEqualToString:@"CreateGame"])
    {
        [self createGame];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllGamesCount"])
    {
        [self getAllGamesCount];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllGames"])
    {
        [self getAllGames];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllGamesByPaging"])
    {
        [self getAllGamesByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetGameByName"])
    {
        [self getGameByName];
    }
    
}
-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)createGame
{
    [gameService createGame:gameName gameDescription:gameDescription completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            NSLog(@"Description =%@",game.description);
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

-(void)getAllGamesCount
{
    [gameService getAllGamesCount:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response =%@",app42Response.strResponse);
            NSLog(@"TotalGameCount = %d",app42Response.totalRecords);
            [self showResponse:app42Response.strResponse];
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

-(void)getAllGames
{
    [gameService getAllGames:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            NSArray *gameList = (NSArray*)responseObj;
            for (Game *game in gameList) {
                NSLog(@"Game Name=%@",game.name);
                NSLog(@"Description =%@",game.description);
                for (Score *score in game.scoreList) {
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
            [self showResponse:[gameList description]];
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

-(void)getAllGamesByPaging
{
    int max = 5;
    int offset = 0;
    
    [gameService getAllGames:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            NSArray *gameList = (NSArray*)responseObj;
            for (Game *game in gameList) {
                NSLog(@"Game Name=%@",game.name);
                NSLog(@"Description =%@",game.description);
                for (Score *score in game.scoreList) {
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
            [self showResponse:[gameList description]];
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

-(void)getGameByName
{
    [gameService getGameByName:gameName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
                Game *game = (Game*)responseObj;
                NSLog(@"Game Name=%@",game.name);
                NSLog(@"Description =%@",game.description);
            
                for (Score *score in game.scoreList) {
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
