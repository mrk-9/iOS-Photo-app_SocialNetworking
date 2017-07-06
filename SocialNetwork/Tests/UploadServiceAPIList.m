//
//  UploadServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "UploadServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface UploadServiceAPIList ()
{
    UploadService *uploadService;
    NSString *fileName;
    NSString *filePath;
    NSString *userName;
    int max;
    int offset;
    NSData *fileData;
    NSString *description;
    NSString *uploadFileType;
}
@end

@implementation UploadServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Upload Service";
    
    uploadService = [App42API buildUploadService];
    
    fileName = @"shephertz12.png";
    filePath = [NSString stringWithString:[[NSBundle mainBundle] pathForResource:@"Tutorial-Box" ofType:@"png"]];
    
    userName = @"Shephertz";
    max = 5;
    offset = 0;
    fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    description = @"Tutorial Image";
    uploadFileType = IMAGE;
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
    if ([cell.textLabel.text isEqualToString:@"UploadFileFromPath"])
    {
        [self uploadFileFromPath];
    }
    else if ([cell.textLabel.text isEqualToString:@"UploadFileWithData"])
    {
        [self uploadFileWithData];
    }
    else if ([cell.textLabel.text isEqualToString:@"UploadFileForUserFromPath"])
    {
        [self uploadFileForUserFromPath];
    }
    else if ([cell.textLabel.text isEqualToString:@"uploadFileForUserWithData"])
    {
        [self uploadFileForUserWithData];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllFilesCount"])
    {
        [self getAllFilesCount];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllFiles"])
    {
        [self getAllFiles];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllFilesByPaging"])
    {
        [self getAllFilesByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFileByUser"])
    {
        [self getFileByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllFilesCountByUser"])
    {
        [self getAllFilesCountByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllFilesByUser"])
    {
        [self getAllFilesByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllFilesByUserByPaging"])
    {
        [self getAllFilesByUserByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFileByName"])
    {
        [self getFileByName];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveFileByUser"])
    {
        [self removeFileByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveAllFilesByUser"])
    {
        [self removeAllFilesByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveAllFiles"])
    {
        [self removeAllFiles];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFilesCountByType"])
    {
        [self getFilesCountByType];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFilesByType"])
    {
        [self getFilesByType];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetFilesByTypeByPaging"])
    {
        [self getFilesByTypeByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GrantAccessOnFile"])
    {
        [self grantAccessOnFile];
    }
    else if ([cell.textLabel.text isEqualToString:@"RevokeAccessOnFile"])
    {
        [self revokeAccessOnFile];
    }
    else if ([cell.textLabel.text isEqualToString:@"UploadFileForGroupFromPath"])
    {
        [self uploadFileForGroupFromPath];
    }
    else if ([cell.textLabel.text isEqualToString:@"UploadFileForGroupWithData"])
    {
        [self uploadFileForGroupWithData];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)uploadFileFromPath
{
    [uploadService uploadFile:fileName filePath:filePath uploadFileType:uploadFileType fileDescription:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)uploadFileWithData
{
    [uploadService uploadFile:fileName fileData:fileData uploadFileType:uploadFileType fileDescription:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)uploadFileForUserFromPath
{
    [uploadService uploadFileForUser:fileName userName:userName filePath:filePath uploadFileType:uploadFileType fileDescription:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)uploadFileForUserWithData
{
    [uploadService uploadFileForUser:fileName userName:userName fileData:fileData uploadFileType:uploadFileType fileDescription:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)getAllFilesCount
{
    [uploadService getAllFilesCount:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Total Files = %d",app42Response.totalRecords);
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
-(void)getAllFiles
{
    [uploadService getAllFiles:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)getAllFilesByPaging
{
    [uploadService getAllFiles:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)getFileByUser
{
    [uploadService getFileByUser:fileName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)getAllFilesCountByUser
{
    [uploadService getAllFilesCountByUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Total Files = %d",app42Response.totalRecords);
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
-(void)getAllFilesByUser
{
    [uploadService getAllFilesByUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)getAllFilesByUserByPaging
{
    [uploadService getAllFilesByUser:userName max:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)getFileByName
{
    [uploadService getFileByName:fileName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)removeFileByUser
{
    [uploadService removeFileByUser:fileName userName:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
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
-(void)removeAllFilesByUser
{
    [uploadService removeAllFilesByUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
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
-(void)removeFileByName
{
    [uploadService removeFileByName:fileName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
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
-(void)removeAllFiles
{
    [uploadService removeAllFiles:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
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
-(void)getFilesCountByType
{
    [uploadService getFilesCountByType:uploadFileType completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Total Files = %d",app42Response.totalRecords);
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
-(void)getFilesByType
{
    [uploadService getFilesByType:uploadFileType completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)getFilesByTypeByPaging
{
    [uploadService getFilesByType:uploadFileType max:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
-(void)grantAccessOnFile
{
    ACL *acl = [[ACL alloc] initWithUserName:userName andPermission:APP42_READ];
    NSArray *aclList = [NSArray arrayWithObjects:acl, nil];
    
    [uploadService grantAccessOnFile:fileName ofUser:userName withAclList:aclList completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Total Files = %d",app42Response.totalRecords);
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
-(void)revokeAccessOnFile
{
    ACL *acl = [[ACL alloc] initWithUserName:userName andPermission:APP42_READ];
    NSArray *aclList = [NSArray arrayWithObjects:acl, nil];
    
    [uploadService revokeAccessOnFile:fileName ofUser:userName withAclList:aclList completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Total Files = %d",app42Response.totalRecords);
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
-(void)uploadFileForGroupWithData
{
    NSString *groupName = @"";
    NSString *ownerName = @"";
    
    [uploadService uploadFileForGroup:fileName userName:userName ownerName:ownerName groupName:groupName fileData:fileData fileType:uploadFileType description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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

-(void)uploadFileForGroupFromPath
{
    NSString *groupName = @"";
    NSString *ownerName = @"";
    
    [uploadService uploadFileForGroup:fileName userName:userName ownerName:ownerName groupName:groupName filePath:filePath fileType:uploadFileType description:description completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Upload *upload = (Upload*)responseObj;
            for (File *file in upload.fileListArray)
            {
                NSLog(@"fileName is %@" , file.name);
                NSLog(@"User Name is %@" , file.userName);
                NSLog(@"fileType is %@" , file.type);
                NSLog(@"fileUrl is %@" , file.url);
                NSLog(@"fileTinyUrl is %@" , file.tinyUrl);
                NSLog(@"fileDescription is %@" , file.description);
            }
            [self showResponse:upload.strResponse];
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
