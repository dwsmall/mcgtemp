//
//  OrderDetailViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "OrderDetailViewController_iPad.h"

@interface OrderDetailViewController_iPad ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tbActions;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tbSaveDraft;


- (IBAction)CancelClicked:(id)sender;

- (IBAction)DoneClicked:(id)sender;

- (IBAction)NewProductClick:(id)sender;

- (IBAction)tbActionsClick:(id)sender;

- (IBAction)tbSaveDraftClick:(id)sender;

- (IBAction)CellEditorBegunEditing:(id)sender;

- (IBAction)CellEditorEndedEdit:(id)sender;


- (IBAction)CancelOrderDetail:(UIBarButtonItem *)sender;

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
@synthesize selectedPRODUCTNUMBER, outputlabel3;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    int NSections = 2;
    
    // NEW RECORD
    if (selectedButton == 0)
    {
        if (selectedHCPNUMBER == 1001) {
            NSections = 3;  // Stage 2 - SHOW HCP INFO...            
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
    // return [tableData count];
    
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
            
            //To Be Delivered To Physician
            MRows=2;  //7
            break;
            
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
    
    // [outputlabel setText:[NSString stringWithFormat:@"Your button was %d", selectedButton]];
    
    // DETERMINE STAGE OF APPLICATION
    
        //STAGE 1 - [SEGUE 1 AND NO HCP SELECTED] =  NEW ORDER
        //STAGE 2 - [SEGUE 1 AND HCP SELECTED AND PRODUCT TOTAL = 0] = NEW ORDER AND HCP SELECTED
        //STAGE 3 - [SEGUE 1 AND HCP SELECTED AND PRODUCT TOTAL <> 0] = NEW ORDER AND WITH PRODUCTS SELECTED
        //STAGE 4 - [SEGUE 2] = SHOW ORDER DETAIL INFORMATION
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    tableData = [NSArray arrayWithObjects:@"April 27, 2013", @"April 28, 2013", @"April 29, 2013",@"April 99, 2013", @"April 77, 2013", @"April 66, 2013", nil];
    
    tableDataX = [NSArray arrayWithObjects:@"To:John Smith", @"To:Dale Smith", @"To:Doug Smith",@"To:DD Smith", @"To:BB Smith", @"To:CC Smith", nil];
    
    prodDataX = [NSArray arrayWithObjects:@"Januvia 100mg (7 tablets)", @"Janumet 50 mg (3 tablets)", @"Olmetec 40mg (3 tablets)",@"cc 100mg (7 tablets)", @"dd 50 mg (3 tablets)", @"ee 40mg (3 tablets)", nil];
    
    unitDataX = [NSArray arrayWithObjects:@"5 Units", @"4 Units", @"7 Units",@"99 Units", @"88 Units", @"77 Units", nil];
    
    statusDataX = [NSArray arrayWithObjects:@"IN PROGRESS", @"IN PROGRESS", @"ON HOLD",@"WAIT", @"WAIT", @"BACKORDER", nil];
    
    // [self.tableView reloadData];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *simpleTableIdentifier = @"SimpleTableItem";
    // static NSString *simpleTableIdentifier2 = @"SimpleTableItem2";
    
    
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
            if (indexPath.row == 0) {
                MyFormType=@"_lineItem";
            }
            else {
                MyFormType=@"_newLineItem";
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






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CancelClicked:(id)sender {
}

- (IBAction)DoneClicked:(id)sender {
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
    
    NSLog(@"process Name 222222 BIG");

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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
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
            [(UILabel *)[cell viewWithTag:1] setText:@"MCG0000001"];
            [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"btn %d", selectedButton]];
        }
        
    }
    
    // REQUESTED PHYSICIAN
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            if (selectedButton == 0) // NEW ORDER
            {
                if (selectedHCPNUMBER == 1001) {
                    [(UILabel *)[cell viewWithTag:1] setText:@"hcp name"]; // load hcp Name
                } else {
                    [(UILabel *)[cell viewWithTag:1] setText:@"SELECT PHYSICIAN"];
                }
            }
            
            
            if (selectedButton == 2)  // SHOW DETAILS
            {
                [(UILabel *)[cell viewWithTag:1] setText:@"Doctors Name"];
            }
            
            
         } else {
             
         
             if (selectedButton == 0) // NEW ORDER
             {
                 if (selectedHCPNUMBER == 1001) {
                     [(UILabel *)[cell viewWithTag:0] setText:@"Address line1 \n Address line2 \n"]; // load Address
                 } else {
                     [(UILabel *)[cell viewWithTag:0] setText:@""];
                 }
             }
             
             
             if (selectedButton == 2)  // SHOW DETAILS
             {
                 [(UILabel *)[cell viewWithTag:0] setText:@"Get Address \n"];
             }
             
        }        
    }
    
    // DELIVERED TO PHYSICIAN
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"TEST123";
        }
    }
    
    
    // DELIVERY INSTRUCTIONS
    if (indexPath.section == 3) {
        [(UILabel *)[cell viewWithTag:1] setText:@"SHIPPING INSTRUCTIONS"];
    }
    
    // SHIPPING CARRIER
    if (indexPath.section == 4) {
        // [(UILabel *)[cell viewWithTag:1] setText:@"DOCTOR NAME"];
    }
    
    // SIGNATURE
    if (indexPath.section == 5) {
        // [(UILabel *)[cell viewWithTag:1] setText:@"DOCTOR NAME"];
    }
    
    
   
}

@end

