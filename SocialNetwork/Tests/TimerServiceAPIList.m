//
//  TimerServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "TimerServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface TimerServiceAPIList ()
{
    TimerService *timerService;
    NSString *timerName;
    NSString *userName;
    long timeInSeconds;
}
@end

@implementation TimerServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Timer Service";
    
    timerService = [App42API buildTimerService];
    timerName = @"App42Watch";
    userName = @"Shephertz";
    timeInSeconds = 60;
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
    if ([cell.textLabel.text isEqualToString:@"CreateOrUpdateTimerWithName"])
    {
        [self createOrUpdateTimerWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"StartTimerWithName"])
    {
        [self startTimerWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"IsTimerActive"])
    {
        [self isTimerActive];
    }
    else if ([cell.textLabel.text isEqualToString:@"CancelTimerWithName"])
    {
        [self cancelTimerWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteTimerWithName"])
    {
        [self deleteTimerWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetCurrentTime"])
    {
        [self getCurrentTime];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)createOrUpdateTimerWithName
{
    
    [timerService createOrUpdateTimerWithName:timerName timeInSeconds:timeInSeconds completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Timer *timer = (Timer*)responseObj;
            NSLog(@"TimerName = %@",timer.name);
            NSLog(@"CurrentTime = %@",timer.currentTime);
            NSLog(@"StartTime = %@",timer.startTime);
            NSLog(@"EndTime = %@",timer.endTime);
            NSLog(@"UserName = %@",timer.userName);
            [self showResponse:timer.strResponse];
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
-(void)startTimerWithName
{
    [timerService startTimerWithName:timerName forUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Timer *timer = (Timer*)responseObj;
            NSLog(@"TimerName = %@",timer.name);
            NSLog(@"CurrentTime = %@",timer.currentTime);
            NSLog(@"StartTime = %@",timer.startTime);
            NSLog(@"EndTime = %@",timer.endTime);
            NSLog(@"UserName = %@",timer.userName);
            [self showResponse:timer.strResponse];
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
-(void)isTimerActive
{
    [timerService isTimerActive:timerName forUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Timer *timer = (Timer*)responseObj;
            NSLog(@"TimerName = %@",timer.name);
            NSLog(@"CurrentTime = %@",timer.currentTime);
            NSLog(@"StartTime = %@",timer.startTime);
            NSLog(@"EndTime = %@",timer.endTime);
            NSLog(@"UserName = %@",timer.userName);
            [self showResponse:timer.strResponse];
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
-(void)cancelTimerWithName
{
    [timerService cancelTimerWithName:timerName forUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Timer *timer = (Timer*)responseObj;
            NSLog(@"TimerName = %@",timer.name);
            NSLog(@"CurrentTime = %@",timer.currentTime);
            NSLog(@"StartTime = %@",timer.startTime);
            NSLog(@"EndTime = %@",timer.endTime);
            NSLog(@"UserName = %@",timer.userName);
            [self showResponse:timer.strResponse];
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
-(void)deleteTimerWithName
{
    [timerService deleteTimerWithName:timerName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            App42Response *app42Response = (App42Response*)responseObj;
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
-(void)getCurrentTime
{
    [timerService getCurrentTime:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Timer *timer = (Timer*)responseObj;
            NSLog(@"TimerName = %@",timer.name);
            NSLog(@"CurrentTime = %@",timer.currentTime);
            NSLog(@"StartTime = %@",timer.startTime);
            NSLog(@"EndTime = %@",timer.endTime);
            NSLog(@"UserName = %@",timer.userName);
            [self showResponse:timer.strResponse];
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
