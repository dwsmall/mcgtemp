//
//  HcpChoice.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "AppDelegate.h"
#import "OrderDetailViewController_iPad.h"

#import "ProductChoice.h"

@interface ProductChoice ()  <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *healthcareProf;

@property (strong, nonatomic) IBOutlet UISearchBar *prodSearchBar;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *DoneButton;


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end



@implementation ProductChoice

@synthesize prodSearchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_productlist" forIndexPath:indexPath];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    checkedCell = indexPath;
    [tableView reloadData];
    
    self.DoneButton.enabled = TRUE;
    
    
}


#pragma mark - Segue Delegate

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    // resign kb incase user left open
    [prodSearchBar resignFirstResponder];
    
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];

    
    if ([[identifier description] isEqualToString:@"_choseproductcancel"]) {
        
        return YES;
         
    }
    
    
    
    if ([[identifier description] isEqualToString:@"_choseproduct_done"]) {

        
        NSMutableArray *removedPRODUCTS = app.globalProductsRmv;
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:checkedCell];
        
        if ([removedPRODUCTS containsObject:[[object valueForKey:@"productid"] description]]) {
            
            int i;
            for(i=0; i<[removedPRODUCTS count]; i++) {
                
                
                NSString *element = [removedPRODUCTS objectAtIndex:i];
                
                if([element isEqualToString: [[object valueForKey:@"productid"] description]]) {
                    
                    // add to productscreen
                    
                    NSMutableArray *arrTempProducts = [NSMutableArray array];
                    
                    arrTempProducts = [NSMutableArray array];
                    [arrTempProducts addObject:[[object valueForKey:@"productid"] description]];
                    [arrTempProducts addObject:[[object valueForKey:@"productname"] description]];
                    [arrTempProducts addObject:[[object valueForKey:@"productdescription"] description]];
                    [arrTempProducts addObject:@"0"];
                    [app.globalProductsScrn addObject:arrTempProducts];
                    
                    
                    [removedPRODUCTS removeObjectAtIndex:i];
                    
                    
                }
            }
            
            return YES;
        }
        
    }
    
    
    UIAlertView *AlertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Product Cannot Be Added",nil)
                              message:NSLocalizedString(@"Product Already Exists",nil)
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [AlertView show];
    
    return NO;
        
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:checkedCell];
    
    // Get destination view
    OrderDetailViewController_iPad *vc = [segue destinationViewController];
    
    
    // Return HCP SELECTION
    if ([[segue identifier] isEqualToString:@"_choseproduct_done"]) {
       
        AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        app.globalProductChosen = @"NEW";
        
        [vc setSelectedCHOSENPRODUCT:@[[[object valueForKey:@"productid"] description],
                                       [[object valueForKey:@"productname"] description],
                                       [[object valueForKey:@"productdescription"] description]]];
        
    }
    
    
    // User Cancelled Selection
    if ([[segue identifier] isEqualToString:@"_choseproductcancel"]) {
        
        AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        app.globalProductChosen = @"NEW";
        
    }
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Delete Cache
    [NSFetchedResultsController deleteCacheWithName:@"MasterProduct"];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Allocation" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productname" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    // set predicate
    NSPredicate *predicate = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *territoryid = [defaults objectForKey:@"MCG_territoryid"];
    
    NSString *searchtxt = prodSearchBar.text;
    
    if (searchtxt.length > 0) {
        
        // search predicate
        predicate = [NSPredicate predicateWithFormat:@"territoryid = %@ and productname contains[cd] %@", territoryid, searchtxt];
    } else {
    
        predicate = [NSPredicate predicateWithFormat:@"territoryid = %@", territoryid];
    }
    
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"MasterProduct"];
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





- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [[object valueForKey:@"productname"] description];
    
    double allocation_max = [[[object valueForKey:@"avail_allocation"] description] doubleValue];
    double order_max = [[[object valueForKey:@"ordermax"] description] doubleValue];
    double set_qty = 0;
    
    // determine qty limitation
    if (allocation_max < order_max) {
        set_qty = allocation_max;
    } else {
        set_qty = order_max;
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%g", set_qty];
    
}




#pragma mark - Search Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [NSFetchedResultsController deleteCacheWithName:@"MasterProduct"];
    
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];
    
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	prodSearchBar.showsScopeBar = YES;
	[prodSearchBar sizeToFit];
    
	[searchBar setShowsCancelButton:YES animated:YES];
    
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	prodSearchBar.showsScopeBar = NO;
	[prodSearchBar sizeToFit];
    
	[prodSearchBar setShowsCancelButton:NO animated:YES];
    
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    prodSearchBar.text = @"";
    
    [searchBar resignFirstResponder];
    
    [NSFetchedResultsController deleteCacheWithName:@"MasterProduct"];
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];
}




@end
