//
//  GeoServiceAPIList.m
//  App42APISample
//
//  Created by Rajeev Ranjan on 29/04/15.
//  Copyright (c) 2015 Rajeev Ranjan. All rights reserved.
//

#import "GeoServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface GeoServiceAPIList ()
{
    GeoService  *geoService;
    NSString    *storageName;
    NSString    *marker;
    double      latitude;
    double      longitude;
    double      distanceInKM;
}
@end

@implementation GeoServiceAPIList

@synthesize apiList;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Geo Service";
    geoService = [App42API buildGeoService];
    storageName = @"GeoStorage";
    latitude = 50.0;
    longitude = 15.5;
    marker = @"Gurgaon";
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
    if ([cell.textLabel.text isEqualToString:@"CreateGeoPoints"])
    {
        [self createGeoPoints];
    }
    /*else if ([cell.textLabel.text isEqualToString:@"UploadFileWithData"])
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
    }*/
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)createGeoPoints
{
    GeoPoint *geoPointObj = [[GeoPoint alloc]init];
    geoPointObj.latitude = 22.77777;
    geoPointObj.longitude = 55.26586;
    geoPointObj.marker = @"first Marker";
    GeoPoint *geoPointObj1 = [[GeoPoint alloc]init];
    geoPointObj1.latitude = 22.565777;
    geoPointObj1.longitude = 55.46986;
    geoPointObj1.marker = @"second Marker";
    
    GeoPoint *geoPointObj2 = [[GeoPoint alloc]init];
    geoPointObj2.latitude = 22.556777;
    geoPointObj2.longitude = 55.46286;
    geoPointObj2.marker = @"third Marker";
    
    GeoPoint *geoPointObj3 = [[GeoPoint alloc]init];
    geoPointObj3.latitude = 22.559777;
    geoPointObj3.longitude = 55.46656;
    geoPointObj3.marker = @"fourth Marker";
    NSArray *geoPoints = [NSArray arrayWithObjects:geoPointObj,geoPointObj1,geoPointObj2,geoPointObj3,nil];

    [geoService createGeoPoints:storageName geoPointsList:geoPoints completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Geo *geo = (Geo*)responseObj;
            NSLog(@"Storage Name = %@",geo.storageName);
            NSLog(@"Source Lat = %@", geo.sourceLat);
            NSLog(@"Source Lng = %@", geo.sourceLng);
            NSLog(@"Distance in KM = %lf", geo.distanceInKM);

            [self showResponse:geo.strResponse];
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
