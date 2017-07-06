//
//  AlbumServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 19/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "AlbumServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"



@interface AlbumServiceAPIList ()
{
    AlbumService *albumService;
    NSString *userName;
    NSString *albumName;
    NSString *albumDescription;
}
@end

@implementation AlbumServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Album Service";
    
    albumService = [App42API buildAlbumService];
    
    userName = @"Rajeev";
    albumName = @"Shephertz";
    albumDescription = @"Shephertzians";
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
    if ([cell.textLabel.text isEqualToString:@"CreateAlbum"])
    {
        [self createAlbum];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAlbumsCount"])
    {
        [self getAlbumsCount];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAlbums"])
    {
        [self getAlbums];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAlbumsByPaging"])
    {
        [self getAlbumsByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAlbumByName"])
    {
        [self getAlbumByName];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveAlbum"])
    {
        [self removeAlbum];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)createAlbum
{
    [albumService createAlbum:userName albumName:albumName albumDescription:albumDescription completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            
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

-(void)getAlbumsCount
{
    [albumService getAlbumsCount:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response=%@",app42Response.strResponse);
            NSLog(@"TotalRecords=%d",app42Response.totalRecords);
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

-(void)getAlbums
{
    [albumService getAlbums:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *albums = (NSArray*)responseObj;
            for (Album *album in albums) {
                NSLog(@"Response=%@",album.strResponse);
                NSLog(@"UserName=%@",album.userName);
                NSLog(@"Album Name=%@",album.name);
                NSLog(@"Description=%@",album.description);
            }
            [self showResponse:[albums description]];
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

-(void)getAlbumsByPaging
{
    int max = 5;
    int offset = 0;
    [albumService getAlbums:userName max:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *albums = (NSArray*)responseObj;
            for (Album *album in albums) {
                NSLog(@"Response=%@",album.strResponse);
                NSLog(@"UserName=%@",album.userName);
                NSLog(@"Album Name=%@",album.name);
                NSLog(@"Description=%@",album.description);
            }
            [self showResponse:[albums description]];
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

-(void)getAlbumByName
{
    [albumService getAlbumByName:userName albumName:albumName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Album *album = (Album*)responseObj;
            NSLog(@"Response=%@",album.strResponse);
            NSLog(@"UserName=%@",album.userName);
            NSLog(@"Album Name=%@",album.name);
            NSLog(@"Description=%@",album.description);
            
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

-(void)removeAlbum
{
    [albumService removeAlbum:userName albumName:albumName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
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

@end
