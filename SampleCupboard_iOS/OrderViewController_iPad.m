//
//  OrderViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "OrderViewController_iPad.h"
#import "OrderDetailViewController_iPad.h"



@interface OrderViewController_iPad ()

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


@implementation OrderViewController_iPad


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
        
        // Get button tag number (or do whatever you need to do here, based on your object
        //NSInteger tagIndex = [(UIButton *)sender tag];
        //  NSInteger tagIndex = 1;
        
        // Pass the information to your destination view
        //[vc setSelectedButton:tagIndex];
        [vc setSelectedButton:2];
        [vc setSelectedHCPNUMBER:2];
        [vc setSelectedPRODUCTNUMBER:0];
        
        // [segue.destinationViewController setSelectedButton:0];
        
        
    }
}





#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // return [[self.fetchedResultsController sections] count];  // returns 1 result
    
    // working model
    //return [self.fetchedResultsController.fetchedObjects count];
    
    // hcp example
    return [[self.fetchedResultsController sections] count];
    //return 5;
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // working model
    // return 3;
    
    // id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    //return [sectionInfo numberOfObjects];
    
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];

    
    // return 3;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        // NSManagedObject *object = [_fetchedResultsController objectAtIndexPath:indexPath];
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
        NSLog(@"Row: %d",indexPath.row);
        NSLog(@"Section: %d",indexPath.section);
    
        // NSLog(@"Section: %d",indexPath.section);

        NSLog(@"Hit Me... ");
        
        NSString *varCellType = @"_topHeader";
        
        switch (indexPath.row) {
            case 0:
                varCellType = @"_topHeader";
                break;
            case 1:
                varCellType = @"_lineItem";
                break;
            case 2:
                varCellType = @"_summary";
                break;
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
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"reference" cacheName:nil];
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
    // NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // NSManagedObject *object = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        
        UILabel *PDate = (UILabel *)[cell viewWithTag:600];
        [PDate setText:@"TestDD"];        
        //[PDate setText:[[object valueForKey:@"datecreated"] description]];
        
        NSMutableString *myWord = [[NSMutableString alloc] init];
        [myWord appendString:[NSString stringWithFormat:@"%d", indexPath.section]];
        
        UILabel *PName = (UILabel *)[cell viewWithTag:601];
        [PName setText:@"test1"];
        
        // [PName setText: [NSString stringWithFormat:@"%@, %@",
        // [[object valueForKey:@"shipping_firstname"] description],
        // [[object valueForKey:@"shipping_lastname"] description]]];
    }
    
    
    
    
    if (indexPath.row == 1) {
        
        UILabel *PDate1 = (UILabel *)[cell viewWithTag:602];
        [PDate1 setText:@"21"];
        
        // [PDate1 setText: [NSString stringWithFormat:@"%@, %@",
           //               [[object valueForKey:@"shipping_firstname"] description],
              //           [[object valueForKey:@"shipping_lastname"] description]]];
        
        
        // [PDate1 setText:@"Ezetrol 10mg"];
        
        UILabel *PName1 = (UILabel *)[cell viewWithTag:603];
        [PName1 setText:@"21"];
        
    }
    
    
    if (indexPath.row == 2) {
        
        UILabel *XNameX = (UILabel *)[cell viewWithTag:604];
        [XNameX setText:@"TestA"];
        
        // [XNameX setText: [NSString stringWithFormat:@"%@, %@",
           //                [[object valueForKey:@"shipping_firstname"] description],
              //             [[object valueForKey:@"shipping_lastname"] description]]];
        
        // [XNameX setText:[[object valueForKey:@"status"] description]];
        
    }
    
    
}


@end