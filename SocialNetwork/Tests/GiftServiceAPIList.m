//
//  GiftServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "GiftServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"



@interface GiftServiceAPIList ()
{
    GiftService *giftService;
    NSString *giftName;
    NSString *giftIconPath;
    NSString *displayName;
    NSString *giftTag;
    NSString *giftDescription;
    NSString *userName;
    NSArray  *recipients;
    NSString *recipient;
    NSString *message;
    NSString *requestId;
}
@end

@implementation GiftServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Gift Service";
    
    giftService = [App42API buildGiftService];
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
    if ([cell.textLabel.text isEqualToString:@"CreateGiftWithName"])
    {
        [self createGiftWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllGifts"])
    {
        [self getAllGifts];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetGiftByName"])
    {
        [self getGiftByName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetGiftsByTag"])
    {
        [self getGiftsByTag];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteGiftByName"])
    {
        [self deleteGiftByName];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendGiftWithName"])
    {
        [self sendGiftWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"RequestGiftWithName"])
    {
        [self requestGiftWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetGiftRequestWithName"])
    {
        [self getGiftRequestWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"DistributeGiftsWithName"])
    {
        [self distributeGiftsWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetGiftCountWithName"])
    {
        [self getGiftCountWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"AcceptGiftRequestWithId"])
    {
        [self distributeGiftsWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"RejectGiftRequestWithId"])
    {
        [self distributeGiftsWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveGiftWithRequestId"])
    {
        [self removeGiftWithRequestId];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}


-(void)createGiftWithName
{
    
    [giftService createGiftWithName:giftName giftIconPath:giftIconPath displayName:displayName giftTag:giftTag description:giftDescription completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Gift *gift = (Gift*)responseObj;
            NSLog(@"Gift Name = %@",gift.name);
            NSLog(@"Display Name = %@",gift.displayName);
            NSLog(@"Icon = %@",gift.icon);
            NSLog(@"Description = %@",gift.description);
            NSLog(@"Tag = %@",gift.tag);
            NSLog(@"CreatedOn = %@",gift.createdOn);
            for (Request *request in gift.requests)
            {
                NSLog(@"Sender = %@",request.sender);
                NSLog(@"Recipient = %@",request.recipient);
                NSLog(@"Message = %@",request.message);
                NSLog(@"RequestID = %@",request.requestId);
                NSLog(@"SentOn = %@",request.sentOn);
                NSLog(@"ReceivedOn = %@",request.receivedOn);
                NSLog(@"Type = %@",request.type);
                NSLog(@"Expiration = %@",request.expiration);
            }
            [self showResponse:gift.strResponse];
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
-(void)getAllGifts
{
    [giftService getAllGifts:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *gifts = (NSArray*)responseObj;
            for (Gift *gift in gifts)
            {
                NSLog(@"Gift Name = %@",gift.name);
                NSLog(@"Display Name = %@",gift.displayName);
                NSLog(@"Icon = %@",gift.icon);
                NSLog(@"Description = %@",gift.description);
                NSLog(@"Tag = %@",gift.tag);
                NSLog(@"CreatedOn = %@",gift.createdOn);
                for (Request *request in gift.requests)
                {
                    NSLog(@"Sender = %@",request.sender);
                    NSLog(@"Recipient = %@",request.recipient);
                    NSLog(@"Message = %@",request.message);
                    NSLog(@"RequestID = %@",request.requestId);
                    NSLog(@"SentOn = %@",request.sentOn);
                    NSLog(@"ReceivedOn = %@",request.receivedOn);
                    NSLog(@"Type = %@",request.type);
                    NSLog(@"Expiration = %@",request.expiration);
                }
            }
            
            [self showResponse:[gifts description]];
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
-(void)getGiftByName
{
    [giftService getGiftByName:giftName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Gift *gift = (Gift*)responseObj;
            NSLog(@"Gift Name = %@",gift.name);
            NSLog(@"Display Name = %@",gift.displayName);
            NSLog(@"Icon = %@",gift.icon);
            NSLog(@"Description = %@",gift.description);
            NSLog(@"Tag = %@",gift.tag);
            NSLog(@"CreatedOn = %@",gift.createdOn);
            for (Request *request in gift.requests)
            {
                NSLog(@"Sender = %@",request.sender);
                NSLog(@"Recipient = %@",request.recipient);
                NSLog(@"Message = %@",request.message);
                NSLog(@"RequestID = %@",request.requestId);
                NSLog(@"SentOn = %@",request.sentOn);
                NSLog(@"ReceivedOn = %@",request.receivedOn);
                NSLog(@"Type = %@",request.type);
                NSLog(@"Expiration = %@",request.expiration);
            }
            [self showResponse:gift.strResponse];
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
-(void)getGiftsByTag
{
    [giftService getGiftsByTag:giftTag completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *gifts = (NSArray*)responseObj;
            for (Gift *gift in gifts)
            {
                NSLog(@"Gift Name = %@",gift.name);
                NSLog(@"Display Name = %@",gift.displayName);
                NSLog(@"Icon = %@",gift.icon);
                NSLog(@"Description = %@",gift.description);
                NSLog(@"Tag = %@",gift.tag);
                NSLog(@"CreatedOn = %@",gift.createdOn);
                for (Request *request in gift.requests)
                {
                    NSLog(@"Sender = %@",request.sender);
                    NSLog(@"Recipient = %@",request.recipient);
                    NSLog(@"Message = %@",request.message);
                    NSLog(@"RequestID = %@",request.requestId);
                    NSLog(@"SentOn = %@",request.sentOn);
                    NSLog(@"ReceivedOn = %@",request.receivedOn);
                    NSLog(@"Type = %@",request.type);
                    NSLog(@"Expiration = %@",request.expiration);
                }
            }
            
            [self showResponse:[gifts description]];
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
-(void)deleteGiftByName
{
    [giftService deleteGiftByName:giftName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42response.strResponse);
            [self showResponse:app42response.strResponse];
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
-(void)sendGiftWithName
{
    [giftService sendGiftWithName:giftName from:userName to:recipients withMessage:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Gift *gift = (Gift*)responseObj;
            NSLog(@"Gift Name = %@",gift.name);
            NSLog(@"Display Name = %@",gift.displayName);
            NSLog(@"Icon = %@",gift.icon);
            NSLog(@"Description = %@",gift.description);
            NSLog(@"Tag = %@",gift.tag);
            NSLog(@"CreatedOn = %@",gift.createdOn);
            for (Request *request in gift.requests)
            {
                NSLog(@"Sender = %@",request.sender);
                NSLog(@"Recipient = %@",request.recipient);
                NSLog(@"Message = %@",request.message);
                NSLog(@"RequestID = %@",request.requestId);
                NSLog(@"SentOn = %@",request.sentOn);
                NSLog(@"ReceivedOn = %@",request.receivedOn);
                NSLog(@"Type = %@",request.type);
                NSLog(@"Expiration = %@",request.expiration);
            }
            [self showResponse:gift.strResponse];
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
-(void)requestGiftWithName
{
    [giftService requestGiftWithName:giftName from:userName to:recipients withMessage:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Gift *gift = (Gift*)responseObj;
            NSLog(@"Gift Name = %@",gift.name);
            NSLog(@"Display Name = %@",gift.displayName);
            NSLog(@"Icon = %@",gift.icon);
            NSLog(@"Description = %@",gift.description);
            NSLog(@"Tag = %@",gift.tag);
            NSLog(@"CreatedOn = %@",gift.createdOn);
            for (Request *request in gift.requests)
            {
                NSLog(@"Sender = %@",request.sender);
                NSLog(@"Recipient = %@",request.recipient);
                NSLog(@"Message = %@",request.message);
                NSLog(@"RequestID = %@",request.requestId);
                NSLog(@"SentOn = %@",request.sentOn);
                NSLog(@"ReceivedOn = %@",request.receivedOn);
                NSLog(@"Type = %@",request.type);
                NSLog(@"Expiration = %@",request.expiration);
            }
            [self showResponse:gift.strResponse];
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
-(void)getGiftRequestWithName
{
    [giftService getGiftRequestWithName:giftName fromUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Gift *gift = (Gift*)responseObj;
            NSLog(@"Gift Name = %@",gift.name);
            NSLog(@"Display Name = %@",gift.displayName);
            NSLog(@"Icon = %@",gift.icon);
            NSLog(@"Description = %@",gift.description);
            NSLog(@"Tag = %@",gift.tag);
            NSLog(@"CreatedOn = %@",gift.createdOn);
            for (Request *request in gift.requests)
            {
                NSLog(@"Sender = %@",request.sender);
                NSLog(@"Recipient = %@",request.recipient);
                NSLog(@"Message = %@",request.message);
                NSLog(@"RequestID = %@",request.requestId);
                NSLog(@"SentOn = %@",request.sentOn);
                NSLog(@"ReceivedOn = %@",request.receivedOn);
                NSLog(@"Type = %@",request.type);
                NSLog(@"Expiration = %@",request.expiration);
            }
            [self showResponse:gift.strResponse];
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
-(void)distributeGiftsWithName
{
    [giftService distributeGiftsWithName:giftName to:recipients count:5 completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *gifts = (NSArray*)responseObj;
            for (Gift *gift in gifts)
            {
                NSLog(@"Gift Name = %@",gift.name);
                NSLog(@"Display Name = %@",gift.displayName);
                NSLog(@"Icon = %@",gift.icon);
                NSLog(@"Description = %@",gift.description);
                NSLog(@"Tag = %@",gift.tag);
                NSLog(@"CreatedOn = %@",gift.createdOn);
                for (Request *request in gift.requests)
                {
                    NSLog(@"Sender = %@",request.sender);
                    NSLog(@"Recipient = %@",request.recipient);
                    NSLog(@"Message = %@",request.message);
                    NSLog(@"RequestID = %@",request.requestId);
                    NSLog(@"SentOn = %@",request.sentOn);
                    NSLog(@"ReceivedOn = %@",request.receivedOn);
                    NSLog(@"Type = %@",request.type);
                    NSLog(@"Expiration = %@",request.expiration);
                }
            }
            
            [self showResponse:[gifts description]];
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
-(void)getGiftCountWithName
{
    [giftService getGiftCountWithName:giftName forUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42response.strResponse);
            NSLog(@"GiftsCount = %d",app42response.totalRecords);
            [self showResponse:app42response.strResponse];
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
-(void)acceptGiftRequestWithId
{
    [giftService acceptGiftRequestWithId:requestId by:recipient completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Gift *gift = (Gift*)responseObj;
            NSLog(@"Gift Name = %@",gift.name);
            NSLog(@"Display Name = %@",gift.displayName);
            NSLog(@"Icon = %@",gift.icon);
            NSLog(@"Description = %@",gift.description);
            NSLog(@"Tag = %@",gift.tag);
            NSLog(@"CreatedOn = %@",gift.createdOn);
            for (Request *request in gift.requests)
            {
                NSLog(@"Sender = %@",request.sender);
                NSLog(@"Recipient = %@",request.recipient);
                NSLog(@"Message = %@",request.message);
                NSLog(@"RequestID = %@",request.requestId);
                NSLog(@"SentOn = %@",request.sentOn);
                NSLog(@"ReceivedOn = %@",request.receivedOn);
                NSLog(@"Type = %@",request.type);
                NSLog(@"Expiration = %@",request.expiration);
            }
            [self showResponse:gift.strResponse];
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
-(void)rejectGiftRequestWithId
{
    [giftService rejectGiftRequestWithId:requestId by:recipient completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Gift *gift = (Gift*)responseObj;
            NSLog(@"Gift Name = %@",gift.name);
            NSLog(@"Display Name = %@",gift.displayName);
            NSLog(@"Icon = %@",gift.icon);
            NSLog(@"Description = %@",gift.description);
            NSLog(@"Tag = %@",gift.tag);
            NSLog(@"CreatedOn = %@",gift.createdOn);
            for (Request *request in gift.requests)
            {
                NSLog(@"Sender = %@",request.sender);
                NSLog(@"Recipient = %@",request.recipient);
                NSLog(@"Message = %@",request.message);
                NSLog(@"RequestID = %@",request.requestId);
                NSLog(@"SentOn = %@",request.sentOn);
                NSLog(@"ReceivedOn = %@",request.receivedOn);
                NSLog(@"Type = %@",request.type);
                NSLog(@"Expiration = %@",request.expiration);
            }
            [self showResponse:gift.strResponse];
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

-(void)removeGiftWithRequestId
{
    [giftService removeGiftWithRequestId:requestId by:recipient completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42response.strResponse);
            [self showResponse:app42response.strResponse];
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
