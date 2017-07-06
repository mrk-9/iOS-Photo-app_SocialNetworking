//
//  SocialServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 17/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "SocialServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"



@interface SocialServiceAPIList ()
{
    SocialService *socialService;
    NSString *accessToken;
    NSString *userName;
    NSString *appId;
    NSString *appSecret;
    NSString *status;
    
}
@end

@implementation SocialServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Social Service";
    
    socialService = [App42API buildSocialService];
    
    accessToken = @"CAACEdEose0cBAO0nO5YDCjqjqCg0WkLibFv0XBBPn25yDZCUsVekOVP4qDzU64tF3s9EiKEeVZA2A6ZAvyd2mcgGWa4ALse54xp2UUdtusmYPWpy4Dl55dQNVNccvBGYZA3x20rZC4LopljSHhHHLv1yVa734rwNPUKRtQQmZAY1LJdC0MC3DnemTyzcJZC8uKLVI6fDNrAZCFFL1cGwqZA3ZAxRYCfbZCS8jwZD";
    userName = @"Rajeev";
    status = @"Hello Friends!";
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
    if ([cell.textLabel.text isEqualToString:@"LinkUserFacebookAccount"])
    {
        [self linkUserFacebookAccount];
    }
    else if ([cell.textLabel.text isEqualToString:@"LinkUserFacebookAccountWithAppID"])
    {
        [self linkUserFacebookAccountWithAppID];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateFacebookStatus"])
    {
        [self updateFacebookStatus];
    }
    else if ([cell.textLabel.text isEqualToString:@"LinkUserTwitterAccount"])
    {
        [self linkUserTwitterAccount];
    }
    else if ([cell.textLabel.text isEqualToString:@"LinkUserTwitterAccountWithConsumerKey"])
    {
        [self linkUserTwitterAccountWithConsumerKey];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateTwitterStatus"])
    {
        [self updateTwitterStatus];
    }
    else if ([cell.textLabel.text isEqualToString:@"LinkUserLinkedInAccount"])
    {
        [self linkUserLinkedInAccount];
    }
    else if ([cell.textLabel.text isEqualToString:@"LinkUserLinkedInAccountApiKey"])
    {
        [self linkUserLinkedInAccountApiKey];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateLinkedInStatus"])
    {
        [self updateLinkedInStatus];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateSocialStatusForAll"])
    {
        [self updateSocialStatusForAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFacebookFriendsFromLinkUser"])
    {
        [self getFacebookFriendsFromLinkUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFacebookFriendsFromAccessToken"])
    {
        [self getFacebookFriendsFromAccessToken];
    }
    else if ([cell.textLabel.text isEqualToString:@"FacebookPublishStream"])
    {
        [self facebookPublishStream];
    }
    else if ([cell.textLabel.text isEqualToString:@"FacebookLinkPost"])
    {
        [self facebookLinkPost];
    }
    else if ([cell.textLabel.text isEqualToString:@"FacebookLinkPostWithCustomThumbnail"])
    {
        [self facebookLinkPostWithCustomThumbnail];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFacebookProfile"])
    {
        [self getFacebookProfile];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFacebookProfilesFromIds"])
    {
        [self getFacebookProfilesFromIds];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

#pragma mark - Facebook Related

-(void)linkUserFacebookAccountWithAppID
{
    [socialService linkUserFacebookAccount:userName appId:appId appSecret:appSecret accessToken:accessToken completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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

-(void)linkUserFacebookAccount
{
    [socialService linkUserFacebookAccount:userName accessToken:accessToken completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            NSLog(@"facebookAccessToken = %@",social.facebookAccessToken);
            NSLog(@"Name = %@",social.facebookProfile.name);
            NSLog(@"FBID = %@",social.facebookProfile.fbId);
            [self showResponse:social.strResponse];
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
-(void)updateFacebookStatus
{
    [socialService updateFacebookStatus:userName status:status completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)getFacebookFriendsFromLinkUser
{
    [socialService getFacebookFriendsFromLinkUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)getFacebookFriendsFromAccessToken
{
    [socialService getFacebookFriendsFromAccessToken:accessToken completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)facebookPublishStream
{
    NSString *fileName = @"";
    NSString *filePath = @"";
    NSString *message  = @"";
    [socialService facebookPublishStream:userName fileName:fileName filePath:filePath message:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        
    }];
}
-(void)facebookLinkPost
{
    NSString *message  = @"";
    NSString *link = @"";
    [socialService facebookLinkPost:userName link:link message:message completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        
    }];
}
-(void)facebookLinkPostWithCustomThumbnail
{
    NSString *message  = @"";
    NSString *link = @"";
    NSString *pictureUrl = @"";
    NSString *fileName = @"";
    NSString *description = @"";
    [socialService facebookLinkPostWithCustomThumbnail:userName link:link message:message pictureUrl:pictureUrl fileName:fileName description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        
    }];
}
-(void)getFacebookProfile
{
    [socialService getFacebookProfile:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)getFacebookProfilesFromIds
{
    NSArray *userIds = [NSArray arrayWithObjects:@"", nil];
    [socialService getFacebookProfilesFromIds:userIds completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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

#pragma mark - Twitter Related

-(void)linkUserTwitterAccountWithConsumerKey
{
    NSString *consumerKey = @"";
    NSString *consumerSecret = @"";
    NSString *accessTokenSecret = @"";
    [socialService linkUserTwitterAccount:userName consumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken accessTokenSecret:accessTokenSecret completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)linkUserTwitterAccount
{
    NSString *accessTokenSecret = @"";
    [socialService linkUserTwitterAccount:userName accessToken:accessToken accessTokenSecret:accessTokenSecret completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)updateTwitterStatus
{
    [socialService updateTwitterStatus:userName status:status completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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

#pragma mark - LinkedIn Related

-(void)linkUserLinkedInAccount
{
    NSString *accessTokenSecret = @"";

    [socialService linkUserLinkedInAccount:userName accessToken:accessToken accessTokenSecret:accessTokenSecret completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)linkUserLinkedInAccountApiKey
{
    NSString *secretKey = @"";
    NSString *apiKey = @"";
    NSString *accessTokenSecret = @"";
    [socialService linkUserLinkedInAccount:userName apiKey:apiKey secretKey:secretKey accessToken:accessToken accessTokenSecret:accessTokenSecret completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)updateLinkedInStatus
{
    [socialService updateLinkedInStatus:userName status:status completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
-(void)updateSocialStatusForAll
{
    [socialService updateSocialStatusForAll:userName status:status completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Social *social = (Social*)responseObj;
            NSLog(@"Response=%@",social.strResponse);
            NSLog(@"User Name=%@",social.userName);
            [self showResponse:social.strResponse];
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
