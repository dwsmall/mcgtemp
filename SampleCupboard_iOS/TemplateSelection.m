//
//  TemplateSelection.m
//  SampleCupboard_iOS
//
//  Created by David Small on 8/13/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "Reachability.h"
#import "AppDelegate.h"
#import "TemplateSelection.h"
#import "OrderDetailViewController_iPad.h"
#import "OrderTemplate.h"
#import "OrderTemplateLine.h"

@interface TemplateSelection () <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

// @property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
// @property (strong, nonatomic) NSArray *filteredList;
// @property (strong, nonatomic) IBOutlet UISearchBar *HcpSearchBar;

@property (strong, nonatomic) IBOutlet UILabel *used_templates;

@property (strong, nonatomic) IBOutlet UILabel *total_templates;


@property (strong, nonatomic) IBOutlet UISearchBar *topSearchBar;

@property(nonatomic) NSInteger noAllocationFound;

@property (nonatomic) NSString *urlsvc;
@property (nonatomic) NSString *baseurl;
@property (nonatomic) NSString *urluserid;
@property (nonatomic) NSString *urltoken;
@property (nonatomic) NSURL *url;




-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end



@implementation TemplateSelection


    @synthesize topSearchBar;

    @synthesize urlsvc, baseurl, urluserid, urltoken, url;

// @synthesize filteredList;
// @synthesize HcpSearchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    
    _used_templates.text = [NSString stringWithFormat:@"%d" , [sectionInfo numberOfObjects]];
    _total_templates.text = @"25";
    
}

- (IBAction)doneButtonClicked:(UIBarButtonItem *)sender {
    
    // _rtnToOrderDetail
    if(checkedCell == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No Template Selected"
                                                        message: @"You Must Select a Template"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {

        [self performSegueWithIdentifier: @"_rtnToOrderDetail" sender: self];
    
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    checkedCell = indexPath;
    [tableView reloadData];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // delete row from fetchResults
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // NSLog(@"fetched results : \n%@\n",[self.fetchedResultsController fetchedObjects]);
        
        // Commit the change.
        NSError *error = nil;
        
        // Update the array and table view.
        if (![_managedObjectContext save:&error])
        {
            // Handle the error.
        }
        
        // remove from screen
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == self.tableView)
    {
        return [[self.fetchedResultsController sections] count];
    }
    else
    {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.tableView)
    {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
    else
    {
        // return [self.filteredList count];
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"_templatelist" forIndexPath:indexPath];
    
    if (cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"_templatelist"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }

    [self configureCell:cell atIndexPath:indexPath];
    
    
    
    // Set CheckMark on Row
    if ([checkedCell isEqual:indexPath])
        
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
    
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *object = nil;
    
    
    if (_tableView == self.tableView)
    {
        
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    }
    else
    {
        
        // NSError *error = nil;
        // self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        
        // object = [self.filteredList objectAtIndex:indexPath.row];
        
    }
    
    // cell.textLabel.text = [[object valueForKey:@"templatename"] description];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    // [DateFormatter setDateFormat:@"dd-MM-yyyy"];
    [DateFormatter setDateFormat:@"EEE, MMM d, yyyy"];
 
    cell.textLabel.text = [[object valueForKey:@"templatename"] description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"created on %@ for %@,%@",
                                 [DateFormatter stringFromDate:[object valueForKey:@"datecreated"]],
                                 [[object valueForKey:@"shipping_firstname"] description],
                                 [[object valueForKey:@"shipping_lastname"] description] ];
     
}




#pragma mark === Accessors ===

/*
- (NSFetchRequest *)searchFetchRequest
{
     
}

*/


#pragma mark === Search Delegate ===

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    /*
        UYLWorldFactsSearchScope scopeKey = controller.searchBar.selectedScopeButtonIndex;
        [self searchForText:searchString scope:scopeKey];
        return YES;
    */
    
    return YES;
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    /*
        NSString *searchString = controller.searchBar.text;
        [self searchForText:searchString scope:searchOption];
        return YES;
    */
    
    return YES;
}




/*
- (void)searchForText:(NSString *)searchText scope:(UYLWorldFactsSearchScope)scopeOption
{
    if (self.managedObjectContext)
    {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"lastname";
        
        if (scopeOption == searchScopePostal)
        {
            searchAttribute = @"postal";
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    }
}
*/




#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderTemplate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    // set predicate
    NSString *searchtxt = topSearchBar.text;
    
    if (searchtxt.length > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"templatename contains[cd] %@", searchtxt];
        NSLog(@"dw1 - show predicate %@" , predicate);
        [fetchRequest setPredicate:predicate];
        
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"templatename" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:@"templates"];
    
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



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // [self.tableView reloadData];
}



#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
   
    
    // Return HCP SELECTION
    if ([[segue identifier] isEqualToString:@"_rtnToOrderDetail"]) {
    
        [self clearOrderValues];
                
        
        if (self.searchDisplayController.isActive)
        {
            NSLog(@"Search is Active");
            
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
            NSLog(@"Search Index %@" , indexPath);
            
        }
        else
        {
         
            
            // load allocation
            
            Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
            NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
            
            if (internetStatus != NotReachable){
                
                // Delete Data HCP
                [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"allocationdata" waitUntilDone:YES];
                
                // load data for allocations
                [self performSelectorOnMainThread:@selector(getAllocationDetailData) withObject:nil waitUntilDone:YES];
                
            }
            
            
            
            // Get destination view
            OrderDetailViewController_iPad *vc = [segue destinationViewController];
            [vc setSelectedHCPNUMBER:1001];
            
            OrderTemplate *ourfetchClass = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:checkedCell.row inSection:0]];
            
            AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            
            app.globalHcpDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_firstname"] description]], @"firstname",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_lastname"] description]], @"lastname",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_facilityname"] description]], @"facility",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_addressline1"] description]], @"address1",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_addressline2"] description]], @"address2",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_addressline3"] description]], @"address3",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_province"] description]], @"province",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_city"] description]], @"city",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_postalcode"] description]] , @"postal",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_status"] description]], @"status",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_phone"] description]], @"phone",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_fax"] description]], @"fax",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_email"] description]], @"email",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shiptoid"] description]], @"shiptoaddressid",
                                       nil];
            
            // set carrier type/info
            app.globalShipType = [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_type"] description]];
            app.globalShipInfo = [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_instructions"] description]];
            
            
            // set selected HCP (check for updates in template address..)
            id appDelegate = (id)[[UIApplication sharedApplication] delegate];
            self.managedObjectContext = [appDelegate managedObjectContext];
            
            NSFetchRequest *requesthcp = [[NSFetchRequest alloc] init];
            NSEntityDescription *entityX = [NSEntityDescription entityForName:@"HealthCareProfessional" inManagedObjectContext:self.managedObjectContext];
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"shiptoaddressid MATCHES[cd] %@", ourfetchClass.shiptoid];
            [requesthcp setEntity:entityX];
            [requesthcp setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *hcpFound = [_managedObjectContext executeFetchRequest:requesthcp error:&error];
            
            
            [vc setMoHCPDATA:[hcpFound objectAtIndex:0]];
         
            
            // set territoryid
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[ourfetchClass valueForKey:@"territoryid"] description] forKey:@"MCG_territoryid"];
            
            
            [defaults setObject:ourfetchClass.templatename forKey:@"MCG_templatename"];
            
            
            // load products
            
            NSSet *orderDetails = [ourfetchClass.toOrdTempDetails valueForKey:@"productid"];
            NSArray *orderDetailsItem = [orderDetails allObjects];
            [defaults setObject:orderDetailsItem forKey:@"MCG_detail_products"];
            
            
            // send all detail records as an Array
            
            NSArray *oRecords = [[ourfetchClass valueForKey:@"toOrdTempDetails"] allObjects];
            [defaults setObject:oRecords forKey:@"MCG_detail_lines"];
            
            
            
            
            // get removed products based on territoryid/selected products
            
            NSManagedObjectContext *tmp_moc = [self managedObjectContext];
            NSEntityDescription *tmp_entityDescription = [NSEntityDescription
                                                      entityForName:@"Allocation" inManagedObjectContext:tmp_moc];
            
            NSFetchRequest *tmp_request = [[NSFetchRequest alloc] init];
            [tmp_request setEntity:tmp_entityDescription]; 
            
            
            //create predicate
            
            NSPredicate *tmp_predicate = [NSPredicate predicateWithFormat:@"territoryid = %@ AND NOT (productid IN %@)", [[ourfetchClass valueForKey:@"territoryid"] description], orderDetails];
            
            NSLog(@"Order Details MY predicate:%@", tmp_predicate);
            
            [tmp_request setPredicate:tmp_predicate];
            
            error = nil;
            
            // [[[self fetchedResultsController] fetchedObjects] count]
            
            NSArray *arrayRmvProd = [tmp_moc executeFetchRequest:tmp_request error:&error];
            
            
            if ([[arrayRmvProd valueForKey:@"productid"] count] > 0)
            {
                
                app.globalProductsRmv = [[NSMutableArray alloc] init];
                // app.globalProductsRmv = [arrayRmvProd valueForKey:@"productid"];
                app.globalProductChosen = @"NEW";
                app.globalHcpChosen = @"EXISTING";
                
                
                for (int i = 0; i < [[arrayRmvProd valueForKey:@"productid"] count]; i++)
                {
                    
                    NSLog(@"dw1 - add SHOW_OBJECT %d - %@", i , [[arrayRmvProd valueForKey:@"productid"] objectAtIndex:i] );
                    [app.globalProductsRmv addObject:[[arrayRmvProd valueForKey:@"productid"] objectAtIndex:i] ];
                    
                }
                
            }
            
            // [app.globalProductsRmv addobject:]
            
            NSLog(@"dw1 - SHOW ITEMS %@", app.globalProductsRmv);
            
            
            // populate dictionary with product and qty
            NSMutableDictionary *productandqty = [[NSMutableDictionary alloc] init];
            
            int total_rcds = 0;
            total_rcds = [[ourfetchClass.toOrdTempDetails allObjects] count];
            for (int i = 0; i < total_rcds; i++)
            {
                
                [productandqty setObject:[[oRecords objectAtIndex:i] valueForKey:@"quantityordered"] forKey:[[oRecords objectAtIndex:i] valueForKey:@"productid"]];
                
            }
            
            
            NSLog(@"dw1 - pass productandqty: %@" , productandqty);
            
            // dictionary with pairing
            [defaults setObject:productandqty forKey:@"MCG_productandqty"];
            
            
            // Pass the information to your destination view
            app.globalMode = @"TEMPLATE";
                
            // [vc setSelectedHCPNUMBER:0];
            // [vc setSelectedPRODUCTNUMBER:0];
            
        }
        
    }
    
    
    
    
    
}






#pragma mark === Accessors ===

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"dw1 - show reaction %@" , topSearchBar.text);
    
    [NSFetchedResultsController deleteCacheWithName:@"templates"];
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	topSearchBar.showsScopeBar = YES;
	[topSearchBar sizeToFit];
    
	[searchBar setShowsCancelButton:YES animated:YES];
    
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	topSearchBar.showsScopeBar = NO;
	[topSearchBar sizeToFit];
    
	[topSearchBar setShowsCancelButton:NO animated:YES];
    
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    topSearchBar.text = @"";
    
    [searchBar resignFirstResponder];
    
    [NSFetchedResultsController deleteCacheWithName:@"templates"];
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];
}





#pragma mark clearOrderValues

- (void)clearOrderValues
{
    
    // initialize values in app delegate
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.globalMode = nil;
    
    app.globalHcpChosen = nil;
    app.globalProductChosen = nil;
    
    app.globalOrderMO = nil;
    app.globalHcpMO = nil;
    
    app.globalHcpDictionary = nil;
    
    app.globalProductsRmv = nil;
    app.globalProductsScrn = nil;
    app.globalRmvProductsFetch = nil;
    
    
    
    // [SignatureControl clearSignature];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"MCG_territoryid"];
    
    
}


#pragma mark CoreData Tasks



- (void) RemoveEntities:(NSString *) removalType {
    
    
    // NSLog(@"Entity A Removal Called %@", removalType);
    
    NSArray *deletionEntity;
    
    // NSString *delete_others = @"others";
    
    // if ([removalType isEqual: delete_others]) {
    deletionEntity = @[@"Allocation"];
    // deletionEntity = @[@"ClientInfo",@"Order",@"Product",@"Allocation",@"AllocationHeader",@"TerritoryFSA",@"Territory",@"Rep"];
    // }
    
    
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
                    
                    // [model setValue:[dicALLOC objectForKey:@"HasAvailableInventory"]forKey:@"hasavailableinventory"];
                    
                    
                    if (![context save:&error]) {
                        NSLog(@"Couldn't save: %@", [error localizedDescription]);
                    }
                    
                }
                
            }
            
            
            
        }
        
    }  // End of Allocation
    
    
    
}





#pragma mark Utility



- (NSString *)stringOrEmptyString:(NSString *)string
{
    if (string)
        return string;
    else
        return @"";
}



@end

