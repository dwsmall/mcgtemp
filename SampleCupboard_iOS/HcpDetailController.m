//
//  HcpDetailController.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-06.
//  Copyright (c) 2013 MCG. All rights reserved.
//



#import "HcpAdditionalDetails.h"

#import "HcpDetailController.h"

@interface HcpDetailController ()

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)return:(UIStoryboardSegue *)segueX;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end




@implementation HcpDetailController

@synthesize selectedHCPINDEX;
@synthesize selectedHCPNUMBER;
@synthesize selectedHCPMSG;
@synthesize currentHCPINFO;
// @synthesize currentHCPARRAY;



-(IBAction)return:(UIStoryboardSegue *)segueX{
    
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


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return [[self.fetchedResultsController sections] count];
    return 4;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *HeaderTitle = @"Default";
    
    switch (section)
    
    {
        case 0:
            
            HeaderTitle = @"Name";
            break;
            
        case 1:
            
            HeaderTitle = @"Communication";
            break;
            
        case 2:
            
            HeaderTitle = @"Address";
            break;
        
        case 3:
            
            HeaderTitle = @"Last 5 Orders";
            break;
            
        default:
            
            HeaderTitle = @"Info";
            break;
            
    }
            
    return HeaderTitle;
            
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    // return [sectionInfo numberOfObjects];
    
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
            MRows=1;
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
        MyFormType = @"_typeB";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyFormType forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"_additionalhcp"]) {
        
        HcpAdditionalDetails *extVC = (HcpAdditionalDetails *)[segue destinationViewController];
        extVC.currentHCPINFOEXT = currentHCPINFO;
        
    }
    
}






- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    
    switch (indexPath.section)
    
    {
        case 0:
            //Name
            if (indexPath.row == 0) {
                // cell.textLabel.text = @"First Name:";
                cell.textLabel.text = @"First Name:";
                cell.detailTextLabel.text = currentHCPINFO[0];
            }
            
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Last Name:";
                cell.detailTextLabel.text = currentHCPINFO[1];
            }
            
            if (indexPath.row == 2) {
                cell.textLabel.text = @"Title:";
                cell.detailTextLabel.text = currentHCPINFO[2];
            }
            
            if (indexPath.row == 3) {
                cell.textLabel.text = @"Gender:";
                cell.detailTextLabel.text = currentHCPINFO[3];
            }
            
            if (indexPath.row == 4) {
                cell.textLabel.text = @"Language:";
                cell.detailTextLabel.text = currentHCPINFO[4];
            }
            break;
            
        case 1:
            
            //Communication
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Telephone:";
                cell.detailTextLabel.text = currentHCPINFO[5];
            }
            
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Fax:";
                cell.detailTextLabel.text = currentHCPINFO[6];
            }
            break;
            
        case 2:
            
            //Address
            if (indexPath.row == 0) {
                cell.textLabel.text = currentHCPINFO[7];
            }
            
            break;
            
        case 3:
            
            //Last 5 Orders
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Load";            }
            break;
    }
    
    
}

@end
