//
//  ReportDetails.m
//  SampleCupboard_iOS
//
//  Created by David Small on 8/29/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "Allocation.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ReportMenu.h"

#import "ReportDetails.h"





@interface ReportDetails () <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (strong, nonatomic) IBOutlet UILabel *SelectAReport;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *myReportTitle;


@property (nonatomic) NSString *urlsvc;
@property (nonatomic) NSString *baseurl;
@property (nonatomic) NSString *urluserid;
@property (nonatomic) NSString *urltoken;
@property (nonatomic) NSURL *url;


@end

@implementation ReportDetails

@synthesize tableView;

@synthesize countFromJSON;
@synthesize storeRcdsJSON;

@synthesize arraySectionCount;


@synthesize myReportTitle;

@synthesize urlsvc, baseurl, urluserid, urltoken, url;


#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"RefreshList" object:nil];
    
    self.splitViewController.delegate = self;
    
    
    // default title
    myReportTitle.text = NSLocalizedString(@"Reports", nil);
    
    
}



-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshList" object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Rotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}



#pragma mark - Choose Report

-(void) refresh {
    
    
    
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    
    
    // Get Data Based On Rpt Selected
    
    int activeRpt = [[ReportMenu globRptChoice] integerValue];
    
    
    
    if (activeRpt > 0) {
        
        // select a Report
        _SelectAReport.text = @"";
        
        myReportTitle.text = @"";
        
    }
    
    
    
    
    switch (activeRpt)
    
    {
        case 0:
            
            [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading Usage...", nil) maskType:SVProgressHUDMaskTypeGradient];
            
            [self performSelectorInBackground:@selector(getUsageData) withObject:nil];
            
            myReportTitle.text = NSLocalizedString(@"My Usage", nil);
            
            break;
            
        case 1:
            
            [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading Allocation...", nil) maskType:SVProgressHUDMaskTypeGradient];
            
            if (internetStatus != NotReachable) {
                
                // remove allocation
                [self performSelectorOnMainThread:@selector(removeEntities) withObject:nil waitUntilDone:YES];
                
                // update database
                [self performSelectorOnMainThread:@selector(getAllocationDetailData) withObject:nil waitUntilDone:YES];
                
            }
            
            // Online ???
            [self performSelectorOnMainThread:@selector(getAllocationData2) withObject:nil waitUntilDone:YES];
            
            myReportTitle.text = NSLocalizedString(@"Territory Allocation", nil);
            
            
            break;
            
        case 2:
            
            [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading Team...",nil) maskType:SVProgressHUDMaskTypeGradient];
           
            [self performSelectorInBackground:@selector(getMyTeamData) withObject:nil];
            
            myReportTitle.text = NSLocalizedString(@"My Team", nil);
            
            break;
    }
    
    
}








#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        
    int SECTIONS = 0;
    
    SECTIONS = [[NSMutableSet setWithArray: arraySectionCount] count];
    
    return SECTIONS;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    // every rpt uses this to determine rows based on section
    // int activeRpt = [[ReportMenu globRptChoice] integerValue];

    
    int ROWS = 0;
    
        // get territoryid
        NSString *territoryid = [arraySectionCount objectAtIndex:section];
    
    
        // apply filter based on territory
        NSMutableArray *filterResults = [[NSMutableArray alloc] init];
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"territoryid = %@", territoryid];
        [filterResults addObjectsFromArray:[storeRcdsJSON filteredArrayUsingPredicate:p]];
    
    
        ROWS = [filterResults count];

    
    
    return ROWS;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    
    
    NSString *HeaderTitle = @"";
    
    /*
     int activeRpt = [[ReportMenu globRptChoice] integerValue];
     -- could use switch to differentiate
     */
    
        
    if (arraySectionCount) {
        HeaderTitle = [arraySectionCount objectAtIndex:section];
    }    
    
    
    return HeaderTitle;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int activeRpt = [[ReportMenu globRptChoice] integerValue];
    
    NSString *MyFormType = @"_Level1";
    
    
    // my usage
    
    if ( activeRpt == 0 ) {
        
        MyFormType = @"_Level1";  // my team
        
    }
    
    
 
    // my allocation
    
    if ( activeRpt == 1 ) {
        
        // get objects based on section
        NSString *territoryid = [arraySectionCount objectAtIndex:indexPath.section];
  
        
        NSMutableArray *myfilteredArray = [[NSMutableArray alloc] init];
        
        
        // filter array
        NSPredicate *p2 = [NSPredicate predicateWithFormat:@"territoryid = %@", territoryid];
        [myfilteredArray addObjectsFromArray:[storeRcdsJSON filteredArrayUsingPredicate:p2]];
        
        // sort array
        NSSortDescriptor *typeDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"type"
                                            ascending:YES
                                            selector:@selector(caseInsensitiveCompare:)];
        
        NSSortDescriptor *prodnameDescriptor = [NSSortDescriptor
                                                sortDescriptorWithKey:@"ProductName"
                                                ascending:YES
                                                selector:@selector(caseInsensitiveCompare:)];
        
        
        NSArray *descriptors2 = @[typeDescriptor, prodnameDescriptor];
        [myfilteredArray sortUsingDescriptors:descriptors2];
        
        
        // default
        
        MyFormType = @"_Allocation";
        
        
        // change if header
        
        if ([myfilteredArray count] > 0) {
            
            NSDictionary *extractArray = [myfilteredArray objectAtIndex:indexPath.row];
            
            if ([[extractArray objectForKey:@"type"] isEqualToString:@"TYPEH"]) {
            
                MyFormType = @"_AllocationHeader";
                
            }
            
        }
        
        
        
    }
    
    if ( activeRpt == 2 ) {
        MyFormType = @"_Level1";  // my team
    }
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyFormType forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *territoryid = @"";
    
    int activeRpt = [[ReportMenu globRptChoice] integerValue];
    
    NSMutableArray *myfilteredArray = nil;
    
 
    
    switch (activeRpt)
    
    {
        case 0: //my usage
        {
            
            // get objects based on section
            territoryid = [arraySectionCount objectAtIndex:indexPath.section];
            
            myfilteredArray = [[NSMutableArray alloc] init];
            
            
            // filter array
            
            NSPredicate *p0 = [NSPredicate predicateWithFormat:@"territoryid = %@", territoryid];
            [myfilteredArray addObjectsFromArray:[storeRcdsJSON filteredArrayUsingPredicate:p0]];
            
            
            // sort array
            
            NSSortDescriptor *typeDescriptor = [NSSortDescriptor
                                                sortDescriptorWithKey:@"type"
                                                ascending:YES
                                                selector:@selector(caseInsensitiveCompare:)];
            
            NSArray *descriptors2 = @[typeDescriptor];
            [myfilteredArray sortUsingDescriptors:descriptors2];
            
            
            // get allocation by territory
            
            if ([myfilteredArray count] > 0) {
                
                NSDictionary *extractArray = [myfilteredArray objectAtIndex:indexPath.row];

                cell.textLabel.text = [extractArray objectForKey:@"YTD"];
                cell.detailTextLabel.text = [[extractArray objectForKey:@"YTDUsage"] description];
                
            }
            
        }
        break;
            
        case 1: // territory allocation            
        {
            territoryid = [arraySectionCount objectAtIndex:indexPath.section];
            
            myfilteredArray = [[NSMutableArray alloc] init];
            
            
            // filter array
            
            NSPredicate *p2 = [NSPredicate predicateWithFormat:@"territoryid = %@", territoryid];
            [myfilteredArray addObjectsFromArray:[storeRcdsJSON filteredArrayUsingPredicate:p2]];
            
            // sort array
            
            NSSortDescriptor *typeDescriptor = [NSSortDescriptor
                                                    sortDescriptorWithKey:@"type"
                                                    ascending:YES
                                                    selector:@selector(caseInsensitiveCompare:)];
            
            NSSortDescriptor *prodnameDescriptor = [NSSortDescriptor
                                                    sortDescriptorWithKey:@"ProductName"
                                                    ascending:YES
                                                    selector:@selector(caseInsensitiveCompare:)];
           
            
            NSArray *descriptors2 = @[typeDescriptor, prodnameDescriptor];
            [myfilteredArray sortUsingDescriptors:descriptors2];
            
            
            // get allocation by territory
            
            if ([myfilteredArray count] > 0) {
                
                NSDictionary *extractArray = [myfilteredArray objectAtIndex:indexPath.row];
                
                if ([[extractArray objectForKey:@"type"] isEqualToString:@"TYPEH"]) {
                    
                    [(UILabel *)[cell viewWithTag:201] setText:[extractArray objectForKey:@"ProductName"]]; //product
                    [(UILabel *)[cell.textLabel viewWithTag:201] setTextColor:[UIColor blueColor]];
                    
                    [(UILabel *)[cell viewWithTag:202] setText:[extractArray objectForKey:@"Total"]]; //total
                    [(UILabel *)[cell.textLabel viewWithTag:202] setTextColor:[UIColor blueColor]];
                    
                    [(UILabel *)[cell viewWithTag:203] setText:[extractArray objectForKey:@"Used"]]; //used
                    [(UILabel *)[cell.textLabel viewWithTag:203] setTextColor:[UIColor blueColor]];
                    
                    [(UILabel *)[cell viewWithTag:204] setText:[extractArray objectForKey:@"Percentage"]]; //pct
                    [(UILabel *)[cell.textLabel viewWithTag:204] setTextColor:[UIColor blueColor]];
                    
                    [(UILabel *)[cell viewWithTag:205] setText:[extractArray objectForKey:@"Stock"]]; //stock
                    [(UILabel *)[cell.textLabel viewWithTag:205] setTextColor:[UIColor blueColor]];
                    
                    // cell.backgroundColor = [UIColor lightGrayColor];
                    cell.backgroundColor = [UIColor lightTextColor];
                    
                    
                    
                } else {
                    
                    [(UILabel *)[cell viewWithTag:101] setText:[extractArray objectForKey:@"ProductName"]]; //product
                    [(UILabel *)[cell viewWithTag:102] setText:[[extractArray objectForKey:@"Total"] description]]; //total
                    [(UILabel *)[cell viewWithTag:103] setText:[[extractArray objectForKey:@"Used"] description]]; //used
                    [(UILabel *)[cell viewWithTag:104] setText:[[extractArray objectForKey:@"Percentage"] description]]; //pct
                    [(UILabel *)[cell viewWithTag:105] setText:[[extractArray objectForKey:@"Stock"] description]]; //stock
                }
            }
            
            
            
        }
        break;
            
        case 2:  // my team
        {
            
            // get objects based on section
            
            territoryid = [arraySectionCount objectAtIndex:indexPath.section];
            
            myfilteredArray = [[NSMutableArray alloc] init];
            
            
            // filter array
            
            NSPredicate *p3 = [NSPredicate predicateWithFormat:@"territoryid = %@", territoryid];
            [myfilteredArray addObjectsFromArray:[storeRcdsJSON filteredArrayUsingPredicate:p3]];
            
            
            // sort array
            
            NSSortDescriptor *nameDescriptor = [NSSortDescriptor
                                                 sortDescriptorWithKey:@"Name"
                                                 ascending:YES
                                                 selector:@selector(compare:)];
            NSSortDescriptor *phoneDescriptor = [NSSortDescriptor
                                                 sortDescriptorWithKey:@"Phone"
                                                 ascending:YES
                                                 selector:@selector(caseInsensitiveCompare:)];
            
            NSArray *descriptors3 = @[nameDescriptor, phoneDescriptor];
            [myfilteredArray sortUsingDescriptors:descriptors3];
            
            
            // get team members by territory
            
            if ([myfilteredArray count] > 0) {
                
                
                NSDictionary *extractArray = [myfilteredArray objectAtIndex:indexPath.row];
                
                    cell.textLabel.text = [[NSString stringWithFormat:@"%@", [extractArray objectForKey:@"Name"]] uppercaseString];
                    cell.detailTextLabel.text = [[self stringOrEmptyString:[extractArray objectForKey:@"Phone"]] uppercaseString];
            }
        }
        break;
            
    } //switch

 
    
    
}


 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return NO;
 }





#pragma mark - JSON Data Feed

- (void)getUsageData {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    
    storeRcdsJSON = [[NSMutableArray alloc] init];
    arraySectionCount = [[NSMutableArray alloc] init];
    
    
    urluserid = app.globalUserID;
    urltoken = app.globalToken;
    baseurl = app.globalBaseUrl;
    
    url = [NSURL URLWithString:@""];
    urlsvc = @"TBD";
    urlsvc = @"GetUsageReportData";
    
    
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    
    // NSLog(@"dw1 - show url %@", url);
    
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    [SVProgressHUD showWithStatus:@"Completing Process..."];
    
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        
        // step.1 - serialize object to data
        
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        
        // convert to dictionary
        
        NSDictionary* dicUSAGE = [dictContainer objectForKey:@"GetUsageReportDataResult"];
        
        NSArray* arrUSAGE = [dictContainer objectForKey:@"GetUsageReportDataResult"];
        
        
        for (int i=0;i<[dicUSAGE count];i++) {
            
            // move array value to dictionary
            
            NSDictionary* dictItems = [arrUSAGE objectAtIndex:i];
                  
            
            // add YTD
            
            NSDictionary *arrayHolderDict = [[NSDictionary alloc] init];
            
            arrayHolderDict = @{@"type": @"_Level1",
                                @"territoryid": [self stringOrEmptyString:[[dictItems objectForKey:@"ProductName"] description]],
                                @"YTD": @"YTD",
                                @"YTDUsage": [self stringOrEmptyString:[dictItems objectForKey:@"YTDusage"]]
                                };
            
            
            [storeRcdsJSON addObject:arrayHolderDict];
            
            
            
            
            // add CURRENT
            
            arrayHolderDict = [[NSDictionary alloc] init];
            
            arrayHolderDict = @{@"type": @"_Level2",
                                @"territoryid": [self stringOrEmptyString:[[dictItems objectForKey:@"ProductName"] description]],
                                @"YTD": [self stringOrEmptyString:[dictItems objectForKey:@"CurrentAllocationName"]],
                                @"YTDUsage": [self stringOrEmptyString:[dictItems objectForKey:@"CurrentAllocationUsage"]]
                                };
            
            [storeRcdsJSON addObject:arrayHolderDict];
            
            
            // add MONTHLY
            
            NSArray *arrMonthly = [dictItems objectForKey:@"MonthUsage"];
            
            for (int x=0;x<[arrMonthly count];x++) {
                
                // break down data
                NSDictionary *myMonthData = [arrMonthly objectAtIndex:x];
                
                NSString *monthName = [myMonthData objectForKey:@"MonthName"];
                NSString *monthUsage = [myMonthData objectForKey:@"MonthUsage"];
                
                arrayHolderDict = [[NSDictionary alloc] init];
                
                arrayHolderDict = @{@"type": @"_Level3",
                                    @"territoryid": [self stringOrEmptyString:[[dictItems objectForKey:@"ProductName"] description]],
                                    @"YTD": [self stringOrEmptyString:monthName],
                                    @"YTDUsage": [self stringOrEmptyString:monthUsage]
                                    };
                
                [storeRcdsJSON addObject:arrayHolderDict];
                
            }
            
        
            [arraySectionCount addObject:[[dictItems objectForKey:@"ProductName"] description]];
            
            
            
            
        } // End of For
            
        
        
    }  // End of Allocation
    


    if ([storeRcdsJSON count] > 0) {
        [self performSelectorOnMainThread:@selector(dismissSuccess) withObject:nil waitUntilDone:YES];
        
    } else {
        [self performSelectorOnMainThread:@selector(dismissNoRecords) withObject:nil waitUntilDone:YES];
        
    }

    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    

    
}


- (void)getAllocationData2 {
    
    storeRcdsJSON = [[NSMutableArray alloc] init];
    arraySectionCount = [[NSMutableArray alloc] init];
    
    NSString *territoryid = @"";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSString *entityName = @"Allocation";
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"territoryname" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"productname" ascending:YES];
    NSArray *sortDescriptorA = @[sortDescriptor, sortDescriptor2];
    
    [request setSortDescriptors:sortDescriptorA];
    
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
    for (Allocation *alloc in objects) {
        
        
        // add territory
        if (![territoryid isEqualToString:[alloc valueForKey:@"territoryname"]]) {
            
            // add new territory
            territoryid = [alloc valueForKey:@"territoryname"];
            
            [arraySectionCount addObject:territoryid];
        
            NSDictionary *arrayHolderDict = [[NSMutableDictionary alloc] init];
        
            arrayHolderDict = @{@"type": @"TYPEH",
                            @"territoryid": [self stringOrEmptyString:territoryid],
                            @"ProductName": NSLocalizedString(@"Product", nil),
                            @"Total": NSLocalizedString(@"Total", nil),
                            @"Used": NSLocalizedString(@"Used", nil),
                            @"Percentage":NSLocalizedString(@"% Used", nil),
                            @"Stock": NSLocalizedString(@"Stock", nil)
                            };
        
            [storeRcdsJSON addObject:arrayHolderDict];
            
        }
        
        territoryid = [alloc valueForKey:@"territoryname"];
        

        
        // prep values
        
            NSString *stock_there = @"NO";

            // NSLog(@"dw1 - show me avail_inventory: %f", [[alloc valueForKey:@"avail_inventory"] doubleValue]);
        
        
            if ([[alloc valueForKey:@"avail_inventory"] doubleValue] > 0) {
                stock_there = @"YES";
            }
        
        NSDictionary *arrayHolderDict = [[NSMutableDictionary alloc] init];
        
        arrayHolderDict = @{@"type": @"TYPEM",
                            @"territoryid": [self stringOrEmptyString:territoryid],
                            @"ProductName": [self stringOrEmptyString:[alloc valueForKey:@"productname"]],
                            @"Total": [self stringOrEmptyString:[alloc valueForKey:@"totalmax"] ],
                            @"Used": [self stringOrEmptyString:[alloc valueForKey:@"quantity_used"] ],
                            @"Percentage": [self stringOrEmptyString:[alloc valueForKey:@"percentage_used"] ],
                            @"Stock": [self stringOrEmptyString:stock_there]
                            };
        
        [storeRcdsJSON addObject:arrayHolderDict];
        
        // NSLog(@"dw1 - showCOUNT %lu" , (unsigned long)[storeRcdsJSON count]);
        
        
        
    }
    
    
    if ([storeRcdsJSON count] > 0) {
        [self performSelectorOnMainThread:@selector(dismissSuccess) withObject:nil waitUntilDone:YES];
        
    } else {
        [self performSelectorOnMainThread:@selector(dismissNoRecords) withObject:nil waitUntilDone:YES];
        
    }
    
    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    
}



- (void)getMyTeamData {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    storeRcdsJSON = [[NSMutableArray alloc] init];
    arraySectionCount = [[NSMutableArray alloc] init];
    
    urluserid = app.globalUserID;
    urltoken = app.globalToken;
    baseurl = app.globalBaseUrl;
    
    url = [NSURL URLWithString:@""];
    urlsvc = @"TBD";
    urlsvc = @"GetTeamReport";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    // NSLog(@"dw1 - show url %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
        
    [SVProgressHUD showWithStatus:@"Completing Process..."];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"GetTeamReportResult"];
        
        
        // msg user if no hcp found
        int noDataFound = 0;
        
        if ([arrayContainer count] == 0) {
            noDataFound = 1;
        };
        
        
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSString *TerritoryNom = [self stringOrEmptyString:[dicItems objectForKey:@"TerritoryName"]];
            
            NSDictionary *members = [dicItems objectForKey:@"Members"];
            
            NSArray *membersARR = [dicItems objectForKey:@"Members"];
            
            
            // update section header
            
            [arraySectionCount addObject:TerritoryNom];
            
            
            // iterate members
            
            
            for(int x=0;x<[members count];x++)
            {
                
                NSDictionary *arrayHolderDict = [[NSMutableDictionary alloc] init];
                
                arrayHolderDict = @{@"type": @"TYPEM",
                                                     @"territoryid": [self stringOrEmptyString:TerritoryNom],
                                                     @"Name": [self stringOrEmptyString:[[membersARR objectAtIndex:x] objectForKey:@"Name"]],
                                                     @"Fax": [self stringOrEmptyString:[[membersARR objectAtIndex:x] objectForKey:@"Fax"]],
                                                     @"Email": [self stringOrEmptyString:[[membersARR objectAtIndex:x] objectForKey:@"Email"]],
                                                     @"Phone": [self stringOrEmptyString:[[membersARR objectAtIndex:x] objectForKey:@"Phone"]]
                                                                };         
                	
                [storeRcdsJSON addObject:arrayHolderDict];
                
            }
           
            
        } // end iter for JSON
        
    } // end JSON null
    
    
    if ([storeRcdsJSON count] > 0) {
        [self performSelectorOnMainThread:@selector(dismissSuccess) withObject:nil waitUntilDone:YES];
        
    } else {
        [self performSelectorOnMainThread:@selector(dismissNoRecords) withObject:nil waitUntilDone:YES];        
    }
    
    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}


- (void) removeEntities {

    NSArray *deletionEntity;
    
    /*
    if ([removalType isEqualToString:@"allocation"])  {
        deletionEntity = @[@"allocation"];
    }
    */
    
    deletionEntity = @[@"Allocation"];
    
    // Define Delegate Context
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    for(int i=0;i<[deletionEntity count];i++)
    {
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:[deletionEntity objectAtIndex:i] inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        
        for (NSManagedObject *managedObject in items) {
            [_managedObjectContext deleteObject:managedObject];
            // NSLog(@"%@ object deleted",[deletionEntity objectAtIndex:i]);
        }
        
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error deleting %@ - error:%@",[deletionEntity objectAtIndex:i],error);
        }
        
        
    }// End Each

    
}


-(void) getAllocationDetailData {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    urluserid = app.globalUserID;
    urltoken = app.globalToken;
    baseurl = app.globalBaseUrl;
    
    url = [NSURL URLWithString:@""];
    urlsvc = @"GetAllocationByRepId";
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                                baseurl,
                                urlsvc,
                                urluserid,
                                urltoken,
                                urluserid]];
    
    // NSLog(@"url: %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        
        // step.1 - serialize object to data
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        // step.2 - Determine How Many Territories in Object
        int numofterr = [[[[dictContainer objectForKey:@"GetAllocationByRepIdResult"] objectForKey:@"Territories"] objectAtIndex:0] count];
        
        numofterr = 1;
        
        // step.3 iterate over territories to get data
        for(int i=0;i<numofterr;i++)
        {
            
            // convert to dictionary
            NSDictionary* dicTERR = [[[dictContainer objectForKey:@"GetAllocationByRepIdResult"] objectForKey:@"Territories"] objectAtIndex:i];
            
            // gather visible products
            NSMutableArray *arrayProductID = [[NSMutableArray alloc] init];
            
            for (int a=0;a<[[dicTERR objectForKey:@"AvailableOrderItems"] count];a++) {
                NSDictionary* dicPROD = [[dicTERR objectForKey:@"AvailableOrderItems"] objectAtIndex:a];
                [arrayProductID addObject:[dicPROD objectForKey:@"ProductId"]];
            }
            
            
            // msg user if no territories exist
            int noAllocationFound = 0;
            
            if ([[dicTERR objectForKey:@"Allocations"] count] == 0) {
                noAllocationFound = 1;
            };
            
            
            // only add visible products
            for(int i=0;i<[[dicTERR objectForKey:@"Allocations"] count];i++)
            {
                NSDictionary* dicALLOC = [[dicTERR objectForKey:@"Allocations"] objectAtIndex:i];
                
                if ( [arrayProductID containsObject:[dicALLOC objectForKey:@"ProductId"]] ) {
                    
                    NSManagedObject *model = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"Allocation"
                                              inManagedObjectContext:context];
                    
                    [model setValue:[dicALLOC objectForKey:@"TerritoryId"] forKey:@"territoryid"];
                    [model setValue:[dicALLOC objectForKey:@"EntityName"] forKey:@"territoryname"];
                    [model setValue:[dicALLOC objectForKey:@"ProductId"] forKey:@"productid"];
                    [model setValue:[dicALLOC objectForKey:@"ProductName"] forKey:@"productname"];
                    [model setValue:[dicALLOC objectForKey:@"ProductDescription"] forKey:@"productdescription"];
                    
                    [model setValue:[dicALLOC objectForKey:@"QuantityUsed"] forKey:@"quantity_used"];
                    [model setValue:[dicALLOC objectForKey:@"PercentageUsed"] forKey:@"percentage_used"];
                    
                    double c_ordermax = [[dicALLOC objectForKey:@"OrderMax"] doubleValue];
                    double c_totalmax = [[dicALLOC objectForKey:@"AvailableAllocation"] doubleValue];
                    
                    if (c_ordermax < 0) {
                        [model setValue:0 forKey:@"ordermax"];
                    } else {
                        [model setValue:[dicALLOC objectForKey:@"OrderMax"] forKey:@"ordermax"];
                    }
                    
                    if (c_totalmax < 0) {
                        [model setValue:0 forKey:@"totalmax"];
                        [model setValue:0 forKey:@"avail_allocation"];
                    } else {
                        [model setValue:[dicALLOC objectForKey:@"TotalMax"] forKey:@"totalmax"];
                        [model setValue:[dicALLOC objectForKey:@"AvailableAllocation"] forKey:@"avail_allocation"];
                    }
                    
                    [model setValue:[dicALLOC objectForKey:@"AvailableInventory"] forKey:@"avail_inventory"];
                    [model setValue:[dicALLOC objectForKey:@"HasAvailableInventory"]forKey:@"hasavailableinventory"];
                    
                    if (![context save:&error]) {
                        NSLog(@"Couldn't save: %@", [error localizedDescription]);
                    }
                    
                }
                
            }
            
            
            
        }
        
    }  // End of Allocation
    
    
    
}





#pragma mark - UISplitViewDelegate methods
-(void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)ViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //Grab a reference to the popover
    self.popover = pc;
    
    //Set the title of the bar button item
    barButtonItem.title = NSLocalizedString(@"Reports", nil);
    
    //Set the bar button item as the Nav Bar's leftBarButtonItem
    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
    
    
}

-(void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)ViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
    // hide popover    
    self.navBarItem.leftBarButtonItem = nil;
}


- (void) splitViewController:(UISplitViewController *)splitViewController popoverController: (UIPopoverController *)pc
   willPresentViewController: (UIViewController *)ViewController
{
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		// NSLog(@"ERR_POPOVER_IN_LANDSCAPE");
	}
}






#pragma mark - Utillities

- (NSString *)stringOrEmptyString:(NSString *)string
{
    
    if (string == nil || [string isKindOfClass:[NSNull class]] ) {
        return @"";
    } else {
        return string;
    }

}



#pragma mark - HUD Methods

- (void)dismiss {
	[SVProgressHUD dismiss];
}

- (void)dismissSuccess {
	[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Loading Complete!",nil)];
}

- (void)dismissNoRecords {
	[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"No Records Found!", nil)];
}

- (void)dismissError {
	[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed with Error", nil)];
}
@end


