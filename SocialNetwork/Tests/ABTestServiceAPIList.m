//
//  ABTestServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "ABTestServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface ABTestServiceAPIList ()
{
    ABTestService *abtestService;
    NSString *testName;
    NSString *variant;
}
@end

@implementation ABTestServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"A/B Test Service";
    
    testName = @"shoppintItem";
    variant = @"ab";
    abtestService = [App42API buildABTestService];
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
    if ([cell.textLabel.text isEqualToString:@"GoalAchievedForTest"])
    {
        [self goalAchievedForTest];
    }
    else if ([cell.textLabel.text isEqualToString:@"Execute"])
    {
        [self execute];
    }
    else if ([cell.textLabel.text isEqualToString:@"ExecuteDataDriven"])
    {
        [self executeDataDriven];
    }
    else if ([cell.textLabel.text isEqualToString:@"IsActive"])
    {
        [self isActive];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)goalAchievedForTest
{
    [abtestService goalAchievedForTest:testName withVariant:variant completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            ABTest *response = (ABTest*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            NSLog(@"description is %@" , response.description);
            NSLog(@"name is %@" , response.name);
            NSLog(@"type is %@" , response.type);
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
-(void)execute
{
    [abtestService execute:testName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            ABTest *response = (ABTest*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            NSLog(@"description is %@" , response.description);
            NSLog(@"name is %@" , response.name);
            NSLog(@"type is %@" , response.type);
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
-(void)executeDataDriven
{
    [abtestService executeDataDriven:testName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            ABTest *response = (ABTest*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            NSLog(@"description is %@" , response.description);
            NSLog(@"name is %@" , response.name);
            NSLog(@"type is %@" , response.type);
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
-(void)isActive
{
    [abtestService isActive:testName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            ABTest *response = (ABTest*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
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

@end
