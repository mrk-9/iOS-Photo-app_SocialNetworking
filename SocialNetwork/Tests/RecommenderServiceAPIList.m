//
//  RecommenderServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 18/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "RecommenderServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface RecommenderServiceAPIList ()
{
    RecommenderService *recommenderService;
    NSString *preferenceFilePath;
    NSString *recommenderSimilarity;

    long userId;
    int howMany;
    int size;
    double threshold;
}
@end

@implementation RecommenderServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Achievement Service";
   
    recommenderService = [App42API buildRecommenderService];

     preferenceFilePath = @"/Users/Rajeev/Desktop/a.csv";
     userId = 12345;
     howMany = 10;
     size = 12;
     threshold = 12;
     recommenderSimilarity = @"";
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
    if ([cell.textLabel.text isEqualToString:@"LoadPreferenceFile"])
    {
        [self loadPreferenceFile];
    }
    else if ([cell.textLabel.text isEqualToString:@"LoadPreferenceFileWithData"])
    {
        [self loadPreferenceFileWithData];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddOrUpdatePreference"])
    {
        [self addOrUpdatePreference];
    }
    else if ([cell.textLabel.text isEqualToString:@"UserBasedNeighborhood"])
    {
        [self userBasedNeighborhood];
    }
    else if ([cell.textLabel.text isEqualToString:@"UserBasedThreshold"])
    {
        [self userBasedThreshold];
    }
    else if ([cell.textLabel.text isEqualToString:@"UserBasedNeighborhoodBySimilarity"])
    {
        [self userBasedNeighborhoodBySimilarity];
    }
    else if ([cell.textLabel.text isEqualToString:@"UserBasedThresholdBySimilarity"])
    {
        [self userBasedThresholdBySimilarity];
    }
    else if ([cell.textLabel.text isEqualToString:@"ItemBased"])
    {
        [self itemBased];
    }
    else if ([cell.textLabel.text isEqualToString:@"SlopeOne"])
    {
        [self slopeOne];
    }
    else if ([cell.textLabel.text isEqualToString:@"UserBasedThresholdForAll"])
    {
        [self userBasedThresholdForAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"UserBasedNeighborhoodBySimilarityForAll"])
    {
        [self userBasedNeighborhoodBySimilarityForAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"UserBasedThresholdBySimilarityForAll"])
    {
        [self userBasedThresholdBySimilarityForAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"ItemBasedForAll"])
    {
        [self itemBasedForAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"ItemBasedBySimilarityForAll"])
    {
        [self itemBasedBySimilarityForAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"SlopeOneForAll"])
    {
        [self slopeOneForAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"ItemBasedBySimilarity"])
    {
        [self itemBasedBySimilarity];
    }
    else if ([cell.textLabel.text isEqualToString:@"UserBasedNeighborhoodForAll"])
    {
        [self userBasedNeighborhoodForAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteAllPreferences"])
    {
        [self deleteAllPreferences];
    }
}

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

-(void)loadPreferenceFile
{
    [recommenderService loadPreferenceFile:preferenceFilePath completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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
-(void)loadPreferenceFileWithData
{
    NSData *preferenceFileData = [NSData dataWithContentsOfFile:preferenceFilePath];
    [recommenderService loadPreferenceFileWithData:preferenceFileData completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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
-(void)addOrUpdatePreference
{
    NSMutableArray *preferenceDataList = nil;
    [recommenderService addOrUpdatePreference:preferenceDataList completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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
-(void)userBasedNeighborhood
{
    [recommenderService userBasedNeighborhood:userId size:size howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)userBasedThreshold
{
    [recommenderService userBasedThreshold:userId threshold:threshold howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)userBasedNeighborhoodBySimilarity
{
    [recommenderService userBasedNeighborhoodBySimilarity:recommenderSimilarity userId:userId size:size howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)userBasedThresholdBySimilarity
{
    [recommenderService userBasedThresholdBySimilarity:recommenderSimilarity userId:userId threshold:threshold howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)itemBased
{
    [recommenderService itemBased:userId howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)slopeOne
{
    [recommenderService slopeOne:userId howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)userBasedThresholdForAll
{
    [recommenderService userBasedThresholdForAll:threshold howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)userBasedNeighborhoodBySimilarityForAll
{
    [recommenderService userBasedThresholdBySimilarityForAll:recommenderSimilarity threshold:threshold howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)userBasedThresholdBySimilarityForAll
{
    [recommenderService userBasedThresholdBySimilarityForAll:recommenderSimilarity threshold:threshold howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)itemBasedForAll
{
    [recommenderService itemBasedForAll:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)itemBasedBySimilarityForAll
{
    [recommenderService itemBasedBySimilarityForAll:recommenderSimilarity howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)slopeOneForAll
{
    [recommenderService slopeOneForAll:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)itemBasedBySimilarity
{
    [recommenderService itemBasedBySimilarity:recommenderSimilarity userId:userId howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)userBasedNeighborhoodForAll
{
    [recommenderService userBasedNeighborhoodForAll:size howMany:howMany completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Recommender *recommender = (Recommender*)responseObj;
            NSLog(@"Response = %@",recommender.strResponse);
            NSLog(@"FileName=%@",recommender.fileName);
            for (RecommendedItem *recommendedItem in recommender.recommendedItemList)
            {
                NSLog(@"UserID = %@",recommendedItem.userId);
                NSLog(@"Item = %@",recommendedItem.item);
                NSLog(@"Value = %lf",recommendedItem.value);
            }
            [self showResponse:recommender.strResponse];
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
-(void)deleteAllPreferences
{
    [recommenderService deleteAllPreferences:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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

@end
