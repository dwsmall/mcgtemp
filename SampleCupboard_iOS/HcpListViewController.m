//
//  HcpListViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "HcpDetailController.h"
#import "HcpListViewController.h"
#import "Hcp+Extensions.h"


@interface HcpListViewController () <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UINavigationItem *hcpTitleBar;
  
    @property (weak, nonatomic) IBOutlet UINavigationItem *healthcareProf;
    @property (strong, nonatomic) IBOutlet UITableView *tableView;

    @property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
    @property (strong, nonatomic) NSArray *filteredList;

@property (strong, nonatomic) IBOutlet UISearchBar *topSearchBar;

    //Configure Cell
    -(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

    //Segue Exit
    -(IBAction)return:(UIStoryboardSegue *)segue;

@end



@implementation HcpListViewController


@synthesize filteredList;
@synthesize topSearchBar;



-(IBAction)return:(UIStoryboardSegue *)segue{
}





#pragma mark - ViewDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [topSearchBar setShowsScopeBar:NO];
    [topSearchBar sizeToFit];
    
    [self.tableView reloadData];
    
    _hcpTitleBar.title = NSLocalizedString(@"Healthcare Professionals", nil);
    
    topSearchBar.scopeButtonTitles = @[NSLocalizedString(@"All", nil), NSLocalizedString(@"Name",nil), NSLocalizedString(@"Postal Code",nil), NSLocalizedString(@"Address",nil), NSLocalizedString(@"Phone", nil)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"_push_to_hcpdetails"]) {
        
        
        // Step 1 - Declare VC Controller
        HcpDetailController *detailVC = (HcpDetailController *)[segue destinationViewController];
        
        
            // second screen
        
            NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
            [detailVC setMoDATAHCP:[self.fetchedResultsController objectAtIndexPath:ip]];
        
            
            // third screen
        
            HcpListViewController *ourfetchClass = [[self fetchedResultsController]objectAtIndexPath:[NSIndexPath indexPathForRow:ip.row inSection:ip.section]];
            
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






#pragma mark - TableView Delegate Methods

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    // NSArray *indexArray = [NSArray arrayWithObjects: @"{search}", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",@"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    // return indexArray;
    
    if (tableView == self.tableView)
    {
        // return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        NSArray *initials = [self.fetchedResultsController sectionIndexTitles];
        [index addObjectsFromArray:initials];
        return index;
    }
    else
    {
        return nil;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    
    if (tableView == self.tableView)
    {
        if (index > 0)
        {
            // The index is offset by one to allow for the extra search icon inserted at the front
            // of the index
            
            return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index-1];
        }
        else
        {
            // The first entry in the index is for the search icon so we return section not found
            // and force the table to scroll to the top.
            
            self.tableView.contentOffset = CGPointZero;
            return NSNotFound;
        }
    }
    else
    {
        return 0;
    }

    
  
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    }
    else
    {
        return nil;
    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == self.tableView)
    {
        return [[self.fetchedResultsController sections] count];
    }
    else
    {
        return 1;
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
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"_hcplist" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // NSLog(@"Did Select Row %ld", (long)indexPath.row);
    // ChosenRowNumber = indexPath.row;
    
}

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
        
    }
    
    
    cell.textLabel.Text = [[NSString stringWithFormat:@"%@, %@", [[object valueForKey:@"lastname"] description], [[object valueForKey:@"firstname"] description]] uppercaseString];
    
    
    cell.detailTextLabel.Text = [NSString stringWithFormat:@"%@ %@ %@",
                                 [[object valueForKey:@"city"] description],
                                 [[object valueForKey:@"province"] description],
                                 [[object valueForKey:@"postal"] description]];
    
}




#pragma mark - SearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [NSFetchedResultsController deleteCacheWithName:@"OrderList"];
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
    
    [NSFetchedResultsController deleteCacheWithName:@"hcplist"];
    _fetchedResultsController=nil;
    
    [self.tableView reloadData];
}







#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
        
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HealthCareProfessional" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastname" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // set predicate
    NSPredicate *predicate = nil;
    NSString *searchtxt = topSearchBar.text;
    
    if (searchtxt.length > 0) {
        
    switch (topSearchBar.selectedScopeButtonIndex) {

        case 1:
            // scope name
            predicate = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@", searchtxt, searchtxt];
            [fetchRequest setPredicate:predicate];
            break;
            
        case 2:
            // scope postal
            predicate = [NSPredicate predicateWithFormat:@"postal contains[cd] %@", searchtxt];
            [fetchRequest setPredicate:predicate];
            break;
            
        case 3:
            // scope address
            predicate = [NSPredicate predicateWithFormat:@"facility contains[cd] %@ OR address1 contains[cd] %@ OR address2 contains[cd] %@ OR address3 contains[cd] %@ OR city contains[cd] %@ OR province contains[cd] %@ OR postal contains[cd] %@", searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt];
            [fetchRequest setPredicate:predicate];
            break;
        case 4:
            // scope phone
            predicate = [NSPredicate predicateWithFormat:@"phone contains[cd] %@", searchtxt];
            [fetchRequest setPredicate:predicate];
            break;
            
        default:
            predicate = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR facility contains[cd] %@ OR address1 contains[cd] %@ OR address2 contains[cd] %@ OR address3 contains[cd] %@ OR city contains[cd] %@ OR province contains[cd] %@ OR postal contains[cd] %@", searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt, searchtxt];
            [fetchRequest setPredicate:predicate];
            break;
    }
        
    }
    
    
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:@"sectionTitle"
                                                                                     cacheName:nil];
    
    
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



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}


#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}





@end
