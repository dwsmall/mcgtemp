//
//  SyncViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "Order.h"
#import "OrderLineItem.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "Hcp+Extensions.h"
#import "AppDelegate.h"


#import "SyncViewController_iPad.h"



Reachability *internetReachableFoo;

@interface SyncViewController_iPad ()

@property (strong, nonatomic) IBOutlet UITableView *syncTableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLoadHCPs;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnReloadData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSync;

@property(nonatomic) NSInteger noHcpFound;
@property(nonatomic) NSInteger noAllocationFound;

@property (nonatomic) NSString *urlsvc;
@property (nonatomic) NSString *baseurl;
@property (nonatomic) NSString *urluserid;
@property (nonatomic) NSString *urltoken;
@property (nonatomic) NSURL *url;



- (IBAction)btnLoadHCPsClick:(id)sender;
- (IBAction)btnReloadDataClick:(id)sender;
- (IBAction)btnSyncClick:(id)sender;

@end



@implementation SyncViewController_iPad

@synthesize noHcpFound, noAllocationFound;
@synthesize orderValue_Dict;
@synthesize orderValueExt_Dict;

@synthesize urlsvc, baseurl, urluserid, urltoken, url;



#pragma mark - ViewDelegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *internetFound = @"";
    
    // check internet status
    // Show No Network Message If Internet is Not Connected...
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    if (internetStatus == NotReachable){
        
        internetFound = @"NO";
        
        
    } else {
        // NSLog(@"Internet connection is OK");
        
        internetFound = @"YES";
    }
    
    
    //Get Last Sync Date (if exists)
    __hcp_stamp.text = @"N/A";
    __data_stamp.text = @"N/A";
    
    
    // initial user ?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *allocid = [defaults objectForKey:@"MCG_allocationid"];
    
    if (allocid.length == 0) {
        
        // first time msg
        if ([internetFound isEqualToString:@"NO"]) {
            UIAlertView *errorAlertView = [[UIAlertView alloc]
                                           initWithTitle:@"Initial Load Requires An Internet Connection"
                                           message:@"Internet connection is required to load data"
                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            errorAlertView.tag = 300;
            [errorAlertView show];
            
        } else {
            
            UIAlertView *errorAlertView = [[UIAlertView alloc]
                                           initWithTitle:@"Please Load Data To Enable Features"
                                           message:@"Initial Setup Requies Loading of Data"
                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            errorAlertView.tag = 400;
            [errorAlertView show];
            
        }
        
    } else {
        
        
        // not first time no internet
        if ([internetFound isEqualToString:@"NO"]) {
            UIAlertView *errorAlertView = [[UIAlertView alloc]
                                           initWithTitle:@"Syncing of Data Requires An Internet Connection"
                                           message:@"Internet connection is required to load data"
                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [errorAlertView show];
        }
        
    }
        
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // not used (was to allow/disallow based on data loaded)
    
    if (alertView.tag == 400 || alertView.tag == 300) {
        
        for (UIViewController *viewController in self.tabBarController.viewControllers) {
            
            if (viewController.tabBarItem.tag != 0) {
                [viewController.tabBarItem setEnabled:NO];
            } else {
                [viewController.tabBarItem setEnabled:YES];
            }
        }
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - SyncOrders Actions

- (IBAction)btnSyncClick:(id)sender {

    // Messaging for Syncing of Data...
    NSString *donotsyncFLAG = @"FALSE";
    
    
    // Check if Online
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    if (internetStatus == NotReachable){
        
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"No internet connection"
                                       message:@"Internet connection is required to sync orders"
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [errorAlertView show];
        
        donotsyncFLAG = @"TRUE";
        
    }
    
    
    
    // Check if Any Records Exist to Be Synced
    if ([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] > 0) {
        
        donotsyncFLAG = @"FALSE";
        
    } else {
        
        /*
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"No Orders To Sync"
                                       message:@"You Have No Orders To Sync At This Time"
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [errorAlertView show];
        */
        
        
        // if online get orders (hey why not?)
        
        if (internetStatus != NotReachable) {
            
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.delegate = self;
            HUD.labelText = @"Connecting";
            HUD.minSize = CGSizeMake(135.f, 135.f);
            
            [HUD showWhileExecuting:@selector(syncOrdersfromSC) onTarget:self withObject:nil animated:YES];
            
        }
        
        donotsyncFLAG = @"TRUE";
        
    }
    
    
    if ([donotsyncFLAG isEqualToString:@"FALSE"] && internetStatus != NotReachable) {
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
	
        HUD.delegate = self;
        HUD.labelText = @"Connecting";
        HUD.minSize = CGSizeMake(135.f, 135.f);
	
        [HUD showWhileExecuting:@selector(sendOrderstoSC) onTarget:self withObject:nil animated:YES];
    }
}







#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return [[self.fetchedResultsController sections] count];
    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    Order *ord = [[self.fetchedResultsController fetchedObjects] objectAtIndex:section];
    
    int TOTROWS;
    TOTROWS = (2 + [ord.toOrderDetails.allObjects count]);
    
    return TOTROWS;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Order *ord = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.section];
    
    NSString *varCellType = @"_orderListDTL";
    
    if (indexPath.row == 0) {
        varCellType = @"_orderListHDR";
    }
    
    // Summary Should Be Equivalent of Total Row Count
    if (indexPath.row == ([ord.toOrderDetails.allObjects count] + 1)) {
        varCellType = @"_orderListSUM";
    }
    
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:varCellType forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Order *order =[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    
    
    // header row
    
    if (indexPath.row == 0) {
        
        // Date [Reference] Formating...
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];

        
        // date
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[order valueForKey:@"datecreated"]]];
        
        // hcp name
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
                                     [[[order valueForKey:@"shipping_firstname"] description] uppercaseString],
                                     [[[order valueForKey:@"shipping_lastname"] description] uppercaseString]];
        
    }
    
    
    
    if (indexPath.row != 0 && indexPath.row != ([order.toOrderDetails.allObjects count] + 1) ) {
        
        // ** SHOULD LOOP TO FIND VALUE AT INDEX (OR STRAIGHT PROPAGATE...)
        
        NSArray *oRecords = [[order valueForKey:@"toOrderDetails"] allObjects];
     
        if ([oRecords count] > 0) {
            
            int total_rcds = 0;
            total_rcds = [oRecords count];
            for (int i = 0; i < total_rcds; i++)
            {
                
                if ((indexPath.row-1) == i) {
                    
                    // product with qty
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ [%@]",
                                           [[oRecords objectAtIndex:i] valueForKey:@"stored_product_name"],
                                           [[[oRecords objectAtIndex:i] valueForKey:@"quantityordered"] stringValue]];
                }
            }
        }
        
    } // eo.if
    
    
    if (indexPath.row == ([order.toOrderDetails.allObjects count] + 1)) {
        
        // days outstanding        
        NSDate *startDate = [NSDate date];
        NSDateFormatter *dayFormater = [[NSDateFormatter alloc]init];
        [dayFormater setDateFormat:@"dd"];
        
        int startDateDay = [[dayFormater stringFromDate:startDate]intValue];
        int endDateDay = [[dayFormater stringFromDate:[order valueForKey:@"datecreated"]]intValue];
        
        
        if ([[order valueForKey:@"projectcode"] isEqualToString:@"REJECTED"]) {
            
            cell.textLabel.text = @"Rejected";
            
        } else {
            cell.textLabel.text = [order valueForKey:@"status"];
        }
        
        cell.textLabel.textColor = [UIColor blueColor];
                
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@", abs(startDateDay - endDateDay) ,@"DAYS OUTSTANDING"];
        cell.detailTextLabel.textColor = [UIColor redColor];
        
    }

}







#pragma mark - FetchedResults Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Delete Cache
    [NSFetchedResultsController deleteCacheWithName:@"syncOrders"];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
   
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSArray *list =
    [NSArray arrayWithObjects:
     @"OFFLINE",
     @"REJECTED", nil];
    
    // Add Predicate for Just UNSENT orders
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectcode IN %@", list];
    [fetchRequest setPredicate:predicate];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:100];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reference" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"syncOrders"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}




- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // [self.tableView beginUpdates];
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    UITableView *tableView = self.syncTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    
    UITableView *tableView = self.syncTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            // [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
    [self.syncTableView reloadData];
}



#pragma mark - GetData Action

- (IBAction)btnReloadDataClick:(id)sender {
    
    // Check Internet
    
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    if (internetStatus == NotReachable){
        
        NSLog(@"There's no connection");
        
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:NSLocalizedString(@"Connection Required",@"titleKey")
                                       message:NSLocalizedString(@"Internet connection is required to sync data!",@"messageKey")
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
        
    } else {
        
        
        // internet ok, process...
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            // Do something...
            [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"others" waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(PopulateEntities:) withObject:@"others" waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:nil waitUntilDone:YES];
            
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        
                
        // Update TimeStamp for Data
        
        NSDate *currentDateNTime = [NSDate date];
        NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
        // [dateformater setDateFormat:@"yyyyMMdd,HH:mm"];
        [dateformater setDateFormat:@"MMM dd, yyyy HH:mm"];
        
        __data_stamp.text = [dateformater stringFromDate: currentDateNTime];
        
        
        // Get Tokenized_Credentials
        
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        
        
        // Update Tokenized_Credential
        
        if ([items count] == 1) {
            
            NSError *error = nil;
            
            //Set up to get the thing you want to update
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
            [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
            
            //Ask for it
            NSArray *savechange = [[context executeFetchRequest:request error:&error] lastObject];
            
            if (error) {
                //Handle any errors
            }
            
            if (!savechange) {
                //Nothing there to update
            }
            
            //Update the object
            [savechange setValue:[NSDate date] forKey:@"last_data_sync_date"];
            
            //Save it
            error = nil;
            if (![context save:&error]) {
                //Handle any error with the saving of the context
            }
            
        }
        
        
        
        
        
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
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"hcp" waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(PopulateEntities:) withObject:@"hcp" waitUntilDone:YES];
            
            
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:nil waitUntilDone:YES];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
                
        
        // Update TimeStamp for HCP
        NSDate *currentDateNTime = [NSDate date];
        NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
        [dateformater setDateFormat:@"yyyyMMdd,HH:mm"];
        // NSString *str = [dateformater stringFromDate: currentDateNTime];
        __hcp_stamp.text = [dateformater stringFromDate: currentDateNTime];
        
        
        // Get Tokenized_Credentials
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        
        
        // Update Tokenized_Credential
        if ([items count] == 1) {
            
            NSError *error = nil;
            
            //Set up to get the thing you want to update
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
            [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
            
            //Ask for it
            NSArray *savechange = [[context executeFetchRequest:request error:&error] lastObject];
            
            if (error) {
                //Handle any errors
            }
            
            if (!savechange) {
                //Nothing there to update
            }
            
            //Update the object
            [savechange setValue:[NSDate date] forKey:@"last_hcp_sync_date"];
            
            //Save it
            error = nil;
            if (![context save:&error]) {
                //Handle any error with the saving of the context
            }
            
        } // if                                    
        
        
        
      
    }
    
}
    
    
#pragma mark - Process Data

- (void) RemoveEntities:(NSString *) removalType {
    
    
    // NSLog(@"Entity A Removal Called %@", removalType);
    
    NSArray *deletionEntity;
    
    NSString *delete_hcp = @"hcp";
    NSString *delete_others = @"others";
    NSString *delete_orders = @"ordersfull";
    
    
    if ([removalType isEqual: delete_hcp])  {
        deletionEntity = @[@"HealthCareProfessional"];
    }
    
    if ([removalType isEqual: delete_others]) {
        deletionEntity = @[@"ClientInfo",@"Order",@"Product",@"Allocation",@"AllocationHeader",@"TerritoryFSA",@"Territory",@"Rep"];
       
    }
    
    if ([removalType isEqual: delete_orders])  {
        deletionEntity = @[@"Order"];
    }
    
    // Define Delegate Context
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];    

    
    for(int i=0;i<[deletionEntity count];i++)
    {
        
        NSLog(@"dw1 - I am about to delete %@" , [deletionEntity objectAtIndex:i]);
    
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:[deletionEntity objectAtIndex:i] inManagedObjectContext:context];
        [fetchRequest setEntity:entity];        
        
        // add predicate for Delete Others [Replace All Function]
        
        if ([[deletionEntity objectAtIndex:i] isEqualToString:@"Order" ] && [removalType isEqual: delete_others]) {
      
            NSPredicate *pred = nil;
            pred = [NSPredicate predicateWithFormat:@"projectcode = nil OR projectcode = %@", @"TEMP"];  // or pred = TEMP
            
            [fetchRequest setPredicate:pred];
            
        }
        
        
        // predicate for Removal of Orders Through Sync
        
        if ([[deletionEntity objectAtIndex:i] isEqualToString:@"Order" ] && [removalType isEqual: delete_orders]) {
            
            NSPredicate *pred = nil;
            pred = [NSPredicate predicateWithFormat:@"projectcode = nil OR projectcode = %@ OR projectcode = %@", @"TEMP", @"OFFLINE"];  // or pred = TEMP
            
            [fetchRequest setPredicate:pred];
            
        }
         
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        
        for (NSManagedObject *managedObject in items) {
            [_managedObjectContext deleteObject:managedObject];
            // NSLog(@"%@ object deleted",[deletionEntity objectAtIndex:i]);
        }
        
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error deleting %@ - error:%@",[deletionEntity objectAtIndex:i],error);
        }
    
        
    }// End Each
    
}





- (void) PopulateEntities:(NSString *) populationType {
    

    //Entities Should Be Defined By Stuff Being Sent (May Need To Exclude Certain Objects)
    
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    // NSManagedObjectContext *context = [self managedObjectContext];
    
     
    // NSError *error;
    
    /*
    //Get User ID AND Token
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
    NSArray *currentitems = [[context executeFetchRequest:request error:&error] lastObject];
    
    NSString *comp_userid = [[[currentitems valueForKey:@"user_id"] description] lowercaseString];
    NSString *comp_token = [[[currentitems valueForKey:@"token"] description] lowercaseString];
    */
    
    
    //Prep Values
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    baseurl = app.globalBaseUrl;
    urluserid = app.globalUserID;
    urltoken = app.globalToken;
    url = [NSURL URLWithString:@""];
    
    urlsvc = @"TBD";
    
    
    //Population Options
    NSString *populate_hcp = @"hcp";
    NSString *populate_others = @"others";
    NSString *populate_orders = @"ordersfull";
    

    
#pragma mark populate hcp
    
    if ([populationType isEqual: populate_hcp])  {
        
        // getHcpData
        [self performSelectorOnMainThread:@selector(getHcpData) withObject:nil waitUntilDone:YES];
        // [self performSelectorInBackground:@selector(getHcpData) withObject:nil];
        
        
    }
    
    

#pragma mark populate others
    

    if ([populationType isEqual: populate_others])  {
  
        // getAllocation Order Data
        [self performSelectorOnMainThread:@selector(getOrderData) withObject:nil waitUntilDone:YES];

        // getClientData
        [self performSelectorOnMainThread:@selector(getClientData) withObject:nil waitUntilDone:YES];
        
        // getProductData
        [self performSelectorOnMainThread:@selector(getProductData) withObject:nil waitUntilDone:YES];
        
        // getAllocation Header Data
        [self performSelectorOnMainThread:@selector(getAllocationHdrData) withObject:nil waitUntilDone:YES];
        
        // getAllocation Detail Data
        [self performSelectorOnMainThread:@selector(getAllocationDetailData) withObject:nil waitUntilDone:YES];
        
        // getAllocation Rep Data
        [self performSelectorOnMainThread:@selector(getRepData) withObject:nil waitUntilDone:YES];
        
        // getAllocation Territory Data
        [self performSelectorOnMainThread:@selector(getTerritoryData) withObject:nil waitUntilDone:YES];
        
        
}  // end populate of others
    
    
    
    
    
#pragma mark FOR REVIEW
    
    if ([populationType isEqual: populate_orders])  {
        
        // getAllocation Order Data
        [self performSelectorOnMainThread:@selector(getOrderData) withObject:nil waitUntilDone:YES];
        
    }
    
    
    
    

}


#pragma mark - DataLoader Routines
-(void) getHcpData {
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // HCP
    urlsvc = @"GetActiveHcpsInARepsReach";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    
    NSLog(@"Show BASE TOKENS %@ %@ %@ %@ %@", url, baseurl, urlsvc, urluserid, urltoken);
    
    
    NSLog(@"Show HCP SVC %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetActiveHcpsInARepsReachResult"];
        
        
        // msg user if no hcp found
        noHcpFound = 0;
        
        if ([arrayContainer count] == 0) {
            noHcpFound = 1;
        };
        
        
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
            
            [model setValue:[dicItems objectForKey:@"Id"] forKey:@"shiptoaddressid"];
            
            
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
            
            
            NSString *hfacility = [dicItems objectForKey:@"FacilityName"];
            if (hfacility.length < 2) {
                [model setValue:@" " forKey:@"facility"];
            } else {
                [model setValue:[dicItems objectForKey:@"FacilityName"] forKey:@"facility"];
            }
            
            
            [model setValue:[dicItems objectForKey:@"Deparment"] forKey:@"department"];
            
            
            NSString *haddress1 = [dicItems objectForKey:@"AddressLine1"];
            if (haddress1.length < 2) {
                [model setValue:@" " forKey:@"address1"];
            } else {
                [model setValue:[dicItems objectForKey:@"AddressLine1"] forKey:@"address1"];
            }
            
            
            NSString *haddress2 = [dicItems objectForKey:@"AddressLine2"];
            if (haddress2.length < 2) {
                [model setValue:@" " forKey:@"address2"];
            } else {
                [model setValue:[dicItems objectForKey:@"AddressLine2"] forKey:@"address2"];
            }
            
            
            NSString *haddress3 = [dicItems objectForKey:@"AddressLine3"];
            if (haddress3.length < 2) {
                [model setValue:@" " forKey:@"address3"];
            } else {
                [model setValue:[dicItems objectForKey:@"AddressLine3"] forKey:@"address3"];
            }
            
            [model setValue:[dicItems objectForKey:@"Email"] forKey:@"email"];
            [model setValue:[dicItems objectForKey:@"City"] forKey:@"city"];
            [model setValue:[dicItems objectForKey:@"Province"] forKey:@"province"];
            [model setValue:[dicItems objectForKey:@"PostalCode"] forKey:@"postal"];
            
            [model setValue:[dicItems objectForKey:@"Title"] forKey:@"title"];
            [model setValue:[dicItems objectForKey:@"Language"] forKey:@"language"];
            [model setValue:[dicItems objectForKey:@"Gender"] forKey:@"gender"];
            [model setValue:[dicItems objectForKey:@"Fax"] forKey:@"fax"];
            
            [model setValue:[dicItems objectForKey:@"PHLID"] forKey:@"id"];
            
            [model setValue:[dicItems objectForKey:@"Id"] forKey:@"identitymanagerid"];
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        
    }


}


-(void) getClientData {

    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    urlsvc = @"GetClientByName";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                @"Merck"]];
    
    NSLog(@"dw1 - show url: %@", url);
    
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        // NSArray* arrayContainer = [dictContainer objectForKey:@"GetClientByNameResult"];
        
        // NSDictionary* dicItems = [arrayContainer objectAtIndex:0];
        
        NSDictionary* dicItems = [dictContainer objectForKey:@"GetClientByNameResult"];
        
        
        NSManagedObject *model = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"ClientInfo"
                                  inManagedObjectContext:context];
        
        [model setValue:[dicItems objectForKey:@"Id"] forKey:@"clientid"];
        [model setValue:[dicItems objectForKey:@"Name"]  forKey:@"displayname"];
        [model setValue:[[dicItems objectForKey:@"Options_OrderType_AllowsBackOrder"] description] forKey:@"opt_ordertype_allowsbackorder"];
        
        
        
        // upate BO OPTIONS in user_credentials
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
        
        //Ask for it
        NSArray *savechange = [[context executeFetchRequest:request error:&error] lastObject];
        
        if (error) {
            //Handle any errors
        }
        
        if (!savechange) {
            //Nothing there to update
        }
        
        //Update the object
        [savechange setValue:[[dicItems objectForKey:@"Options_OrderType_AllowsBackOrder"] description] forKey:@"allow_backorder"];
        // [savechange setValue:[dictRow objectForKey:@"Id"] forKey:@"multiple_carrier"];
        
        //Save it
        error = nil;
        if (![context save:&error]) {
            //Handle any error with the saving of the context
        }
        
        
        // update user credentials
        AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        app.globalClientOptionBO = [[dicItems objectForKey:@"Options_OrderType_AllowsBackOrder"] description];
        
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
    }


}


-(void)getProductData {

    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];    
    
    urlsvc = @"GetProductByUserId";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
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
            [model setValue:[dicItems objectForKey:@"Id"]  forKey:@"id"];
            
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        // if (error == nil)
        // NSLog(@"%@", dictContainer);
    }


}


-(void) getAllocationHdrData {

    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    urlsvc = @"GetAllocationByRepId";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    NSLog(@"url: %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        
        
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        // segment results to 2nd dictionary
        NSDictionary* dictRow = [dictContainer objectForKey:@"GetAllocationByRepIdResult"];
        
        NSManagedObject *model = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"AllocationHeader"
                                  inManagedObjectContext:context];
        [model setValue:[dictRow objectForKey:@"Id"] forKey:@"id"];
        [model setValue:[dictRow objectForKey:@"ClientId"] forKey:@"clientid"];
        [model setValue:[dictRow objectForKey:@"Name"] forKey:@"name"];
        [model setValue:[dictRow objectForKey:@"Description"] forKey:@"allocdescription"];
        
        // Date Conversion Routine
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
        NSString *dateStringA = [dictRow objectForKey:@"DateStart"];
        NSString *dateStringB = [dictRow objectForKey:@"DateEnd"];
        
        NSDate *dateA = [dateFormatter dateFromString:dateStringA];
        NSDate *dateB = [dateFormatter dateFromString:dateStringB];
        
        [model setValue:dateA forKey:@"datestart"];
        [model setValue:dateB forKey:@"dateend"];
        [model setValue:[dictRow objectForKey:@"Inactive"]  forKey:@"inactive"];
        [model setValue:[dictRow objectForKey:@"Year"]  forKey:@"year"];
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        
        // upate allocation headerid in user_credentials
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
        
        //Ask for it
        NSArray *savechange = [[context executeFetchRequest:request error:&error] lastObject];
        
        if (error) {
            //Handle any errors
        }
        
        if (!savechange) {
            //Nothing there to update
        }
        
        //Update the object
        [savechange setValue:[dictRow objectForKey:@"Id"] forKey:@"allocationid"];
        
        //Save it
        error = nil;
        if (![context save:&error]) {
            //Handle any error with the saving of the context
        }
        
        
        // update user credentials
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[dictRow objectForKey:@"Id"] forKey:@"MCG_allocationid"];
        
        // update user credentials
        AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        app.globalAllocationId = [dictRow objectForKey:@"Id"];
        
    }


}


-(void) getAllocationDetailData {
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    urlsvc = @"GetAllocationByRepId";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    NSLog(@"url: %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        
        // step.1 - serialize object to data
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        // step.2 - Determine How Many Territories in Object
        int numofterr = [[[[dictContainer objectForKey:@"GetAllocationByRepIdResult"] objectForKey:@"Territories"] objectAtIndex:0] count];
        
        NSLog(@"how many territories please ?? :%d" , numofterr);
        numofterr = 1;
        
        // step.3 iterate over territories to get data
        for(int i=0;i<numofterr;i++)
        {
            
            // convert to dictionary
            NSDictionary* dicTERR = [[[dictContainer objectForKey:@"GetAllocationByRepIdResult"] objectForKey:@"Territories"] objectAtIndex:i];
            
            // gather visible products
            NSMutableArray *arrayProductID = [[NSMutableArray alloc] init];
            
            for (int a=0;a<[[dicTERR objectForKey:@"AvailableOrderItems"] count];a++) {
                NSDictionary* dicPROD = [[dicTERR objectForKey:@"AvailableOrderItems"] objectAtIndex:a];
                [arrayProductID addObject:[dicPROD objectForKey:@"ProductId"]];
            }
            
            
            // msg user if no territories exist
            noAllocationFound = 0;
            
            if ([[dicTERR objectForKey:@"Allocations"] count] == 0) {
                noAllocationFound = 1;
            };
            
            
            // only add visible products
            for(int i=0;i<[[dicTERR objectForKey:@"Allocations"] count];i++)
            {
                NSDictionary* dicALLOC = [[dicTERR objectForKey:@"Allocations"] objectAtIndex:i];
                
                if ( [arrayProductID containsObject:[dicALLOC objectForKey:@"ProductId"]] ) {
                    
                    NSManagedObject *model = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"Allocation"
                                              inManagedObjectContext:context];
                    
                    [model setValue:[dicALLOC objectForKey:@"TerritoryId"] forKey:@"territoryid"];
                    [model setValue:[dicALLOC objectForKey:@"EntityName"] forKey:@"territoryname"];
                    [model setValue:[dicALLOC objectForKey:@"ProductId"] forKey:@"productid"];
                    [model setValue:[dicALLOC objectForKey:@"ProductName"] forKey:@"productname"];
                    [model setValue:[dicALLOC objectForKey:@"ProductDescription"] forKey:@"productdescription"];
                    
                    // double c_ordermax = [[dicALLOC objectForKey:@"Max"] doubleValue];
                    // double c_totalmax = [[dicALLOC objectForKey:@"AvailableAllocation"] doubleValue];
                    
                    
                    /*
                    if (c_ordermax < 0) {
                        [model setValue:0 forKey:@"ordermax"];
                    } else {
                        [model setValue:[dicALLOC objectForKey:@"OrderMax"] forKey:@"ordermax"];
                    }
                    
                    if (c_totalmax < 0) {
                        [model setValue:0 forKey:@"totalmax"];
                        [model setValue:0 forKey:@"avail_allocation"];
                    } else {
                        [model setValue:[dicALLOC objectForKey:@"AvailableAllocation"] forKey:@"totalmax"];
                        [model setValue:[dicALLOC objectForKey:@"AvailableAllocation"] forKey:@"avail_allocation"];
                    }
                    
                    */
                    
                    
                    
                    // computed values
                    
                    [model setValue:[dicALLOC objectForKey:@"Max"] forKey:@"max_computed"];
                    [model setValue:[dicALLOC objectForKey:@"AvailableAllocation"] forKey:@"avail_allocation"];
                    [model setValue:[dicALLOC objectForKey:@"AvailableInventory"] forKey:@"avail_inventory"];
                    [model setValue:[dicALLOC objectForKey:@"OrderMax"] forKey:@"ordermax"];
                    
                    // [model setValue:[dicALLOC objectForKey:@"HasAvailableInventory"]forKey:@"hasavailableinventory"];
                    
                    
                    if (![context save:&error]) {
                        NSLog(@"Couldn't save: %@", [error localizedDescription]);
                    }
                    
                }
                
            }
            
            
            
        }
        
    }  // End of Allocation



}




-(void) getRepData {
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    urlsvc = @"GetUserById";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    NSLog(@"url: %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetUserByIdResult"];
        
        // NSLog(@"array count %d",[arrayContainer count]);
        
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
                
            }
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
    }

}



-(void) getOrderData {
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    urlsvc = @"GetOrdersByRepId";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];

    NSData *jsonData = [NSData dataWithContentsOfURL:url];

    NSLog(@"url: %@", url);    

    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetOrdersByRepIdResult"];
        
        
        NSLog(@"dw1 - how many loaded:%d", [arrayContainer count]);
        
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *OrderHDR = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"Order"
                                         inManagedObjectContext:context];
            
            [OrderHDR setValue:[dicItems objectForKey:@"orderId"] forKey:@"orderid"];
            
            
            [OrderHDR setValue:[NSString stringWithFormat:@"%@",[dicItems objectForKey:@"reference"]] forKey:@"reference"];
            
            [OrderHDR setValue:[dicItems objectForKey:@"refprefix"] forKey:@"refprefix"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_facilityname"] forKey:@"shipping_facilityname"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_firstname"] forKey:@"shipping_firstname"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_lastname"] forKey:@"shipping_lastname"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_line1"] forKey:@"shipping_addressline1"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_line2"] forKey:@"shipping_addressline2"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_line3"] forKey:@"shipping_addressline3"];
            
            
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_postalcode"] forKey:@"shipping_postalcode"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_city"] forKey:@"shipping_city"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_provinces"] forKey:@"shipping_province"];
            
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_phone"] forKey:@"shipping_phone"];
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_phoneextension"] forKey:@"shipping_phoneextension"];
            
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_trackingnumber"] forKey:@"trackingnumbers"];
            [OrderHDR setValue:[dicItems objectForKey:@"FormNumber"] forKey:@"formnumber"];
            
            [OrderHDR setValue:[dicItems objectForKey:@"status"] forKey:@"status"];
            
            [OrderHDR setValue:[dicItems objectForKey:@"shipping_signature64"] forKey:@"signature"];
            
            
            // Date Conversion Routine
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSLog(@"dw1 - conv_date:%@", [dicItems objectForKey:@"datecreated"]);
            NSString *myDateToConvert = [dicItems objectForKey:@"datecreated"];
            NSDate *myDate = [dateFormatter dateFromString:myDateToConvert];
            
            NSLog(@"dw1 - populate_date:%@", myDate);
            
            [OrderHDR setValue:myDate forKey:@"datecreated"];
            
            
            // Iteration of Order Details
            NSArray* arrayContainer2 = [dicItems objectForKey:@"orderLineItems"];
            
            // NSLog(@"PXX %@", arrayContainer2);
            
            // Get Matching Detailed Items And Insert
            for(int x=0;x<[arrayContainer2 count];x++)
            {
                
                NSDictionary* dicItems2 = [arrayContainer2 objectAtIndex:x];
                
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
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
    }

}


-(void) getTerritoryData {

    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    urlsvc = @"GetTerritoriesByUserId";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    NSLog(@"url: %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
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
                [modelfsa setValue:[dicItemsFSA objectForKey:@"FSA"] forKey:@"fsa"];
                [modelfsa setValue:[dicItemsFSA objectForKey:@"TerritoryId"] forKey:@"territory_id"];
                
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
}




#pragma mark - Utillities


+ (NSInteger)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    NSInteger daysBetween = abs([components day]);
    return daysBetween+1;
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

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(3);
}


- (void)sendOrderstoSC {
    
	// Indeterminate mode
	sleep(1);
    
    // int iSection = 0;
    
    // Loop Through Fetched Results and Create XML Records
    for (Order *obj in self.fetchedResultsController.fetchedObjects) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
        // Create XML Header
        orderValue_Dict = @{   @"UserId" : [defaults objectForKey:@"MCG_userid"],
                                @"Token" : @"0bb9fdad-ddd9-4cea-861b-073bb6d1a590",
                                @"OwnerId" : [defaults objectForKey:@"MCG_userid"],
                                @"ShipToId" : [self stringOrEmptyString:[[obj valueForKey:@"shiptoid"] description]],
                                @"TerritoryId" : [self stringOrEmptyString:[[obj valueForKey:@"territoryid"] description]],
                                @"AllocationId" : [self stringOrEmptyString:[[obj valueForKey:@"allocationid"] description]],
                                @"CreatorId" : [defaults objectForKey:@"MCG_userid"],
                                @"ClientId" : [self stringOrEmptyString:[[obj valueForKey:@"clientid"] description]],
                                @"ShippingAddressId" : [self stringOrEmptyString:[[obj valueForKey:@"shiptoid"] description]],
                                @"ApplicationSource" : @"MobileSampleCupboard",
                                @"DateEntered" : @"2013-07-10T00:00:00",
                                @"DateCreated" : @"2013-07-10T00:00:00",
                                @"DateModified" : @"2013-07-10T00:00:00",
                                @"Shipping_FacilityName" : [self stringOrEmptyString:[[obj valueForKey:@"shipping_facilityname"] description]],
                                @"ShippingFirstName" : [self stringOrEmptyString:[[obj valueForKey:@"shipping_firstname"] description]],
                                @"ShippingLastName" : [self stringOrEmptyString:[[obj valueForKey:@"shipping_lastname"] description]],
                                @"Shipping_AddressLine1" : [self stringOrEmptyString:[[obj valueForKey:@"shipping_addressline1"] description]],
                                @"Shipping_AddressLine2" : [self stringOrEmptyString:[[obj valueForKey:@"shipping_addressline2"] description]],
                                @"Shipping_AddressLine3" :[self stringOrEmptyString:[[obj valueForKey:@"shipping_addressline3"] description]],
                                @"Shipping_City" : [self stringOrEmptyString:[[obj valueForKey:@"shipping_city"] description]],
                                @"Shipping_PostalCode" : [self stringOrEmptyString:[[obj valueForKey:@"shipping_postalcode"] description]]
                                };
        
        
            // Build xml
            NSMutableString *order_xml = [[NSMutableString alloc] initWithString:@""];
            [order_xml appendString:@"<?xml version=\"1.0\"?>\n<NewMobileOrderModel xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n"];
        
            // Convert Dictionary Values
            NSArray *arr = [orderValue_Dict allKeys];
        
            // Conversion Routine
            for(int i=0;i<[arr count];i++)
            {
                id nodeValue = [orderValue_Dict objectForKey:[arr objectAtIndex:i]];
                
                if([nodeValue isKindOfClass:[NSArray class]] )
                {
                    if([nodeValue count]>0){
                        for(int j=0;j<[nodeValue count];j++)
                        {
                            id value = [nodeValue objectAtIndex:j];
                            if([ value isKindOfClass:[NSDictionary class]])
                            {
                                [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                                [order_xml appendString:[NSString stringWithFormat:@"%@",[value objectForKey:@"text"]]];
                                [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
                            }
                        }
                    }
                }
                else if([nodeValue isKindOfClass:[NSDictionary class]])
                {
                    [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                    if([[nodeValue objectForKey:@"Id"] isKindOfClass:[NSString class]])
                        [order_xml appendString:[NSString stringWithFormat:@"%@",[nodeValue objectForKey:@"Id"]]];
                    else
                        [order_xml appendString:[NSString stringWithFormat:@"%@",[[nodeValue objectForKey:@"Id"] objectForKey:@"text"]]];
                    [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
                }
                
                else
                {
                    if([nodeValue length]>0){
                        [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                        [order_xml appendString:[NSString stringWithFormat:@"%@",[orderValue_Dict objectForKey:[arr objectAtIndex:i]]]];
                        [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
                    }
                }
            }
        
        
            // OrderLine Details
            [order_xml appendString:[NSString stringWithFormat:@"<IsDraft xsi:nil=\"%@\" />\n", @"true"]];
            [order_xml appendString:[NSString stringWithFormat:@"<DateSigned xsi:nil=\"%@\" />\n", @"true"]];
            
            [order_xml appendString:[NSString stringWithFormat:@"<OrderLineItems>\n"]];
        
        
            // build detail file
            /*
            NSSet *orderDetails = [obj.toOrderDetails valueForKeyPath:@"productid"];
            NSArray *orderDetailsItem = [orderDetails allObjects];
            
            NSSet *orderDetails2 = [obj.toOrderDetails valueForKeyPath:@"quantityordered"];
            NSArray *orderDetailsQTY = [orderDetails2 allObjects];
            */
        
            int totdtl = [obj.toOrderDetails.allObjects count];
        
            for(int i = 0; i < totdtl; i++) {
                
                [order_xml appendString:[NSString stringWithFormat:@"<NewMobileOrderLineItem>\n<ProductId>%@</ProductId>\n<QuantityOrdered>%@</QuantityOrdered>\n</NewMobileOrderLineItem>\n",
                                         [[obj.toOrderDetails.allObjects valueForKeyPath:@"productid"] objectAtIndex:i],
                                         [[obj.toOrderDetails.allObjects valueForKeyPath:@"quantityordered"] objectAtIndex:i] ]];
            }
        
            [order_xml appendString:[NSString stringWithFormat:@"</OrderLineItems>\n"]];
        
            // Header End
            [order_xml appendString:[NSString stringWithFormat:@"</NewMobileOrderModel>\n"]];
        
        
            // Should Replace Contradicting XML Characters
            // NSString *order_xml=[order_xml stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
        
            NSLog(@"xmlData: %@", order_xml);
        
        
            //Post XML to SC
            NSData *data = [order_xml dataUsingEncoding:NSUTF8StringEncoding];
            
            url = [NSURL URLWithString:@"http://dev.samplecupboard.com/Data/MobileServices.svc/CreateOrder"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:data];
            
            // NSURLResponse *response;
            // NSError *err;
            // NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            // NSString *order_response_msg = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
    };
 
    
    
    
	// Switch to determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"Sending Data";
	float progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		HUD.progress = progress;
		usleep(10000);
	}
    
	// Back to indeterminate mode
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Updating Status";
    
    // replacement of Orders in Core-Data With Orders From The System...
    
        // Delete Data HCP
        [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"ordersfull" waitUntilDone:YES];
        
        // Populate Data For "others"
        [self performSelectorOnMainThread:@selector(PopulateEntities:) withObject:@"ordersfull" waitUntilDone:YES];
    
    
     // remove badge (all synced)
    [self updateSyncBadge];
    
    

    // update Sync Button

	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
	sleep(1);
    
    
    
    
    
}


-(void) syncOrdersfromSC {

    
    // Switch to determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Syncing Orders";
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(10000);
    }
    
    // Back to indeterminate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Updating Status";
    
    // replacement of Orders in Core-Data With Orders From The System...
    
    // Delete Data HCP
    [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"ordersfull" waitUntilDone:YES];
    
    // Populate Data For "others"
    [self performSelectorOnMainThread:@selector(PopulateEntities:) withObject:@"ordersfull" waitUntilDone:YES];
    
    
    // remove badge (all synced)
    [self updateSyncBadge];
    
    // update Sync Button
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"Completed";
    sleep(1);


}


- (NSString *)stringOrEmptyString:(NSString *)string
{
    
    if (string == nil || [string isKindOfClass:[NSNull class]] ) {
        return @"";
    } else {
        return string;
    }
    
}





- (void)showAlert:(NSString *)string {

    NSString *msgText = nil;
    
    if (noHcpFound == 1) {
        msgText = @"Warning! No HCP Records Recieved";
    }
    
    if (noAllocationFound == 1) {
        msgText = @"Warning! No Allocation Records Recieved.";
    }
    
    if (noHcpFound == 0 && noAllocationFound == 0) {
        msgText = @"All files loaded successfully";
    }
    
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Data Load Complete"
                          message: msgText
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
    
}


#pragma mark - update sync counter


-(void) updateSyncBadge {
    
    
    NSLog(@"dw1 - Badge Was Called");
    
    
    // Get OutStanding Badges on Login
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    // NSError *error;
    NSArray *list =
    [NSArray arrayWithObjects:
     @"OFFLINE",
     @"REJECTED", nil];
    
    // Get UNSENT item count
    NSFetchRequest *fetchRequestBadge = [[NSFetchRequest alloc] init];
    fetchRequestBadge.entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:context];
    fetchRequestBadge.predicate = [NSPredicate predicateWithFormat:@"projectcode IN %@", list];
    
    NSError *error = nil;
    NSUInteger numberOfRecords = [context countForFetchRequest:fetchRequestBadge error:&error];
    
    
    // Set All TabBar Badges Upon Load
    for (UIViewController *viewController in self.tabBarController.viewControllers) {
        
        if (viewController.tabBarItem.tag == 4) {
            
            if (numberOfRecords > 0) {
                viewController.tabBarItem.badgeValue = [@(numberOfRecords) description];
            } else {
                viewController.tabBarItem.badgeValue = nil;
            }
        }
       
    }
    
    
}

@end