//
//  OrderDetailViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "Order.h"
#import "OrderLineItem.h"
#import "TextInputDialog_iPad.h"
#import "OrderDetailViewController_iPad.h"

#import "Reachability.h"

Reachability *internetReachableFoo;


@interface OrderDetailViewController_iPad ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tbActions;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tbSaveDraft;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UILabel *carrier_display_label;

- (IBAction)CancelClicked:(id)sender;


- (IBAction)NewProductClick:(id)sender;

- (IBAction)tbActionsClick:(id)sender;

- (IBAction)tbSaveDraftClick:(id)sender;

- (IBAction)CellEditorBegunEditing:(id)sender;

- (IBAction)CellEditorEndedEdit:(id)sender;


- (IBAction)CancelOrderDetail:(UIBarButtonItem *)sender;


- (IBAction)Carrier_Ground:(UIButton *)sender;

- (IBAction)Carrier_Air:(UIButton *)sender;


- (IBAction)Done_Clicked:(UIBarButtonItem *)sender;

@end


@implementation OrderDetailViewController_iPad

NSArray *tableData;
NSArray *tableDataX;
NSArray *prodDataX;
NSArray *unitDataX;
NSArray *statusDataX;


@synthesize selectedButton, outputlabel;
@synthesize selectedHCP, outputlabel1;
@synthesize selectedHCPNUMBER, outputlabel2;
@synthesize selectedHCPINFO, outputlabel4;
@synthesize selectedPRODUCTNUMBER, outputlabel3;
@synthesize myresults, outputlabel5;

@synthesize fetchedResultsController2, outputlabelA;
@synthesize managedObjectContext2, outputlabelB;

@synthesize fetchRequest2, outputlabelC;
@synthesize fetchOBJ2, outputlabelD;

@synthesize moDATA, outputlabelE;
@synthesize moHCPDATA, outputlabelF;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    int NSections = 2;
    
    // NEW RECORD
    if (selectedButton == 0)
    {
        if (selectedHCPNUMBER == 1001) {
            NSections = 6;  // Stage 2 - SHOW HCP INFO...
        } else {
            NSections = 2;  // Stage 1
        }
        
        if (selectedPRODUCTNUMBER == 1001) {
            NSections = 6;  // Stage 3 - SHOW ALL INFO...
        }
    }
    

    
    // SHOW EXISTING ORDER
    if (selectedButton == 2)
    {
        NSections = 6;
    }

    return NSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *HeaderTitle = @"Default";
    
    switch (section)
    
    {
        case 0:
            
            HeaderTitle = @"";
            break;
            
        case 1:
            
            HeaderTitle = @"Requested Physician";
            break;
            
        case 2:
            HeaderTitle = @"To be delivered to Physician";
            break;
            
        case 3:
            
            HeaderTitle = @"Delivery Instructions";
            break;
            
            
        case 4:
            
            HeaderTitle = @"Shipping Carrier";
            break;
            
            
        case 5:
            
            HeaderTitle = @"Signature (required)";
            break;
            
        default:
            
            HeaderTitle = @"";
            break;
            
    }
    
    return HeaderTitle;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    NSManagedObject *object = moDATA;
    
    
    int MRows = 0;
    
    switch (section)
    
    {
        case 0:
            
            //Header
            MRows=1;
            break;
            
        case 1:
            
            //Requested Physician
            MRows=2;
            break;
            
        case 2:
            // Products - To Be Delivered To Physician
                // View Detail ?
            if (selectedButton == 0) // NEW ORDER
            {
                MRows = [[[self fetchedResultsController] fetchedObjects] count];   //Total Products
                break;
            }
           
            if (selectedButton == 2) // SHOW DETAILS
            {            
            MRows = [[object valueForKey:@"toOrderDetails"] count];
            break;
            }
            
        case 3:
            //Delivery Instructions
            MRows=1;
            break;
            
        case 4:
            //Shipping Carrier
            MRows=1;
            break;
        
        case 5:
            
            //Signature
            MRows=1;
            break;
            
        default:
            
            MRows=1;
            break;
            
    }
    
    return MRows;
    
    
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    
    // DETERMINE STAGE OF APPLICATION
    
        //STAGE 1 - [SEGUE 1 AND NO HCP SELECTED] =  NEW ORDER
        //STAGE 2 - [SEGUE 1 AND HCP SELECTED AND PRODUCT TOTAL = 0] = NEW ORDER AND HCP SELECTED
        //STAGE 3 - [SEGUE 1 AND HCP SELECTED AND PRODUCT TOTAL <> 0] = NEW ORDER AND WITH PRODUCTS SELECTED
        //STAGE 4 - [SEGUE 2] = SHOW ORDER DETAIL INFORMATION
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *MyFormType = @"_header";
    
    switch (indexPath.section)
    
    {
        case 0:
            
            //Header
            MyFormType=@"_header";
            break;
            
        case 1:
            
            //Requested Physician
            if (indexPath.row == 0) {
                MyFormType = @"_shipTo";
            }
            else {
                MyFormType = @"_address";
            }
            
            break;
            
        case 2:
            
            //To Be Delivered To Physician
            // Iterate based on fetched products from table
            if (indexPath.row == [[[self fetchedResultsController] fetchedObjects] count]) {
                MyFormType=@"_newLineItem";
            } else {
                MyFormType=@"_lineItem";
            }			            
            break;
            
        case 3:
            
            //Delivery Instructions
            MyFormType=@"_instructions";
            break;
            
        case 4:
            
            //Shipping Carrier
            MyFormType=@"_carrier";
            break;
            
        case 5:
            
            //Signature
            MyFormType=@"_signature";
            break;
            
        default:
            
            MyFormType=@"";
            break;
            
    }
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyFormType forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];    
    
    return cell;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.section == 2)
    {
        
        /* Custom Keyboard to Prevent Negatives.
          User entering signed values using Alpha,etc... 
        */
        
        _hiddenTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        _hiddenTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        _hiddenTextField.becomeFirstResponder;
        
    }

}


#pragma mark - UIKeyInput Protocol Methods

- (BOOL)hasText
{
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSIndexPath *ip = [self.myTableView indexPathForSelectedRow];
    
    UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:ip];
    
    cell.detailTextLabel.text = string;
    
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CancelClicked:(id)sender {
}



- (IBAction)NewProductClick:(id)sender {
}

- (IBAction)tbActionsClick:(id)sender {
}

- (IBAction)tbSaveDraftClick:(id)sender {
}

- (IBAction)CellEditorBegunEditing:(id)sender {
}

- (IBAction)CellEditorEndedEdit:(id)sender {
}




- (IBAction)CancelOrderDetail:(UIBarButtonItem *)sender {

    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle: @"Cancel Request" message: @"Warning! All Entered Data Will Be Lost" delegate: self
                               cancelButtonTitle: @"cancel" otherButtonTitles: @"OK", nil];
    
    [alertView show];
}

- (IBAction)Carrier_Ground:(UIButton *)sender {
    
    // change label
    	

}

- (IBAction)Carrier_Air:(UIButton *)sender {
    
    
    
    //UIAlertView *alertView = [[UIAlertView alloc]
      //                        initWithTitle: @"Warning" message: @"This shipment will be sent by ATS Air" delegate: self
        //                      cancelButtonTitle: @"OK" otherButtonTitles:nil];
    
    // [alertView show];
}




- (IBAction)Done_Clicked:(UIBarButtonItem *)sender {
    
    NSLog(@"Create Entry in Order Temp");
    
    // TEST INSERTION METHOD USING MANUAL INSERT
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *contextINSERT = [self managedObjectContext];
    
    
    // PART 1. INSERT ORDER
    // NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *OrderHDR = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Order"
                                 inManagedObjectContext:contextINSERT];
    [OrderHDR setValue:@"D646E129-1F38-4F83-94D7-82BF57DD4F24" forKey:@"clientid"];
    [OrderHDR setValue:@"2e9847f5-c72b-4118-bb99-349377e17777" forKey:@"orderid"];
    [OrderHDR setValue:@"1234567" forKey:@"reference"];
    [OrderHDR setValue:@"TESTXML" forKey:@"shipping_firstname"];
    [OrderHDR setValue:@"TESTXMLSEND" forKey:@"shipping_lastname"];
    [OrderHDR setValue:@"NEW" forKey:@"status"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
    NSString *dateStringA = @"Tue, 18 Oct 2011 15:54:43 +0900";
    NSDate *dateA = [dateFormatter dateFromString:dateStringA];
    [OrderHDR setValue:dateA forKey:@"datecreated"];
    
    // could also use [OrderHDR setValue:[NSDate date] forKey:@"datecreated"];
    
    
    // PART 2. INSERT ORDER DETAILS IMMEDIATELY AFTER
    NSManagedObject *OrderDTL = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"OrderLineItem"
                                 inManagedObjectContext:contextINSERT];
    [OrderDTL setValue:@"2e9847f5-c72b-4118-bb99-349377e17777" forKey:@"orderid"];
    [OrderDTL setValue:@"D646E129-1F38-4F83-94D7-82BF57DD4F24" forKey:@"clientid"];
    [OrderDTL setValue:@"D646E129-1F38-4F83-94D7-82BF57DD4F24" forKey:@"productid"];
    
    [OrderDTL setValue:@"Jaunumet 88" forKey:@"stored_product_name"];
    [OrderDTL setValue:@"4 units" forKey:@"stored_product_description"];
    [OrderDTL setValue:@"12352" forKey:@"stored_product_code"];
    
    [OrderDTL setValue:[NSNumber numberWithInt:55] forKey:@"quantityordered"];
    [OrderDTL setValue:[NSDate date] forKey:@"datecreated"];
    
    //PART 3. INSERT VALUE FOR RELATIONSHIP
    [OrderDTL setValue:OrderHDR forKey:@"toOrderHeader"];
    // [OrderHDR setValue:OrderDTL forKey:@"toOrderDetails"];
    
    NSError *error;
    if (![contextINSERT save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    
    // Check if Online Status is Good
    // Show No Network Message If Internet is Not Connected...
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    if (internetStatus == NotReachable){
        
        
        // Update badge number
        // Set All TabBar Badges Upon Load
        for (UIViewController *viewController in self.tabBarController.viewControllers) {
            
            if (viewController.tabBarItem.tag == 4) {
                //Get TabBarItem and Increment By 1
                viewController.tabBarItem.badgeValue = @"2";
            }
        }
        
        NSLog(@"There's no connection");
        
        
    } else {
        NSLog(@"Internet connection is OK");
        
        
        //Create XML File For Submission
        
        NSDictionary *ordhdr_dict = @{   @"UserId" : @"0BB9FDAD-DDD9-4CEA-861B-073BB6D1A590",
                                    @"Token" : @"kR1zzKeIrOSZrMKq9C7YYA==",
                                    @"OwnerId" : @"0BB9FDAD-DDD9-4CEA-861B-073BB6D1A590",
                                    @"ShipToId" : @"795632d4-1e96-4a69-a1af-1e579527bdff",
                                    @"TerritoryId" : @"9c0df8e7-e88a-4f92-8a0d-0cb902ea3f7e",
                                    @"AllocationId" : @"a0e4dc78-07c1-414c-be8e-ed6732902729",
                                    @"CreatorId" : @"0bb9fdad-ddd9-4cea-861b-073bb6d1a590",
                                    @"ClientId" : @"d646e129-1f38-4f83-94d7-82bf57dd4f24",
                                    @"ShippingAddressId" : @"47ae66f2-4646-403f-a4a6-42faf3b36539",
                                    @"ApplicationSource" : @"MobileSampleCupboard",
                                    @"DateEntered" : @"2013-07-10T00:00:00",
                                    @"DateCreated" : @"2013-07-10T00:00:00",
                                    @"DateModified" : @"2013-07-10T00:00:00",
                                    @"Shipping_FacilityName" : @"Dougs Health Care",
                                    @"ShippingFirstName" : @"Carl",
                                    @"ShippingLastName" : @"Lewis",
                                    @"Shipping_AddressLine1" : @"77 Redwillow Rd",
                                    @"Shipping_AddressLine2" : @"Apartment 5",
                                    @"Shipping_AddressLine3" : @"PO 521",
                                    @"Shipping_City" : @"Brampton",
                                    @"Shipping_PostalCode" : @"L6P2B2",
                                    @"Shipping_Province" : @"ON",
                                    @"Shipping_Status" : @"Active",
                                    @"Shipping_Phone" : @"234343434",
                                    @"Shipping_PhoneExtension" : @"xt.234",
                                    @"Shipping_Fax" : @"234234",
                                    @"Shipping_Partner" : @"ATS",
                                    @"Shipping_Type" : @"GROUND",
                                    @"Shipping_Email" : @"me@myemail.com",
                                    @"Signature" : @"W3siaXNTdGFydCI6IHRydWUsICJ4IjogMTg1LCAieSI6IDg0fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMTg3LCAieSI6IDgyfSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMTk3LCAieSI6IDgyfSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMjE2LCAieSI6IDc5fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMjQzLCAieSI6IDc3fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMjcxLCAieSI6IDc0fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMzAyLCAieSI6IDcxfSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMzMxLCAieSI6IDY5fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMzYxLCAieSI6IDY2fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogMzkwLCAieSI6IDY2fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNDE4LCAieSI6IDY2fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNDM5LCAieSI6IDY2fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNDYwLCAieSI6IDY3fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNDc0LCAieSI6IDY5fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNDg3LCAieSI6IDcxfSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNDk1LCAieSI6IDczfSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNDk4LCAieSI6IDc0fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNTAxLCAieSI6IDc1fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNTAxLCAieSI6IDc2fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNTAxLCAieSI6IDc4fSwgeyJpc1N0YXJ0IjogZmFsc2UsICJ4IjogNDk4LCAieSI6IDgzfV0="
                                    };
        
        // Build xml
        NSMutableString *order_xml = [[NSMutableString alloc] initWithString:@""];
        [order_xml appendString:@"<?xml version=\"1.0\"?>\n<NewMobileOrderModel xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n"];
        
            // Convert Dictionary Values
            NSArray *arr = [ordhdr_dict allKeys];
        
            // Conversion Routine
            for(int i=0;i<[arr count];i++)
            {
                id nodeValue = [ordhdr_dict objectForKey:[arr objectAtIndex:i]];
                
                if([nodeValue isKindOfClass:[NSArray class]] )
                {
                    if([nodeValue count]>0){
                        for(int j=0;j<[nodeValue count];j++)
                        {
                            id value = [nodeValue objectAtIndex:j];
                            if([ value isKindOfClass:[NSDictionary class]])
                            {
                                [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                                [order_xml appendString:[NSString stringWithFormat:@"%@",[value objectForKey:@"text"]]];
                                [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
                            }
                        }
                    }
                }
                else if([nodeValue isKindOfClass:[NSDictionary class]])
                {
                    [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                    if([[nodeValue objectForKey:@"Id"] isKindOfClass:[NSString class]])
                        [order_xml appendString:[NSString stringWithFormat:@"%@",[nodeValue objectForKey:@"Id"]]];
                    else
                        [order_xml appendString:[NSString stringWithFormat:@"%@",[[nodeValue objectForKey:@"Id"] objectForKey:@"text"]]];
                    [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
                }
            
                else
                {
                    if([nodeValue length]>0){
                        [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                        [order_xml appendString:[NSString stringWithFormat:@"%@",[ordhdr_dict objectForKey:[arr objectAtIndex:i]]]];
                        [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
                    }
                }
            }
        
        NSString *ordhdr_xml=[order_xml stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
        
        // OrderLine Details
            [order_xml appendString:[NSString stringWithFormat:@"<IsDraft xsi:nil=\"%@\" />\n", @"true"]];
            [order_xml appendString:[NSString stringWithFormat:@"<DateSigned xsi:nil=\"%@\" />\n", @"true"]];
        
            [order_xml appendString:[NSString stringWithFormat:@"<OrderLineItems>\n"]];
        
            [order_xml appendString:[NSString stringWithFormat:@"<NewMobileOrderLineItem>\n<ProductId>%@</ProductId>\n<QuantityOrdered>%@</QuantityOrdered>\n</NewMobileOrderLineItem>\n", @"4fe0bf38-9382-4710-877d-9fcd513effa2", @"1"]];
        
            // [order_xml appendString:[NSString stringWithFormat:@"<NewMobileOrderLineItem><ProductId>%@</ProductId><QuantityOrdered>%@</QuantityOrdered></NewMobileOrderLineItem>", @"4fe0bf38-9382-4710-877d-9fcd513effa2", @"1"]];
        
            [order_xml appendString:[NSString stringWithFormat:@"</OrderLineItems>\n"]];
        
        // Header End
        [order_xml appendString:[NSString stringWithFormat:@"</NewMobileOrderModel>\n"]];
        
        NSLog(@"xmlData: %@", order_xml);
        
        
        //Send Response To SC
        NSData *data = [order_xml dataUsingEncoding:NSUTF8StringEncoding];
        // NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoTEST options:kNilOptions error:&errorMSG];
        
        NSURL *url = [NSURL URLWithString:@"http://dev.samplecupboard.com/Data/MobileServices.svc/CreateOrder"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:data];
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"responseData: %@", newStr);
        
    
    }
    
    
       
    
}




/*
 Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
 subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
 with information from a managed object at the given index path in the fetched results controller.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.myTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.myTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.myTableView endUpdates];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        NSLog(@"Manual Segue Required");
        [self performSegueWithIdentifier:@"_returntoorderlist" sender:self];
    }
    else if([title isEqualToString:@"cancel"])
    {
        // NSLog(@"User Selected Cancel");
    }
 
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //return [indexPath row] * 20;
    int Npole = 44;
    
    if (indexPath.section == 0) {
        Npole = 100;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        Npole = 75;
    }
    
    return Npole;
    
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
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *pFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"ProductList"];
    // pFetchedResultsController.delegate = self;
    self.fetchedResultsController = pFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}   
    
    return _fetchedResultsController;
}








- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *object = moDATA;
    
    // HEADER
    if (indexPath.section == 0) {
        
        // Initialize Values
        
        [(UILabel *)[cell viewWithTag:1] setText:@""];  //reference
        [(UILabel *)[cell viewWithTag:5] setText:@"NEW"]; //status
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"dd-MM-yyyy"];
        [(UILabel *)[cell viewWithTag:2] setText:[DateFormatter stringFromDate:[NSDate date]]]; //Date Created
        
        [(UILabel *)[cell viewWithTag:3] setText:@""]; //date released
        [(UILabel *)[cell viewWithTag:4] setText:@""]; //date shipped
        
        [(UILabel *)[cell viewWithTag:6] setText:@""]; //reason label
        [(UILabel *)[cell viewWithTag:7] setText:@""]; //reason value
        
        [(UILabel *)[cell viewWithTag:8] setText:@""]; //tracking label
        [(UILabel *)[cell viewWithTag:9] setText:@""]; //tracking value
        
        
        if (selectedButton == 2)
        {
            [(UILabel *)[cell viewWithTag:1] setText:[[object valueForKey:@"reference"] description]];
            [(UILabel *)[cell viewWithTag:5] setText:[[object valueForKey:@"status"] description]]; //status
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"dd-MM-yyyy"];
            [(UILabel *)[cell viewWithTag:2] setText:[DateFormatter stringFromDate:[object valueForKey:@"datecreated"] ]]; //Date Created
            
            [(UILabel *)[cell viewWithTag:3] setText:[object valueForKey:@"datereleased"]]; //date released
            [(UILabel *)[cell viewWithTag:4] setText:[object valueForKey:@"dateshipped"]]; //date shipped
            
            // [(UILabel *)[cell viewWithTag:6] setText:@""]; //reason label
            // [(UILabel *)[cell viewWithTag:7] setText:@""]; //reason value
            
            // [(UILabel *)[cell viewWithTag:8] setText:@""]; //tracking label
            // [(UILabel *)[cell viewWithTag:9] setText:@""]; //tracking value
        }
        
    }
    
    // REQUESTED PHYSICIAN
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            if (selectedButton == 0) // NEW ORDER
            {
                if (selectedHCPNUMBER == 1001) {
                     NSLog(@"Value For [TOPROW] selectedHCPNUMBER %d", selectedHCPNUMBER);
                    
                    [(UILabel *)[cell viewWithTag:1] setText:selectedHCPINFO[0]]; // load hcp Name
                    
                     NSLog(@"SHOULD NOT WRITE BLANK %@", selectedHCPINFO[0]);
                } else {
                    NSLog(@"Value For [BOTTOMROW] selectedHCPNUMBER %d", selectedHCPNUMBER);
                    [(UILabel *)[cell viewWithTag:1] setText:selectedHCPINFO[0]];
                }
            }
            
            
            if (selectedButton == 2)  // SHOW DETAILS
            {
                [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%@, %@",
                                                          [[object valueForKey:@"shipping_lastname"] description],
                                                          [[object valueForKey:@"shipping_firstname"] description]]];
            }
            
            
         } else {
             
         
             if (selectedButton == 0) // NEW ORDER
             {
                 if (selectedHCPNUMBER == 1001) {
                     [(UILabel *)[cell viewWithTag:0] setText:selectedHCPINFO[1]]; // load Address
                 } else {
                     [(UILabel *)[cell viewWithTag:0] setText:@""];
                 }
             }
             
             
             if (selectedButton == 2)  // SHOW DETAILS
             {
                 
                 NSString *AddressBuilder = [NSString stringWithFormat:@"%@ \n %@ \n %@ \n %@,%@,%@",
                                             [[object valueForKey:@"shipping_addressline1"] description],
                                             [[object valueForKey:@"shipping_addressline2"] description],
                                             [[object valueForKey:@"shipping_addressline3"] description],
                                             [[object valueForKey:@"shipping_city"] description],
                                             [[object valueForKey:@"shipping_province"] description],
                                             [[object valueForKey:@"shipping_postalcode"] description]];
                 
                 [(UILabel *)[cell viewWithTag:0] setText:AddressBuilder];
             }
             
        }        
    }
    
    // DELIVERED TO PHYSICIAN
    if (indexPath.section == 2) {
        
        if (selectedButton == 0) // NEW ORDER
        {
            NSManagedObject *ProductObject = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                                   [[ProductObject valueForKey:@"name"] description],
                                   [[ProductObject valueForKey:@"product_description"] description]];
            
            cell.detailTextLabel.text = @"0";
        }
        
        if (selectedButton == 2) // EXISTING ORDER
        {
            // Iterate based on fetched products from table
            if (indexPath.row == [[[self fetchedResultsController] fetchedObjects] count])
            {
                cell.textLabel.text = @"";
            
            } else {                
                NSSet *orderDetails = [[object valueForKey:@"toOrderDetails"] valueForKeyPath:@"productid"];
                NSArray *orderDetailsItem = [orderDetails allObjects];
                NSSet *orderDetails2 = [[object valueForKey:@"toOrderDetails"] valueForKeyPath:@"quantityordered"];
                NSArray *orderDetailsItem2 = [orderDetails2 allObjects];
                cell.textLabel.text = [orderDetailsItem objectAtIndex:(indexPath.row)];
                cell.detailTextLabel.text = [[orderDetailsItem2 objectAtIndex:(indexPath.row)] stringValue];
            }
        }
    }
    
    
    // DELIVERY INSTRUCTIONS
    if (indexPath.section == 3) {
        [(UILabel *)[cell viewWithTag:1] setText:[[object valueForKey:@"shipping_instructions"] description]];
    }
    
    // SHIPPING CARRIER
    if (indexPath.section == 4) {
        
    }
    
    // SIGNATURE
    if (indexPath.section == 5) {
    }
    
    
   
}







@end

