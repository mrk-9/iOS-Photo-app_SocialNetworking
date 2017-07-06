//
//  StorageServiceAPIList.m
//  PAE_iOS_SDK
//
//  Created by Shephertz Technologies Pvt Ltd on 06/11/14.
//  Copyright (c) 2014 ShephertzTechnology PVT LTD. All rights reserved.
//

#import "StorageServiceAPIList.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "ResponseViewController.h"


@interface StorageServiceAPIList ()
{
    StorageService *storageService;
}
@end

@implementation StorageServiceAPIList
@synthesize apiList;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Storage Service";
    
    [App42API setOfflineStorage:YES];
    storageService = [App42API buildStorageService];
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
    if ([cell.textLabel.text isEqualToString:@"InsertDocFromJsonString"])
    {
        [self insertJsonDoc];
    }
    else if ([cell.textLabel.text isEqualToString:@"InsertDocFromDictionary"])
    {
        [self insertDocWithDataDict];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindAllDocs"])
    {
        [self findAllDocs];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindAllDocsByPaging"])
    {
        [self findAllDocsByPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindAllDocsCount"])
    {
        [self findAllDocsCount];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindAllCollections"])
    {
        [self findAllCollections];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindDocumentById"])
    {
        [self findDocumentById];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindDocumentByKeyValue"])
    {
        [self findDocumentByKeyValue];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindDocumentByQuery"])
    {
        [self findDocumentByQuery];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindDocumentsByQueryWithPaging"])
    {
        [self findDocumentsByQueryWithPaging];
    }
    else if ([cell.textLabel.text isEqualToString:@"FindDocsWithQueryPagingOrderBy"])
    {
        [self findDocsWithQueryPagingOrderBy];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateDocumentByIdFromJsonString"])
    {
        [self updateDocumentByIdFromJsonString];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateDocumentByIdFromDictionary"])
    {
        [self updateDocumentByIdFromDictionary];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateDocumentByKeyValueFromJsonString"])
    {
        [self updateDocumentByKeyValueFromJsonString];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateDocumentByKeyValueFromDictionary"])
    {
        [self updateDocumentByKeyValueFromDictionary];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateDocumentByQueryFromJsonString"])
    {
        [self updateDocumentByQueryFromJsonString];
    }
    else if ([cell.textLabel.text isEqualToString:@"UpdateDocumentByQueryFromDictionary"])
    {
        [self updateDocumentByQueryFromDictionary];
    }
    else if ([cell.textLabel.text isEqualToString:@"SaveOrUpdateDocumentByKeyValueFromJsonString"])
    {
        [self saveOrUpdateDocumentByKeyValueFromJsonString];
    }
    else if ([cell.textLabel.text isEqualToString:@"SaveOrUpdateDocumentByKeyValueFromDictionary"])
    {
        [self saveOrUpdateDocumentByKeyValueFromDictionary];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteAllDocuments"])
    {
        [self deleteAllDocuments];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteDocumentById"])
    {
        [self deleteDocumentById];
    }
    else if ([cell.textLabel.text isEqualToString:@"DeleteDocumentsByKeyValue"])
    {
        [self deleteDocumentsByKeyValue];
    }
    else if ([cell.textLabel.text isEqualToString:@"InsertJsonDocUsingMap"])
    {
        [self insertJsonDocUsingMap];
    }
    else if ([cell.textLabel.text isEqualToString:@"MapReduce"])
    {
        [self mapReduce];
    }
    else if ([cell.textLabel.text isEqualToString:@"GrantAccess"])
    {
        [self grantAccess];
    }
    else if ([cell.textLabel.text isEqualToString:@"RevokeAccess"])
    {
        [self revokeAccess];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddOrUpdateKeys"])
    {
        [self addOrUpdateKeys];
    }
    else if ([cell.textLabel.text isEqualToString:@"InsertDocFromDataDictWithAtachment"])
    {
        [self insertDocFromDataDictWithAtachment];
    }
    else if ([cell.textLabel.text isEqualToString:@"InsertJSONDocumentWithAttachment"])
    {
        [self insertJSONDocumentWithAttachment];
    }
    else if ([cell.textLabel.text isEqualToString:@"AddAttachmentToDocs"])
    {
        [self addAttachmentToDocs];
    }
}



-(void)showResponse:(NSString*)response
{
    ResponseViewController *responseViewController = [[ResponseViewController alloc] initWithNibName:@"ResponseViewController" bundle:nil];
    responseViewController.response = response;
    [self.navigationController pushViewController:responseViewController animated:YES];
    
}

#pragma mark- insertDocument

-(void)addAttachmentToDocs
{
    
}

-(void)insertJsonDoc
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"RajeevRShephertz";
    NSString *json = @"{\"name\":\"RajeevRShephertz\",\"age\":32,\"phone\":\"8800927154\"}";
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"App42_SessionID"];
    [storageService setSessionId:sessionId];
    
    [storageService insertJSONDocument:dbName collectionName:collectionName json:json completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            if (storage.isOfflineSync)
            {
                //Request is saved in cache
                NSLog(@"Offline Response = %@",storage.strResponse);
            }
            else
            {
                NSLog(@"dbName is %@" , storage.dbName);
                NSLog(@"collectionNameId is %@" ,  storage.collectionName);
                NSMutableArray *jsonDocArray = storage.jsonDocArray;
                for(JSONDocument *jsonDoc in jsonDocArray)
                {
                    NSLog(@"objectId is = %@ ", jsonDoc.docId);
                    NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                    NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                    NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                    NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
                }
            }
            [self showResponse:storage.strResponse];
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

-(void)insertJSONDocumentWithAttachment
{
    
}

-(void)insertDocWithDataDict
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Rajeev Ranjan",@"name", nil];
    [storageService insertJSONDocument:dbName collectionName:collectionName dataDict:dataDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionNameId is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)insertDocFromDataDictWithAtachment
{
    
}

#pragma mark- FindAllDocs

-(void)findAllDocs
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    [storageService findAllDocuments:dbName collectionName:collectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionNameId is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)findAllDocsByPaging
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    int max =5;
    int offset = 0;
    [storageService findAllDocuments:dbName collectionName:collectionName max:max offset:offset completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionNameId is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)findAllDocsCount
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    [storageService findAllDocumentsCount:dbName collectionName:collectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            NSLog(@"TotalRecords is %d" ,  response.totalRecords);
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

-(void)findAllCollections
{
     NSString *dbName = @"jsonDocument2";
    [storageService findAllCollections:dbName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

#pragma mark- FindDocument

-(void)findDocumentById
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *docId = @"docId";
    [storageService findDocumentById:dbName collectionName:collectionName docId:docId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)findDocumentByQuery
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"TestingScore";
    NSArray *arr = [NSArray arrayWithObjects:@"100004971962878",@"John", nil];
     Query *query = [QueryBuilder buildQueryWithKey:@"UserId" value:arr andOperator:APP42_OP_INLIST];
    [storageService findDocumentsByQuery:query dbName:dbName collectionName:collectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception){
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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


-(void)findDocumentByKeyValue
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *key =@"name";
    NSString *value = @"value";
    
    [storageService findDocumentByKeyValue:dbName collectionName:collectionName key:key value:value completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)findDocumentsByQueryWithPaging
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    Query *query = [QueryBuilder buildQueryWithKey:@"Role" value:@"COO" andOperator:APP42_OP_EQUALS];
    [storageService findDocumentsByQueryWithPaging:dbName collectionName:collectionName query:query max:5 offset:0 completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)findDocsWithQueryPagingOrderBy
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    Query *query = [QueryBuilder buildQueryWithKey:@"Role" value:@"COO" andOperator:APP42_OP_EQUALS];
    [storageService findDocsWithQueryPagingOrderBy:dbName collectionName:collectionName query:query max:5 offset:0 orderByKey:@"name" orderByType:APP42_ORDER_ASCENDING completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

#pragma mark- UpdateDocuments

-(void)updateDocumentByKeyValueFromJsonString
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *key =@"name";
    NSString *value = @"value";
    NSString *jsonString = @"";
    [storageService updateDocumentByKeyValue:dbName collectionName:collectionName key:key value:value newJsonDoc:jsonString completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)updateDocumentByKeyValueFromDictionary
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *key =@"name";
    NSString *value = @"value";
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"key",@"value", nil];
    [storageService updateDocumentByKeyValue:dbName collectionName:collectionName key:key value:value newDataDict:dataDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)updateDocumentByIdFromJsonString
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *docId =@"docId";
    NSString *jsonString = @"";
    [storageService updateDocumentByDocId:dbName collectionName:collectionName docId:docId newJsonDoc:jsonString completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)updateDocumentByIdFromDictionary
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *docId =@"docId";
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"key",@"value", nil];
    [storageService updateDocumentByDocId:dbName collectionName:collectionName docId:docId newDataDict:dataDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)updateDocumentByQueryFromJsonString
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *jsonString = @"{\"Role\":\"B\"}";
    Query *query = [QueryBuilder buildQueryWithKey:@"Role" value:@"COO" andOperator:APP42_OP_EQUALS];

    [storageService updateDocumentByQuery:dbName collectionName:collectionName query:query newJsonDoc:jsonString completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)updateDocumentByQueryFromDictionary
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    Query *query = [QueryBuilder buildQueryWithKey:@"Role" value:@"COO" andOperator:APP42_OP_EQUALS];

    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Role",@"A", nil];
    [storageService updateDocumentByQuery:dbName collectionName:collectionName query:query newDataDict:dataDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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


-(void)saveOrUpdateDocumentByKeyValueFromJsonString
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *key =@"name";
    NSString *value = @"value";
    NSString *jsonString = @"";
    [storageService saveOrUpdateDocumentByKeyValue:dbName collectionName:collectionName key:key value:value newJsonDoc:jsonString completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)saveOrUpdateDocumentByKeyValueFromDictionary
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *key =@"name";
    NSString *value = @"value";
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:@"key",@"value", nil];
    [storageService saveOrUpdateDocumentByKeyValue:dbName collectionName:collectionName key:key value:value dataDict:dataDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)addOrUpdateKeys
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *docId =@"docId";
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Nick",@"First Name", nil];

    [storageService addOrUpdateKeys:dbName collectionName:collectionName docId:docId dataDict:jsonDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionName is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

#pragma mark- DeleteDocuments

-(void)deleteDocumentById
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *docId =@"docId";
    [storageService deleteDocumentById:dbName collectionName:collectionName docId:docId completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            
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

-(void)deleteDocumentsByKeyValue
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *key =@"key";
    NSString *value =@"value";

    [storageService deleteDocumentsByKeyValue:dbName collectionName:collectionName key:key value:value completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
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

-(void)deleteAllDocuments
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    [storageService deleteAllDocuments:dbName collectionName:collectionName completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            App42Response *response = (App42Response*)responseObj;
            NSLog(@"Response is %@" , response.strResponse);
            
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

#pragma mark- ACL methods

-(void)grantAccess
{
    
}

-(void)revokeAccess
{
    
}

#pragma mark- Map Reduce

-(void)insertJsonDocUsingMap
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
    [mutableDict setObject:@"23" forKey:@"age"];
    [mutableDict setObject:@"Rajeev" forKey:@"name"];
    [storageService insertJsonDocUsingMap:dbName collectionName:collectionName map:mutableDict completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            Storage *storage = (Storage*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionNameId is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                NSLog(@"objectId is = %@ ", jsonDoc.docId);
                NSLog(@"jsonDoc is  = %@ ", jsonDoc.jsonDoc);
                NSLog(@"UpdatedAt   = %@ ", jsonDoc.updatedAt);
                NSLog(@"CreatedAt   = %@ ", jsonDoc.createdAt);
                NSLog(@"Loc=(%lf, %lf)",jsonDoc.loc.lat,jsonDoc.loc.lng);
            }
            [self showResponse:storage.strResponse];
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

-(void)mapReduce
{
    NSString *dbName = @"jsonDocument2";
    NSString *collectionName = @"Your_Collection_Name";
    NSString *mapFunction = @"function map(){ emit(this.user,1);}" ;
    NSString *reduceFunction = @"function reduce(key, val){var sum = 0; for(var n=0;n<val.length;n++){ sum = sum + val[n]; } return sum;}";
    [storageService mapReduce:dbName collectionName:collectionName mapFunction:mapFunction reduceFunction:reduceFunction completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)
        {
            NSString *response = (NSString*)responseObj;
            NSLog(@"Response is %@" , response);
            
            [self showResponse:response];
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
