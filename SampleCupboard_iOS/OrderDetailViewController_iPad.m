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

@end

@implementation OrderDetailViewController_iPad

NSArray *tableData;
NSArray *tableDataX;
NSArray *prodDataX;
NSArray *unitDataX;
NSArray *statusDataX;


@synthesize selectedButton, outputlabel;




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    int NSections = 2;
    if (1 == 2) {
        // Check If HCP Populated
        NSections = 3;
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
    
    [outputlabel setText:[NSString stringWithFormat:@"Your button was %d", selectedButton]];
    
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
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *simpleTableIdentifier2 = @"SimpleTableItem2";
    
    
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
        [(UILabel *)[cell viewWithTag:1] setText:@"MCG0000001"];
    }
    
    // REQUESTED PHYSICIAN
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
         [(UILabel *)[cell viewWithTag:1] setText:@"DOCTOR NAME"];
         } else {
         [(UILabel *)[cell viewWithTag:0] setText:@"ADDRESS LINE 1 \n ADDRESS LINE 2 \n ADDRESS LINE 3"];
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
        [(UILabel *)[cell viewWithTag:1] setText:@"DOCTOR NAME"];
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

