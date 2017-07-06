//
//  CatalogueServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Rajeev Ranjan on 09/12/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "CatalogueServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface CatalogueServiceAPIList ()
{
    CatalogueService *catalogueService;
    NSString *catalogueName;
    NSString *catalogueDescription;
    NSString *categoryName;
    NSString *categoryDescription;
    NSString *cartId;
    NSString *itemID;
}
@end

@implementation CatalogueServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Catalogue Service";
    
    catalogueService = [App42API buildCatalogueService];
    
    catalogueName = @"Mobiles";
    categoryName = @"Apple";
    catalogueDescription = @"Find different mobiles here!";
    categoryDescription = @"Find different iPhones here";
    cartId = @"";
    itemID = @"";
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
    if ([cell.textLabel.text isEqualToString:@"CreateCatalogue"])
    {
        [self createCatalogue];
    }
    else if ([cell.textLabel.text isEqualToString:@"CreateCategory"])
    {
        [self createCategory];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddItem"])
    {
        [self addItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetItems"])
    {
        [self getItems];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetItemsByCategory"])
    {
        [self getItemsByCategory];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetItemsCountByCategory"])
    {
        [self getItemsCountByCategory];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetItemsByCategoryByPaging"])
    {
        [self getItemsByCategoryByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetItemById"])
    {
        [self getItemById];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveAllItems"])
    {
        [self removeAllItems];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveItemsByCategory"])
    {
        [self removeItemsByCategory];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveItemById"])
    {
        [self removeItemById];
    }
}

-(void)createCatalogue
{
    [catalogueService createCatalogue:catalogueName catalogueDescription:catalogueDescription completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Catalogue *catalogue = (Catalogue*)responseObj;
            NSLog(@"Response=%@",catalogue.strResponse);
            NSLog(@"CatalogueName=%@",catalogue.name);
            NSLog(@"Description=%@",catalogue.description);
            
            [self showResponse:catalogue.strResponse];
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
-(void)createCategory
{
    [catalogueService createCategory:catalogueName categoryName:categoryName categoryDescription:categoryDescription completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Catalogue *catalogue = (Catalogue*)responseObj;
            NSLog(@"Response=%@",catalogue.strResponse);
            NSLog(@"CatalogueName=%@",catalogue.name);
            NSLog(@"Description=%@",catalogue.description);
            for (CategoryData *category in catalogue.categoryListArray)
            {
                NSLog(@"CategoryName=%@",category.name);
                NSLog(@"CategoryDescription=%@",category.description);
                for (categoryItem *item in category.itemListArray)
                {
                    NSLog(@"ItemName=%@",item.name);
                    NSLog(@"ItemDescription=%@",item.description);
                    NSLog(@"ItemID=%@",item.itemId);
                    NSLog(@"Item URL=%@",item.url);
                    NSLog(@"Item Price=%lf",item.price);
                }
            }
            [self showResponse:catalogue.strResponse];
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
-(void)addItem
{
    ItemData *itemData = [[ItemData alloc]init];
    itemData.itemId = @"iPhone1234";
    itemData.name = @"iPhone 4";
    itemData.image = [[NSBundle mainBundle] pathForResource:@"Tutorial-Box" ofType:@"png"];
    itemData.description = @"The finest and latest";
    itemData.price = 53500.0;
    [catalogueService addItem:catalogueName categoryName:categoryName itemData:itemData completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Catalogue *catalogue = (Catalogue*)responseObj;
            NSLog(@"Response=%@",catalogue.strResponse);
            NSLog(@"CatalogueName=%@",catalogue.name);
            for (CategoryData *category in catalogue.categoryListArray)
            {
                NSLog(@"CategoryName=%@",category.name);
                for (categoryItem *item in category.itemListArray)
                {
                    NSLog(@"ItemName=%@",item.name);
                    NSLog(@"ItemDescription=%@",item.description);
                    NSLog(@"ItemID=%@",item.itemId);
                    NSLog(@"Item URL=%@",item.url);
                    NSLog(@"Item Price=%lf",item.price);
                    //itemID = item.itemId;
                }
            }
            [self showResponse:catalogue.strResponse];
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
-(void)getItems
{
    [catalogueService getItems:catalogueName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Catalogue *catalogue = (Catalogue*)responseObj;
            NSLog(@"Response=%@",catalogue.strResponse);
            NSLog(@"CatalogueName=%@",catalogue.name);
            for (CategoryData *category in catalogue.categoryListArray)
            {
                NSLog(@"CategoryName=%@",category.name);
                for (categoryItem *item in category.itemListArray)
                {
                    NSLog(@"ItemName=%@",item.name);
                    NSLog(@"ItemDescription=%@",item.description);
                    NSLog(@"ItemID=%@",item.itemId);
                    NSLog(@"Item URL=%@",item.url);
                    NSLog(@"Item Price=%lf",item.price);
                    itemID = item.itemId;
                }
            }
            [self showResponse:catalogue.strResponse];
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
-(void)getItemsByCategory
{
    [catalogueService getItemsByCategory:catalogueName categoryName:categoryName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Catalogue *catalogue = (Catalogue*)responseObj;
            NSLog(@"Response=%@",catalogue.strResponse);
            NSLog(@"CatalogueName=%@",catalogue.name);
            for (CategoryData *category in catalogue.categoryListArray)
            {
                NSLog(@"CategoryName=%@",category.name);
                for (categoryItem *item in category.itemListArray)
                {
                    NSLog(@"ItemName=%@",item.name);
                    NSLog(@"ItemDescription=%@",item.description);
                    NSLog(@"ItemID=%@",item.itemId);
                    NSLog(@"Item URL=%@",item.url);
                    NSLog(@"Item Price=%lf",item.price);
                    itemID = item.itemId;
                }
            }
            [self showResponse:catalogue.strResponse];
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
-(void)getItemsCountByCategory
{
    [catalogueService getItemsCountByCategory:catalogueName categoryName:categoryName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response=%@",app42Response.strResponse);
            NSLog(@"TotalItemsCount=%d",app42Response.totalRecords);
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
-(void)getItemsByCategoryByPaging
{
    int max = 5;
    int offset = 0;
    [catalogueService getItemsByCategory:catalogueName categoryName:categoryName max:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Catalogue *catalogue = (Catalogue*)responseObj;
            NSLog(@"Response=%@",catalogue.strResponse);
            NSLog(@"CatalogueName=%@",catalogue.name);
            for (CategoryData *category in catalogue.categoryListArray)
            {
                NSLog(@"CategoryName=%@",category.name);
                for (categoryItem *item in category.itemListArray)
                {
                    NSLog(@"ItemName=%@",item.name);
                    NSLog(@"ItemDescription=%@",item.description);
                    NSLog(@"ItemID=%@",item.itemId);
                    NSLog(@"Item URL=%@",item.url);
                    NSLog(@"Item Price=%lf",item.price);
                    itemID = item.itemId;
                }
            }
            [self showResponse:catalogue.strResponse];
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
-(void)getItemById
{
    [catalogueService getItemById:catalogueName categoryName:categoryName itemId:itemID completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Catalogue *catalogue = (Catalogue*)responseObj;
            NSLog(@"Response=%@",catalogue.strResponse);
            NSLog(@"CatalogueName=%@",catalogue.name);
            for (CategoryData *category in catalogue.categoryListArray)
            {
                NSLog(@"CategoryName=%@",category.name);
                for (categoryItem *item in category.itemListArray)
                {
                    NSLog(@"ItemName=%@",item.name);
                    NSLog(@"ItemDescription=%@",item.description);
                    NSLog(@"ItemID=%@",item.itemId);
                    NSLog(@"Item URL=%@",item.url);
                    NSLog(@"Item Price=%lf",item.price);
                    itemID = item.itemId;
                }
            }
            [self showResponse:catalogue.strResponse];
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
-(void)removeAllItems
{
    [catalogueService removeAllItems:catalogueName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
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
-(void)removeItemsByCategory
{
    [catalogueService removeItemsByCategory:catalogueName categoryName:categoryName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
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

-(void)removeItemById
{
    [catalogueService removeItemById:catalogueName categoryName:categoryName itemId:itemID completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
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

-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
}

@end
