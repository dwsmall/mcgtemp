//
//  HcpDetailController.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-06.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "HcpDetailController.h"

@interface HcpDetailController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end




@implementation HcpDetailController


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


// [NSPredicate predicateWithFormat:SUBQUERY(Product,$product,$product.allocation.prodid == %@).@count != 0",id]


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
            MRows=1;  
            break;

        case 2:
            
            //Address
            MRows=7;  //7
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
    
    
    // UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"_typeA"];
    
    // UILabel *Product = (UILabel *)[cell viewWithTag:8801];
    // [Product setText:@"TestX"];
    
    // return cell;
    
    
    NSString *MyFormType = @"_typeA";
    
    if ((indexPath.section == 0 && indexPath.row == 2) || indexPath.section == 1) {
        MyFormType = @"_typeB";
    }

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyFormType forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];

    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_typeB" forIndexPath:indexPath];
    // [self configureCell:cell atIndexPath:indexPath];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    // self.detailViewController.detailItem = object;
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
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
    // NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // cell.textLabel.text = [[object valueForKey:@"firstname"] description];
    
    
    // Set Vars
    NSString *varLeftTitle = @"Title1";
    NSString *varRightValue = @"Title2";
    NSString *varTitle1 = @"Title1";
    NSString *varText1 = @"Title2";
    NSString *varTitle2 = @"Title1";
    NSString *varText2 = @"Title2";
    NSString *varTitle3 = @"Title1";
    NSString *varText3 = @"Title2";

    
    
    switch (indexPath.section)
    
    {
        case 0:
            //Name
            if (indexPath.row == 0) {
                varLeftTitle = @"First Name:";
                varRightValue = @"David";
            }
            
            if (indexPath.row == 1) {
                varLeftTitle = @"Last Name:";
                varRightValue = @"Small";
            }
            
            if (indexPath.row == 2) {
                varTitle1 = @"Title:";
                varText1 = @"DR";
                varTitle2 = @"Gender:";
                varText2 = @"Male";
                varTitle3 = @"Lang:";
                varText3 = @"Francais";
            }
            break;
            
        case 1:
            
            //Communication
            if (indexPath.row == 0) {
                varTitle1 = @"Phone:";
                varText1 = @"999.999.9999";
                varTitle2 = @"Ext:";
                varText2 = @"xt. 222";
                varTitle3 = @"Fax:";
                varText3 = @"999.999.9999";
            }
            break;
            
        case 2:
            
            //Address
            if (indexPath.row == 0) {
                varLeftTitle = @"Facility Name:";
                varRightValue = @"MCG";
            }
            
            if (indexPath.row == 1) {
                varLeftTitle = @"AddressLine1:";
                varRightValue = @"123123.1232";
            }
           
            if (indexPath.row == 2) {
                varLeftTitle = @"AddressLine2:";
                varRightValue = @"123123.1232";
            }
            
            
            if (indexPath.row == 3) {
                varLeftTitle = @"AddressLine3:";
                varRightValue = @"123123.1232";
            }
            
            if (indexPath.row == 4) {
                varLeftTitle = @"Province:";
                varRightValue = @"123123.1232";
            }
            
            if (indexPath.row == 5) {
                varLeftTitle = @"City:";
                varRightValue = @"123123.1232";
            }
            
            if (indexPath.row == 6) {
                varLeftTitle = @"PostalCode:";
                varRightValue = @"123123.1232";
            }
            
            break;
            
        case 3:
            
            //Last 5 Orders
            if (indexPath.row == 0) {
                varLeftTitle = @"Load:";
                varRightValue = @"";
            }
            break;
            
    }
    
    
    
    
    
    
    if ((indexPath.section == 0 && indexPath.row == 2) || indexPath.section == 1) {
        
        //    [self configureCell:cell atIndexPath:indexPath];
        
        UILabel *Title1 = (UILabel *)[cell viewWithTag:8803];
        [Title1 setText:varTitle1];
        
        UILabel *Text1 = (UILabel *)[cell viewWithTag:8804];
        [Text1 setText:varText1];
        
        UILabel *Title2 = (UILabel *)[cell viewWithTag:8805];
        [Title2 setText:varTitle2];
        
        UILabel *Text2 = (UILabel *)[cell viewWithTag:8806];
        [Text2 setText:varText2];
        
        UILabel *Title3 = (UILabel *)[cell viewWithTag:8807];
        [Title3 setText:varTitle3];
        
        UILabel *Text3 = (UILabel *)[cell viewWithTag:8808];
        [Text3 setText:varText3];
        
        
        
    } else {
    
    
    UILabel *LeftTitle = (UILabel *)[cell viewWithTag:8801];
    [LeftTitle setText:varLeftTitle];
    
    UILabel *RightValue = (UILabel *)[cell viewWithTag:8802];
    [RightValue setText:varRightValue];
        
    }
    
}

@end
