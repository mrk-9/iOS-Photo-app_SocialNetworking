//
//  EventServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 11/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "EventServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface EventServiceAPIList ()
{
    EventService *eventService;
}
@end

@implementation EventServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Event Service";
    //[App42API setLoggedInUser:@"Rajeev"];
    //[App42API enableApp42Trace:YES];
   // [App42API enableAppStateEventTracking:YES];
   // [App42API enableEventService:YES];
   // [App42API setOfflineStorage:YES];
    EventService *eventService = [App42API buildEventService];
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
    if ([cell.textLabel.text isEqualToString:@"TrackEventWithName"])
    {
        [self trackEvent];
    }
    else if ([cell.textLabel.text isEqualToString:@"StartActivityWithName"])
    {
        [self startActivity];
    }
    else if ([cell.textLabel.text isEqualToString:@"EndActivityWithName"])
    {
        [self endActivity];
    }
    else if ([cell.textLabel.text isEqualToString:@"SetLoggedInUserProperties"])
    {
        [self setLoggedInUserProperties];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateLoggedInUserProperties"])
    {
        [self updateLoggedInUserProperties];
    }
}



-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
    
}

-(void)setLoggedInUserProperties
{
NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:@"Free",@"UserType", nil];
[eventService setLoggedInUserProperties:properties completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
    if (success)
    {
        App42Response *response = (App42Response*)responseObj;
        NSLog(@"IsResponseSuccess is %d" , response.isResponseSuccess);
    }
    else
    {
        NSLog(@"Exception = %@",[exception reason]);
        NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
        NSLog(@"App Error Code = %d",[exception appErrorCode]);
        NSLog(@"User Info = %@",[exception userInfo]);
    }
}];
}

-(void)updateLoggedInUserProperties
{
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:@"Premium",@"UserType",@"Admin",@"UserRole", nil];
    [eventService updateLoggedInUserProperties:properties completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
             NSLog(@"isResponseSuccess is %d" , response.isResponseSuccess);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}

-(void)trackEvent
{
    NSString *eventName = @"Purchase_1";
    NSDictionary *properties = @{@"key": @"value"};
    [eventService trackEventWithName:eventName andProperties:properties completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
            NSLog(@"IsResponseSuccess is %d" , response.isResponseSuccess);
        }
        else
        {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];
}

-(void)startActivity
{
NSString *activityName = @"Level1";
NSDictionary *properties = @{@"key": @"value"};
[eventService startActivityWithName:activityName andProperties:properties completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
    if (success)
    {
        App42Response *response = (App42Response*)responseObj;
        NSLog(@"IsResponseSuccess is %d" , response.isResponseSuccess);
    }
    else
    {
        NSLog(@"Exception = %@",[exception reason]);
        NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
        NSLog(@"App Error Code = %d",[exception appErrorCode]);
        NSLog(@"User Info = %@",[exception userInfo]);
    }
}];
}

-(void)endActivity
{
NSString *activityName = @"Level1";
NSDictionary *properties = @{@"key": @"value"};
[eventService endActivityWithName:activityName andProperties:properties completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
    if (success)
    {
        App42Response *response = (App42Response*)responseObj;
        NSLog(@"IsResponseSuccess is %d" , response.isResponseSuccess);
    }
    else
    {
        NSLog(@"Exception = %@",[exception reason]);
        NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
        NSLog(@"App Error Code = %d",[exception appErrorCode]);
        NSLog(@"User Info = %@",[exception userInfo]);
    }
}];
}



@end
