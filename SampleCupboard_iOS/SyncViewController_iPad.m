//
//  SyncViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "SyncViewController_iPad.h"
#import "Reachability.h"

Reachability *internetReachableFoo;

@interface SyncViewController_iPad ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLoadHCPs;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnReloadData;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSync;

- (IBAction)btnLoadHCPsClick:(id)sender;

- (IBAction)btnReloadDataClick:(id)sender;

- (IBAction)btnSyncClick:(id)sender;


@end


@implementation SyncViewController_iPad



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






    
- (IBAction)btnReloadDataClick:(id)sender {

    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Remove Client Info
    NSError *errorMSG = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"ClientInfo" inManagedObjectContext:context]];
    
    NSArray *matchingData = [managedObjectContext executeFetchRequest:request error:&errorMSG];
    
    if ([matchingData count]>0) {
        for (NSManagedObject *obj in matchingData) {
            [managedObjectContext deleteObject:obj];
        }
        [managedObjectContext save:&errorMSG];
    }


    // Remove Product Info
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Product" inManagedObjectContext:context]];
    matchingData = [managedObjectContext executeFetchRequest:request error:&errorMSG];
    
    if ([matchingData count]>0) {
        for (NSManagedObject *obj in matchingData) {
            [managedObjectContext deleteObject:obj];
        }
        [managedObjectContext save:&errorMSG];
    }
    
    // Remove Allocation
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Allocation" inManagedObjectContext:context]];
    matchingData = [managedObjectContext executeFetchRequest:request error:&errorMSG];
    
    if ([matchingData count]>0) {
        for (NSManagedObject *obj in matchingData) {
            [managedObjectContext deleteObject:obj];
        }
        [managedObjectContext save:&errorMSG];
    }
    
    // Remove AllocationHeader
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"AllocationHeader" inManagedObjectContext:context]];
    matchingData = [managedObjectContext executeFetchRequest:request error:&errorMSG];
    
    if ([matchingData count]>0) {
        for (NSManagedObject *obj in matchingData) {
            [managedObjectContext deleteObject:obj];
        }
        [managedObjectContext save:&errorMSG];
    }
    
    
    // Remove TerritoryFSA
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TerritoryFSA" inManagedObjectContext:context]];
    matchingData = [managedObjectContext executeFetchRequest:request error:&errorMSG];
    
    if ([matchingData count]>0) {
        for (NSManagedObject *obj in matchingData) {
            [managedObjectContext deleteObject:obj];
        }
        [managedObjectContext save:&errorMSG];
    }
    
    // Remove Territory
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Territory" inManagedObjectContext:context]];
    matchingData = [managedObjectContext executeFetchRequest:request error:&errorMSG];
    
    if ([matchingData count]>0) {
        for (NSManagedObject *obj in matchingData) {
            [managedObjectContext deleteObject:obj];
        }
        [managedObjectContext save:&errorMSG];
    }

    
    // Remove Rep
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Rep" inManagedObjectContext:context]];
    matchingData = [managedObjectContext executeFetchRequest:request error:&errorMSG];
    
    if ([matchingData count]>0) {
        for (NSManagedObject *obj in matchingData) {
            [managedObjectContext deleteObject:obj];
        }
        [managedObjectContext save:&errorMSG];
    }
    
    
    
    
    
    
    // Client Info -  Single Record
    NSURL *url = [NSURL URLWithString:@"http://project.dwsmall.com/clientinfo"];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"clientinfo"];
        
        // NSLog(@"clientinfo: %@", arrayContainer);
        
        NSDictionary* dicItems = [arrayContainer objectAtIndex:0];
        
        NSManagedObject *model = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"ClientInfo"
                                  inManagedObjectContext:context];
        [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
        [model setValue:[dicItems objectForKey:@"DisplayName"]  forKey:@"displayname"];
        

        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    // Products - Multiple
    url = [NSURL URLWithString:@"http://project.dwsmall.com/product"];
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"product"];
        
        // NSLog(@"product: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Product"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"Type"]  forKey:@"type"];
            [model setValue:[dicItems objectForKey:@"Code"]  forKey:@"code"];
            [model setValue:[dicItems objectForKey:@"lowlevelquantity"]  forKey:@"lowlevelquantity"];
            [model setValue:[dicItems objectForKey:@"unitmultiplier"]  forKey:@"unitmultiplier"];
            [model setValue:[dicItems objectForKey:@"options_OrderTypeEligibility"]  forKey:@"options_ordertypeeligibility"];
            [model setValue:[dicItems objectForKey:@"status"]  forKey:@"status"];
        }
                       
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    // AllocationHeader - Single
    
    url = [NSURL URLWithString:@"http://project.dwsmall.com/allocationheader"];
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"allocationheader"];
        
        // NSLog(@"allocationheader: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"AllocationHeader"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"Name"] forKey:@"name"];
            [model setValue:[dicItems objectForKey:@"Description"] forKey:@"allocdescription"];
            
            // Date Conversion Routine
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
            NSString *dateStringA = [dicItems objectForKey:@"DateStart"];
            NSString *dateStringB = [dicItems objectForKey:@"DateEnd"];
            
            NSDate *dateA = [dateFormatter dateFromString:dateStringA];
            NSDate *dateB = [dateFormatter dateFromString:dateStringB];
            
            [model setValue:dateA forKey:@"datestart"];
            [model setValue:dateB forKey:@"dateend"];
            [model setValue:[dicItems objectForKey:@"Inactive"]  forKey:@"inactive"];
            [model setValue:[dicItems objectForKey:@"Year"]  forKey:@"year"];
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    
    // Allocation
    
    url = [NSURL URLWithString:@"http://project.dwsmall.com/allocation"];
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"allocation"];
        
        // NSLog(@"allocation: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Allocation"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"OriginalTotalMax"] forKey:@"originaltotalmax"];
            [model setValue:[dicItems objectForKey:@"OriginalOrderMax"] forKey:@"originalordermax"];
            [model setValue:[dicItems objectForKey:@"Inventory"] forKey:@"inventory"];
            [model setValue:[dicItems objectForKey:@"HCPTargetListId"] forKey:@"hcptargetlistid"];
            [model setValue:[dicItems objectForKey:@"IsHCP"] forKey:@"ishcp"];
            [model setValue:[dicItems objectForKey:@"IsHCPTargetList"] forKey:@"ishcptargetlist"];
            [model setValue:[dicItems objectForKey:@"IsRep"] forKey:@"isrep"];
            [model setValue:[dicItems objectForKey:@"IsTerritory"] forKey:@"isterritory"];
            [model setValue:[dicItems objectForKey:@"ProductId"] forKey:@"productid"];
            [model setValue:[dicItems objectForKey:@"TerritoryId"] forKey:@"territoryid"];
            [model setValue:[dicItems objectForKey:@"TotalMax"] forKey:@"totalmax"];
            [model setValue:[dicItems objectForKey:@"OrderMax"] forKey:@"ordermax"];
            [model setValue:[dicItems objectForKey:@"ParentId"] forKey:@"parentid"];
            [model setValue:[dicItems objectForKey:@"DefaultOrderMax"] forKey:@"defaultordermax"];
            [model setValue:[dicItems objectForKey:@"AllocationHeaderId"] forKey:@"allocationheaderid"];
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    
    // Territory
    
    url = [NSURL URLWithString:@"http://project.dwsmall.com/territory"];
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"territory"];
        
        // NSLog(@"territory: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Territory"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"Province"] forKey:@"province"];
            [model setValue:[dicItems objectForKey:@"Name"] forKey:@"name"];
            [model setValue:[dicItems objectForKey:@"TerritoryNumber"] forKey:@"territorynumber"];
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    // TerritoryFSA
    
    url = [NSURL URLWithString:@"http://project.dwsmall.com/territoryfsa"];
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"territoryfsa"];
        
        // NSLog(@"territoryfsa: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"TerritoryFSA"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"Fsa"] forKey:@"fsa"];
            [model setValue:[dicItems objectForKey:@"Territoryid"] forKey:@"territoryid"];
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    
    
    // REP
    
    url = [NSURL URLWithString:@"http://project.dwsmall.com/rep"];
    jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSArray* arrayContainer = [dictContainer objectForKey:@"rep"];
        
        // NSLog(@"rep: %@", arrayContainer);
        
        //Iterate JSON Objects
        for(int i=0;i<[arrayContainer count];i++)
        {
            NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Rep"
                                      inManagedObjectContext:context];
            [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
            [model setValue:[dicItems objectForKey:@"FirstName"] forKey:@"firstname"];
            [model setValue:[dicItems objectForKey:@"LastName"] forKey:@"lastname"];
            [model setValue:[dicItems objectForKey:@"Title"] forKey:@"title"];
            [model setValue:[dicItems objectForKey:@"Role"] forKey:@"role"];
            [model setValue:[dicItems objectForKey:@"Username"] forKey:@"username"];
            [model setValue:[dicItems objectForKey:@"Password"] forKey:@"password"];
            [model setValue:[dicItems objectForKey:@"Status"] forKey:@"status"];
            [model setValue:[dicItems objectForKey:@"Language"] forKey:@"language"];
            [model setValue:[dicItems objectForKey:@"PreferredLanguage"] forKey:@"preferredlanguage"];
            [model setValue:[dicItems objectForKey:@"IdentityManagerId"] forKey:@"identitymanagerid"];
            [model setValue:[dicItems objectForKey:@"Email"] forKey:@"email"];
            
        }
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        if (error == nil)
            NSLog(@"%@", dictContainer);
    }
    

    
    
    // Process Complete
    UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Complete",@"titleKey")
                              message:NSLocalizedString(@"Reload Complete",@"messageKey")
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK",@"cancelKey")
                              otherButtonTitles:nil];
    [alert show];
    
    
    
    
}

- (IBAction)btnLoadHCPsClick:(id)sender {
    
    
    if (2 == 1) {
        
        // No Internet Connection
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Connection Required",@"titleKey")
                                  message:NSLocalizedString(@"Device Could Not Connect To Internet!",@"messageKey")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"ok",@"cancelKey")
                                  otherButtonTitles:nil];
        [alertView show];
        
    
    } else {
        
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        NSManagedObjectContext *context = [self managedObjectContext];
        
    
        // Remove Client Info
        NSError *errorMSG = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        [request setEntity:[NSEntityDescription entityForName:@"HealthCareProfessional" inManagedObjectContext:context]];
        
        NSArray *matchingData = [managedObjectContext executeFetchRequest:request error:&errorMSG];
        
        if ([matchingData count]>0) {
            for (NSManagedObject *obj in matchingData) {
                [managedObjectContext deleteObject:obj];
            }
            [managedObjectContext save:&errorMSG];
        }

        
        
        // HCP
        
        NSURL *url = [NSURL URLWithString:@"http://project.dwsmall.com/hcp"];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        
        
        if(jsonData != nil)
        {
            NSError *error = nil;
            NSDictionary* dictContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            NSArray* arrayContainer = [dictContainer objectForKey:@"hcp"];
            
            // NSLog(@"hcp: %@", arrayContainer);
            
            //Iterate JSON Objects
            for(int i=0;i<[arrayContainer count];i++)
            {
                NSDictionary* dicItems = [arrayContainer objectAtIndex:i];
                
                NSManagedObject *model = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"HealthCareProfessional"
                                          inManagedObjectContext:context];
                [model setValue:[dicItems objectForKey:@"ClientId"] forKey:@"clientid"];
                [model setValue:[dicItems objectForKey:@"FirstName"] forKey:@"firstname"];
                [model setValue:[dicItems objectForKey:@"LastName"] forKey:@"lastname"];
                [model setValue:[dicItems objectForKey:@"Phone"] forKey:@"phone"];
                [model setValue:[dicItems objectForKey:@"Fax"] forKey:@"fax"];
                [model setValue:[dicItems objectForKey:@"Facility"] forKey:@"facility"];
                [model setValue:[dicItems objectForKey:@"Deparment"] forKey:@"department"];
                [model setValue:[dicItems objectForKey:@"Address1"] forKey:@"address1"];
                [model setValue:[dicItems objectForKey:@"Address2"] forKey:@"address2"];
                [model setValue:[dicItems objectForKey:@"Address3"] forKey:@"address3"];
                [model setValue:[dicItems objectForKey:@"Email"] forKey:@"email"];
                [model setValue:[dicItems objectForKey:@"City"] forKey:@"city"];
                [model setValue:[dicItems objectForKey:@"Province"] forKey:@"province"];
                [model setValue:[dicItems objectForKey:@"Postal"] forKey:@"postal"];
                // [model setValue:[dicItems objectForKey:@"SignDate"] forKey:@"signdate"];
                [model setValue:[dicItems objectForKey:@"PHLID"] forKey:@"phlid"];
                [model setValue:[dicItems objectForKey:@"Rejected"] forKey:@"rejected"];
                
            }
            
            if (![context save:&error]) {
                NSLog(@"Couldn't save: %@", [error localizedDescription]);
            }
            
            // if (error == nil)
                // NSLog(@"%@", dictContainer);
        }
        
        
        // Process All Records
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"HCP Update Complete"
                              message: @"All Hcp Records Have Been Updated."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}
    
    

- (IBAction)btnSyncClick:(id)sender {
    
    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Connection Established!");
    });
    
    if (2 == 2)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Connection Established!");
        });
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                         initWithTitle: @"Synchronize"
                         message: @"Record synchronized successfully"
                         delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
    [alert show];
    
}


// Checks if we have an internet connection or not
- (void) testInternetConnection
{

    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Connection Established!");
        });
        
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Connection Could Not Be Made to Internet");
        });
        
    };
    
    [internetReachableFoo startNotifier];
    
    
}


-(bool) mainx
{
    char* name;
    name = malloc (sizeof(char) * 6);
    name = "david";
    return TRUE;
}




- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	NSLog(@"%@ object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

@end