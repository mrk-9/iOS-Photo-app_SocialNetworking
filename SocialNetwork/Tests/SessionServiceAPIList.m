//
//  SessionServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 11/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "SessionServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"



@interface SessionServiceAPIList ()
{
    SessionService *sessionService;
    NSString *userName;
    NSString *sessionId;
    NSString *attributeName;
    NSString *attributeValue;
}
@end

@implementation SessionServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Event Service";
    
    sessionService = [App42API buildSessionService];
    
    userName = @"Rajeev";
    attributeName = @"PremiumUser";
    attributeValue = @"Yes";
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
    if ([cell.textLabel.text isEqualToString:@"GetSession"])
    {
        [self getSession];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetOrCreateSession"])
    {
        [self getOrCreateSession];
    }
    else if ([cell.textLabel.text isEqualToString:@"Invalidate"])
    {
        [self invalidate];
    }
    else if ([cell.textLabel.text isEqualToString:@"SetAttribute"])
    {
        [self setAttribute];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAttribute"])
    {
        [self getAttribute];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllAttributes"])
    {
        [self getAllAttributes];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveAttribute"])
    {
        [self removeAttribute];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveAllAttributes"])
    {
        [self removeAllAttribute];
    }
}

-(void)getSession
{
    [sessionService getSession:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Session *session = (Session*)responseObj;
            NSLog(@"Response=%@",session.strResponse);
            NSLog(@"User Name=%@",session.userName);
            NSLog(@"Session Id=%@",session.sessionId);
            NSLog(@"InvalidatedOn=%@",session.invalidatedOn);
            NSLog(@"CreatedOn=%@",session.createdOn);
            for (Attribute *attribute in session.attributeArray) {
                NSLog(@"AttributeName = %@",attribute.name);
                NSLog(@"AttributeValue = %@",attribute.value);
            }
            [self showResponse:session.strResponse];
            sessionId = session.sessionId;
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

-(void)getOrCreateSession
{
    BOOL isCreate = NO;
    [sessionService getSession:userName isCreate:isCreate completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Session *session = (Session*)responseObj;
            NSLog(@"Response=%@",session.strResponse);
            NSLog(@"User Name=%@",session.userName);
            NSLog(@"Session Id=%@",session.sessionId);
            NSLog(@"InvalidatedOn=%@",session.invalidatedOn);
            NSLog(@"CreatedOn=%@",session.createdOn);
            for (Attribute *attribute in session.attributeArray) {
                NSLog(@"AttributeName = %@",attribute.name);
                NSLog(@"AttributeValue = %@",attribute.value);
            }
            [self showResponse:session.strResponse];
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

-(void)invalidate
{
    [sessionService invalidate:sessionId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Session *session = (Session*)responseObj;
            NSLog(@"Response=%@",session.strResponse);
            NSLog(@"User Name=%@",session.userName);
            NSLog(@"Session Id=%@",session.sessionId);
            NSLog(@"InvalidatedOn=%@",session.invalidatedOn);
            NSLog(@"CreatedOn=%@",session.createdOn);
            for (Attribute *attribute in session.attributeArray) {
                NSLog(@"AttributeName = %@",attribute.name);
                NSLog(@"AttributeValue = %@",attribute.value);
            }
            [self showResponse:session.strResponse];
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

-(void)setAttribute
{
    [sessionService setAttribute:sessionId attributeName:attributeName attributeValue:attributeValue completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Session *session = (Session*)responseObj;
            NSLog(@"Response=%@",session.strResponse);
            NSLog(@"User Name=%@",session.userName);
            NSLog(@"Session Id=%@",session.sessionId);
            NSLog(@"InvalidatedOn=%@",session.invalidatedOn);
            NSLog(@"CreatedOn=%@",session.createdOn);
            for (Attribute *attribute in session.attributeArray) {
                NSLog(@"AttributeName = %@",attribute.name);
                NSLog(@"AttributeValue = %@",attribute.value);
            }
            [self showResponse:session.strResponse];
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

-(void)getAttribute
{
    [sessionService getAttribute:sessionId attributeName:attributeName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Session *session = (Session*)responseObj;
            NSLog(@"Response=%@",session.strResponse);
            NSLog(@"User Name=%@",session.userName);
            NSLog(@"Session Id=%@",session.sessionId);
            NSLog(@"InvalidatedOn=%@",session.invalidatedOn);
            NSLog(@"CreatedOn=%@",session.createdOn);
            for (Attribute *attribute in session.attributeArray) {
                NSLog(@"AttributeName = %@",attribute.name);
                NSLog(@"AttributeValue = %@",attribute.value);
            }
            [self showResponse:session.strResponse];
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

-(void)getAllAttributes
{
    [sessionService getAllAttributes:sessionId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Session *session = (Session*)responseObj;
            NSLog(@"Response=%@",session.strResponse);
            NSLog(@"User Name=%@",session.userName);
            NSLog(@"Session Id=%@",session.sessionId);
            NSLog(@"InvalidatedOn=%@",session.invalidatedOn);
            NSLog(@"CreatedOn=%@",session.createdOn);
            for (Attribute *attribute in session.attributeArray) {
                NSLog(@"AttributeName = %@",attribute.name);
                NSLog(@"AttributeValue = %@",attribute.value);
            }
            [self showResponse:session.strResponse];
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

-(void)removeAttribute
{
    [sessionService removeAttribute:sessionId attributeName:attributeName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response=%@",app42Response.strResponse);
            [self showResponse:app42Response.strResponse];
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

-(void)removeAllAttribute
{
    [sessionService removeAllAttributes:sessionId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response=%@",app42Response.strResponse);
            [self showResponse:app42Response.strResponse];
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


-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

@end
