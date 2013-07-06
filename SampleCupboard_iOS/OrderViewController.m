//
//  OrderViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "Order.h"
#import "OrderLineItem.h"

#import "OrderViewController.h"
#import "OrderDetailViewController_iPad.h"

@interface OrderViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderStatusFilter;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderStatusFilterValueChanged;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)OrderStatusFilterValueChanged:(UISegmentedControl *)sender;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

-(IBAction)return:(UIStoryboardSegue *)segue;

@end


@implementation OrderViewController


-(IBAction)return:(UIStoryboardSegue *)segue{
    
}






#pragma mark - View Functions


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView reloadData];
    
    // Check OutStanding Orders And Display
    // [self.tabBarItem setBadgeValue:@"3"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"_viewordersegue"]) {
        
        // Get destination view
        OrderDetailViewController_iPad *vc = [segue destinationViewController];
        
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
       // vc.fetchedResultsController2 = [[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.row];
        
        
        // Pass the information to your destination view
        [vc setSelectedButton:2];
        [vc setSelectedHCPNUMBER:2];
        [vc setSelectedPRODUCTNUMBER:0];
        [vc setFetchedResultsController2:[[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section]];
        [vc setManagedObjectContext2: [[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section]];
        
        [vc setMyresults:[[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section]];
        
        [vc setMoDATA:[[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.section]];
        
        
        
        
        //[vc setFetchedResultsController2:(NSFetchedResultsController)]
        
        // NSLog(@"Make Sure Populated Before Sending %@", [[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.row]);
        
        // NSLog(@"THIS ROW HAS BEEN SELECTED %d",ip.row);
        // NSLog(@"THIS SECTION SECTION HAS BEEN SELECTED %d",ip.section);

        
        // NSLog(@"THIS SENDER ROW HAS BEEN SELECTED %@",[sender indexPathForSelectedRow]);

        
        
        
        
        // option 1 [prepare values]
        
    }
}




#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Fetch Each Object As Section (Should Show Total Orders as Results - XX)
    
    NSLog(@"NUMBER OF SECTIONS: %d", [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]);
    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
         
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Determine Number of Rows Based on NSSet Count For Details
    
    // Order *order =[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]];
    
    Order *ord = [[self.fetchedResultsController fetchedObjects] objectAtIndex:section];
    
    int TOTROWS;
    TOTROWS = (2 + [ord.toOrderDetails.allObjects count]);
    
    return TOTROWS;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        Order *ord = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.section];

    
        NSString *varCellType = @"_lineItem";
    
        if (indexPath.row == 0) {
            varCellType = @"_topHeader";
        }
    
        // Summary Should Be Equivalent of Total Row Count
        if (indexPath.row == ([ord.toOrderDetails.allObjects count] + 1)) {
            varCellType = @"_summary";
        }

        
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:varCellType forIndexPath:indexPath];
        
        [self configureCell:cell atIndexPath:indexPath];
        return cell;   
   
}






#pragma mark - Fetched results controller

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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"reference" ascending:NO];
    // NSArray *sortDescriptors = @[sortDescriptor];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
    // [self.tableView.reloadData];
    // [self.tableView endUpdates];
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

- (IBAction)OrderStatusFilterValueChanged:(UISegmentedControl *)sender {
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    // REPLACE INDEX PATH FOR ROW ON FETCH CALL
    //NSManagedObject *object = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    
    Order *order =[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    
    // HEADER CELL
    if (indexPath.row == 0) {
        
        UILabel *PDate = (UILabel *)[cell viewWithTag:600];
        
        // Date [Reference] Formating...
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        [PDate setText: [NSString stringWithFormat:@"%@ [MERC%@]",
                         [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[order valueForKey:@"datecreated"]]],
                         [[order valueForKey:@"reference"] description]]];
        
        
        // Name Formating
        UILabel *PName = (UILabel *)[cell viewWithTag:601];
        [PName setText: [NSString stringWithFormat:@"%@, %@",
        [[order valueForKey:@"shipping_firstname"] description],
        [[order valueForKey:@"shipping_lastname"] description]]];
    }
    
    
    // DETAIL ITEM CELL    
    if (indexPath.row != 0 && indexPath.row != ([order.toOrderDetails.allObjects count] + 1) ) {
    
        NSSet *orderDetails = [order.toOrderDetails valueForKeyPath:@"productid"];
        NSArray *orderDetailsItem = [orderDetails allObjects];

        NSSet *orderDetails2 = [order.toOrderDetails valueForKeyPath:@"quantityordered"];
        NSArray *orderDetailsItem2 = [orderDetails2 allObjects];

        
        UILabel *PItem = (UILabel *)[cell viewWithTag:602];
        [PItem setText:[orderDetailsItem objectAtIndex:(indexPath.row - 1)]];
    
        UILabel *PQty = (UILabel *)[cell viewWithTag:603];
        [PQty setText:[[orderDetailsItem2 objectAtIndex:(indexPath.row - 1)] stringValue]];
        
    }
    
    
    // SUMMARY CELL
    if (indexPath.row == ([order.toOrderDetails.allObjects count] + 1)) {
        UILabel *XNameX = (UILabel *)[cell viewWithTag:604];
        [XNameX setText:[[order valueForKey:@"status"] description]];
    }
    
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    // DO NOT USE THIS MESSAGE (WILL CAUSE CRASH)
    // self.fetchedResultsController = nil;
    // self.context = nil;
}

@end