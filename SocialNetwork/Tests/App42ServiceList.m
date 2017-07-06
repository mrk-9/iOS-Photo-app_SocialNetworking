//
//  App42ServiceList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 21/10/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "App42ServiceList.h"
#import "ABTestServiceAPIList.h"
#import "RecommenderServiceAPIList.h"
#import "AlbumServiceAPIList.h"
#import "PhotoServiceAPIList.h"
#import "EmailServiceAPIList.h"
#import "MessageServiceAPIList.h"
#import "BuddyServiceAPIList.h"
#import "AchievementServiceAPIList.h"
#import "GiftServiceAPIList.h"
#import "LoggingServiceAPIList.h"
#import "UserServiceAPIList.h"
#import "SocialServiceAPIList.h"
#import "SessionServiceAPIList.h"
#import "StorageServiceAPIList.h"
#import "EventServiceAPIList.h"
#import "AvatarServiceAPIList.h"
#import "PushAPIList.h"
#import "RewardServiceAPIList.h"
#import "ScoreboardServiceAPIList.h"
#import "ScoreServiceAPIList.h"
#import "GameServiceAPIList.h"
#import "UploadServiceAPIList.h"
#import "ReviewServiceList.h"
#import "TimerServiceAPIList.h"
#import "CatalogueServiceAPIList.h"
#import "CartServiceAPIList.h"
#import "GeoServiceAPIList.h"

@interface App42ServiceList ()
{
    NSDictionary *serviceList;
    NSArray *sortedKeys;
    int servicesCount;
}
@end

@implementation App42ServiceList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UINavigationBar *navBar = [[UINavigationBar alloc]init];
    // [self.tableView addSubview:navBar];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"App42 Services";
    serviceList = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"App42Services" ofType:@"plist"]];
    servicesCount = (int)[serviceList count];
    
    sortedKeys = [[NSArray alloc] initWithArray:[[serviceList allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)]];
    
    //NSArray * objects = [dict objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"%s",__func__);
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%s",__func__);
    // Return the number of rows in the section.
    return servicesCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

        int index = (int)indexPath.row;
        //NSLog(@"Index : %d",index);
        cell.textLabel.text = [sortedKeys objectAtIndex:index];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"%@",cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:@"User Service"])
    {
        UserServiceAPIList *serviceAPIList = [[UserServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Storage Service"])
    {
        StorageServiceAPIList *serviceAPIList = [[StorageServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Event Service"])
    {
        EventServiceAPIList *serviceAPIList = [[EventServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Avatar Service"])
    {
        AvatarServiceAPIList *serviceAPIList = [[AvatarServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"PushNotification Service"])
    {
        PushAPIList *serviceAPIList = [[PushAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Reward Service"])
    {
        RewardServiceAPIList *serviceAPIList = [[RewardServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Game Service"])
    {
        GameServiceAPIList *serviceAPIList = [[GameServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Scoreboard Service"])
    {
        ScoreboardServiceAPIList *serviceAPIList = [[ScoreboardServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Score Service"])
    {
        ScoreServiceAPIList *serviceAPIList = [[ScoreServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Timer Service"])
    {
        TimerServiceAPIList *serviceAPIList = [[TimerServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Upload Service"])
    {
        UploadServiceAPIList *serviceAPIList = [[UploadServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Review Service"])
    {
        ReviewServiceList *serviceAPIList = [[ReviewServiceList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Achievement Service"])
    {
        AchievementServiceAPIList *serviceAPIList = [[AchievementServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"A/B Test Service"])
    {
        ABTestServiceAPIList *serviceAPIList = [[ABTestServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Gift Service"])
    {
        GiftServiceAPIList *serviceAPIList = [[GiftServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Social Service"])
    {
        SocialServiceAPIList *serviceAPIList = [[SocialServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Session Service"])
    {
        SessionServiceAPIList *serviceAPIList = [[SessionServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Message Service"])
    {
        MessageServiceAPIList *serviceAPIList = [[MessageServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Recommend Service"])
    {
        RecommenderServiceAPIList *serviceAPIList = [[RecommenderServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Email Service"])
    {
        EmailServiceAPIList *serviceAPIList = [[EmailServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Buddy Service"])
    {
        BuddyServiceAPIList *serviceAPIList = [[BuddyServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Album Service"])
    {
        AlbumServiceAPIList *serviceAPIList = [[AlbumServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Photo Service"])
    {
        PhotoServiceAPIList *serviceAPIList = [[PhotoServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Log Service"])
    {
        LoggingServiceAPIList *serviceAPIList = [[LoggingServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Catalogue Service"])
    {
        CatalogueServiceAPIList *serviceAPIList = [[CatalogueServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Cart Service"])
    {
        CartServiceAPIList *serviceAPIList = [[CartServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Geo Service"])
    {
        GeoServiceAPIList *serviceAPIList = [[GeoServiceAPIList alloc] initWithStyle:UITableViewStylePlain];
        //NSLog(@"%@",[serviceList objectForKey:cell.textLabel.text]);
        serviceAPIList.apiList = [serviceList objectForKey:cell.textLabel.text];
        [self.navigationController pushViewController:serviceAPIList animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
