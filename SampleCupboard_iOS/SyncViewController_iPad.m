//
//  SyncViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//



#import "SyncViewController_iPad.h"
#import "Reachability.h"

Reachability *internetReachableFoo;

@interface SyncViewController_iPad ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLoadHCPs;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnReloadData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSync;

- (IBAction)btnLoadHCPsClick:(id)sender;
- (IBAction)btnReloadDataClick:(id)sender;
- (IBAction)btnSyncClick:(id)sender;

@end



@implementation SyncViewController_iPad

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Show No Network Message If Internet is Not Connected...
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
     if (internetStatus == NotReachable){
     
         NSLog(@"There's no connection");
         
         UIAlertView *errorAlertView = [[UIAlertView alloc]
                                        initWithTitle:@"No internet connection"
                                        message:@"Internet connection is required to use this app"
                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         
         [errorAlertView show];
         
     
     } else {
         NSLog(@"Internet connection is OK");
     }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSyncClick:(id)sender {
    
    
    
    // TEST INSERTION METHOD USING MANUAL INSERT
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    // PART 1. INSERT ORDER
    // NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *OrderHDR = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Order"
                                 inManagedObjectContext:context];
    [OrderHDR setValue:@"123456" forKey:@"clientid"];
    [OrderHDR setValue:@"2e9847f5-c72b-4118-bb99-349377e18758" forKey:@"orderid"];
    [OrderHDR setValue:@"1234567" forKey:@"reference"];
    [OrderHDR setValue:@"Brick" forKey:@"shipping_firstname"];
    [OrderHDR setValue:@"Mortar" forKey:@"shipping_lastname"];
    [OrderHDR setValue:@"Active" forKey:@"status"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
        NSString *dateStringA = @"Tue, 18 Oct 2011 15:54:43 +0900";
        NSDate *dateA = [dateFormatter dateFromString:dateStringA];
    [OrderHDR setValue:dateA forKey:@"datecreated"];
    
    
    
    // could also use [OrderHDR setValue:[NSDate date] forKey:@"datecreated"];
    
    
    // PART 2. INSERT ORDER DETAILS IMMEDIATELY AFTER
    NSManagedObject *OrderDTL = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"OrderLineItem"
                                          inManagedObjectContext:context];
    [OrderDTL setValue:@"2e9847f5-c72b-4118-bb99-349377e18758" forKey:@"orderid"];
    [OrderDTL setValue:@"123456" forKey:@"clientid"];
    [OrderDTL setValue:@"EMG 2300" forKey:@"productid"];
    [OrderDTL setValue:[NSNumber numberWithInt:55] forKey:@"quantityordered"];
    [OrderDTL setValue:[NSDate date] forKey:@"datecreated"];
    
    //PART 3. INSERT VALUE FOR RELATIONSHIP    
    [OrderDTL setValue:OrderHDR forKey:@"toOrderHeader"];
    // [OrderHDR setValue:OrderDTL forKey:@"toOrderDetails"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Synchronize"
                          message: @"Record synchronized successfully"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];

    
    // [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"others" waitUntilDone:YES];
    
    // Delete Data For "others"
    // [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"others" waitUntilDone:YES];
    
    // Example #1 - NO Work
    // [self performSelectorOnMainThread:@selector(deleteAllManagedObjectsInModel:) withObject:@"others" waitUntilDone:YES];
    
    
}


- (IBAction)btnReloadDataClick:(id)sender {
    
    // Check Internet
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    if (internetStatus == NotReachable){
        
        NSLog(@"There's no connection");
        
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:NSLocalizedString(@"Connection Required",@"titleKey")
                                       message:NSLocalizedString(@"Internet connection is required to use this app!",@"messageKey")                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
        
    } else {
        
        // NSLog(NSLocalizedString(@"Connection OK",@"fakeKey"));
        
        // Delete Data For "others"
        [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"others" waitUntilDone:YES];
        
        // Populate Data For "others"
        [self performSelectorOnMainThread:@selector(PopulateEntities:) withObject:@"others" waitUntilDone:YES];
        
        // Process Complete
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Complete",@"titleKey")
                              message:NSLocalizedString(@"Reload Complete",@"messageKey")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK",@"cancelKey")
                              otherButtonTitles:nil];
        [alert show];
    }
    
}



- (IBAction)btnLoadHCPsClick:(id)sender {
    
    
    // Check Internet
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    if (internetStatus == NotReachable){
        
        NSLog(@"There's no connection");
        
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:NSLocalizedString(@"Connection Required",@"titleKey")
                                       message:NSLocalizedString(@"Internet connection is required to use this app!",@"messageKey")                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
        
    } else {
        
        // Delete Data HCP
        [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"hcp" waitUntilDone:YES];
        
        // Populate Data For "others"
        [self performSelectorOnMainThread:@selector(PopulateEntities:) withObject:@"hcp" waitUntilDone:YES];
        
        // Process All Records
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"HCP Update Complete"
                              message: @"All Hcp Records Have Been Updated."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}
    
    

- (void) RemoveEntities:(NSString *) removalType {
    
    
    NSLog(@"Entity A Removal Called %@", removalType);
    
    NSArray *deletionEntity;
    
    NSString *delete_hcp = @"hcp";
    NSString *delete_others = @"others";
    
    
    if ([removalType isEqual: delete_hcp])  {
        deletionEntity = @[@"HealthCareProfessional"];
    }
    
    if ([removalType isEqual: delete_others]) {
        deletionEntity = @[@"ClientInfo",@"Product",@"Allocation",@"AllocationHeader",@"TerritoryFSA",@"Territory",@"Rep", @"Order", @"OrderLineItem"];
    }
    
    
    // Define Delegate Context
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    

    
    for(int i=0;i<[deletionEntity count];i++)
    {
        
        NSLog(@"Entity in Question %@", [deletionEntity objectAtIndex:i]);
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:[deletionEntity objectAtIndex:i] inManagedObjectContext:context];
  
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        
        for (NSManagedObject *managedObject in items) {
            [_managedObjectContext deleteObject:managedObject];
            NSLog(@"%@ object deleted",[deletionEntity objectAtIndex:i]);
        }
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error deleting %@ - error:%@",[deletionEntity objectAtIndex:i],error);
        }
        
        NSLog(@"Actual Entry %@", [deletionEntity objectAtIndex:i] );
        
        
    }// End Each
    
}





// EXAMPLE #1 - Remove All Objects IF NEW REP
- (void)deleteAllManagedObjectsInModel:(NSString *) removalType
{

    //managedObjectModel
    NSManagedObjectModel *managedObjectModel;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SampleCupboard_iOS" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //managedObjectContext
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [managedObjectContext performBlockAndWait:^{
            for (NSEntityDescription *entity in managedObjectModel) {
                NSFetchRequest *fetchRequest = [NSFetchRequest new];
                [fetchRequest setEntity:entity];
                [fetchRequest setIncludesSubentities:NO];
                NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
                for (NSManagedObject *managedObject in objects) {
                    [managedObjectContext deleteObject:managedObjectContext];
                }
            }
            
            [managedObjectContext save:nil];
        }];
    }];
    [operation setCompletionBlock:^{
        // Do stuff once the truncation is complete
    }];
    [operation start];
}






- (void) PopulateEntities:(NSString *) populationType {
    

    //Entities Should Be Defined By Stuff Being Sent (May Need To Exclude Certain Objects)
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error;
    
    //Get User ID AND Token
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
    NSArray *currentitems = [[context executeFetchRequest:request error:&error] lastObject];
    
    NSString *comp_userid = [[[currentitems valueForKey:@"user_id"] description] lowercaseString];
    NSString *comp_token = [[[currentitems valueForKey:@"token"] description] lowercaseString];
    
    
    //Prep Values
    NSString *baseurl = @"http://dev.samplecupboard.com/Data/MobileServices.svc";
    NSString *urluserid = comp_userid;
    NSString *urltoken = comp_token;
    NSURL *url = [NSURL URLWithString:@""];
    
    NSString *urlsvc = @"TBD";
    
    
    //Population Options
    NSString *populate_hcp = @"hcp";
    NSString *populate_others = @"others";
    
    
    
    
    if ([populationType isEqual: populate_hcp])  {
        
    // HCP
    urlsvc = @"GetActiveHcpsInARepsReach";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                    baseurl,
                                    urlsvc,
                                    urluserid,
                                    urltoken,
                                    urluserid]];
        
    NSLog(@"Show HCP SVC %@", url);
        
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetActiveHcpsInARepsReachResult"];
        
        // NSLog(@"hcp: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"HealthCareProfessional"
                                      inManagedObjectContext:context];
            [model setValue:@"TEST123" forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"FirstName"] forKey:@"firstname"];
            [model setValue:[dicItems objectForKey:@"LastName"] forKey:@"lastname"];
            
            
            if ([[dicItems objectForKey:@"Phone"] isKindOfClass:[NSNull class]]) {
                [model setValue:@" " forKey:@"phone"];
            } else {
                [model setValue:[dicItems objectForKey:@"Phone"] forKey:@"phone"];
            }
            
            if ([[dicItems objectForKey:@"Fax"] isKindOfClass:[NSNull class]]) {
                [model setValue:@" " forKey:@"fax"];
            } else {
                [model setValue:[dicItems objectForKey:@"Fax"] forKey:@"fax"];
            }
            
            
            if ([[dicItems objectForKey:@"FacilityName"] isKindOfClass:[NSNull class]]) {
                [model setValue:@" " forKey:@"facility"];
            } else {
                [model setValue:[dicItems objectForKey:@"FacilityName"] forKey:@"facility"];
            }
            
            [model setValue:[dicItems objectForKey:@"Deparment"] forKey:@"department"];
            [model setValue:[dicItems objectForKey:@"AddressLine1"] forKey:@"address1"];
            
            if ([[dicItems objectForKey:@"AddressLine2"] isKindOfClass:[NSNull class]]) {
                [model setValue:@" " forKey:@"address2"];
            } else {
                [model setValue:[dicItems objectForKey:@"AddressLine2"] forKey:@"address2"];
            }
            
            if ([[dicItems objectForKey:@"AddressLine3"] isKindOfClass:[NSNull class]]) {
                [model setValue:@" " forKey:@"address3"];
            } else {
                [model setValue:[dicItems objectForKey:@"AddressLine3"] forKey:@"address3"];
            }
            
            
            
            // [model setValue:[dicItems objectForKey:@"AddressLine2"] forKey:@"address2"];
            // [model setValue:[dicItems objectForKey:@"AddressLine3"] forKey:@"address3"];
            [model setValue:[dicItems objectForKey:@"Email"] forKey:@"email"];
            [model setValue:[dicItems objectForKey:@"City"] forKey:@"city"];
            [model setValue:[dicItems objectForKey:@"Province"] forKey:@"province"];
            [model setValue:[dicItems objectForKey:@"PostalCode"] forKey:@"postal"];
            // [model setValue:[dicItems objectForKey:@"SignDate"] forKey:@"signdate"];
            [model setValue:[dicItems objectForKey:@"PHLID"] forKey:@"id"];
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        // if (error == nil)
        // NSLog(@"%@", dictContainer);addre
    }

    
        
        
    }  // END HCP SECTION
    
    
    
    
    if ([populationType isEqual: populate_others])  {
    
    // Client Info -  Single Record
    NSURL *url = [NSURL URLWithString:@"http://project.dwsmall.com/clientinfo"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"clientinfo"];
        
        // NSLog(@"clientinfo: %@", arrayContainer);
        
        NSDictionary* dicItems = [arrayContainer objectAtIndex:0];
        
        NSManagedObject *model = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"ClientInfo"
                                  inManagedObjectContext:context];
        [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
        [model setValue:[dicItems objectForKey:@"DisplayName"]  forKey:@"displayname"];
        
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    // Products - Multiple
        
    urlsvc = @"GetProductByUserId";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                    baseurl,
                                    urlsvc,
                                    urluserid,
                                    urltoken,
                                    urluserid]];
        
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetProductByUserIdResult"];
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Product"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"Code"]  forKey:@"code"];
            [model setValue:[dicItems objectForKey:@"Name"]  forKey:@"name"];
            [model setValue:[dicItems objectForKey:@"Description"]  forKey:@"product_description"];
            [model setValue:[dicItems objectForKey:@"LowLevelQuantity"]  forKey:@"lowlevelquantity"];
            [model setValue:[dicItems objectForKey:@"Type"]  forKey:@"type"];
            [model setValue:[dicItems objectForKey:@"Status"]  forKey:@"status"];
            [model setValue:[dicItems objectForKey:@"UnitMultiplier"]  forKey:@"unitmultiplier"];
            
            // [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            // [model setValue:[dicItems objectForKey:@"options_OrderTypeEligibility"]  forKey:@"options_ordertypeeligibility"];
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    // AllocationHeader - Single
    
    url = [NSURL URLWithString:@"http://project.dwsmall.com/allocationheader"];
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"allocationheader"];
        
        // NSLog(@"allocationheader: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"AllocationHeader"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"Name"] forKey:@"name"];
            [model setValue:[dicItems objectForKey:@"Description"] forKey:@"allocdescription"];
            
            // Date Conversion Routine
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
            NSString *dateStringA = [dicItems objectForKey:@"DateStart"];
            NSString *dateStringB = [dicItems objectForKey:@"DateEnd"];
            
            NSDate *dateA = [dateFormatter dateFromString:dateStringA];
            NSDate *dateB = [dateFormatter dateFromString:dateStringB];
            
            [model setValue:dateA forKey:@"datestart"];
            [model setValue:dateB forKey:@"dateend"];
            [model setValue:[dicItems objectForKey:@"Inactive"]  forKey:@"inactive"];
            [model setValue:[dicItems objectForKey:@"Year"]  forKey:@"year"];
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    
    // Allocation
    
    url = [NSURL URLWithString:@"http://project.dwsmall.com/allocation"];
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"allocation"];
        
        // NSLog(@"allocation: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Allocation"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"OriginalTotalMax"] forKey:@"originaltotalmax"];
            [model setValue:[dicItems objectForKey:@"OriginalOrderMax"] forKey:@"originalordermax"];
            [model setValue:[dicItems objectForKey:@"Inventory"] forKey:@"inventory"];
            [model setValue:[dicItems objectForKey:@"HCPTargetListId"] forKey:@"hcptargetlistid"];
            [model setValue:[dicItems objectForKey:@"IsHCP"] forKey:@"ishcp"];
            [model setValue:[dicItems objectForKey:@"IsHCPTargetList"] forKey:@"ishcptargetlist"];
            [model setValue:[dicItems objectForKey:@"IsRep"] forKey:@"isrep"];
            [model setValue:[dicItems objectForKey:@"IsTerritory"] forKey:@"isterritory"];
            [model setValue:[dicItems objectForKey:@"ProductId"] forKey:@"productid"];
            [model setValue:[dicItems objectForKey:@"TerritoryId"] forKey:@"territoryid"];
            [model setValue:[dicItems objectForKey:@"TotalMax"] forKey:@"totalmax"];
            [model setValue:[dicItems objectForKey:@"OrderMax"] forKey:@"ordermax"];
            [model setValue:[dicItems objectForKey:@"ParentId"] forKey:@"parentid"];
            [model setValue:[dicItems objectForKey:@"DefaultOrderMax"] forKey:@"defaultordermax"];
            [model setValue:[dicItems objectForKey:@"AllocationHeaderId"] forKey:@"allocationheaderid"];
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
        
    
    // REP
    
        NSString *urlsvc = @"GetUserById";        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                                baseurl,
                                                urlsvc,
                                                urluserid,
                                                urltoken,
                                                urluserid]];
        
        NSLog(@"url: %@", url);
        
        jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetUserByIdResult"];
        
        
        NSLog(@"array count %d",[arrayContainer count]);
        

        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            
            // should only be 1 item
            if (i == 5)
            {
                NSLog(@"current index %d",i);
                NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
                NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Rep"
                                      inManagedObjectContext:context];
                // [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
                [model setValue:[dicItems objectForKey:@"Name"] forKey:@"firstname"];
                [model setValue:[dicItems objectForKey:@"Password"] forKey:@"password"];
            
                // [model setValue:[dicItems objectForKey:@"LastName"] forKey:@"lastname"];
                // [model setValue:[dicItems objectForKey:@"Title"] forKey:@"title"];
                // [model setValue:[dicItems objectForKey:@"Role"] forKey:@"role"];
                // [model setValue:[dicItems objectForKey:@"Username"] forKey:@"username"];
                // [model setValue:[dicItems objectForKey:@"Status"] forKey:@"status"];
                // [model setValue:[dicItems objectForKey:@"Language"] forKey:@"language"];
                // [model setValue:[dicItems objectForKey:@"PreferredLanguage"] forKey:@"preferredlanguage"];
                // [model setValue:[dicItems objectForKey:@"IdentityManagerId"] forKey:@"identitymanagerid"];
                // [model setValue:[dicItems objectForKey:@"Email"] forKey:@"email"];
            }
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
        
        
    // ORDER INFO
    
    // HCP
    urlsvc = @"GetOrdersByRepId";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                    baseurl,
                                    urlsvc,
                                    urluserid,
                                    urltoken,
                                    urluserid]];
        
    jsonData = [NSData dataWithContentsOfURL:url];
        
    
        // Grab Detailed Data
        urlsvc = @"GetOrdersItemByRepId";
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                    baseurl,
                                    urlsvc,
                                    urluserid,
                                    urltoken,
                                    urluserid]];
        NSData *jsonData2 = [NSData dataWithContentsOfURL:url2];
        
        
        NSLog(@"Url for ORDER DETAIL: %@", url2);
        
        
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
            // Dictionary of Detailed Items
            NSDictionary* dictContainer2 = [NSJSONSerialization JSONObjectWithData:jsonData2 options:kNilOptions error:&error];
        
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetOrdersByRepIdResult"];
        
            // Container of Detailed Items
            NSArray* arrayContainer2 = [dictContainer2 objectForKey:@"GetOrdersItemByRepIdResult"];
        
        
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *OrderHDR = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Order"
                                      inManagedObjectContext:context];
            // [OrderHDR setValue:[dicItems objectForKey:@"clientid"] forKey:@"clientid"];
            [OrderHDR setValue:[dicItems objectForKey:@"orderId"] forKey:@"orderid"];
            
            
            [OrderHDR setValue:[NSString stringWithFormat:@"%@",[dicItems objectForKey:@"reference"]] forKey:@"reference"];
            
            [OrderHDR setValue:[dicItems objectForKey:@"refprefix"] forKey:@"refprefix"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_facilityname"] forKey:@"shipping_facilityname"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_firstname"] forKey:@"shipping_firstname"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_lastname"] forKey:@"shipping_lastname"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_line1"] forKey:@"shipping_addressline1"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_line2"] forKey:@"shipping_addressline2"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_line3"] forKey:@"shipping_addressline3"];
            
            // [OrderHDR setValue:[dicItems objectForKey:@"shipping_suite"] forKey:@"shipping_suite"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_postalcode"] forKey:@"shipping_postalcode"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_city"] forKey:@"shipping_city"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_provinces"] forKey:@"shipping_province"];
            // [OrderHDR setValue:[dicItems objectForKey:@"shipping_notes"] forKey:@"shipping_notes"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_phone"] forKey:@"shipping_phone"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_phoneextension"] forKey:@"shipping_phoneextension"];
            
            // [OrderHDR setValue:[dicItems objectForKey:@"shipping_trackingnumber"] forKey:@"trackingnumbers"];
            
            // [OrderHDR setValue:[dicItems objectForKey:@"shipping_fax"] forKey:@"shipping_fax"];
            // [OrderHDR setValue:[dicItems objectForKey:@"shipping_instructions"] forKey:@"shipping_instructions"];
            // [OrderHDR setValue:[dicItems objectForKey:@"shipping_licence"] forKey:@"shipping_licence"];
            
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_status"] forKey:@"status"];
            
            
            // Date Conversion Routine
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
            NSString *dateStringA = [dicItems objectForKey:@"datecreated"];
            NSDate *dateA = [dateFormatter dateFromString:dateStringA];
            [OrderHDR setValue:dateA forKey:@"datecreated"];
            
            
                // Get Matching Detailed Items And Insert
                for(int x=0;x<[arrayContainer2 count];x++)
                {
                    NSDictionary* dicItems2 = [arrayContainer2 objectAtIndex:x];
                    
                    // WRITE OUT COMPARATIVE VALUES...
                    NSString *TESTdw1 = [[dicItems objectForKey:@"orderId"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    NSString *TESTdw2 = [[dicItems2 objectForKey:@"Orderid"] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    
                    // NSLog(@"Comparison %@, %@", TESTdw1, TESTdw2);
                    
                    
                    if ([TESTdw1 isEqualToString: TESTdw2]) {
                    // PART 2. INSERT ORDER DETAILS IMMEDIATELY AFTER
                        NSLog(@"MATCH WAS FOUND");
                        
                    NSManagedObject *OrderDTL = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"OrderLineItem"
                                         inManagedObjectContext:context];
                        
                        // [OrderDTL setValue:[dicItems2 objectForKey:@"clientid"] forKey:@"clientid"];
                        [OrderDTL setValue:[dicItems2 objectForKey:@"Orderid"] forKey:@"orderid"];
                        [OrderDTL setValue:[dicItems2 objectForKey:@"ProductId"] forKey:@"productid"];
                        
                        [OrderDTL setValue:[dicItems2 objectForKey:@"Stored_Product_Name"] forKey:@"stored_product_name"];
                        [OrderDTL setValue:[dicItems2 objectForKey:@"Stored_Product_Description"] forKey:@"stored_product_description"];
                        [OrderDTL setValue:[dicItems2 objectForKey:@"Stored_Product_Code"]  forKey:@"stored_product_code"];

                        [OrderDTL setValue:[dicItems2 objectForKey:@"quantityordered"] forKey:@"quantityordered"];
                        [OrderDTL setValue:[NSDate date] forKey:@"datecreated"];
            
                        //PART 3. INSERT VALUE FOR RELATIONSHIP
                        [OrderDTL setValue:OrderHDR forKey:@"toOrderHeader"];
                    }
                }
            
            
            
            // [model setValue:[dicItems objectForKey:@"datecreated"] forKey:@"datecreated"];
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
            NSLog(@"%@", dictContainer2);
    }
    
        
        
        
        
        // TERRITORY POPULATION
        
        urlsvc = @"GetTerritoriesByUserId";
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                    baseurl,
                                    urlsvc,
                                    urluserid,
                                    urltoken,
                                    urluserid]];
        
        jsonData = [NSData dataWithContentsOfURL:url];
        
        if(jsonData != nil)	
        {
            NSError *error = nil;
            
            NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            
            NSArray* arrayContainer = [dictContainer objectForKey:@"GetTerritoriesByUserIdResult"];
            
            
            //Iterate TERRITORY
            for(int i=0;i<[arrayContainer count];i++)
            {
                NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
                
                // Create TERRITORY
                NSManagedObject *model = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"Territory"
                                          inManagedObjectContext:context];
                // [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
                [model setValue:[dicItems objectForKey:@"Name"] forKey:@"name"];
                [model setValue:[dicItems objectForKey:@"Id"] forKey:@"territory_id"];
                
                
                    // Get Detailed Items [FSA]
                
                    urlsvc = @"GetFSAByTerritoryId";
                    NSURL *urlFSA = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                            baseurl,
                                            urlsvc,
                                            urluserid,
                                            urltoken,
                                            [dicItems objectForKey:@"Id"]]];
	
                    NSData *jsonDataFSA = [NSData dataWithContentsOfURL:urlFSA];
                
                    // Dictionary of Detailed Items
                    NSDictionary* dictContainerFSA = [NSJSONSerialization JSONObjectWithData:jsonDataFSA options:kNilOptions error:&error];
                
                    // Container of Detailed Items
                    NSArray* arrayContainerFSA = [dictContainerFSA objectForKey:@"GetFSAByTerritoryIdResult"];
                
                    //Iterate FSA
                    for(int x=0;x<[arrayContainerFSA count];x++)
                    {
                        NSDictionary* dicItemsFSA = [arrayContainerFSA objectAtIndex:x];
                        	
                                NSManagedObject *modelfsa = [NSEntityDescription
                                                  insertNewObjectForEntityForName:@"TerritoryFSA"
                                                  inManagedObjectContext:context];
                                [modelfsa setValue:[dicItemsFSA objectForKey:@"Fsa"] forKey:@"fsa"];
                                [modelfsa setValue:[dicItemsFSA objectForKey:@"Territoryid"] forKey:@"territory_id"];
                        
                            //PART 3. INSERT VALUE FOR RELATIONSHIP
                            // [OrderDTL setValue:OrderHDR forKey:@"toOrderHeader"];
                    }
                
                
            }  //End of dictContainer For
            
            
            if (![context save:&error]) {
                    NSLog(@"Couldn't save: %@", [error localizedDescription]);
            }
            
            if (error == nil) {
                    NSLog(@"%@", dictContainer);
            }
    }
        
        
        
        
    
        
        
    }  // end populate of others

}










- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	NSLog(@"%@ object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}


@end