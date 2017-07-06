//
//  ScoreService.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 17/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "ScoreServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface ScoreServiceAPIList ()
{
    ScoreService *scoreService;
}
@end

@implementation ScoreServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Score Service";
    
    scoreService = [App42API buildScoreService];
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
    if ([cell.textLabel.text isEqualToString:@"AddScore"])
    {
        [self addScore];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeductScore"])
    {
        [self deductScore];
    }
    
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}
-(void)addScore
{
    NSString *gameName = @"StarOFWar";
    NSString *userName = @"Shephertz";
    double gameScore = 300;
    [scoreService addScore:gameName gameUserName:userName gScore:gameScore completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Game *game = (Game*)responseObj;
            NSLog(@"Game Name=%@",game.name);
            for (Score *score in game.scoreList)
            {
                NSLog(@"UserName=%@",score.userName);
                NSLog(@"Score=%f",score.value);
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
-(void)deductScore
{
    NSString *gameName = @"StarOFWar";
    NSString *userName = @"Shephertz";
    double gameScore = 300;
    [scoreService deductScore:gameName gameUserName:userName gameScore:gameScore completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success) {
             Game *game = (Game*)responseObj;
             NSLog(@"Game Name=%@",game.name);
             NSLog(@"Description =%@",game.description);
             for (Score *score in game.scoreList)
             {
                 NSLog(@"UserName=%@",score.userName);
                 NSLog(@"Score=%f",score.value);
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
