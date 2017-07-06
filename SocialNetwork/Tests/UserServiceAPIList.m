//
//  UserServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 21/10/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "UserServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface UserServiceAPIList ()
{
    UserService *userService;
    NSString *sessionId;
}
@end

@implementation UserServiceAPIList
@synthesize apiList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"User Service";
    
    //[App42API setOfflineStorage:YES];
    //[[App42CacheManager sharedCacheManager] setPolicy:APP42_CACHE_FIRST];
    //[[App42CacheManager sharedCacheManager] setExpiryInMinutes:100];
    userService = [App42API buildUserService];
}

- (void)didReceiveMemoryWarning
{
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
        //NSLog(@"Index : %d",index);
        cell.textLabel.text = [apiList objectAtIndex:index];
    }
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"%@",cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:@"CreateUser"])
    {
        [self createUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateUserWithRoles"])
    {
        [self createUserWithRoles];
    }
    else if ([cell.textLabel.text isEqualToString:@"AssignRoles"])
    {
        [self assignRoles];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetRolesByUser"])
    {
        [self getRolesByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetUsersByRole"])
    {
        [self getUsersByRole];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllUsersCount"])
    {
        [self getAllUsersCount];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetLockedUsersCount"])
    {
        [self getLockedUsersCount];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllUsers"])
    {
        [self getAllUsers];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllUsersByPaging"])
    {
        [self getAllUsersByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetLockedUsers"])
    {
        [self getLockedUsers];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetLockedUsersByPaging"])
    {
        [self getLockedUsersByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetUserByEmailId"])
    {
        [self getUserByEmail];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateOrUpdateProfile"])
    {
        [self createOrUpdateProfile];
    }
    else if ([cell.textLabel.text isEqualToString:@"AuthenticateUser"])
    {
        [self authenticateUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"LockUser"])
    {
        [self lockUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"UnlockUser"])
    {
        [self unlockUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"ChangeUserPassword"])
    {
        [self changeUserPassword];
    }
    else if ([cell.textLabel.text isEqualToString:@"ResetUserPassword"])
    {
        [self resetUserPasswordWithSystemGeneratedPSW];
    }
    else if ([cell.textLabel.text isEqualToString:@"RevokeRole"])
    {
        [self revokeRole];
    }
    else if ([cell.textLabel.text isEqualToString:@"RevokeAllRoles"])
    {
        [self revokeAllRoles];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetUsersByProfileData"])
    {
        [self getUserByProfileData];
    }
    else if ([cell.textLabel.text isEqualToString:@"Logout"])
    {
        [self logout];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateUserWithProfile"])
    {
        [self createUserWithProfile];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetUsersByGroup"])
    {
        [self getUserByGroup];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetUserByName"])
    {
        [self getUserByName];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
    
}

#pragma mark- Create User
-(void)createUser
{
    NSString *userName = @"ShephertzShephertz";
    NSString *password = @"123456";
    NSString *email = @"rajranshephert@shephertz.co.in";
    //[App42API setDbName:@"TestDB"];
//    [userService addUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Rajeev",@"name", nil] collectionName:@"abcd" completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
//        NSLog(@"Exception =%@",exception);
//        NSLog(@"Response = %@",responseObj);
//    }];
    
    [userService createUser:userName password:password emailAddress:email completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
    {
        if (success)
        {
            User *user = (User*)responseObj;
            if (user.isOfflineSync)
            {
                NSLog(@"Response=%@",user.strResponse);
            }
            else
            {
                NSLog(@"Response=%@",user.strResponse);
                NSLog(@"User Name=%@",user.userName);
                NSLog(@"Email = %@",user.email);
                NSLog(@"SessionId = %@",user.sessionId);
                for (JSONDocument *doc in user.jsonDocArray)
                {
                    NSLog(@"CreatedAt=%@",doc.createdAt);
                    NSLog(@"UpdatedAt=%@",doc.updatedAt);
                    NSLog(@"DocId=%@",doc.docId);
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
            
            [self showResponse:user.strResponse];
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

-(void)createUserWithRoles
{
    NSString *userName = @"Shephertz";
    NSString *password = @"123456";
    NSString *email = @"rajran@shephertz.co.in";
    userService = [App42API buildUserService];
    NSArray *roles = [NSArray arrayWithObjects:@"A",@"B", nil];
    [userService createUser:userName password:password emailAddress:email roleList:roles completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             User *user = (User*)responseObj;
             NSLog(@"Response=%@",user.strResponse);
             NSLog(@"User Name=%@",user.userName);
             NSLog(@"Email = %@",user.email);
             NSLog(@"SessionId = %@",user.sessionId);
             for (JSONDocument *doc in user.jsonDocArray)
             {
                 NSLog(@"CreatedAt=%@",doc.createdAt);
                 NSLog(@"UpdatedAt=%@",doc.updatedAt);
                 NSLog(@"DocId=%@",doc.docId);
                 NSLog(@"Doc=%@",doc.jsonDoc);
             }
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

-(void)createUserWithProfile
{
    NSString *userName = @"Shephertzians121";
    NSString *password = @"123456";
    NSString *email = @"rajranshephertz@shephertz.co.in";
    
    Profile *profileObj = [[Profile alloc]init];
    profileObj.country = @"India";
    profileObj.city = @"Delhi";
    profileObj.dateOfBirth = [NSDate date];
    profileObj.firstName = @"test1";
    profileObj.lastName = @"test2";
    profileObj.homeLandLine = @"8800927154";
    
    userService = [App42API buildUserService];
    [userService createUserWithProfile:userName password:password emailAddress:email profile:profileObj completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             User *user = (User*)responseObj;
             NSLog(@"Response=%@",user.strResponse);
             NSLog(@"User Name=%@",user.userName);
             NSLog(@"Email = %@",user.email);
             NSLog(@"SessionId = %@",user.sessionId);
             for (JSONDocument *doc in user.jsonDocArray)
             {
                 NSLog(@"CreatedAt=%@",doc.createdAt);
                 NSLog(@"UpdatedAt=%@",doc.updatedAt);
                 NSLog(@"DocId=%@",doc.docId);
                 NSLog(@"Doc=%@",doc.jsonDoc);
             }
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

#pragma mark- Get Users

-(void)getUserByName
{
    NSString *userName = @"UserName";
    
    [userService getUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            if (user.isFromCache)
            {
                // Response from cache
                NSLog(@"UserName=%@",user.userName);
                NSLog(@"Email=%@",user.email);
            }
            else
            {
                // Response from server
                NSLog(@"UserName=%@",user.userName);
                NSLog(@"Email=%@",user.email);
            }
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

-(void)getUserByEmail
{
    NSString *emailId = @"email@gmail.com";
    
    [userService getUserByEmailId:emailId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            NSLog(@"UserName=%@",user.userName);
            NSLog(@"Email=%@",user.email);
            NSLog(@"RollList=%@",user.roleList);
            NSLog(@"Response=%@",[user toString]);
            for (JSONDocument *doc in user.jsonDocArray)
            {
                NSLog(@"Doc=%@",doc.jsonDoc);
            }
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

-(void)getUserByProfileData
{
    Profile *profileObj = [[Profile alloc]init];
    profileObj.country = @"India";
    profileObj.city = @"Delhi";
    profileObj.dateOfBirth = [NSDate date];
    profileObj.firstName = @"test1";
    profileObj.lastName = @"test2";
    profileObj.homeLandLine = @"8800927154";
    
    [userService getUsersByProfileData:profileObj completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            NSLog(@"UserName=%@",user.userName);
            NSLog(@"Email=%@",user.email);
            NSLog(@"RollList=%@",user.roleList);
            NSLog(@"Response=%@",[user toString]);
            for (JSONDocument *doc in user.jsonDocArray)
            {
                NSLog(@"Doc=%@",doc.jsonDoc);
            }
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

-(void)getUserByGroup
{
    NSArray *usersGroup = [NSArray arrayWithObjects:@"A",@"B", nil];
    
    [userService getUsersByGroup:usersGroup completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *usersArray = (NSArray*)responseObj;
            NSLog(@"usersArray=%@",usersArray);
            for (User *user in usersArray)
            {
                NSLog(@"UserName=%@",user.userName);
                NSLog(@"Email=%@",user.email);
                NSLog(@"RollList=%@",user.roleList);
                NSLog(@"Response=%@",[user toString]);
                for (JSONDocument *doc in user.jsonDocArray)
                {
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
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

-(void)getUsersByRole
{
    NSString *role = @"A";
    [userService getUsersByRole:role completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *usersArray = (NSArray*)responseObj;
            NSLog(@"usersArray=%@",usersArray);
            for (User *user in usersArray)
            {
                NSLog(@"UserName=%@",user.userName);
                NSLog(@"Email=%@",user.email);
                NSLog(@"RollList=%@",user.roleList);
                NSLog(@"Response=%@",[user toString]);
                for (JSONDocument *doc in user.jsonDocArray)
                {
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
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

-(void)getAllUsers
{
    [userService getAllUsers:^(BOOL success, id responseObj, App42Exception *exception)
    {
        if (success)
        {
            NSArray *usersArray = (NSArray*)responseObj;
            //NSLog(@"usersArray=%@",usersArray);
            for (User *user in usersArray)
            {
                NSLog(@"UserName=%@",user.userName);
                NSLog(@"Email=%@",user.email);
                NSLog(@"RollList=%@",user.roleList);
                //NSLog(@"Response=%@",[user toString]);
                for (JSONDocument *doc in user.jsonDocArray)
                {
                    NSLog(@"Doc=%@",doc.jsonDoc);
                }
            }
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

-(void)getAllUsersByPaging
{
    int max = 5;
    int offset = 0;
    
    [userService getAllUsers:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             NSArray *usersArray = (NSArray*)responseObj;
             NSLog(@"usersArray=%@",usersArray);
             for (User *user in usersArray)
             {
                 NSLog(@"UserName=%@",user.userName);
                 NSLog(@"Email=%@",user.email);
                 NSLog(@"RollList=%@",user.roleList);
                 NSLog(@"Response=%@",[user toString]);
                 for (JSONDocument *doc in user.jsonDocArray)
                 {
                     NSLog(@"Doc=%@",doc.jsonDoc);
                 }
             }
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

-(void)getAllUsersCount
{
    [userService getAllUsersCount:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             App42Response *response = (App42Response*)responseObj;
             if (response.isFromCache)
             {
                 // Response from cache
                 NSLog(@"Response=%@",response.strResponse);
                 NSLog(@"UsersCount=%d",response.totalRecords);
             }
             else
             {
                 // Response from server
                 NSLog(@"Response=%@",response.strResponse);
                 NSLog(@"UsersCount=%d",response.totalRecords);
             }
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

-(void)getLockedUsers
{
    [userService getLockedUsers:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             NSArray *usersArray = (NSArray*)responseObj;
             NSLog(@"usersArray=%@",usersArray);
             for (User *user in usersArray)
             {
                 NSLog(@"UserName=%@",user.userName);
                 NSLog(@"Email=%@",user.email);
                 NSLog(@"RollList=%@",user.roleList);
                 NSLog(@"Response=%@",[user toString]);
                 for (JSONDocument *doc in user.jsonDocArray)
                 {
                     NSLog(@"Doc=%@",doc.jsonDoc);
                 }
             }
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

-(void)getLockedUsersByPaging
{
    int max = 5;
    int offset = 0;
    
    [userService getLockedUsers:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             NSArray *usersArray = (NSArray*)responseObj;
             NSLog(@"usersArray=%@",usersArray);
             for (User *user in usersArray)
             {
                 NSLog(@"UserName=%@",user.userName);
                 NSLog(@"Email=%@",user.email);
                 NSLog(@"RollList=%@",user.roleList);
                 NSLog(@"Response=%@",[user toString]);
                 for (JSONDocument *doc in user.jsonDocArray)
                 {
                     NSLog(@"Doc=%@",doc.jsonDoc);
                 }
             }
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


-(void)getLockedUsersCount
{
    [userService getLockedUsersCount:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             App42Response *response = (App42Response*)responseObj;
             NSLog(@"Response=%@",response.strResponse);
             NSLog(@"UsersCount=%d",response.totalRecords);
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

#pragma mark- Roles Related APIs

-(void)getRolesByUser
{
    NSString *userName = @"User Name";
    [userService getRolesByUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            NSLog(@"UserName=%@",user.userName);
            NSLog(@"Email=%@",user.email);
            NSLog(@"RollList=%@",user.roleList);
            NSLog(@"Response=%@",[user toString]);
            for (JSONDocument *doc in user.jsonDocArray)
            {
                NSLog(@"Doc=%@",doc.jsonDoc);
            }
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

-(void)assignRoles
{
    NSString *userName = @"UserName";
    NSArray *roleList = [[NSArray alloc] initWithObjects:@"C",@"D", nil];
    [userService assignRoles:userName roleList:roleList completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            NSLog(@"UserName=%@",user.userName);
            NSLog(@"Email=%@",user.email);
            NSLog(@"RollList=%@",user.roleList);
            NSLog(@"Response=%@",[user toString]);
            for (JSONDocument *doc in user.jsonDocArray)
            {
                NSLog(@"Doc=%@",doc.jsonDoc);
            }
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

-(void)revokeRole
{
    NSString *userName = @"User Name";
    NSString *role = @"A";
    [userService revokeRole:userName role:role completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *user = (App42Response*)responseObj;
            NSLog(@"Response=%@",user.strResponse);
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

-(void)revokeAllRoles
{
    NSString *userName = @"User Name";
    [userService revokeAllRoles:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *user = (App42Response*)responseObj;
            NSLog(@"Response=%@",user.strResponse);
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

#pragma mark- Lock/Unlock User

-(void)lockUser
{
    NSString *userName = @"User Name";
    [userService lockUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            NSLog(@"UserName=%@",user.userName);
            NSLog(@"isAccountLocked = %d",user.isAccountLocked);
            NSLog(@"Email=%@",user.email);
            NSLog(@"RollList=%@",user.roleList);
            NSLog(@"Response=%@",[user toString]);
            for (JSONDocument *doc in user.jsonDocArray)
            {
                NSLog(@"Doc=%@",doc.jsonDoc);
            }
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

-(void)unlockUser
{
    NSString *userName = [NSString stringWithFormat:@"Rajeev %@",[NSDate date]];
    [userService unlockUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            NSLog(@"UserName=%@",user.userName);
            NSLog(@"isAccountLocked = %d",user.isAccountLocked);
            NSLog(@"Email=%@",user.email);
            NSLog(@"RollList=%@",user.roleList);
            NSLog(@"Response=%@",[user toString]);
            for (JSONDocument *doc in user.jsonDocArray)
            {
                NSLog(@"Doc=%@",doc.jsonDoc);
            }
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

#pragma mark- Authentication Related

-(void)authenticateUser
{
    //NSString *userName = @"RajeevRanjan81";
    //NSString *pwd = @"*********";
    NSString *userName = @"Shephertz";
    NSString *password = @"123456";
    UserService *userService1 = [App42API buildUserService];
    //NSMutableDictionary *otherMetaHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"true",@"userProfile", nil];
    //[userService setOtherMetaHeaders:otherMetaHeaders];
    [userService1 authenticateUser:userName password:password completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            NSLog(@"UserName=%@",user.userName);
            NSLog(@"isAccountLocked = %d",user.isAccountLocked);
            NSLog(@"Email=%@",user.email);
            NSLog(@"RollList=%@",user.roleList);
            NSLog(@"Response=%@",[user toString]);
            sessionId = [user.sessionId copy];
            [[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:@"App42_SessionID"];
            for (JSONDocument *doc in user.jsonDocArray)
            {
                NSLog(@"Doc=%@",doc.jsonDoc);
            }
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

-(void)logout
{
    //NSString *userName = @"0e567162-a421-4fd1-9d56-88a3dc0d20f8";
    [userService logout:sessionId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *user = (App42Response*)responseObj;
            NSLog(@"Response=%@",user.strResponse);
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

-(void)deleteUser
{
    NSString *userName = @"";
    [userService deleteUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *user = (App42Response*)responseObj;
            NSLog(@"Response=%@",user.strResponse);
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


#pragma mark- updateEmail

-(void)updateUser
{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"ss"];
        NSString *userName = [NSString stringWithFormat:@"Rajeev %@",[NSDate date]];
        NSString *password = @"123456";
        NSString *email = [NSString stringWithFormat:@"rajeev%@@gmail.com",[dateFormatter stringFromDate:[NSDate date]]];
        [userService createUser:userName password:password emailAddress:email completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
            if (success)
            {
                NSString *newEmail = [NSString stringWithFormat:@"rajeev.ranjan%@@gmail.com",[dateFormatter stringFromDate:[NSDate date]]];
                [userService updateEmail:userName emailAddress:newEmail completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
                {
                    if (success)
                    {
                        User *user = (User*)responseObj;
                        NSLog(@"Response=%@",user.strResponse);
                        NSLog(@"User Name=%@",user.userName);
                        NSLog(@"Email = %@",user.email);
                        NSLog(@"SessionId = %@",user.sessionId);
                        for (JSONDocument *doc in user.jsonDocArray)
                        {
                            NSLog(@"CreatedAt=%@",doc.createdAt);
                            NSLog(@"UpdatedAt=%@",doc.updatedAt);
                            NSLog(@"DocId=%@",doc.docId);
                            NSLog(@"Doc=%@",doc.jsonDoc);
                        }
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
            else
            {
                NSLog(@"Exception = %@",[exception reason]);
                NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
                NSLog(@"App Error Code = %d",[exception appErrorCode]);
                NSLog(@"User Info = %@",[exception userInfo]);
            }
        }];
}



#pragma mark- createOrUpdateProfile

-(void)createOrUpdateProfile
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"ss"];
    NSString *userName = [NSString stringWithFormat:@"Sushil %@",[NSDate date]];
    NSString *password = @"123456";
    NSString *email = [NSString stringWithFormat:@"tanvi%@@gmail.com",[dateFormatter stringFromDate:[NSDate date]]];
   [userService createUser:userName password:password emailAddress:email completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
       if (success)
       {
           User *user = (User*)responseObj;
           Profile *profileDataObject = [[Profile alloc]initWithUser:user];
           profileDataObject.firstName = @"dfdf";
           profileDataObject.lastName = @"dfdf";
           profileDataObject.sex = MALE;
           profileDataObject.city = @"dfasd";
           profileDataObject.state = @"dfad";
           profileDataObject.country = @"dfadad";
           profileDataObject.line1 = @"dfasdf";
           profileDataObject.line2 = @"dfadafgf";
           profileDataObject.mobile = @"dfas";
           profileDataObject.pincode = @"dfasd";
           profileDataObject.homeLandLine = @"dfadsfsd";
           profileDataObject.officeLandLine = @"dfasdfagfg";
           profileDataObject.dateOfBirth = [NSDate date];
           user.profile = profileDataObject;
           [userService createOrUpdateProfile:user completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
           {
               if (success)
               {
                   User *user = (User*)responseObj;
                   NSLog(@"Response=%@",user.strResponse);
                   NSLog(@"User Name=%@",user.userName);
                   NSLog(@"Email = %@",user.email);
                   NSLog(@"SessionId = %@",user.sessionId);
                   for (JSONDocument *doc in user.jsonDocArray)
                   {
                       NSLog(@"CreatedAt=%@",doc.createdAt);
                       NSLog(@"UpdatedAt=%@",doc.updatedAt);
                       NSLog(@"DocId=%@",doc.docId);
                       NSLog(@"Doc=%@",doc.jsonDoc);
                   }
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
       else
       {
           NSLog(@"Exception = %@",[exception reason]);
           NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
           NSLog(@"App Error Code = %d",[exception appErrorCode]);
           NSLog(@"User Info = %@",[exception userInfo]);
       }
    }];
}

#pragma mark- ResetPassword

-(void)changeUserPassword
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"ss"];
    NSString *userName = [NSString stringWithFormat:@"rajeev%@",[NSDate date]];
    NSString *password = @"123456";
    NSString *email = [NSString stringWithFormat:@"rajeev%@@gmail.com",[dateFormatter stringFromDate:[NSDate date]]];
    [userService createUser:userName password:password emailAddress:email completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            
            [userService changeUserPassword:user.userName oldPassword:password newPassword:@"123456789" completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
             {
                 if (success)
                 {
                     App42Response *app42Response = (App42Response*)responseObj;
                     NSLog(@"Response=%@",app42Response.strResponse);
                     NSLog(@"IsResponseSuccess=%d",app42Response.isResponseSuccess);
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
        else
        {
            
        }
    }];
    
}

-(void)resetUserPasswordWithSystemGeneratedPSW
{
    NSString *userName = @"";
    [userService resetUserPassword:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            User *user = (User*)responseObj;
            NSLog(@"UserName=%@",user.userName);
            NSLog(@"isAccountLocked = %d",user.isAccountLocked);
            NSLog(@"Email=%@",user.email);
            NSLog(@"RollList=%@",user.roleList);
            NSLog(@"Response=%@",[user toString]);
            for (JSONDocument *doc in user.jsonDocArray)
            {
                NSLog(@"Doc=%@",doc.jsonDoc);
            }
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
