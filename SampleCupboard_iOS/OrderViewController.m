//
//  OrderViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "Reachability.h"

#import "AppDelegate.h"
#import "CustomBadge.h"

#import "Order.h"
#import "OrderLineItem.h"
#import "OrderDetailViewController_iPad.h"

#import "OrderViewController.h"



@interface OrderViewController ()


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet MESegmentedControl *segmentBar;





@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UISearchBar *topSearchBar;

@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) IBOutlet UISearchBar *orderSearchBar;


@property(nonatomic) NSInteger noAllocationFound;

@property (nonatomic) NSString *urlsvc;
@property (nonatomic) NSString *baseurl;
@property (nonatomic) NSString *urluserid;
@property (nonatomic) NSString *urltoken;
@property (nonatomic) NSURL *url;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;





- (IBAction)segmentClicked:(id)sender;

-(IBAction)return:(UIStoryboardSegue *)segue;


@end




@implementation OrderViewController

@synthesize filteredList;
@synthesize orderSearchBar;

@synthesize segmentedControl;

@synthesize urlsvc, baseurl, urluserid, urltoken, url;


-(IBAction)return:(UIStoryboardSegue *)segue{
    
}






#pragma mark - View Functions

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    // count on number of drafts
    // Get OutStanding Badges on Login
    /*
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    */
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Get UNSENT item count
    NSFetchRequest *fetchDraftBadge = [[NSFetchRequest alloc] init];
    fetchDraftBadge.entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:context];
    fetchDraftBadge.predicate = [NSPredicate predicateWithFormat:@"status == %@", @"DRAFT"];
    
    NSError *error = nil;
    NSUInteger numberOfRecords = [context countForFetchRequest:fetchDraftBadge error:&error];
    
    NSLog(@"dw1 - how many badges: %d", numberOfRecords);
    
    
    if (numberOfRecords > 0) {
        /* removed till next version due to horizontal placement
        
         [_segmentBar setBadgeNumber:numberOfRecords forSegmentAtIndex:5];
         
         */
        
    } else {
        [_segmentBar setBadgeNumber:0 forSegmentAtIndex:5];
    }
    
    /*
     // To set a badge with custom colours:
    [_segmentBar setBadgeNumber:1 forSegmentAtIndex:5 usingBlock:^(CustomBadge *badge)
     {
         // See CustomBadge.h for other badge properties that can be changed here
         badge.badgeFrameColor = [UIColor whiteColor]; // default is white
         badge.badgeInsetColor = [UIColor grayColor]; // default is red
         badge.badgeTextColor = [UIColor whiteColor]; // default is white
     }
     ];
     */
    
    //update sync portion    
    [self updateSyncBadge];
    
    
    
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
    
    if (isLandscape) {
                NSLog(@"dw1 - I am in landscape mode X2");
        
        CGRect Frame = _segmentBar.frame;
        
        CGFloat newX = _segmentBar.frame.origin.x + 200;
        CGFloat newY = _segmentBar.frame.origin.y;
        Frame.origin = CGPointMake(newX, newY);
        
        _segmentBar.Frame = Frame;
        
         
    } else {
                NSLog(@"dw1 - I am portrait mode X2");
    }
    
    // reposition segment bar based on horizontal/portrait
        // a. show frame position
    NSLog(@"dw1 - show frame origin x: %f", _segmentBar.frame.origin.x);
    NSLog(@"dw1 - show frame origin y: %f", _segmentBar.frame.origin.y);
    NSLog(@"dw1 - show frame size: %f", _segmentBar.frame.size.width);
    
    // [_segmentBar setFrame:_segmentBar.frame]
    
    
    
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    // Do any additional setup after loading the view, typically from a nib.
    NSError *error = nil;
    
    [[self fetchedResultsController] performFetch:&error];
    
    [self.tableView reloadData];
    
    [segmentedControl setBadgeNumber:1 forSegmentAtIndex:0];
    
}



- (void)viewDidDisappear:(BOOL)animated
{
    
    // Clear the badge numbers
    [segmentedControl clearBadges];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Rotate

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
*/


-(void)willRotateToInterfaceOrientation: (UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    
    
    
     BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
     
     if (isLandscape) {
         NSLog(@"dw1 - I am portrait mode X");
     
     } else {
     
         NSLog(@"dw1 - I am in landscape mode X");
     }
    
    
    NSLog(@"dw1 - did rotate will 1--");
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    
    NSLog(@"dw1 - did rotate will 2--");
    
}



#pragma mark - Segue Delegates

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    [self clearOrderValues];
    
    // NEW ORDER

    if ([[segue identifier] isEqualToString:@"_newordersegue"]) {
        
        // load allocation
        
        Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
        NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
        
        if (internetStatus != NotReachable){
            
        // Delete Data HCP
        [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"allocationdata" waitUntilDone:YES];
        
        // load data for allocations
        [self performSelectorOnMainThread:@selector(getAllocationDetailData) withObject:nil waitUntilDone:YES];
        
        }
    }
    
    
    
    
    // VIEW ORDER
    
    if ([[segue identifier] isEqualToString:@"_viewordersegue"]) {
        
        // Order *ord = [[self.fetchedResultsController fetchedObjects] objectAtIndex:section];
        
        
        // Get destination view
        OrderDetailViewController_iPad *vc = [segue destinationViewController];
        
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        Order *ord = [[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section];
        
        if ([[[ord valueForKey:@"projectcode"] description] isEqualToString:@"DRAFT"]) {
            
            
            // load allocation
            
            Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
            NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
            
            if (internetStatus != NotReachable){
                
                // Delete Data HCP
                [self performSelectorOnMainThread:@selector(RemoveEntities:) withObject:@"allocationdata" waitUntilDone:YES];
                
                // load data for allocations
                [self performSelectorOnMainThread:@selector(getAllocationDetailData) withObject:nil waitUntilDone:YES];
                
            }
            
            
            
            // draft
            // [vc setSelectedButton:4];
            
            // Store Data
            app.globalMode = @"DRAFT";
            app.globalOrderMO = [[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section];
            
            
            // prepare hcps as existing
            AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];            
            app.globalHcpChosen = @"EXISTING";
            
            NSManagedObject *ourfetchClass = [[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section];
            Order *ourfetchClassOrder = [[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section];
            
            
            // set carrier type/info
            app.globalShipType = [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_type"] description]];
            app.globalShipInfo = [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shipping_instructions"] description]];
            
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
            
            
            // set territoryid
            
            [defaults setObject:[[ourfetchClass valueForKey:@"territoryid"] description] forKey:@"MCG_territoryid"];
            
            
            NSSet *orderDetails = [ourfetchClassOrder.toOrderDetails valueForKey:@"productid"];
            
            
            NSArray *orderDetailsItem = [orderDetails allObjects];
            [defaults setObject:orderDetailsItem forKey:@"MCG_detail_products"];
            
            
            
            // send all detail records as an Array
            
            NSArray *oRecords = [[ourfetchClassOrder valueForKey:@"toOrderDetails"] allObjects];
            [defaults setObject:oRecords forKey:@"MCG_detail_lines"];
            
            
            // get removed products based on territoryid/selected products
            
            NSManagedObjectContext *tmp_moc = [self managedObjectContext];
            NSEntityDescription *tmp_entityDescription = [NSEntityDescription
                                                          entityForName:@"Allocation" inManagedObjectContext:tmp_moc];
            
            NSFetchRequest *tmp_request = [[NSFetchRequest alloc] init];
            [tmp_request setEntity:tmp_entityDescription];
            
            //create predicate
            
            NSPredicate *tmp_predicate = [NSPredicate predicateWithFormat:@"territoryid = %@ AND NOT (productid IN %@)", [[ourfetchClass valueForKey:@"territoryid"] description], orderDetails];
            
            
            // NSLog(@"Order Details: %@, predicate:%@", orderDetails, tmp_predicate);
            
            [tmp_request setPredicate:tmp_predicate];
            
            NSError *error = nil;
            
            // [[[self fetchedResultsController] fetchedObjects] count]
            
            NSArray *arrayRmvProd = [tmp_moc executeFetchRequest:tmp_request error:&error];
            
            
            if ([[arrayRmvProd valueForKey:@"productid"] count] > 0)
            {
                
                app.globalProductsRmv = [[NSMutableArray alloc] init];
                // app.globalProductsRmv = [arrayRmvProd valueForKey:@"productid"];
                app.globalProductChosen = @"NEW";
                
                
                
                for (int i = 0; i < [[arrayRmvProd valueForKey:@"productid"] count]; i++)
                {
                    
                    NSLog(@"dw1 - add SHOW_OBJECT %d - %@", i , [[arrayRmvProd valueForKey:@"productid"] objectAtIndex:i] );
                    [app.globalProductsRmv addObject:[[arrayRmvProd valueForKey:@"productid"] objectAtIndex:i] ];
                    
                }
                
            }
            
            
            // [app.globalProductsRmv addobject:]
            
            NSLog(@"dw1 - SHOW ITEMS %@", app.globalProductsRmv);
            
            
            
            
            app.globalProductsRmv = nil;
            app.globalProductChosen = @"NEW";
            
            
            // populate dictionary with product and qty
            
            NSMutableDictionary *productandqty = [[NSMutableDictionary alloc] init];
            
            int total_rcds = 0;
            total_rcds = [[ourfetchClassOrder.toOrderDetails allObjects] count];
            for (int i = 0; i < total_rcds; i++)
            {
                
                [productandqty setObject:[[oRecords objectAtIndex:i] valueForKey:@"quantityordered"] forKey:[[oRecords objectAtIndex:i] valueForKey:@"productid"]];
                
            }
            
            
            NSLog(@"dw1 - pass productandqty: %@" , productandqty);
            
            // dictionary with pairing
            [defaults setObject:productandqty forKey:@"MCG_productandqty"];
            
        
        } else {
            
            // regular order
            // [vc setSelectedButton:2];
            
            app.globalMode = @"VIEW";
        
        }        
        
        [vc setMoDATA:[[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section]];
    
        
    }
}





#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Fetch Each Object As Section (Should Show Total Orders as Results - XX)
    
    
    
    if (tableView == self.tableView)
    {
        return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    }
    else
    {
        return 1;
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Determine Number of Rows Based on NSSet Count For Details
    
    // Order *order =[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]];
    if (tableView == self.tableView)
    {
        
        Order *ord = [[self.fetchedResultsController fetchedObjects] objectAtIndex:section];
    
        int TOTROWS;
        TOTROWS = (2 + [ord.toOrderDetails.allObjects count]);
        return TOTROWS;
    }
    else
    {
        return [self.filteredList count];
    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Order *ord = nil;
    
    if (tableView == self.tableView)
    {
        ord = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.section];
    }
    else
    {
        ord = [self.filteredList objectAtIndex:indexPath.section];
    }
    
    
        NSString *varCellType = @"_lineItem";
    
        if (indexPath.row == 0) {
            varCellType = @"_topHeader";
        }
    
        // Summary Should Be Equivalent of Total Row Count
        if (indexPath.row == ([ord.toOrderDetails.allObjects count] + 1)) {
            varCellType = @"_summary";
        }

        
        UITableViewCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:varCellType forIndexPath:indexPath];
        
        [self configureCell:cell atIndexPath:indexPath];
        return cell;   
   
}






#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    [NSFetchedResultsController deleteCacheWithName:@"OrderList"];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    // NSManagedObjectContext *context = [self managedObjectContext];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:2000];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reference" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"datecreated" ascending:NO];
    // NSArray *sortDescriptors = @[sortDescriptor];
    NSArray *sortDescriptorA = @[sortDescriptor, sortDescriptor2];
   // NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorA, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptorA];
    
    
    //prepare compound predicate holder
    NSMutableArray *compoundPredicateArray = [[NSMutableArray alloc] init];

    
    // set predicate based on segment
    // 0 : all | 1 : in progress | 2 : On Hold | 3 : Shipped | 4 : Cancelled | 5 : Draft
    
    NSArray *all_status = @[@"",@[@"Active",@"New",@"ReadyForShipping",@"SentToWarehouse"],@[@"OnHold"], @[@"Shipped"],@[@"Cancelled"], @[@"DRAFT"]];
    
    NSArray *exclude_type = @[@[@"DRAFT"]];
    
    
    if (_segmentBar.selectedSegmentIndex > 0) {
    
        NSPredicate *predicateSTS = [NSPredicate predicateWithFormat:@"status IN (%@) ", all_status[_segmentBar.selectedSegmentIndex]];
        
        [compoundPredicateArray addObject: predicateSTS ];
        
        // [fetchRequest setPredicate:predicate];
        
        NSLog(@"dw1 - show DRAFT:%@", predicateSTS);
    } else {
    
        // exclude DRAFT
        NSPredicate *predicateSTS = [NSPredicate predicateWithFormat:@"NOT status IN (%@) ", exclude_type[_segmentBar.selectedSegmentIndex]];
        
        [compoundPredicateArray addObject: predicateSTS ];        
    }
    
    
    // set predicate based on search
    if (_topSearchBar.text.length > 0) {
    
        NSLog(@"dw1 - search bar UX1 %@", _topSearchBar.text);
        
        NSPredicate *predicateSRCH = [NSPredicate predicateWithFormat:@"shipping_lastname contains[cd] %@ OR shipping_firstname contains[cd] %@ OR shipping_postalcode contains[cd] %@ OR reference contains[cd] %@", _topSearchBar.text, _topSearchBar.text, _topSearchBar.text, _topSearchBar.text];
        
        NSLog(@"dw1 - show my predicate %@" , predicateSRCH);
        
        [compoundPredicateArray addObject: predicateSRCH];
        // [fetchRequest setPredicate:predicate2];
    }
    
    
    if ([compoundPredicateArray count] > 0) {
        
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                                  compoundPredicateArray];
        
        [fetchRequest setPredicate:predicate];
    
    }
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"OrderList"];
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
    // [self.tableView reloadData];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */







#pragma mark - Custom Functions

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    
    Order *order = nil;
    
    if (_tableView == self.tableView)
    {
        order =[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    } else
    {
        order = [self.filteredList objectAtIndex:indexPath.row];
    }
    
    
    
    // HEADER CELL
    if (indexPath.row == 0) {
        
        UILabel *PDate = (UILabel *)[cell viewWithTag:600];
        
        // Date [Reference] Formating...
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        
        // update header based on projectcode type
        

        // do not show ref. if value is null
        if( [[[order valueForKey:@"projectcode"] description] isEqualToString:@"OFFLINE"]  ||
            [[[order valueForKey:@"projectcode"] description] isEqualToString:@"DRAFT"] ) {
            
            // unprocessed
            
            [PDate setText: [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[order valueForKey:@"datecreated"]]] ];
        
        } else  {
            
            
            // regular order
            
            [PDate setText: [NSString stringWithFormat:@"%@ [%@%@]",
                             [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[order valueForKey:@"datecreated"]]],
                             [[order valueForKey:@"refprefix"] description],
                             [[order valueForKey:@"reference"] description]]];
        }        
        
        
        // Name Formating
        UILabel *PName = (UILabel *)[cell viewWithTag:601];
        [PName setText: [NSString stringWithFormat:@"%@, %@",
        [[order valueForKey:@"shipping_firstname"] description],
        [[order valueForKey:@"shipping_lastname"] description]]];
    }
    
    
    
    // DETAIL ITEM CELL
    if (indexPath.row != 0 && indexPath.row != ([order.toOrderDetails.allObjects count] + 1) ) {
     

        // ** SHOULD LOOP TO FIND VALUE AT INDEX (OR STRAIGHT PROPAGATE...)
        
        NSArray *oRecords = [[order valueForKey:@"toOrderDetails"] allObjects];

       if ([oRecords count] > 0) {
           
            int total_rcds = 0;
            total_rcds = [[order.toOrderDetails allObjects] count];
            for (int i = 0; i < total_rcds; i++)
            {
                if (i == (indexPath.row - 1)) {
                    UILabel *PItem = (UILabel *)[cell viewWithTag:602];
                    [PItem setText:[[oRecords objectAtIndex:i] valueForKey:@"stored_product_name"]];
                
                    UILabel *PQty = (UILabel *)[cell viewWithTag:603];
                    [PQty setText:[[[oRecords objectAtIndex:i] valueForKey:@"quantityordered"] stringValue]];
                }
                
            }
           
        
        }
        
        
    
       
    }
    
    
    // SUMMARY CELL
    if (indexPath.row == ([order.toOrderDetails.allObjects count] + 1)) {
        UILabel *XNameX = (UILabel *)[cell viewWithTag:604];
        [XNameX setText:[[order valueForKey:@"status"] description]];
    }
    
    
}





#pragma mark === Accessors ===


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    NSLog(@"dw1 - show reaction %@" , _topSearchBar.text);
    
    
    
    [NSFetchedResultsController deleteCacheWithName:@"OrderList"];
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];

}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _topSearchBar.text = @"";
    
    [searchBar resignFirstResponder];

    [NSFetchedResultsController deleteCacheWithName:@"OrderList"];
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];
}



- (IBAction)segmentClicked:(id)sender {
    
    [NSFetchedResultsController deleteCacheWithName:@"OrderList"];
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];
    
}

#pragma mark - Sync RTData

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

    // Set the button Text Color
    /*
    [_UserLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _UserLoginBtn.layer.cornerRadius = 10; // this value vary as per your desire
    _UserLoginBtn.clipsToBounds = YES;
     */
    

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



#pragma mark - utilities

- (NSString *)stringOrEmptyString:(NSString *)string
{
    if (string)
        return string;
    else
        return @" ";
}
@end