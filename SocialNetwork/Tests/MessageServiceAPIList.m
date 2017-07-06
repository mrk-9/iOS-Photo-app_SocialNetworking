//
//  MessageServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "MessageServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface MessageServiceAPIList ()
{
    QueueService *queueService;
    NSString *queueName;
    NSString *queueDescription;
    NSString *message;
    NSString *messageId;
    NSString *correlationId;
    long timeOut;

}
@end

@implementation MessageServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Message/Queue Service";
   
    queueService = [App42API buildQueueService];

    queueName = @"TestQueue";
    queueDescription = @"This is a testing queue!";
    message = @"Hi, how are you today?";
    messageId = @"";
    correlationId = @"";
    timeOut = 600000;
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
    if ([cell.textLabel.text isEqualToString:@"CreatePullQueue"])
    {
        [self createPullQueue];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeletePullQueue"])
    {
        [self deletePullQueue];
    }
    else if ([cell.textLabel.text isEqualToString:@"PurgePullQueue"])
    {
        [self purgePullQueue];
    }
    else if ([cell.textLabel.text isEqualToString:@"PendingMessages"])
    {
        [self pendingMessages];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetMessages"])
    {
        [self getMessages];
    }
    else if ([cell.textLabel.text isEqualToString:@"SendMessage"])
    {
        [self sendMessage];
    }
    else if ([cell.textLabel.text isEqualToString:@"ReceiveMessage"])
    {
        [self receiveMessage];
    }
    else if ([cell.textLabel.text isEqualToString:@"ReceiveMessageByCorrelationId"])
    {
        [self receiveMessageByCorrelationId];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveMessage"])
    {
        [self removeMessage];
    }
}

-(void)createPullQueue
{
    [queueService createPullQueue:queueName description:queueDescription completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Queue *queue = (Queue*)responseObj;
            NSLog(@"Response is %@" , queue.strResponse);
            NSLog(@"isResponseSuccess is %d" , queue.isResponseSuccess);
            for (Message *l_message in queue.messageArray)
            {
                correlationId = l_message.correlationId;
                messageId = l_message.messageId;
                NSLog(@"CorrelationId is =%@",l_message.correlationId);
                NSLog(@"MessageId is  = %@",l_message.messageId);
                NSLog(@"Payload is  = %@",l_message.payLoad);
            }
            [self showResponse:queue.strResponse];
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
-(void)deletePullQueue
{
    [queueService deletePullQueue:queueName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response is %@" , app42Response.strResponse);
            NSLog(@"isResponseSuccess is %d" , app42Response.isResponseSuccess);
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
-(void)purgePullQueue
{
    [queueService purgePullQueue:queueName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response is %@" , app42Response.strResponse);
            NSLog(@"isResponseSuccess is %d" , app42Response.isResponseSuccess);
            
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

-(void)pendingMessages
{
    [queueService pendingMessages:queueName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Queue *queue = (Queue*)responseObj;
            NSLog(@"Response is %@" , queue.strResponse);
            NSLog(@"isResponseSuccess is %d" , queue.isResponseSuccess);
            for (Message *l_message in queue.messageArray)
            {
                correlationId = l_message.correlationId;
                messageId = l_message.messageId;
                NSLog(@"CorrelationId is =%@",l_message.correlationId);
                NSLog(@"MessageId is  = %@",l_message.messageId);
                NSLog(@"Payload is  = %@",l_message.payLoad);
            }
            [self showResponse:queue.strResponse];
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
-(void)getMessages
{
    [queueService getMessages:queueName receiveTimeOut:timeOut completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Queue *queue = (Queue*)responseObj;
            NSLog(@"Response is %@" , queue.strResponse);
            NSLog(@"isResponseSuccess is %d" , queue.isResponseSuccess);
            for (Message *l_message in queue.messageArray)
            {
                correlationId = l_message.correlationId;
                messageId = l_message.messageId;
                NSLog(@"CorrelationId is =%@",l_message.correlationId);
                NSLog(@"MessageId is  = %@",l_message.messageId);
                NSLog(@"Payload is  = %@",l_message.payLoad);
            }
            [self showResponse:queue.strResponse];
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
-(void)sendMessage
{
    [queueService sendMessage:queueName message:message expiryTime:timeOut completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Queue *queue = (Queue*)responseObj;
            NSLog(@"Response is %@" , queue.strResponse);
            NSLog(@"isResponseSuccess is %d" , queue.isResponseSuccess);
            for (Message *l_message in queue.messageArray)
            {
                correlationId = l_message.correlationId;
                messageId = l_message.messageId;
                NSLog(@"CorrelationId is =%@",l_message.correlationId);
                NSLog(@"MessageId is  = %@",l_message.messageId);
                NSLog(@"Payload is  = %@",l_message.payLoad);
            }
            [self showResponse:queue.strResponse];
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
-(void)receiveMessage
{
    [queueService receiveMessage:queueName receiveTimeOut:timeOut completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Queue *queue = (Queue*)responseObj;
            NSLog(@"Response is %@" , queue.strResponse);
            NSLog(@"isResponseSuccess is %d" , queue.isResponseSuccess);
            for (Message *l_message in queue.messageArray)
            {
                correlationId = l_message.correlationId;
                messageId = l_message.messageId;
                NSLog(@"CorrelationId is =%@",l_message.correlationId);
                NSLog(@"MessageId is  = %@",l_message.messageId);
                NSLog(@"Payload is  = %@",l_message.payLoad);
            }
            [self showResponse:queue.strResponse];
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
-(void)receiveMessageByCorrelationId
{
    [queueService receiveMessageByCorrelationId:queueName receiveTimeOut:timeOut correlationId:correlationId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Queue *queue = (Queue*)responseObj;
            NSLog(@"Response is %@" , queue.strResponse);
            NSLog(@"isResponseSuccess is %d" , queue.isResponseSuccess);
            for (Message *l_message in queue.messageArray)
            {
                correlationId = l_message.correlationId;
                messageId = l_message.messageId;
                NSLog(@"CorrelationId is =%@",l_message.correlationId);
                NSLog(@"MessageId is  = %@",l_message.messageId);
                NSLog(@"Payload is  = %@",l_message.payLoad);
            }
            [self showResponse:queue.strResponse];
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
-(void)removeMessage
{
    [queueService removeMessage:queueName messageId:messageId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response is %@" , app42Response.strResponse);
            NSLog(@"isResponseSuccess is %d" , app42Response.isResponseSuccess);
            
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
