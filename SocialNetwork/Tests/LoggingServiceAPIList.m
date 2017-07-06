//
//  LoggingServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "LoggingServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface LoggingServiceAPIList ()
{
    LogService *logService;
}
@end

@implementation LoggingServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Log Service";
   
    logService = [App42API buildLogService];

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
    if ([cell.textLabel.text isEqualToString:@"Info"])
    {
        [self info];
    }
    else if ([cell.textLabel.text isEqualToString:@"debug"])
    {
        [self debug];
    }
    else if ([cell.textLabel.text isEqualToString:@"error"])
    {
        [self error];
    }
    else if ([cell.textLabel.text isEqualToString:@"fatal"])
    {
        [self fatal];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsCountByModule"])
    {
        [self fetchLogsCountByModule];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsByModule"])
    {
        [self fetchLogsByModule];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsByFatal"])
    {
        [self fetchLogsByFatal];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsByError"])
    {
        [self fetchLogsByError];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsByError"])
    {
        [self fetchLogsByError];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsByInfo"])
    {
        [self fetchLogsByInfo];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsByDebug"])
    {
        [self fetchLogsByDebug];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsCountByFatal"])
    {
        [self fetchLogsCountByFatal];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsCountByError"])
    {
        [self fetchLogsCountByError];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsCountByDebug"])
    {
        [self fetchLogsCountByDebug];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsCountByInfo"])
    {
        [self fetchLogsCountByInfo];
    }
    else if ([cell.textLabel.text isEqualToString:@"fetchLogsByModuleAndText"])
    {
        [self fetchLogsByModuleAndText];
    }
    
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)info
{
    
    [logService info:@"Messaege for success" module:@"AppInfo" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
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

-(void)debug
{
    
    [logService debug:@"Messaege for success" module:@"AppDebug" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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


-(void)error
{
    
    [logService error:@"Messaege for success" module:@"AppError" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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

-(void)fatal
{
    
    [logService fatal:@"Messaege for success" module:@"AppFatal" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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


-(void)fetchLogsCountByModule
{
    
    [logService fetchLogsCountByModule:@"AppFatal" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
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

-(void)fetchLogsByModule
{
    
    [logService fetchLogsByModule:@"AppFatal" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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

-(void)fetchLogsByFatal
{
    
    [logService fetchLogsByFatal:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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

-(void)fetchLogsByError
{
    
    [logService fetchLogsByError:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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

-(void)fetchLogsByDebug
{
    
    [logService fetchLogsByDebug:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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
-(void)fetchLogsByInfo
{
    
    [logService fetchLogsByInfo:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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

-(void)fetchLogsCountByFatal
{
    
    [logService fetchLogsCountByFatal:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
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

-(void)fetchLogsCountByError
{
    
    [logService fetchLogsCountByError:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
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

-(void)fetchLogsCountByDebug
{
    
    [logService fetchLogsCountByDebug:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
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

-(void)fetchLogsCountByInfo
{
    
    [logService fetchLogsCountByInfo:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
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

-(void)fetchLogsByModuleAndText
{
    
    [logService fetchLogsByModuleAndText:@"AppInfo" text:@"Messaege for success" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Log *response = (Log*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (LogMessage *message in response.logMessageArray)
            {
                NSLog(@"module is =%@",message.module);
                NSLog(@"logTime is  = %@",message.logTime);
            }
            
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
