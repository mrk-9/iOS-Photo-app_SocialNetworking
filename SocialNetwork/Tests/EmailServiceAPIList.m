//
//  EmailServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "EmailServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"



@interface EmailServiceAPIList ()
{
    EmailService *emailService;
    NSString *emailId;
    NSString *host;
    NSString *sendTo;
}
@end

@implementation EmailServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Email Service";
    
    emailId = @"himanshu.sharma@shephertz.co.in";
    host = @"smtp.gmail.com";
    emailService = [App42API buildEmailService];
    
    

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
    if ([cell.textLabel.text isEqualToString:@"Create Email Configuration"])
    {
        [self createEmailCong];
    }
    else if ([cell.textLabel.text isEqualToString:@"Send Email"])
    {
        [self sendEmail];
    }
    else if ([cell.textLabel.text isEqualToString:@"Get Email Configuration"])
    {
        [self getEmail];
    }
    else if ([cell.textLabel.text isEqualToString:@"Remove Email Configuration"])
    {
        [self removeEmail];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)createEmailCong
{
    
    [emailService createEmailConfiguration:host emailPort:465 emailId:emailId emailPassword:@"him@1234" isSSL:true completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Email *response = (Email*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (Configurations *config in response.configurationArray)
            {
                NSLog(@"Email Id is =%@",config.emailId);
                NSLog(@"Host is  = %@",config.host);
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
-(void)sendEmail
{
    [emailService sendMail:@"himanshu.sharma@shephertz.co.in" subject:@"API Testing" Message:@"Congrates" fromEmail:emailId emailMIME:HTML_TEXT_MIME_TYPE completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Email *response = (Email*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (Configurations *config in response.configurationArray)
            {
                NSLog(@"Email Id is =%@",config.emailId);
                NSLog(@"Host is  = %@",config.host);
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
-(void)getEmail
{
    [emailService getEmailConfiguration:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Email *response = (Email*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
            for (Configurations *config in response.configurationArray)
            {
                NSLog(@"Email Id is =%@",config.emailId);
                NSLog(@"Host is  = %@",config.host);
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

-(void)removeEmail
{
    
    [emailService removeEmailConfiguration:emailId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
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
@end
