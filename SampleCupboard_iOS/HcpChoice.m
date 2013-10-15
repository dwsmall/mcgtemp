//
//  HcpChoice.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "AppDelegate.h"

#import "OrderDetailViewController_iPad.h"
#import "HcpChoice.h"
#import "HealthCareProfessional.h"

@interface HcpChoice () <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *healthcareProf;

@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) NSFetchRequest *territoryFetchRequest;

@property (strong, nonatomic) NSFetchRequest *draftFetchRequest;

@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSArray *fsaFoundList;
@property (strong, nonatomic) NSArray *draftFoundList;


@property (strong, nonatomic) IBOutlet UISearchBar *topSearchBar;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation HcpChoice


@synthesize path;
@synthesize filteredList;
@synthesize fsaFoundList, draftFoundList;


@synthesize topSearchBar;


BOOL isSearching;


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // search
    
    [topSearchBar setShowsScopeBar:NO];
    [topSearchBar sizeToFit];
    
    
    //populate territories
    
    _territoryFetchRequest = [[NSFetchRequest alloc] init];
    _draftFetchRequest = [[NSFetchRequest alloc] init];
    
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TerritoryFSA" inManagedObjectContext:self.managedObjectContext];
    [_territoryFetchRequest setEntity:entity];
    
    
    NSEntityDescription *entityX = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:self.managedObjectContext];
    [_draftFetchRequest setEntity:entityX];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fsa" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_territoryFetchRequest setSortDescriptors:sortDescriptors];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}




#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
    {
        return [[self.fetchedResultsController sections] count];
        NSLog(@"tableView Alive Alive");
        

    }
    else
    {
        return 1;
        NSLog(@"tableView Did IT");
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
        return [self.filteredList count];
                NSLog(@"tableView Did IT - 2");
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"_hcplist" forIndexPath:indexPath];
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


/*
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
*/



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = nil;
    
    if (_tableView == self.tableView)
    {
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    else
    {
        NSError *error = nil;
        self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        
        object = [self.filteredList objectAtIndex:indexPath.row];
        
        NSLog(@"tableView Did IT - 3");
    }

     
    int adjHeight = 70;  // 2 Lines
    
    // facility - 3 Lines
    if ([[[object valueForKey:@"facility"] description] length] > 2) {
        adjHeight = 80;
    }

    // addressline2 - 4 Lines
    if ([[[object valueForKey:@"address2"] description] length] > 2) {
        adjHeight = 100;
    }
    
    // addressline3 - 5 Lines
    if ([[[object valueForKey:@"address3"] description] length] > 2) {
        adjHeight = 120;
    }
    
      // 3 lines
    return adjHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    path = indexPath;
    NSLog(@"index path for hcp_selection DID SELECT %i", path.row);
    
    checkedCell = indexPath;
    [tableView reloadData];
}


#pragma mark - Configure Cell

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *object = nil;
    
    if (_tableView == self.tableView)
    {
        object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    else
    {
        NSError *error = nil;
        self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        
        object = [self.filteredList objectAtIndex:indexPath.row];
        
        NSLog(@"tableView Did IT - 3");
    }
    
    
    cell.textLabel.Text = [[NSString stringWithFormat:@"%@, %@", [[object valueForKey:@"lastname"] description], [[object valueForKey:@"firstname"] description]] uppercaseString];
    
    
    // populate 4 column
    
    NSMutableString *address = [NSMutableString string];
    
    if ([[object valueForKey:@"facility"] description].length > 2) {
        [address appendString:[[object valueForKey:@"facility"] description]];
        [address appendString:@" \n"];
    }
    
    if ([[object valueForKey:@"address1"] description].length > 2) {
        [address appendString:[[object valueForKey:@"address1"] description]];
        [address appendString:@" \n"];
    }
    
    if ([[object valueForKey:@"address2"] description].length > 2) {
        [address appendString:[[object valueForKey:@"address2"] description]];
        [address appendString:@" \n"];
    }
    
    if ([[object valueForKey:@"address3"] description].length > 2) {
        [address appendString:[[object valueForKey:@"address3"] description]];
        [address appendString:@" \n"];
    }
    
    
    NSString *AddressBuilder = [NSString stringWithFormat:@"%@ %@,%@,%@",
                                address,
                                [[object valueForKey:@"city"] description],
                                [[object valueForKey:@"province"] description],
                                [[object valueForKey:@"postal"] description]];
    
    
    cell.detailTextLabel.Text = AddressBuilder;
    
    
    NSLog(@"dw1 - show addressBuilder:%@", AddressBuilder);
    
    
    
    /*
    cell.detailTextLabel.Text = [NSString stringWithFormat:@"%@ \n %@ %@ %@ \n %@ %@ %@",
                                 [[object valueForKey:@"facility"] description],
                                 [[object valueForKey:@"address1"] description],
                                 [[object valueForKey:@"address2"] description],
                                 [[object valueForKey:@"address3"] description],
                                 [[object valueForKey:@"city"] description],
                                 [[object valueForKey:@"province"] description],
                                 [[object valueForKey:@"postal"] description]];
     */
    
    
}







#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Delete Cache
    [NSFetchedResultsController deleteCacheWithName:@"HCPChoice"];
    
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    // NSManagedObjectContext *context = [self managedObjectContext];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HealthCareProfessional" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastname" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    // set predicate
    NSPredicate *predicate = nil;
    NSString *searchtxt = topSearchBar.text;
    
    NSLog(@"dw1 - my selected ScopeButton:%ld", (long)topSearchBar.selectedScopeButtonIndex);
    
    
    if (searchtxt.length > 0) {
        
        switch (topSearchBar.selectedScopeButtonIndex) {
                
            case 1:
                // scope name
                predicate = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@", searchtxt, searchtxt];
                NSLog(@"dw1 - show predicate 1 %@" , predicate);
                [fetchRequest setPredicate:predicate];
                break;
            
            case 2:
                // scope address
                predicate = [NSPredicate predicateWithFormat:@"facility contains[cd] %@ OR address1 contains[cd] %@ OR address2 contains[cd] %@ OR address3 contains[cd] %@ OR city contains[cd] %@ OR province contains[cd] %@ OR postal contains[cd] %@", searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt];
                NSLog(@"dw1 - show predicate 3 address: %@" , predicate);
                [fetchRequest setPredicate:predicate];
                break;
                
            case 3:
                // scope postal
                predicate = [NSPredicate predicateWithFormat:@"postal contains[cd] %@", searchtxt];
                NSLog(@"dw1 - show predicate 2 %@" , predicate);
                [fetchRequest setPredicate:predicate];
                break;                
            
            case 4:
                // scope phone
                predicate = [NSPredicate predicateWithFormat:@"phone contains[cd] %@", searchtxt];
                NSLog(@"dw1 - show predicate 4 %@" , predicate);
                [fetchRequest setPredicate:predicate];
                break;
                
            default:
                predicate = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR facility contains[cd] %@ OR address1 contains[cd] %@ OR address2 contains[cd] %@ OR address3 contains[cd] %@ OR city contains[cd] %@ OR province contains[cd] %@ OR postal contains[cd] %@", searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt];
                NSLog(@"dw1 - show predicate 5 %@" , predicate);
                [fetchRequest setPredicate:predicate];
                break;
        }
        
    }
    
    
    
    
    
    
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













#pragma mark - Search Delegate


- (void)searchForText:(NSString *)searchText
{
    /*
    if (self.managedObjectContext)
    {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"lastname";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.territoryFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.filteredList = [self.managedObjectContext executeFetchRequest:self.territoryFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    }
    */
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"dw1 - show reaction %@" , topSearchBar.text);
    
    [NSFetchedResultsController deleteCacheWithName:@"HCPChoice"];
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
    
    [NSFetchedResultsController deleteCacheWithName:@"HCPChoice"];
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];
}






#pragma mark - Segue Delegates



// segue validation (should I segue or not ?)

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    
    // resign kb incase user left open
    [topSearchBar resignFirstResponder];
    
    
    if ([[identifier description] isEqualToString:@"_chosehcp_done"]) {
        
        
        NSError *error = nil;
        
        // check if existing draft exists with hcp
        HealthCareProfessional *hcpfetchClassX = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:checkedCell.row inSection:0]];
        
        // NSString *hcpid = [[hcpfetchClassX valueForKey:@"identitymanagerid"] description];
        NSString *current_shiptoid = [[hcpfetchClassX valueForKey:@"shiptoaddressid"] description];
        
        // check core data for shiptoid (of draft order)
        NSPredicate *predicateX = [NSPredicate predicateWithFormat:@"projectcode = %@ AND shiptoid contains[c] %@",
                                  @"DRAFT", current_shiptoid];
        
        [self.draftFetchRequest setPredicate:predicateX];
        
        NSLog(@"dw1 SHOWX: %@, %@", current_shiptoid, predicateX);
        
        
        error = nil;
        
        id appDelegateX = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegateX managedObjectContext];
        
        self.draftFoundList = [self.managedObjectContext executeFetchRequest:self.draftFetchRequest error:&error];
        if (error)
        {
            NSLog(@"draftFetchRequest failed: %@",[error localizedDescription]);
        }
        
        // stop if draft found
        if ([self.draftFoundList count] > 0) {
            
            // msg
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HCP Cannot Be Selected"
                                                            message:@"A Current Draft Is In Progress for this HCP."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            // cancel request
            return NO;
            
            
        }
        
        
        
        
        
        // check if fsa in territory
        HealthCareProfessional *hcpfetchClass = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:checkedCell.row inSection:0]];
        
        NSString *strpostal = [[hcpfetchClass valueForKey:@"postal"] description];
        
        
        // check core data for fsa (which territories it exists)
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fsa contains[c] %@) OR (fsa contains[c] %@)",
                                strpostal, [strpostal substringToIndex:3]];
        
        [self.territoryFetchRequest setPredicate:predicate];
        
        error = nil;
        
            id appDelegate = (id)[[UIApplication sharedApplication] delegate];
            self.managedObjectContext = [appDelegate managedObjectContext];
        
        self.fsaFoundList = [self.managedObjectContext executeFetchRequest:self.territoryFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
        
        // set territoryID based on result
        if ([self.fsaFoundList count] > 0) {
            
            // set territory of first index
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            
            // check/show msg for differing territory
            
            if (![[defaults valueForKey:@"MCG_territoryid"] isEqualToString:[[self.fsaFoundList objectAtIndex:0]  valueForKey:@"territory_id"]] && [[defaults valueForKey:@"MCG_territoryid"]length] > 1) {
                
                
                // reset product/screen values
                
                AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                app.globalProductChosen = nil;
                app.globalProductsScrn = [[NSMutableArray alloc] init];
                app.globalProductsRmv = [[NSMutableArray alloc] init];
                
                // remove existing values
                
                
                
                
                
                // show msg on order screen
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New HCP Territory Selected"
                                                                message:@"This has reset previous products/qty's"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
                // total reset of existing values
                [defaults setValue:nil forKey:@"MCG_productandqty"];
                [defaults setValue:nil forKey:@"MCG_detail_products"];
                
            }
            
            
            // update territory            
            [defaults setObject:[[self.fsaFoundList objectAtIndex:0]  valueForKey:@"territory_id"] forKey:@"MCG_territoryid"];
            
            
            
            
            
            
            
        } else {
            
            // show error msg
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid HCP Selection"
                                                        message:@"This HCP is not available in your territory."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
             [alert show];
        
            
            
              // cancel request
              return NO;
        }
        
        
    }
    
    return YES;
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    // done button pressed
    
    if ([[segue identifier] isEqualToString:@"_chosehcp_done"]) {
        
        
        if (self.searchDisplayController.isActive)
        {
            NSLog(@"Search is Active");
            
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
            NSLog(@"Search Index %@" , indexPath);
            
        }
        else
        {   
            // set value in app delegate
            
            AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            app.globalHcpChosen = @"NEW";
            
            OrderDetailViewController_iPad *ourfetchClass = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:checkedCell.row inSection:0]];
            
            app.globalHcpDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"firstname"] description]], @"firstname",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"lastname"] description]], @"lastname",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"facility"] description]], @"facility",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"address1"] description]], @"address1",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"address2"] description]], @"address2",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"address3"] description]], @"address3",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"province"] description]], @"province",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"city"] description]], @"city",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"postal"] description]] , @"postal",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"status"] description]], @"status",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"phone"] description]], @"phone",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"fax"] description]], @"fax",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"email"] description]], @"email",
                                       [self stringOrEmptyString:[[ourfetchClass valueForKey:@"shiptoaddressid"] description]], @"shiptoaddressid",
                                       nil];
            
            
            NSLog(@"dw1 - forward marchA:%@", [[ourfetchClass valueForKey:@"status"] description] );
            NSLog(@"dw1 - forward marchB:%@", [[ourfetchClass valueForKey:@"phone"] description] );
            NSLog(@"dw1 - forward marchC:%@", [[ourfetchClass valueForKey:@"fax"] description] );
            NSLog(@"dw1 - forward marchD:%@", [[ourfetchClass valueForKey:@"email"] description] );
            NSLog(@"dw1 - forward marchE:%@", [[ourfetchClass valueForKey:@"shiptoaddressid"] description] );
            
            NSLog(@"dw1 - forward march2:%@", app.globalHcpDictionary );
            
            
            
            /*
            // Get destination view
            OrderDetailViewController_iPad *vc = [segue destinationViewController];
            [vc setSelectedHCPNUMBER:1001];           
            
            [vc setMoHCPDATA:[[self.fetchedResultsController fetchedObjects] objectAtIndex:checkedCell.row]];
            
     
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
            
            
            NSString *shorthcp_name = [NSString stringWithFormat:@"%@, %@",
                                          [[ourfetchClass valueForKey:@"lastname"] description],
                                          [[ourfetchClass valueForKey:@"firstname"] description]];
            
            
            
            NSMutableString *address = [NSMutableString string];
            
            if ([[ourfetchClass valueForKey:@"facility"] description].length > 2) {
                [address appendString:[[ourfetchClass valueForKey:@"facility"] description]];
                [address appendString:@" \n"];
            }
            
            if ([[ourfetchClass valueForKey:@"address1"] description].length > 2) {
                [address appendString:[[ourfetchClass valueForKey:@"address1"] description]];
                [address appendString:@" \n"];
            }
            
            if ([[ourfetchClass valueForKey:@"address2"] description].length > 2) {
                [address appendString:[[ourfetchClass valueForKey:@"address2"] description]];
                [address appendString:@" \n"];
            }
            
            if ([[ourfetchClass valueForKey:@"address3"] description].length > 2) {
                [address appendString:[[ourfetchClass valueForKey:@"address3"] description]];
                [address appendString:@" \n"];
            }
            
            
            NSString *longaddress_name = [NSString stringWithFormat:@"%@ %@,%@,%@",
                                        address,
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
                                        [[ourfetchClass valueForKey:@"postal"] description],
                                        [[ourfetchClass valueForKey:@"shiptoaddressid"] description]];
         */
            
            
            
        }
        
    }
    
    
        
        
    // User Cancelled Selection
    if ([[segue identifier] isEqualToString:@"_chosehcp_cancel"]) {
        
        
    }
}


#pragma mark - utillities

- (NSString *)stringOrEmptyString:(NSString *)string
{
    if (string)
        return string;
    else
        return @" ";
}


@end
