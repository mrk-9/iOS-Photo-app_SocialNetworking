//
//  PushAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 13/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "PushAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"
#import "AppDelegate.h"


@interface PushAPIList ()
{
    PushNotificationService *pushService;
}
@property(nonatomic,copy) NSString *deviceToken;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *channelName;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSDictionary *messageDict;

@end

@implementation PushAPIList
@synthesize apiList,deviceToken,userName,channelName,message,messageDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"PushNotification Service";
    
    pushService = [App42API buildPushService];
    
    //self.deviceToken = [(AppDelegate*)[[UIApplication sharedApplication] delegate] getDeviceToken];
    self.userName = @"Shephertz-Device";
    self.channelName = @"Shephertz";
    self.message = @"Hello, howdy";
    self.messageDict = [NSDictionary dictionaryWithObjectsAndKeys:self.message,@"alert",@"1",@"badge",@"Default",@"sound", nil];
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
    if ([cell.textLabel.text isEqualToString:@"RegisterDeviceToken"])
    {
        [self registerDeviceToken];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateChannelForApp"])
    {
        [self createChannelForApp];
    }
    else if ([cell.textLabel.text isEqualToString:@"SubscribeToChannel"])
    {
        [self subscribeToChannel];
    }
    else if ([cell.textLabel.text isEqualToString:@"UnsubscribeFromChannel"])
    {
        [self unsubscribeFromChannel];
    }
    else if ([cell.textLabel.text isEqualToString:@"SubscribeToChannelWithDeviceToken"])
    {
        [self subscribeToChannelWithDeviceToken];
    }
    else if ([cell.textLabel.text isEqualToString:@"SubscribeToChannelWithTokenType"])
    {
        [self subscribeToChannelWithTokenType];
    }
    else if ([cell.textLabel.text isEqualToString:@"UnsubscribeDeviceToChannel"])
    {
        [self unsubscribeDeviceToChannel];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageToChannel"])
    {
        [self sendPushMessageToChannel];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageDictToChannel"])
    {
        [self sendPushMessageDictToChannel];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageToAll"])
    {
        [self sendPushMessageToAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageToiOS"])
    {
        [self sendPushMessageToiOS];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageToAndroid"])
    {
        [self sendPushMessageToAndroid];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageToUser"])
    {
        [self sendPushMessageToUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageDictToUser"])
    {
        [self sendPushMessageDictToUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushToTargetUsers"])
    {
        [self sendPushToTargetUsers];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageToGroup"])
    {
        [self sendPushMessageToGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendMessageToInActiveUsersFromDate"])
    {
        [self sendMessageToInActiveUsersFromDate];
    }
    else if ([cell.textLabel.text isEqualToString:@"ScheduleMessageToUser"])
    {
        [self scheduleMessageToUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteDeviceToken"])
    {
        [self deleteDeviceToken];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteAllDevices"])
    {
        [self deleteAllDevices];
    }
    else if ([cell.textLabel.text isEqualToString:@"UnsubscribeDeviceForUser"])
    {
        [self unsubscribeDeviceForUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"ResubscribeDeviceForUser"])
    {
        [self resubscribeDeviceForUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendPushMessageToDevice"])
    {
        [self sendPushMessageToDevice];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdatePushBadgeforDevice"])
    {
        [self updatePushBadgeforDevice];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdatePushBadgeforUser"])
    {
        [self updatePushBadgeforUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteChannel"])
    {
        [self deleteChannel];
    }
}

-(void)uploadp12File
{
    
}

-(void)registerDeviceToken
{
    self.deviceToken = @"204b3b21148a2b67b769c331a10c81f789213330d641133848b5e1bb6a4e3b0a";
    if (self.deviceToken)
    {
        //self.userName = [NSString stringWithFormat:@"%@%@",self.userName,[[NSDate date] description]];
        [pushService registerDeviceToken:self.deviceToken withUser:self.userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
            if (success)
            {
                PushNotification *pushNotification = (PushNotification*)responseObj;
                NSLog(@"UserName=%@",pushNotification.userName);
                NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
                NSLog(@"Response=%@",pushNotification.strResponse);
                [self showResponse:pushNotification.strResponse];
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
    
}

-(void)createChannelForApp
{
    NSString *description = @"Creating channel";
    [pushService createChannelForApp:channelName description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];
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

-(void)subscribeToChannel
{
    [pushService subscribeToChannel:channelName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)unsubscribeFromChannel
{
    [pushService unsubscribeFromChannel:channelName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)subscribeToChannelWithDeviceToken
{
    [pushService subscribeToChannel:channelName userName:userName deviceToken:deviceToken completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)subscribeToChannelWithTokenType
{
    [pushService subscribeToChannel:channelName userName:userName deviceToken:deviceToken deviceType:@"iOS" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)unsubscribeDeviceToChannel
{
    [pushService unsubscribeDeviceToChannel:channelName userName:userName deviceToken:deviceToken completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)sendPushMessageToChannel
{
    [pushService sendPushMessageToChannel:channelName withMessage:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)sendPushMessageDictToChannel
{
    [pushService sendPushMessageToChannel:channelName withMessageDictionary:messageDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)sendPushMessageToAll
{
    [pushService sendPushMessageToAll:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)sendPushMessageToiOS
{
    [pushService sendPushMessageToiOS:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)sendPushMessageToAndroid
{
    [pushService sendPushMessageToAndroid:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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

-(void)sendPushMessageToUser
{
    [pushService sendPushMessageToUser:userName message:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)sendPushMessageDictToUser
{
    [pushService sendPushMessageToUser:userName withMessageDictionary:messageDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)sendPushToTargetUsers
{
    [pushService sendPushToTargetUsers:userName dbName:@"" collectionName:@"" query:nil completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)sendPushMessageToGroup
{
    NSArray *group = [NSArray arrayWithObjects:userName, nil];
    [pushService sendPushMessageToGroup:group message:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)sendMessageToInActiveUsersFromDate
{
    [pushService sendMessageToInActiveUsersFromDate:nil toDate:nil message:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)scheduleMessageToUser
{
    [pushService scheduleMessageToUser:userName expiryDate:nil message:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)deleteDeviceToken
{
    [pushService deleteDeviceToken:userName deviceToken:deviceToken completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"isResponseSuccess=%d",app42Response.isResponseSuccess);
            NSLog(@"Response=%@",app42Response.strResponse);
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
-(void)deleteAllDevices
{
    [pushService deleteAllDevices:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"isResponseSuccess=%d",app42Response.isResponseSuccess);
            NSLog(@"Response=%@",app42Response.strResponse);
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
-(void)unsubscribeDeviceForUser
{
    [pushService unsubscribeDeviceForUser:userName deviceToken:deviceToken completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)resubscribeDeviceForUser
{
    [pushService resubscribeDeviceForUser:userName deviceToken:deviceToken completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)sendPushMessageToDevice
{
    [pushService sendPushMessageToDevice:deviceToken userName:userName message:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)updatePushBadgeforDevice
{
    [pushService updatePushBadgeforDevice:deviceToken userName:userName badges:10 completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];
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
-(void)updatePushBadgeforUser
{
    [pushService updatePushBadgeforUser:userName badges:5 completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            PushNotification *pushNotification = (PushNotification*)responseObj;
            NSLog(@"UserName=%@",pushNotification.userName);
            NSLog(@"isResponseSuccess=%d",pushNotification.isResponseSuccess);
            NSLog(@"Response=%@",pushNotification.strResponse);
            [self showResponse:pushNotification.strResponse];

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
-(void)deleteChannel
{
    [pushService deleteChannel:channelName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"isResponseSuccess=%d",app42Response.isResponseSuccess);
            NSLog(@"Response=%@",app42Response.strResponse);
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

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}


@end
