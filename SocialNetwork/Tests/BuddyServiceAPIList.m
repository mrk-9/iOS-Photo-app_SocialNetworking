//
//  BuddyServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 19/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "BuddyServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface BuddyServiceAPIList ()
{
    BuddyService *buddyService;
    NSString *userName;
    NSString *buddyName;
    NSString *ownerName;
    NSString *groupName;
    NSString *message;
    NSString *messageId;
    NSMutableArray  *messageIds;
    NSArray  *friendsArray;
}
@end

@implementation BuddyServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Buddy Service";
    
    buddyService = [App42API buildBuddyService];
    
    userName = @"Rajeev";
    buddyName = @"Ranjan";
    groupName = @"Shephertzians";
    ownerName = @"Rajeev";
    message = @"Please add me to your conection!";
    friendsArray = [NSArray arrayWithObjects:userName,buddyName, nil];
    messageIds = [[NSMutableArray alloc] initWithCapacity:0];
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
    if ([cell.textLabel.text isEqualToString:@"SendFriendRequestFromUser"])
    {
        [self sendFriendRequestFromUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFriendRequest"])
    {
        [self getFriendRequest];
    }
    else if ([cell.textLabel.text isEqualToString:@"AcceptFriendRequestFromBuddy"])
    {
        [self acceptFriendRequestFromBuddy];
    }
    else if ([cell.textLabel.text isEqualToString:@"RejectFriendRequestFromBuddy"])
    {
        [self rejectFriendRequestFromBuddy];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateGroup"])
    {
        [self createGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllFriends"])
    {
        [self getAllFriends];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddFriends"])
    {
        [self addFriends];
    }
    else if ([cell.textLabel.text isEqualToString:@"CheckedInWithUser"])
    {
        [self checkedInWithUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFriendsOfUser"])
    {
        [self getFriendsOfUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllGroups"])
    {
        [self getAllGroups];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllFriendsOfUser"])
    {
        [self getAllFriendsOfUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"BlockFriendRequestFromBuddy"])
    {
        [self blockFriendRequestFromBuddy];
    }
    else if ([cell.textLabel.text isEqualToString:@"BlockBuddy"])
    {
        [self blockBuddy];
    }
    else if ([cell.textLabel.text isEqualToString:@"UnblockBuddy"])
    {
        [self unblockBuddy];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendMessageToGroup"])
    {
        [self sendMessageToGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendMessageToFriend"])
    {
        [self sendMessageToFriend];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendMessageToFriends"])
    {
        [self sendMessageToFriends];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllMessages"])
    {
        [self getAllMessages];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllMessagesFromBuddy"])
    {
        [self getAllMessagesFromBuddy];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllMessagesFromGroup"])
    {
        [self getAllMessagesFromGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"UnFriend"])
    {
        [self unFriend];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteMessageById"])
    {
        [self deleteMessageById];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteMessageByIds"])
    {
        [self deleteMessageByIds];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)sendFriendRequestFromUser
{
    [buddyService sendFriendRequestFromUser:userName toBuddy:buddyName withMessage:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
            
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
-(void)getFriendRequest
{
    [buddyService getFriendRequest:buddyName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            }
            [self showResponse:[buddyList description]];
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
-(void)acceptFriendRequestFromBuddy
{
    [buddyService acceptFriendRequestFromBuddy:userName toUser:buddyName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
            
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
-(void)rejectFriendRequestFromBuddy
{
    [buddyService rejectFriendRequestFromBuddy:userName toUser:buddyName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
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
-(void)createGroup
{
    [buddyService createGroup:groupName byUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
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
-(void)getAllFriends
{
    [buddyService getAllFriends:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            }
            [self showResponse:[buddyList description]];
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
-(void)addFriends
{
    [buddyService addFriends:friendsArray ofUser:userName toGroup:groupName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            }
            [self showResponse:[buddyList description]];
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
-(void)checkedInWithUser
{
    GeoPoint *geoPoint = [[GeoPoint alloc] init];
    geoPoint.latitude = 50.0;
    geoPoint.longitude = 50.0;
    geoPoint.marker = @"Here";
    [buddyService checkedInWithUser:userName geoLocation:geoPoint completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
            
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
-(void)getFriendsOfUser
{
    double lat = 50;
    double lng = 50;
    double radius = 50;
    int max = 10;
    [buddyService getFriendsOfUser:userName withLatitude:lat andLongitude:lng inRadius:radius max:max completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            }
            [self showResponse:[buddyList description]];
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
-(void)getAllGroups
{
    [buddyService getAllGroups:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"GroupName=%@",buddy.groupName);
            }
            [self showResponse:[buddyList description]];
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
-(void)getAllFriendsOfUser
{
    [buddyService getAllFriendsOfUser:userName inGroup:groupName ofOwner:ownerName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            }
            [self showResponse:[buddyList description]];
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
-(void)blockFriendRequestFromBuddy
{
    [buddyService blockFriendRequestFromBuddy:userName toUser:buddyName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
            
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
-(void)blockBuddy
{
    [buddyService blockBuddy:buddyName byUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
            
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
-(void)unblockBuddy
{
    [buddyService unblockBuddy:buddyName byUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
            
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
-(void)sendMessageToGroup
{
    [buddyService sendMessage:message fromUser:userName toGroup:groupName ofGroupOwner:ownerName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
            
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

-(void)sendMessageToFriend
{
    [buddyService sendMessage:message toFriend:buddyName fromUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Buddy *buddy = (Buddy*)responseObj;
            NSLog(@"Response=%@",buddy.strResponse);
            NSLog(@"BuddyName=%@",buddy.buddyName);
            NSLog(@"UserName=%@",buddy.userName);
            NSLog(@"Message=%@",buddy.message);
            NSLog(@"MessageId=%@",buddy.messageId);
            NSLog(@"OwnerName=%@",buddy.ownerName);
            NSLog(@"GroupName=%@",buddy.groupName);
            NSLog(@"SentOn=%@",buddy.sendedOn);
            NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            [self showResponse:buddy.strResponse];
            
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

-(void)sendMessageToFriends
{
    [buddyService sendMessageToFriends:message fromUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            }
            [self showResponse:[buddyList description]];
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
-(void)getAllMessages
{
    [buddyService getAllMessages:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
                messageId = buddy.messageId;
                [messageIds addObject:messageId];

            }
            [self showResponse:[buddyList description]];
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
-(void)getAllMessagesFromBuddy
{
    [buddyService getAllMessagesFromBuddy:buddyName toUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            }
            [self showResponse:[buddyList description]];
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
-(void)getAllMessagesFromGroup
{
    [buddyService getAllMessagesFromGroup:groupName ofGroupOwner:ownerName toUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *buddyList = (NSArray*)responseObj;
            for (Buddy *buddy in buddyList) {
                NSLog(@"Response=%@",buddy.strResponse);
                NSLog(@"BuddyName=%@",buddy.buddyName);
                NSLog(@"UserName=%@",buddy.userName);
                NSLog(@"Message=%@",buddy.message);
                NSLog(@"MessageId=%@",buddy.messageId);
                NSLog(@"OwnerName=%@",buddy.ownerName);
                NSLog(@"GroupName=%@",buddy.groupName);
                NSLog(@"SentOn=%@",buddy.sendedOn);
                NSLog(@"AcceptedOn=%@",buddy.acceptedOn);
            }
            [self showResponse:[buddyList description]];
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
-(void)unFriend
{
    [buddyService unFriend:userName buddyName:buddyName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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
-(void)deleteMessageById
{
    [buddyService deleteMessageById:messageId userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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
-(void)deleteMessageByIds
{
    [buddyService deleteMessageByIds:messageIds userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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

@end
