//
//  HcpChoice.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "OrderDetailViewController_iPad.h"
#import "HcpChoice.h"

@interface HcpChoice ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *healthcareProf;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation HcpChoice




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_hcplist" forIndexPath:indexPath];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int adjHeight = 80;
    return adjHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    path = indexPath;
    NSLog(@"index path for hcp_selection DID SELECT %i", path.row);
    
    checkedCell = indexPath;
    [tableView reloadData];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HealthCareProfessional" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"HCPChoice"];
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









#pragma mark - Cell

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.Text = [[NSString stringWithFormat:@"%@, %@", [[object valueForKey:@"firstname"] description], [[object valueForKey:@"lastname"] description]] uppercaseString];
    
    cell.detailTextLabel.Text = [NSString stringWithFormat:@"%@ \n %@ %@ %@ \n %@ %@ %@",
                                 [[object valueForKey:@"facility"] description],
                                 [[object valueForKey:@"address1"] description],
                                 [[object valueForKey:@"address2"] description],
                                 [[object valueForKey:@"address3"] description],
                                 [[object valueForKey:@"city"] description],
                                 [[object valueForKey:@"province"] description],
                                 [[object valueForKey:@"postal"] description]];
}



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    // Return HCP SELECTION
    if ([[segue identifier] isEqualToString:@"_chosehcp_done"]) {
        
        // SHOULD USE - NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        // Can Use Checked Cell Because 2 step with Done Clause
        
        // Get destination view
        OrderDetailViewController_iPad *vc = [segue destinationViewController];
        [vc setSelectedHCPNUMBER:1001];
        
        
        [vc setMoHCPDATA:[[self.fetchedResultsController fetchedObjects] objectAtIndex:checkedCell.row]];
                
        OrderDetailViewController_iPad *ourfetchClass = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:checkedCell.row inSection:0]];
        
 
        // Handling of Null Fields (Server Side or Replace With NSAssert)
        NSString *varphlid = [[ourfetchClass valueForKey:@"phlid"] description];
        NSString *varfirst = [[ourfetchClass valueForKey:@"firstname"] description];
        NSString *varlast = [[ourfetchClass valueForKey:@"lastname"] description];
        NSString *varfacility = [[ourfetchClass valueForKey:@"facility"] description];
        NSString *varaddress1 = [[ourfetchClass valueForKey:@"address1"] description];
        NSString *varaddress2 = [[ourfetchClass valueForKey:@"address2"] description];
        NSString *varaddress3 = [[ourfetchClass valueForKey:@"address3"] description];
        
        if (varphlid == NULL) {varphlid = @"111";}
        if (varfirst == NULL) { varfirst = @".";}
        if (varlast == NULL) {varlast = @".";}
        if (varfacility == NULL) {varfacility = @" ";}
        if (varaddress1 == NULL) {varaddress1 = @" ";}
        if (varaddress2 == NULL) {varaddress2 = @" ";}
        if (varaddress3 == NULL) {varaddress3 = @" ";}
        
        
        NSString *shorthcp_name = [NSString stringWithFormat:@"%@,%@",
                                      [[ourfetchClass valueForKey:@"lastname"] description],
                                      [[ourfetchClass valueForKey:@"firstname"] description]];
        
        NSString *longaddress_name = [NSString stringWithFormat:@"%@ \n %@ %@ %@ %@",
                                      [[ourfetchClass valueForKey:@"facility"] description],
                                      [[ourfetchClass valueForKey:@"address1"] description],
                                      [[ourfetchClass valueForKey:@"city"] description],
                                      [[ourfetchClass valueForKey:@"province"] description],
                                      [[ourfetchClass valueForKey:@"postal"] description]];
        
        vc.selectedHCPINFO = @[shorthcp_name,
                               longaddress_name,
                                    varfacility,
                                    varaddress1,
                                    varaddress2,
                                    varaddress3,
                                    [[ourfetchClass valueForKey:@"province"] description],
                                    [[ourfetchClass valueForKey:@"city"] description],
                                    [[ourfetchClass valueForKey:@"postal"] description]];        
    }
    
    
    // User Cancelled Selection
    if ([[segue identifier] isEqualToString:@"_chosehcp_cancel"]) {
        
        
    }
}

@end
