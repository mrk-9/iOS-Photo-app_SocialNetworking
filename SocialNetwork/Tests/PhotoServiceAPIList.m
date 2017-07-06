//
//  PhotoServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 19/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "PhotoServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface PhotoServiceAPIList ()
{
    PhotoService *photoService;
    NSString *userName;
    NSString *albumName;
    NSString *photoName;
    NSString *photoDescription;
}
@end

@implementation PhotoServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Photo Service";
    
    photoService = [App42API buildPhotoService];
    
    userName = @"Rajeev";
    albumName = @"Shephertz";
    photoDescription = @"Shephertzians";
    photoName = @"GroupPhoto1";
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
    if ([cell.textLabel.text isEqualToString:@"AddPhotoFromPath"])
    {
        [self addPhotoFromPath];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddPhotoWithData"])
    {
        [self addPhotoWithData];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddTagToPhoto"])
    {
        [self addTagToPhoto];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPhotos"])
    {
        [self getPhotos];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetTaggedPhotos"])
    {
        [self getTaggedPhotos];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPhotosCountByAlbumName"])
    {
        [self getPhotosCountByAlbumName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPhotosByAlbumName"])
    {
        [self getPhotosByAlbumName];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPhotosByAlbumNameByPaging"])
    {
        [self getPhotosByAlbumNameByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPhotosByAlbumAndPhotoName"])
    {
        [self getPhotosByAlbumAndPhotoName];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemovePhoto"])
    {
        [self removePhoto];
    }
    else if ([cell.textLabel.text isEqualToString:@"GrantAccessToPhoto"])
    {
        [self grantAccessToPhoto];
    }
    else if ([cell.textLabel.text isEqualToString:@"RevokeAccessToPhoto"])
    {
        [self revokeAccessToPhoto];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdatePhoto"])
    {
        [self updatePhoto];
    }
}

-(void)addPhotoFromPath
{
    NSString *photoPath = [[NSBundle mainBundle] pathForResource:@"Tutorial-Box" ofType:@"png"];
    [photoService addPhoto:userName albumName:albumName photoName:photoName photoDescription:photoDescription path:photoPath completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
-(void)addPhotoWithData
{
    NSString *photoPath = [[NSBundle mainBundle] pathForResource:@"Tutorial-Box" ofType:@"png"];
    NSData *photoData = [NSData dataWithContentsOfFile:photoPath];
    NSString *photoNameWithExt = @"pic.png";
    [photoService addPhoto:userName albumName:albumName photoName:photoNameWithExt photoDescription:photoDescription fileData:photoData completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
-(void)addTagToPhoto
{
    NSArray *tagList = [NSArray arrayWithObjects:@"A",@"B", nil];
    [photoService addTagToPhoto:userName albumName:albumName photoName:photoName tagList:tagList completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
-(void)getPhotos
{
    [photoService getPhotos:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *albumList = (NSArray*)responseObj;
            
            for (Album *album in albumList) {
                NSLog(@"Response=%@",album.strResponse);
                NSLog(@"UserName=%@",album.userName);
                NSLog(@"Album Name=%@",album.name);
                NSLog(@"Description=%@",album.description);
                for (Photo *photo in album.photoList)
                {
                    NSLog(@"Photo Name=%@",photo.name);
                    NSLog(@"Description=%@",photo.description);
                    NSLog(@"URL=%@",photo.url);
                    NSLog(@"Tiny URL=%@",photo.tinyUrl);
                    NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                    NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                    NSLog(@"CreatedOn=%@",photo.createdOn);
                }
            }
            [self showResponse:[albumList description]];
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
-(void)getTaggedPhotos
{
    NSString *tag = @"A";
    [photoService getTaggedPhotos:userName tag:tag completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *albumList = (NSArray*)responseObj;
            
            for (Album *album in albumList) {
                NSLog(@"Response=%@",album.strResponse);
                NSLog(@"UserName=%@",album.userName);
                NSLog(@"Album Name=%@",album.name);
                NSLog(@"Description=%@",album.description);
                for (Photo *photo in album.photoList)
                {
                    NSLog(@"Photo Name=%@",photo.name);
                    NSLog(@"Description=%@",photo.description);
                    NSLog(@"URL=%@",photo.url);
                    NSLog(@"Tiny URL=%@",photo.tinyUrl);
                    NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                    NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                    NSLog(@"CreatedOn=%@",photo.createdOn);
                }
            }
            [self showResponse:[albumList description]];
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
-(void)getPhotosCountByAlbumName
{
    [photoService getPhotosCountByAlbumName:userName albumName:albumName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response=%@",app42Response.strResponse);
            NSLog(@"Total Photos = %d",app42Response.totalRecords);
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
-(void)getPhotosByAlbumName
{
    [photoService getPhotosByAlbumName:userName albumName:albumName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
-(void)getPhotosByAlbumNameByPaging
{
    int max = 5;
    int offset = 0;
    [photoService getPhotosByAlbumName:max offset:offset userName:userName albumName:albumName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
-(void)getPhotosByAlbumAndPhotoName
{
    [photoService getPhotosByAlbumAndPhotoName:userName albumName:albumName photoName:photoName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
-(void)removePhoto
{
    [photoService removePhoto:userName albumName:albumName photoName:photoName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
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
-(void)grantAccessToPhoto
{
    [photoService grantAccessToPhoto:photoName inAlbum:albumName ofUser:userName withAclList:nil completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
-(void)revokeAccessToPhoto
{
    [photoService revokeAccessToPhoto:photoName inAlbum:albumName ofUser:userName withAclList:nil completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
-(void)updatePhoto
{
    NSString *photoPath = [[NSBundle mainBundle] pathForResource:@"Tutorial-Box" ofType:@"png"];
    [photoService updatePhoto:userName albumName:albumName photoName:photoName photoDescription:photoDescription path:photoPath completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            for (Photo *photo in album.photoList)
            {
                NSLog(@"Photo Name=%@",photo.name);
                NSLog(@"Description=%@",photo.description);
                NSLog(@"URL=%@",photo.url);
                NSLog(@"Tiny URL=%@",photo.tinyUrl);
                NSLog(@"Thumbnail Tiny URL=%@",photo.thumbNailTinyUrl);
                NSLog(@"Thumbnail URL=%@",photo.thumbNailUrl);
                NSLog(@"CreatedOn=%@",photo.createdOn);
            }
            [self showResponse:album.strResponse];
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
