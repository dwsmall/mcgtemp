//
//  HcpListViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "HcpDetailController.h"

#import "HcpListViewController_iPad.h"

@interface HcpListViewController_iPad ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *healthcareProf;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

-(IBAction)return:(UIStoryboardSegue *)segue;

@end

@implementation HcpListViewController_iPad


-(IBAction)return:(UIStoryboardSegue *)segue{
    
}




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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Did Select Row %ld", (long)indexPath.row);
    
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // NSString *cellText = cell.textLabel.text;
    
    ChosenRowNumber = indexPath.row;
    
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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"_push_to_hcpdetails"]) {
       
        
            // Step 1 - Declare VC Controller
            HcpDetailController *detailVC = (HcpDetailController *)[segue destinationViewController];
        
            // Method #1 - Get Index Path of Selected Row, Use As Index Path of fetch To Retrieve Values
            // DOES NOT WORK NSIndexPath *indexPathX = [self.tableView indexPathForSelectedRow];
            // NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

            HcpListViewController_iPad *ourfetchClass = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:ChosenRowNumber inSection:0]];
        
        
            // Handling of Null Fields (Server Side or Replace With NSAssert)
            NSString *varfirst = [[ourfetchClass valueForKey:@"firstname"] description];
            NSString *varlast = [[ourfetchClass valueForKey:@"lastname"] description];
            NSString *vargender = [[ourfetchClass valueForKey:@"gender"] description];
            NSString *varphone = [[ourfetchClass valueForKey:@"phone"] description];
            NSString *varfax = [[ourfetchClass valueForKey:@"fax"] description];
            NSString *varaddress1 = [[ourfetchClass valueForKey:@"address1"] description];
            NSString *varaddress2 = [[ourfetchClass valueForKey:@"address2"] description];
            NSString *varaddress3 = [[ourfetchClass valueForKey:@"address3"] description];
            NSString *vardeparment = [[ourfetchClass valueForKey:@"department"] description];
            NSString *varfacility = [[ourfetchClass valueForKey:@"facility"] description];
            NSString *varlang = [[ourfetchClass valueForKey:@"language"] description];
        
            if (varfirst == NULL) { varfirst = @".";}
            if (varlast == NULL) {varlast = @".";}
            if (vargender == NULL) {vargender = @"MALE";}
            if (varphone == NULL) {varphone = @" ";}
            if (varfacility == NULL) {varfacility = @" ";}
            if (varaddress1 == NULL) {varaddress1 = @" ";}
            if (varaddress2 == NULL) {varaddress2 = @" ";}
            if (varaddress3 == NULL) {varaddress3 = @" ";}
            if (vardeparment == NULL) {vardeparment = @" ";}
            if (varlang == NULL) {varlang = @"English";}
            
        
        
            NSString *longaddress_name = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                                     [[ourfetchClass valueForKey:@"facility"] description],
                                     [[ourfetchClass valueForKey:@"address1"] description],
                                     [[ourfetchClass valueForKey:@"city"] description],
                                     [[ourfetchClass valueForKey:@"province"] description],
                                     [[ourfetchClass valueForKey:@"postal"] description]];
        
            detailVC.currentHCPINFO = @[varfirst,
                              varlast,
                              @"DR",
                              vargender,
                              varlang,
                              varphone,
                              varfax,
                              longaddress_name,
                              @"Primary",
                              varfacility,
                              varaddress1,
                              varaddress2,
                              varaddress3,
                              [[ourfetchClass valueForKey:@"province"] description],
                              [[ourfetchClass valueForKey:@"city"] description],
                              [[ourfetchClass valueForKey:@"postal"] description],
                              vardeparment];

        
    }

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
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
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



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // cell.textLabel.text = [[object valueForKey:@"firstname"] description];
    cell.textLabel.Text = [[NSString stringWithFormat:@"%@, %@", [[object valueForKey:@"firstname"] description], [[object valueForKey:@"lastname"] description]] uppercaseString];
    
    cell.detailTextLabel.Text = [NSString stringWithFormat:@"%@ %@ %@",
                                 [[object valueForKey:@"city"] description],
                                 [[object valueForKey:@"province"] description],
    [[object valueForKey:@"postal"] description]];
    
    // cell.detailTextLabel.Text = [[object valueForKey:@"address1"] description];
}



@end
