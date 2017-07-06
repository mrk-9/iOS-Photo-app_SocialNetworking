//
//  AvatarServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 12/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "AvatarServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface AvatarServiceAPIList ()
{
    AvatarService *avatarService;
}
@end

@implementation AvatarServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Avatar Service";
   
    avatarService = [App42API buildAvatarService];
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
    if ([cell.textLabel.text isEqualToString:@"CreateAvatarWithName"])
    {
        [self createAvatarWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateAvatarFromFacebookWithName"])
    {
        [self createAvatarFromFacebookWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateAvatarFromFileDataWithName"])
    {
        [self createAvatarFromFileDataWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateAvatarFromWebURLWithName"])
    {
        [self createAvatarFromWebURLWithName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAvatarByName"])
    {
        [self getAvatarByName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllAvatarsForUser"])
    {
        [self getAllAvatarsForUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetCurrentAvatar"])
    {
        [self getCurrentAvatar];
    }
    else if ([cell.textLabel.text isEqualToString:@"ChangeCurrentAvatarWithName"])
    {
        [self changeCurrentAvatarWithName];
    }
}

-(void)createAvatarWithName
{
    NSString *avatarName = @"boxPic1";
    NSString *userName = @"Shephertz";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Tutorial-Box" ofType:@"png"];
    NSString *description = @"Tutorial box image";
    [avatarService createAvatarWithName:avatarName userName:userName filePath:filePath description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Avatar *avatar = (Avatar*)responseObj;
            NSLog(@"AvatarName=%@",avatar.name);
            NSLog(@"AvatarName  %@",avatar.name);
            NSLog(@"tinyUrl is  %@",avatar.tinyUrl);
            NSLog(@"UserName is %@",avatar.userName);
            NSLog(@"Is Current is %d",avatar.isCurrent);
            NSLog(@"Created On : %@",avatar.createdOn);
            [self showResponse:[avatar strResponse]];
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
-(void)createAvatarFromFacebookWithName
{
    NSString *avatarName = @"fbAvatar";
    NSString *userName = @"Shephertz";
    NSString *accessToken = @"CAACEdEose0cBAPqBxHZAJ76gWtmwUiWxWb1sI1xNeBq6yYRlwN7LoGxjp9n42I6bHAgwrYncbzptrkXqWTVzXRaQZA6LCwMj0ZA7m5fZAgHufC8Ce4FkaszT6wnDYT1oma9mL9KSDB22VM42soeoiX7NwuLvOyV13Pz3IAHAp42skMwyyehBR5YZCqv73ONLSgolc605y75DyzUhobpnDaZCcxtW3iquoZD";
    NSString *description = @"fb avatar";
    
    [avatarService createAvatarFromFacebookWithName:avatarName userName:userName accessToken:accessToken description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Avatar *avatar = (Avatar*)responseObj;
            NSLog(@"AvatarName=%@",avatar.name);
            NSLog(@"AvatarName  %@",avatar.name);
            NSLog(@"tinyUrl is  %@",avatar.tinyUrl);
            NSLog(@"UserName is %@",avatar.userName);
            NSLog(@"Is Current is %d",avatar.isCurrent);
            NSLog(@"Created On : %@",avatar.createdOn);
            [self showResponse:[avatar strResponse]];
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
-(void)createAvatarFromFileDataWithName
{
    NSString *avatarName = @"fileDataAvatar";
    NSString *userName = @"Shephertz";
    NSString *description = @"fileDataAvatar";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Tutorial-Box" ofType:@"png"];
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSString *extension = @"png";
    
    [avatarService createAvatarFromFileDataWithName:avatarName userName:userName fileData:fileData description:description extension:extension completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Avatar *avatar = (Avatar*)responseObj;
            NSLog(@"AvatarName=%@",avatar.name);
            NSLog(@"AvatarName  %@",avatar.name);
            NSLog(@"tinyUrl is  %@",avatar.tinyUrl);
            NSLog(@"UserName is %@",avatar.userName);
            NSLog(@"Is Current is %d",avatar.isCurrent);
            NSLog(@"Created On : %@",avatar.createdOn);
            [self showResponse:[avatar strResponse]];
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

-(void)createAvatarFromWebURLWithName
{
    NSString *avatarName = @"webAvatar";
    NSString *userName = @"Shephertz";
    NSString *description = @"webAvatar";
    NSString *webUrl = @"http://cdn.shephertz.com/repository/files/67359321652c10b15fd5f659d096a2051745aa4f339b936d6ce5dccb165de863/7e69e757f39ead571d8dde04ff0b977b99205821/845aead103fecee436a8b2922e8d790b9be24466.png";
    
    [avatarService createAvatarFromWebURLWithName:avatarName userName:userName webUrl:webUrl description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Avatar *avatar = (Avatar*)responseObj;
            NSLog(@"AvatarName=%@",avatar.name);
            NSLog(@"AvatarName  %@",avatar.name);
            NSLog(@"tinyUrl is  %@",avatar.tinyUrl);
            NSLog(@"UserName is %@",avatar.userName);
            NSLog(@"Is Current is %d",avatar.isCurrent);
            NSLog(@"Created On : %@",avatar.createdOn);
            [self showResponse:[avatar strResponse]];
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

-(void)getAvatarByName
{
    //NSString *avatarName = @"boxPic";
    //NSString *avatarName = @"fileDataAvatar";
    NSString *avatarName = @"fbAvatar";
    NSString *userName = @"Shephertz";
    
    [avatarService getAvatarByName:avatarName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Avatar *avatar = (Avatar*)responseObj;
            NSLog(@"AvatarName=%@",avatar.name);
            NSLog(@"AvatarName  %@",avatar.name);
            NSLog(@"tinyUrl is  %@",avatar.tinyUrl);
            NSLog(@"UserName is %@",avatar.userName);
            NSLog(@"Is Current is %d",avatar.isCurrent);
            NSLog(@"Created On : %@",avatar.createdOn);
            [self showResponse:[avatar strResponse]];
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

-(void)getAllAvatarsForUser
{
    
    NSString *userName = @"Shephertz";
    [avatarService getAllAvatarsForUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
            if (success) {
                NSArray *avatarList = (NSArray*)responseObj;
                
                for (Avatar *avatar in avatarList)
                {
                    NSLog(@"AvatarName=%@",avatar.name);
                    NSLog(@"AvatarName  %@",avatar.name);
                    NSLog(@"tinyUrl is  %@",avatar.tinyUrl);
                    NSLog(@"UserName is %@",avatar.userName);
                    NSLog(@"Is Current is %d",avatar.isCurrent);
                    NSLog(@"Created On : %@",avatar.createdOn);
                }
                [self showResponse:[avatarList description]];
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

-(void)getCurrentAvatar
{
    NSString *userName = @"Shephertz";
    [avatarService getCurrentAvatar:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Avatar *avatar = (Avatar*)responseObj;
            NSLog(@"AvatarName=%@",avatar.name);
            NSLog(@"AvatarName  %@",avatar.name);
            NSLog(@"tinyUrl is  %@",avatar.tinyUrl);
            NSLog(@"UserName is %@",avatar.userName);
            NSLog(@"Is Current is %d",avatar.isCurrent);
            NSLog(@"Created On : %@",avatar.createdOn);
            [self showResponse:[avatar strResponse]];
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

-(void)changeCurrentAvatarWithName
{
    //NSString *avatarName = @"boxPic";
    //NSString *avatarName = @"fileDataAvatar";
    NSString *avatarName = @"fbAvatar";
    NSString *userName = @"Shephertz";
    [avatarService changeCurrentAvatarWithName:avatarName forUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Avatar *avatar = (Avatar*)responseObj;
            NSLog(@"AvatarName=%@",avatar.name);
            NSLog(@"AvatarName  %@",avatar.name);
            NSLog(@"tinyUrl is  %@",avatar.tinyUrl);
            NSLog(@"UserName is %@",avatar.userName);
            NSLog(@"Is Current is %d",avatar.isCurrent);
            NSLog(@"Created On : %@",avatar.createdOn);
            [self showResponse:[avatar strResponse]];
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
