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
        
        // Pass the information to your destination view
        [vc setSelectedButton:2];
        [vc setSelectedHCPNUMBER:2];
        [vc setSelectedPRODUCTNUMBER:0];
    }
}




#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Fetch Each Object As Section (Should Show Total Orders as Results - XX)
    // NSLog(@"NUMBER OF SECTIONS: %d", [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]);
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
    [self.tableView endUpdates];
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
    NSManagedObject *object = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
    
    if (indexPath.row == 0) {
        
        UILabel *PDate = (UILabel *)[cell viewWithTag:600];
        [PDate setText:[[object valueForKey:@"datecreated"] description]];
        
        UILabel *PName = (UILabel *)[cell viewWithTag:601];
        [PName setText: [NSString stringWithFormat:@"%@, %@",
        [[object valueForKey:@"shipping_firstname"] description],
        [[object valueForKey:@"shipping_lastname"] description]]];
    }
    
    
    
    
    // if (indexPath.row == 1) {
        
     
        Order *order =[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        
        
        // TEST1
        NSSet *books = order.toOrderDetails;
        NSArray *booksList = books;
        // NSLog(@"Name TEST1: %@", booksList[0]);
    
        // TEST2
        NSSet *orderDetails = [order.toOrderDetails valueForKeyPath:@"productid"];
        NSArray *orderDetailsItem = [orderDetails allObjects];
        
        // TEST3
        NSSet *booksByAuthor = [object valueForKey:@"toOrderDetails"];
        NSArray *booksArray = [booksByAuthor allObjects];
        
        for (books in booksList) {
            NSLog(@"Name: %@", booksList.description);
            // NSLog(@"Zip: %@", details.zip);
        }
       
        
        
        UILabel *PDate1 = (UILabel *)[cell viewWithTag:602];
        // [PDate1 setText:[[object valueForKey:@"shipping_firstname"] description]];
        // [PDate1 setText:[order.reference description]];
        
        
    
        NSLog(@"Name MSG1 : %@", order.toOrderDetails.description);
    
        // MSG2 SHOWS ALL VALUES toOrderDetails is null
        // NSLog(@"Name MSG2 : %@", [order.toOrderDetails valueForKeyPath:@"productid"]);
    
        [PDate1 setText:[orderDetails.description description]];
        
        // [PDate1 setText:[order.shipping_firstname description]];
        
        // [PDate1 setText:[[order valueForKey:@"shipping_firstname"] description]];
        
        // [PDate1 setText:@"Ezetrol 10mg"];
        // [PDate1 setText:[[object valueForKeyPath:@"shipping_firstname"] description]];
        // UILabel PDate1 = role.shipping_lastname;
        // cell.textLabel.text = order.shipping_firstname;
        
        // [PDate1 setText:[[object valueForKey:@"datecreated.order"] description]];
        
        UILabel *PName1 = (UILabel *)[cell viewWithTag:603];
        // [PName1 setText:[[object valueForKeyPath:order.shipping_addressline1] description]];
        // [PDate1 setText:[order.shipping_addressline1 description]];
        [PName1 setText:@"21"];
   // }
    
    
    if (indexPath.row == 2) {
        UILabel *XNameX = (UILabel *)[cell viewWithTag:604];
        [XNameX setText:[[object valueForKey:@"status"] description]];
    }
    
    
}


@end