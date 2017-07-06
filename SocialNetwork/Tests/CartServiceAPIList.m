//
//  CartServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Rajeev Ranjan on 09/12/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "CartServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface CartServiceAPIList ()
{
    CartService *cartService;
    NSString *userName;
    NSString *cartId;
    NSString *itemId;
    NSString *paymentStatus;
    int itemQuantity;
    double price;
}
@end

@implementation CartServiceAPIList
@synthesize apiList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Cart Service";
    
    cartService = [App42API buildCartService];
    
    userName = @"RajeevRanjan";
    cartId = [[NSUserDefaults standardUserDefaults] objectForKey:@"App42_CartID"];
    if (!cartId)
    {
        cartId = @"";
    }
    itemId = @"iPhone12345";
    itemQuantity = 10;
    price = 500;
    
    paymentStatus = AUTHORIZED;
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
    if ([cell.textLabel.text isEqualToString:@"CreateCart"])
    {
        [self createCart];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetCartDetails"])
    {
        [self getCartDetails];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddItem"])
    {
        [self addItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetItems"])
    {
        [self getItems];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetItem"])
    {
        [self getItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveItem"])
    {
        [self removeItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"RemoveAllItems"])
    {
        [self removeAllItems];
    }
    else if ([cell.textLabel.text isEqualToString:@"IsEmpty"])
    {
        [self isEmpty];
    }
    else if ([cell.textLabel.text isEqualToString:@"CheckOut"])
    {
        [self checkOut];
    }
    else if ([cell.textLabel.text isEqualToString:@"Payment"])
    {
        [self payment];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPaymentsByUser"])
    {
        [self getPaymentsByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPaymentByCart"])
    {
        [self getPaymentByCart];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPaymentsByUserAndStatus"])
    {
        [self getPaymentsByUserAndStatus];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPaymentsByStatus"])
    {
        [self getPaymentsByStatus];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPaymentHistoryByUser"])
    {
        [self getPaymentHistoryByUser];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetPaymentHistoryAll"])
    {
        [self getPaymentHistoryAll];
    }
    else if ([cell.textLabel.text isEqualToString:@"IncreaseQuantity"])
    {
        [self increaseQuantity];
    }
    else if ([cell.textLabel.text isEqualToString:@"DecreaseQuantity"])
    {
        [self decreaseQuantity];
    }
}

-(void)createCart
{
    [cartService createCart:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"User Name=%@",cart.userName);
            NSLog(@"Cart ID=%@",cart.cartId);
            NSLog(@"CreationTime=%@",cart.creationTime);
            NSLog(@"Cart Session=%@",cart.cartSession);
            NSLog(@"isEmpty=%d",cart.isEmpty);
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
            [[NSUserDefaults standardUserDefaults] setObject:cartId forKey:@"App42_CartID"];
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
-(void)getCartDetails
{
    [cartService getCartDetails:cartId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"User Name=%@",cart.userName);
            NSLog(@"Cart ID=%@",cart.cartId);
            NSLog(@"CreatedOn=%@",cart.creationTime);
            NSLog(@"CheckoutTime=%@",cart.checkOutTime);
            NSLog(@"State=%@",cart.state);
            NSLog(@"Cart Session=%@",cart.cartSession);
            NSLog(@"isEmpty=%d",cart.isEmpty);
            NSLog(@"Total Amount=%lf",cart.totalAmount);
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
    [cartService addItem:cartId itemID:itemId itemQuantity:itemQuantity price:price completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"User Name=%@",cart.userName);
            NSLog(@"Cart ID=%@",cart.cartId);
            NSLog(@"CreatedOn=%@",cart.creationTime);
            NSLog(@"CheckoutTime=%@",cart.checkOutTime);
            NSLog(@"State=%@",cart.state);
            NSLog(@"Cart Session=%@",cart.cartSession);
            NSLog(@"isEmpty=%d",cart.isEmpty);
            NSLog(@"Total Amount=%lf",cart.totalAmount);
            
            for (Item *item in cart.itemListArray)
            {
                NSLog(@"ItemName=%@",item.name);
                NSLog(@"ItemID=%@",item.itemId);
                NSLog(@"ItemPrice = %d", [item.price intValue]);
                NSLog(@"Item Image = %@",item.image);
                NSLog(@"Item Quantity = %d",item.quantity);
                NSLog(@"Total Amount = %lf",item.totalAmount);
                itemId = item.itemId;
            }
            
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
    [cartService getItems:cartId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"Cart ID=%@",cart.cartId);
            
            for (Item *item in cart.itemListArray)
            {
                NSLog(@"ItemID=%@",item.itemId);
                NSLog(@"ItemPrice = %d", [item.price intValue]);
                NSLog(@"Item Image = %@",item.image);
                NSLog(@"Item Quantity = %d",item.quantity);
                NSLog(@"Total Amount = %lf",item.totalAmount);
                itemId = item.itemId;
            }
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
-(void)getItem
{
    [cartService getItem:cartId itemId:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"Cart ID=%@",cart.cartId);
            
            for (Item *item in cart.itemListArray)
            {
                NSLog(@"ItemName=%@",item.name);
                NSLog(@"ItemID=%@",item.itemId);
                NSLog(@"ItemPrice = %d", [item.price intValue]);
                NSLog(@"Item Image = %@",item.image);
                NSLog(@"Item Quantity = %d",item.quantity);
                NSLog(@"Total Amount = %lf",item.totalAmount);
                itemId = item.itemId;
            }

            
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
-(void)removeItem
{
    [cartService removeItem:cartId itemId:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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
-(void)removeAllItems
{
    [cartService removeAllItems:cartId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response = %@",app42Response.strResponse);
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
-(void)isEmpty
{
    [cartService isEmpty:cartId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"Cart ID=%@",cart.cartId);
            NSLog(@"isEmpty=%d",cart.isEmpty);
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
-(void)checkOut
{
    [cartService checkOut:cartId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"User Name=%@",cart.userName);
            NSLog(@"Cart ID=%@",cart.cartId);
            NSLog(@"CreatedOn=%@",cart.creationTime);
            NSLog(@"CheckoutTime=%@",cart.checkOutTime);
            NSLog(@"State=%@",cart.state);
            NSLog(@"Cart Session=%@",cart.cartSession);
            NSLog(@"isEmpty=%d",cart.isEmpty);
            NSLog(@"Total Amount=%lf",cart.totalAmount);
            
            for (Item *item in cart.itemListArray)
            {
                NSLog(@"ItemName=%@",item.name);
                NSLog(@"ItemID=%@",item.itemId);
                NSLog(@"ItemPrice = %d", [item.price intValue]);
                NSLog(@"Item Image = %@",item.image);
                NSLog(@"Item Quantity = %d",item.quantity);
                NSLog(@"Total Amount = %lf",item.totalAmount);
                itemId = item.itemId;
            }

            
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
-(void)payment
{
    NSString *transactionID = @"123456782313";
    [cartService payment:cartId transactionID:transactionID paymentStatus:AUTHORIZED completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"User Name=%@",cart.userName);
            NSLog(@"Cart ID=%@",cart.cartId);
            NSLog(@"CreatedOn=%@",cart.creationTime);
            NSLog(@"CheckoutTime=%@",cart.checkOutTime);
            NSLog(@"State=%@",cart.state);
            NSLog(@"Cart Session=%@",cart.cartSession);
            NSLog(@"isEmpty=%d",cart.isEmpty);
            NSLog(@"Total Amount=%lf",cart.totalAmount);
            
            for (Item *item in cart.itemListArray)
            {
                NSLog(@"ItemName=%@",item.name);
                NSLog(@"ItemID=%@",item.itemId);
                NSLog(@"ItemPrice = %d", [item.price intValue]);
                NSLog(@"Item Image = %@",item.image);
                NSLog(@"Item Quantity = %d",item.quantity);
                NSLog(@"Total Amount = %lf",item.totalAmount);
                itemId = item.itemId;
            }

            
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
-(void)getPaymentsByUser
{
    [cartService getPaymentsByUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *arrayObj = (NSArray*)responseObj;
            for (Cart *cart in arrayObj)
            {
                NSLog(@"Response=%@",cart.strResponse);
                NSLog(@"Cart ID=%@",cart.cartId);
                
                NSLog(@"TransactionID = %@",cart.paymentObj.transactionId);
                NSLog(@"Status = %@",cart.paymentObj.status);
                NSLog(@"Payment Date = %@",cart.paymentObj.date);
                NSLog(@"Total amount = %lf",cart.paymentObj.totalAmount);

            }
            [self showResponse:[arrayObj description]];
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
-(void)getPaymentByCart
{
    [cartService getPaymentByCart:cartId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"Cart ID=%@",cart.cartId);
            
            NSLog(@"TransactionID = %@",cart.paymentObj.transactionId);
            NSLog(@"Status = %@",cart.paymentObj.status);
            NSLog(@"Payment Date = %@",cart.paymentObj.date);
            NSLog(@"Total amount = %lf",cart.paymentObj.totalAmount);

            
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
-(void)getPaymentsByUserAndStatus
{
    [cartService getPaymentsByUserAndStatus:userName status:paymentStatus completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *arrayObj = (NSArray*)responseObj;
            for (Cart *cart in arrayObj)
            {
                NSLog(@"Response=%@",cart.strResponse);
                NSLog(@"Cart ID=%@",cart.cartId);
                
                NSLog(@"TransactionID = %@",cart.paymentObj.transactionId);
                NSLog(@"Status = %@",cart.paymentObj.status);
                NSLog(@"Payment Date = %@",cart.paymentObj.date);
                NSLog(@"Total amount = %lf",cart.paymentObj.totalAmount);
                
            }
            [self showResponse:[arrayObj description]];
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
-(void)getPaymentsByStatus
{
    [cartService getPaymentsByStatus:paymentStatus completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *arrayObj = (NSArray*)responseObj;
            for (Cart *cart in arrayObj)
            {
                NSLog(@"Response=%@",cart.strResponse);
                NSLog(@"Cart ID=%@",cart.cartId);
                
                NSLog(@"TransactionID = %@",cart.paymentObj.transactionId);
                NSLog(@"Status = %@",cart.paymentObj.status);
                NSLog(@"Payment Date = %@",cart.paymentObj.date);
                NSLog(@"Total amount = %lf",cart.paymentObj.totalAmount);
                
            }
            [self showResponse:[arrayObj description]];
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
-(void)getPaymentHistoryByUser
{
    [cartService getPaymentHistoryByUser:userName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *arrayObj = (NSArray*)responseObj;
            for (Cart *cart in arrayObj)
            {
                NSLog(@"Response=%@",cart.strResponse);
                NSLog(@"User Name=%@",cart.userName);
                NSLog(@"Cart ID=%@",cart.cartId);
                NSLog(@"CreatedOn=%@",cart.creationTime);
                NSLog(@"CheckoutTime=%@",cart.checkOutTime);
                NSLog(@"State=%@",cart.state);
                NSLog(@"Cart Session=%@",cart.cartSession);
                NSLog(@"isEmpty=%d",cart.isEmpty);
                NSLog(@"Total Amount=%lf",cart.totalAmount);
                
                for (Item *item in cart.itemListArray)
                {
                    NSLog(@"ItemName=%@",item.name);
                    NSLog(@"ItemID=%@",item.itemId);
                    NSLog(@"ItemPrice = %d", [item.price intValue]);
                    NSLog(@"Item Image = %@",item.image);
                    NSLog(@"Item Quantity = %d",item.quantity);
                    NSLog(@"Total Amount = %lf",item.totalAmount);
                    itemId = item.itemId;
                }

                
                NSLog(@"TransactionID = %@",cart.paymentObj.transactionId);
                NSLog(@"Status = %@",cart.paymentObj.status);
                NSLog(@"Payment Date = %@",cart.paymentObj.date);
                NSLog(@"Total amount = %lf",cart.paymentObj.totalAmount);
                
            }
            [self showResponse:[arrayObj description]];
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
-(void)getPaymentHistoryAll
{
    [cartService getPaymentHistoryAll:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *arrayObj = (NSArray*)responseObj;
            for (Cart *cart in arrayObj)
            {
                NSLog(@"Response=%@",cart.strResponse);
                NSLog(@"User Name=%@",cart.userName);
                NSLog(@"Cart ID=%@",cart.cartId);
                NSLog(@"CreatedOn=%@",cart.creationTime);
                NSLog(@"CheckoutTime=%@",cart.checkOutTime);
                NSLog(@"State=%@",cart.state);
                NSLog(@"Cart Session=%@",cart.cartSession);
                NSLog(@"isEmpty=%d",cart.isEmpty);
                NSLog(@"Total Amount=%lf",cart.totalAmount);
                
                for (Item *item in cart.itemListArray)
                {
                    NSLog(@"ItemName=%@",item.name);
                    NSLog(@"ItemID=%@",item.itemId);
                    NSLog(@"ItemPrice = %d", [item.price intValue]);
                    NSLog(@"Item Image = %@",item.image);
                    NSLog(@"Item Quantity = %d",item.quantity);
                    NSLog(@"Total Amount = %lf",item.totalAmount);
                    itemId = item.itemId;
                }
                
                
                NSLog(@"TransactionID = %@",cart.paymentObj.transactionId);
                NSLog(@"Status = %@",cart.paymentObj.status);
                NSLog(@"Payment Date = %@",cart.paymentObj.date);
                NSLog(@"Total amount = %lf",cart.paymentObj.totalAmount);
                
            }
            [self showResponse:[arrayObj description]];
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
-(void)increaseQuantity
{
    [cartService increaseQuantity:cartId itemID:itemId itemQuantity:itemQuantity completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"User Name=%@",cart.userName);
            NSLog(@"Cart ID=%@",cart.cartId);
            NSLog(@"CreatedOn=%@",cart.creationTime);
            NSLog(@"CheckoutTime=%@",cart.checkOutTime);
            NSLog(@"State=%@",cart.state);
            NSLog(@"Cart Session=%@",cart.cartSession);
            NSLog(@"isEmpty=%d",cart.isEmpty);
            NSLog(@"Total Amount=%lf",cart.totalAmount);
            
            for (Item *item in cart.itemListArray)
            {
                NSLog(@"ItemName=%@",item.name);
                NSLog(@"ItemID=%@",item.itemId);
                NSLog(@"ItemPrice = %d", [item.price intValue]);
                NSLog(@"Item Image = %@",item.image);
                NSLog(@"Item Quantity = %d",item.quantity);
                NSLog(@"Total Amount = %lf",item.totalAmount);
                itemId = item.itemId;
            }
            
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
-(void)decreaseQuantity
{
    [cartService decreaseQuantity:cartId itemID:itemId itemQuantity:itemQuantity completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Cart *cart = (Cart*)responseObj;
            NSLog(@"Response=%@",cart.strResponse);
            NSLog(@"User Name=%@",cart.userName);
            NSLog(@"Cart ID=%@",cart.cartId);
            NSLog(@"CreatedOn=%@",cart.creationTime);
            NSLog(@"CheckoutTime=%@",cart.checkOutTime);
            NSLog(@"State=%@",cart.state);
            NSLog(@"Cart Session=%@",cart.cartSession);
            NSLog(@"isEmpty=%d",cart.isEmpty);
            NSLog(@"Total Amount=%lf",cart.totalAmount);
            
            for (Item *item in cart.itemListArray)
            {
                NSLog(@"ItemName=%@",item.name);
                NSLog(@"ItemID=%@",item.itemId);
                NSLog(@"ItemPrice = %d", [item.price intValue]);
                NSLog(@"Item Image = %@",item.image);
                NSLog(@"Item Quantity = %d",item.quantity);
                NSLog(@"Total Amount = %lf",item.totalAmount);
                itemId = item.itemId;
            }

            
            [self showResponse:cart.strResponse];
            cartId = cart.cartId;
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
