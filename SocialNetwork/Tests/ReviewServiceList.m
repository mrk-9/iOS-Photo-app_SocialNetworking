//
//  ReviewServiceList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 19/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "ReviewServiceList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface ReviewServiceList ()
{
    ReviewService *reviewService;
    NSString *reviewName;
    NSString *itemId;
    NSString *reviewId;
    NSString *commentId;
    NSString *reviewComment;
    double reviewRating;
    NSString *userID;
    
    int max;
    int offset;
}
@end

@implementation ReviewServiceList

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
    self.navigationItem.title = @"Review Service";
    
    reviewService = [App42API buildReviewService];
    
    reviewName = @"Shephertz1911";
    itemId = @"1234561";
    reviewId = @"";
    reviewComment = @"Great";
    reviewRating = 20;
    max = 10;
    offset = 0;
    userID = @"";
    commentId = @"";
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
        NSLog(@"Index : %d",index);
        cell.textLabel.text = [apiList objectAtIndex:index];
    }
    // Configure the cell...
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:@"CreateReview"])
    {
        [self createReview];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllReviews"])
    {
        [self getAllReviews];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllReviewsCount"])
    {
        [self getAllReviewsCount];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllReviewsByPaging"])
    {
        [self getAllReviewsByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAverageReviewByItem"])
    {
        [self getAverageReviewByItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"getReviewsCountByItem"])
    {
        [self getReviewsCountByItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetReviewsCountByItemAndRating"])
    {
        [self getReviewsCountByItemAndRating];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetReviewsByItem"])
    {
        [self getReviewsByItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetReviewsByItemByPaging"])
    {
        [self getReviewsByItemByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetHighestReviewByItem"])
    {
        [self getHighestReviewByItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetLowestReviewByItem"])
    {
        [self getLowestReviewByItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"Mute"])
    {
        [self mute];
    }
    else if ([cell.textLabel.text isEqualToString:@"Unmute"])
    {
        [self unmute];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddComment"])
    {
        [self addComment];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetCommentsByItem"])
    {
        [self getCommentsByItem];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteReviewByReviewId"])
    {
        [self deleteReviewByReviewId];
    }
    else if ([cell.textLabel.text isEqualToString:@"deleteCommentByCommentId"])
    {
        [self deleteCommentByCommentId];
    }
    else if ([cell.textLabel.text isEqualToString:@"GetAllReviewsByUser"])
    {
        [self getAllReviewsByUser];
    }
}


-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
    
}

#pragma mark- Create Review
-(void)createReview
{
    [reviewService createReview:reviewName itemID:itemId reviewComment:reviewComment reviewRating: reviewRating completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             Review *review = (Review*)responseObj;
             NSLog(@"Response =%@",review.strResponse);
             NSLog(@"userId is =%@",review.userId);
             NSLog(@"itemId is  = %@",review.itemId);
             NSLog(@"commentId is  = %@",review.commentId);
             [self showResponse:review.strResponse];
             itemId = review.itemId;
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


#pragma mark- Get All Reviews
-(void)getAllReviews
{
    [reviewService getAllReviews:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             NSArray *reviewArray = (NSArray*)responseObj;
             NSLog(@"reviewArray=%@",reviewArray);
             for (Review *review in reviewArray)
             {
                 NSLog(@"userId is =%@",review.userId);
                 NSLog(@"itemId is  = %@",review.itemId);
                 NSLog(@"commentId is  = %@",review.commentId);
             }
             [self showResponse:[reviewArray description]];
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

#pragma mark- Get All Reviews Count
-(void)getAllReviewsCount
{
    [reviewService getAllReviewsCount:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             App42Response *response = (App42Response*)responseObj;
             NSLog(@"Response=%@",response.strResponse);
             NSLog(@"UsersCount=%d",response.totalRecords);
             [self showResponse:response.strResponse];
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

#pragma mark- Get All Reviews
-(void)getAllReviewsByPaging
{
    [reviewService getAllReviews:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception)
     {
         if (success)
         {
             NSArray *reviewArray = (NSArray*)responseObj;
             NSLog(@"reviewArray=%@",reviewArray);
             for (Review *review in reviewArray)
             {
                 NSLog(@"userId is =%@",review.userId);
                 NSLog(@"itemId is  = %@",review.itemId);
                 NSLog(@"commentId is  = %@",review.commentId);
             }
             [self showResponse:[reviewArray description]];
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

-(void)getAverageReviewByItem
{
    [reviewService getAverageReviewByItem:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Review *review = (Review*)responseObj;
            NSLog(@"Response =%@",review);
            NSLog(@"userId is =%@",review.userId);
            NSLog(@"itemId is  = %@",review.itemId);
            NSLog(@"commentId is  = %@",review.commentId);
            [self showResponse:review.strResponse];
            itemId = review.itemId;
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

-(void)getReviewsCountByItem
{
    [reviewService getReviewsCountByItem:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response =%@",app42Response.strResponse);
            NSLog(@"ReviewsCount =%d",app42Response.totalRecords);

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

-(void)getReviewsCountByItemAndRating
{
    [reviewService getReviewsCountByItem:itemId andRating:reviewRating completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response =%@",app42Response.strResponse);
            NSLog(@"ReviewsCount =%d",app42Response.totalRecords);
            
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

-(void)getReviewsByItem
{
    [reviewService getReviewsByItem:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *reviewArray = (NSArray*)responseObj;
            NSLog(@"reviewArray=%@",reviewArray);
            for (Review *review in reviewArray)
            {
                NSLog(@"userId is =%@",review.userId);
                NSLog(@"itemId is  = %@",review.itemId);
                NSLog(@"commentId is  = %@",review.commentId);
            }
            [self showResponse:[reviewArray description]];
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

-(void)getReviewsByItemByPaging
{
    [reviewService getReviewsByItem:itemId max:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *reviewArray = (NSArray*)responseObj;
            NSLog(@"reviewArray=%@",reviewArray);
            for (Review *review in reviewArray)
            {
                NSLog(@"userId is =%@",review.userId);
                NSLog(@"itemId is  = %@",review.itemId);
                NSLog(@"commentId is  = %@",review.commentId);
            }
            [self showResponse:[reviewArray description]];
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

-(void)getHighestReviewByItem
{
    [reviewService getHighestReviewByItem:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Review *review = (Review*)responseObj;
            NSLog(@"Response =%@",review);
            NSLog(@"userId is =%@",review.userId);
            NSLog(@"itemId is  = %@",review.itemId);
            NSLog(@"commentId is  = %@",review.commentId);
            [self showResponse:review.strResponse];
            itemId = review.itemId;
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

-(void)getLowestReviewByItem
{
    [reviewService getLowestReviewByItem:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Review *review = (Review*)responseObj;
            NSLog(@"Response =%@",review);
            NSLog(@"userId is =%@",review.userId);
            NSLog(@"itemId is  = %@",review.itemId);
            NSLog(@"commentId is  = %@",review.commentId);
            [self showResponse:review.strResponse];
            itemId = review.itemId;
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

-(void)mute
{
    [reviewService mute:reviewId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Review *review = (Review*)responseObj;
            NSLog(@"Response =%@",review);
            NSLog(@"userId is =%@",review.userId);
            NSLog(@"itemId is  = %@",review.itemId);
            NSLog(@"commentId is  = %@",review.commentId);
            [self showResponse:review.strResponse];
            itemId = review.itemId;
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

-(void)unmute
{
    [reviewService unmute:reviewId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Review *review = (Review*)responseObj;
            NSLog(@"Response =%@",review);
            NSLog(@"userId is =%@",review.userId);
            NSLog(@"itemId is  = %@",review.itemId);
            NSLog(@"commentId is  = %@",review.commentId);
            [self showResponse:review.strResponse];
            itemId = review.itemId;
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

-(void)addComment
{
    [reviewService addComment:reviewComment byUser:userID forItem:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Review *review = (Review*)responseObj;
            NSLog(@"Response =%@",review);
            NSLog(@"userId is =%@",review.userId);
            NSLog(@"itemId is  = %@",review.itemId);
            NSLog(@"commentId is  = %@",review.commentId);
            [self showResponse:review.strResponse];
            itemId = review.itemId;
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

-(void)getCommentsByItem
{
    [reviewService getCommentsByItem:itemId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *reviewArray = (NSArray*)responseObj;
            NSLog(@"reviewArray=%@",reviewArray);
            for (Review *review in reviewArray)
            {
                NSLog(@"Response =%@",review);
                NSLog(@"userId is =%@",review.userId);
                NSLog(@"itemId is  = %@",review.itemId);
                NSLog(@"commentId is  = %@",review.commentId);
            }
            [self showResponse:[reviewArray description]];
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

-(void)deleteReviewByReviewId
{
    [reviewService deleteReviewByReviewId:reviewId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response =%@",app42Response.strResponse);
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

-(void)deleteCommentByCommentId
{
    [reviewService deleteCommentByCommentId:commentId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response =%@",app42Response.strResponse);
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

-(void)getAllReviewsByUser
{
    [reviewService getAllReviews:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSArray *reviewArray = (NSArray*)responseObj;
            NSLog(@"reviewArray=%@",reviewArray);
            for (Review *review in reviewArray)
            {
                NSLog(@"Response =%@",review);
                NSLog(@"userId is =%@",review.userId);
                NSLog(@"itemId is  = %@",review.itemId);
                NSLog(@"commentId is  = %@",review.commentId);
            }
            [self showResponse:[reviewArray description]];
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
