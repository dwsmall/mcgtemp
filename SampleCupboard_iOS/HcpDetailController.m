//
//  HcpDetailController.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-06.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "Reachability.h"

#import "AppDelegate.h"
#import "OrderDetailViewController_iPad.h"
#import "SVProgressHUD.h"
#import "HcpAdditionalDetails.h"

#import "HcpDetailController.h"

@interface HcpDetailController ()

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSFetchRequest *territoryFetchRequest;

@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSArray *fsaFoundList;


@property(nonatomic) NSInteger noAllocationFound;

@property (nonatomic) NSString *urlsvc;
@property (nonatomic) NSString *baseurl;
@property (nonatomic) NSString *urluserid;
@property (nonatomic) NSString *urltoken;
@property (nonatomic) NSURL *url;

@property (strong, nonatomic) IBOutlet UINavigationItem *hcpTopTitle;


- (IBAction)return:(UIStoryboardSegue *)segueX;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end




@implementation HcpDetailController

@synthesize selectedHCPINDEX;
@synthesize selectedHCPNUMBER;
@synthesize selectedHCPMSG;
@synthesize currentHCPINFO;
@synthesize moDATAHCP, outputlabelA;

@synthesize previousOrdersRetrieved;
@synthesize storePreviousOrders;

@synthesize urlsvc, baseurl, urluserid, urltoken, url;


// @synthesize currentHCPARRAY;



-(IBAction)return:(UIStoryboardSegue *)segueX{
    
}

#pragma mark - View Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    int myInt = [previousOrdersRetrieved integerValue];
    NSLog(@"dw1 - did viewDidLoad %d", myInt);
  
    
    //populate territories
    
    _territoryFetchRequest = [[NSFetchRequest alloc] init];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TerritoryFSA" inManagedObjectContext:self.managedObjectContext];
    [_territoryFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fsa" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_territoryFetchRequest setSortDescriptors:sortDescriptors];
    
    _hcpTopTitle.title = NSLocalizedString(@"HCP Details", nil);
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *HeaderTitle = @"Default";
    
    switch (section)
    
    {
        case 0:
            
            HeaderTitle = NSLocalizedString(@"Name", nil);
            break;
            
        case 1:
            
            HeaderTitle = NSLocalizedString(@"Communication",nil);
            break;
            
        case 2:
            
            HeaderTitle = NSLocalizedString(@"Address",nil);
            break;
        
        case 3:
            
            HeaderTitle = NSLocalizedString(@"Order History",nil);
            break;
            
        default:
            
            HeaderTitle = NSLocalizedString(@"Info",nil);
            break;
            
    }
            
    return HeaderTitle;
            
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int MRows = 0;
    
    switch (section)
    
    {
        case 0:
            
            //Name Rows
            MRows=5;  //5
            break;
            
        case 1:
            
            //Communication
            MRows=2;
            break;

        case 2:
            
            //Address
            MRows=1;  //7
            break;
            
        case 3:
            
            //Last 5 Orders
            MRows = 1;
            
            int myInt = [previousOrdersRetrieved integerValue];
            // NSLog(@"show row accumulation = %d", myInt);
            
            if (previousOrdersRetrieved > 0) {
                MRows = myInt;
            }
            break;
        
        default:
            
            MRows=1;
            break;
            
    }
    
    return MRows;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    
    NSString *MyFormType = @"_typeA";
    
    if ( indexPath.section == 2 ) {
        MyFormType = @"_typeC";
    }
    
    if (indexPath.section == 3) {
        
        MyFormType = @"_typeD";
        
        if ([storePreviousOrders count] > 0) {
            
            // check Data Type
            NSArray *extractArray = [storePreviousOrders objectAtIndex:indexPath.row];
            
            if ([[extractArray objectAtIndex:0] isEqualToString:@"TYPE1"]) {
                
                // apply style

                MyFormType = @"_showOrdHeader";
                
                
               
            } else {
                
                MyFormType = @"_showOrdDetail";
                
            }
            
            
        } // End if
    }
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyFormType forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    // NSLog(@"dw1 - %ld", (long)selectedCell.tag);
    // NSLog(@"dw2 - %@", selectedCell.reuseIdentifier);
    
    if ([selectedCell.reuseIdentifier isEqualToString:@"_typeD"]) {
        
        // Load Orders From Server...
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading Orders...",nil)];
        [self performSelectorOnMainThread:@selector(retrievePreviousOrders) withObject:nil waitUntilDone:YES];
        
        if (previousOrdersRetrieved == 0) {
            [self performSelector:@selector(dismissNoRecords) withObject:nil afterDelay:0.4f];
        }else {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];
        
        }
    
        
    }
    
}



#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    // NSManagedObjectContext *context = [self managedObjectContext];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HealthCareProfessional" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"phlid" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"MasterHCP"];
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
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    [self.tableView endUpdates];
}




#pragma mark - Segue Delegates


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([[identifier description] isEqualToString:@"_createOrderFromHcp"]) {
        
        
            // Load Allocation
        
            Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
            NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
            
            if (internetStatus != NotReachable){
                
                // Delete Data HCP
                [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"allocationdata" waitUntilDone:YES];
                
                // load data for allocations
                [self performSelectorOnMainThread:@selector(getAllocationDetailData) withObject:nil waitUntilDone:YES];
                
            }
        
        
        
        // get fetched object
        
        NSManagedObject *hcpfetchClass = moDATAHCP;
        
        // check if fsa in territory
        
        NSString *strpostal = [[hcpfetchClass valueForKey:@"postal"] description];
        
        
        // check core data for fsa (which territories it exists)
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fsa contains[c] %@) OR (fsa contains[c] %@)",
                                  strpostal, [strpostal substringToIndex:3]];
        
        [self.territoryFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        
        self.fsaFoundList = [self.managedObjectContext executeFetchRequest:self.territoryFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
        
        
        // set territoryID based on result
        
        if ([self.fsaFoundList count] > 0) {
            
            // set territory of first index
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[self.fsaFoundList objectAtIndex:0]  valueForKey:@"territory_id"] forKey:@"MCG_territoryid"];
            
            NSLog(@"hcp posted - %@" , [[self.fsaFoundList objectAtIndex:0]  valueForKey:@"territory_id"]);
            
        } else {
            
            // show error msg
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid HCP Selection", nil)
                                                            message:NSLocalizedString(@"This HCP is not available in your territory.",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            // cancel request
            return NO;
        }
        
        
    }
    
    return YES;
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    // view additional details
    
    if ([segue.identifier isEqualToString:@"_additionalhcp"]) {
        
        HcpAdditionalDetails *extVC = (HcpAdditionalDetails *)[segue destinationViewController];
        extVC.currentHCPINFOEXT = currentHCPINFO;
        
    }
    
    
    
    // create new order
    
    if ([[segue identifier] isEqualToString:@"_createOrderFromHcp"]) {
        
        
            // Get destination view
        
            // set values in app delegate
        
            AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            app.globalHcpChosen = @"FROMHCP";
        
            NSManagedObject *ourfetchClass = moDATAHCP;
        
            app.globalHcpDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"firstname"] description]], @"firstname",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"lastname"] description]], @"lastname",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"facility"] description]], @"facility",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"address1"] description]], @"address1",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"address2"] description]], @"address2",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"address3"] description]], @"address3",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"province"] description]], @"province",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"city"] description]], @"city",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"postal"] description]] , @"postal",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"status"] description]], @"status",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"phone"] description]], @"phone",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"fax"] description]], @"fax",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"email"] description]], @"email",
                                   [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shiptoaddressid"] description]], @"shiptoaddressid",
                                   nil];
        
                       
        }
        

    
    
}



#pragma mark - Configure Cell

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = moDATAHCP;
    
    switch (indexPath.section)
    
    {
        case 0:
            //Name
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"First Name:",nil);
                cell.detailTextLabel.text = [[object valueForKey:@"firstname"] description];
            }
            
            if (indexPath.row == 1) {
                cell.textLabel.text = NSLocalizedString(@"Last Name:",nil);
                cell.detailTextLabel.text = [[object valueForKey:@"lastname"] description];
                // cell.detailTextLabel.text = currentHCPINFO[1];
            }
            
            if (indexPath.row == 2) {
                cell.textLabel.text = NSLocalizedString(@"Title:",nil);
                cell.detailTextLabel.text = [[object valueForKey:@"title"] description];
                // cell.detailTextLabel.text = @"ADD TITLE";
                // cell.detailTextLabel.text = currentHCPINFO[2];
            }
            
            if (indexPath.row == 3) {
                cell.textLabel.text = NSLocalizedString(@"Gender:",nil);
                cell.detailTextLabel.text = [[object valueForKey:@"gender"] description];
                // cell.detailTextLabel.text = currentHCPINFO[3];
            }
            
            if (indexPath.row == 4) {
                cell.textLabel.text = NSLocalizedString(@"Language:",nil);
                cell.detailTextLabel.text = [[object valueForKey:@"language"] description];
                // cell.detailTextLabel.text = currentHCPINFO[4];
            }
            break;
            
        case 1:
            
            //Communication
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"Telephone:",nil);;
                cell.detailTextLabel.text = [[object valueForKey:@"phone"] description];
                // cell.detailTextLabel.text = currentHCPINFO[5];
            }
            
            if (indexPath.row == 1) {
                cell.textLabel.text = NSLocalizedString(@"Fax:",nil);;
                cell.detailTextLabel.text = [[object valueForKey:@"fax"] description];
                // cell.detailTextLabel.text = currentHCPINFO[6];
            }
            break;
            
        case 2:
            
            //Address
            if (indexPath.row == 0) {
                NSString *longaddress_name = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                                              [[object valueForKey:@"facility"] description],
                                              [[object valueForKey:@"address1"] description],
                                              [[object valueForKey:@"city"] description],
                                              [[object valueForKey:@"province"] description],
                                              [[object valueForKey:@"postal"] description]];
                cell.textLabel.text = longaddress_name;
            }
            
            break;
            
        case 3:
            
             if ([storePreviousOrders count] > 0) {
                 
                 // check Data Type
                 NSArray *extractArray = [storePreviousOrders objectAtIndex:indexPath.row];
                 
                 if ([[extractArray objectAtIndex:0] isEqualToString:@"TYPE1"]) {
                   
                     [(UILabel *)[cell viewWithTag:101] setText:[extractArray objectAtIndex:4]]; //date
                     
                     [(UILabel *)[cell viewWithTag:102] setText:[NSString stringWithFormat:@"%@%@", [extractArray objectAtIndex:1], [extractArray objectAtIndex:2]]]; //reference
                     
                     [(UILabel *)[cell viewWithTag:103] setText:[[extractArray objectAtIndex:3] description]]; //status
                     
                     [(UILabel *)[cell viewWithTag:104] setText:[extractArray objectAtIndex:5]]; //calc days
                     
                     [(UILabel *)[cell viewWithTag:105] setText:NSLocalizedString(@"Days Ago",nil)]; //description
                     
                     
                 } else {
                     
                     [(UILabel *)[cell viewWithTag:201] setText:[extractArray objectAtIndex:1]]; //product
                     
                     [(UILabel *)[cell viewWithTag:202] setText:[extractArray objectAtIndex:3]]; //amt
                     
                 }
                 
                 
             } else {
             
                 cell.textLabel.text = NSLocalizedString(@"Show Previous Orders",nil);
                 cell.textLabel.textColor = [UIColor blueColor];
             
             }
            
            break;
    }
    
    
}




#pragma mark - Custom Functions

-(void) retrievePreviousOrders {

    
    NSManagedObject *object = moDATAHCP;
    
    storePreviousOrders = [[NSMutableArray alloc] init];
    
    
    //Prep Values
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    urluserid = app.globalUserID;
    urltoken = app.globalToken;
    baseurl = app.globalBaseUrl;
    
    url = [NSURL URLWithString:@""];
    
    NSString *urlhcpid = [[object valueForKey:@"shiptoaddressid"] description];
    NSString *urlamt = @"5";
    
    urlsvc = @"GetOrdersByTerritoryId";
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@",
                                    baseurl,
                                    urlsvc,
                                    urluserid,
                                    urltoken,
                                    urluserid,
                                    urlhcpid,
                                    urlamt]];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetOrdersByTerritoryIdResult"];
        
        
        NSLog(@"dw1 - how many loaded:%d", [arrayContainer count]);
        
        
        if ([arrayContainer count] > 0) {
        
        [self.tableViewX beginUpdates];
        [self.tableViewX deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:3]]
                               withRowAnimation:UITableViewRowAnimationTop];
        
        }
        
        int ctr = 0;
        
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            

            
            // Date Conversion Routine
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSLog(@"dw1 - conv_date:%@", [dicItems objectForKey:@"datecreated"]);
            NSString *myDateToConvert = [dicItems objectForKey:@"datecreated"];
            NSDate *myDate = [dateFormatter dateFromString:myDateToConvert];
            
            // friendly date pls
            NSDateFormatter *dateFormaterG = [[NSDateFormatter alloc]init];
            [dateFormaterG setDateFormat:@"MM-dd-yyyy"];
            NSString *myDateX = [dateFormaterG stringFromDate:myDate];
            
            NSLog(@"dw1 - show date da! %@", myDateX);
            
            
            // calc date diff
            NSDate *lastDate = myDate;
            NSTimeInterval lastDiff = [lastDate timeIntervalSinceNow];
            int howManyDays = lastDiff / 86400;
            
            if (howManyDays < 0) {
                howManyDays = howManyDays * -1;
            }
            
            // DWX01 - NSArray *arrayHolder = [[NSMutableArray alloc] init];
            
            NSArray *arrayHolder = @[@"TYPE1",
                            [self stringOrEmptyString:[dicItems objectForKey:@"refprefix"]],
                            [self stringOrEmptyString:[dicItems objectForKey:@"reference"]],
                            [self stringOrEmptyString:[dicItems objectForKey:@"shipping_status"]],
                            myDateX,
                            [self stringOrEmptyString:[NSString stringWithFormat:@"%d", howManyDays]] ];
            
            
            // add entry to array
            
            [storePreviousOrders addObject:arrayHolder];
            
            
            
            [self.tableViewX insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:ctr inSection:3]]
                                   withRowAnimation:UITableViewRowAnimationTop];            

            
            // increment value
            double cVal = [previousOrdersRetrieved doubleValue];
            cVal = cVal + 1;
            previousOrdersRetrieved = [NSDecimalNumber numberWithDouble:cVal];
            
            
            // update ctr
            ctr = ctr + 1;
            
            // Iteration of Order Details
            NSArray* arrayContainer2 = [dicItems objectForKey:@"orderLineItems"];
            
            
            // Get Matching Detailed Items And Insert
            for(int x=0;x<[arrayContainer2 count];x++)
            {
                
                NSDictionary* dicItems2 = [arrayContainer2 objectAtIndex:x];
                
                // DWX01 - NSArray *arrayHolder = [[NSMutableArray alloc] init];
                
                
                // add entry to array
                
                NSArray *arrayHolder = @[@"TYPE2",
                                [self stringOrEmptyString:[dicItems2 objectForKey:@"Stored_Product_Name"]],
                                [self stringOrEmptyString:[dicItems2 objectForKey:@"Stored_Product_Description"]],
                                [self stringOrEmptyString:[[dicItems2 objectForKey:@"quantityordered"] description]] ];
                
                [storePreviousOrders addObject:arrayHolder];
                
                
                // insert row
                [self.tableViewX insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:ctr inSection:3]]
                                       withRowAnimation:UITableViewRowAnimationTop];
                
                // increment value
                double cVal = [previousOrdersRetrieved doubleValue];
                cVal = cVal + 1;
                previousOrdersRetrieved = [NSDecimalNumber numberWithDouble:cVal];
                
                // update ctr
                ctr = ctr + 1;
                
                
                                
            } // array2
           
        } // array
        
        
    } //jsonData
    
    
    
    [self.tableViewX endUpdates];
       

}




- (void) RemoveEntities:(NSString *) removalType {
   
    NSArray *deletionEntity;
    
    deletionEntity = @[@"Allocation"];
    
    
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


-(void) getAllocationDetailData {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    baseurl = app.globalBaseUrl;
    urluserid = app.globalUserID;
    urltoken = app.globalToken;
    url = [NSURL URLWithString:@""];
    
    
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
                    
                    
                    // computed values
                    
                    [model setValue:[dicALLOC objectForKey:@"Max"] forKey:@"max_computed"];
                    [model setValue:[dicALLOC objectForKey:@"AvailableAllocation"] forKey:@"avail_allocation"];
                    [model setValue:[dicALLOC objectForKey:@"AvailableInventory"] forKey:@"avail_inventory"];
                    [model setValue:[dicALLOC objectForKey:@"OrderMax"] forKey:@"ordermax"];
                    
                    
                    if (![context save:&error]) {
                        NSLog(@"Couldn't save: %@", [error localizedDescription]);
                    }
                    
                }
                
            }
            
            
            
        }
        
    }  // End of Allocation
    
    
    
}


#pragma mark - HUD Methods

- (void)dismiss {
	[SVProgressHUD dismiss];
}


- (void)dismissSuccess {
	[SVProgressHUD showSuccessWithStatus:@"Loading Complete!"];
}


- (void)dismissNoRecords {
	[SVProgressHUD showSuccessWithStatus:@"No Orders Found!"];
}

- (void)dismissError {
	[SVProgressHUD showErrorWithStatus:@"Failed with Error"];
}



#pragma mark - Utillities

- (NSString *)stringOrEmptyString:(NSString *)string
{
    if (string == nil || [string isKindOfClass:[NSNull class]] ) {
        return @"";
    } else {
        return string;
    }
    
}


@end
