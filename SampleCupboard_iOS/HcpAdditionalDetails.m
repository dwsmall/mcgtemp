//
//  HcpAdditionalDetails.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-12.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "HcpAdditionalDetails.h"

@interface HcpAdditionalDetails ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end



@implementation HcpAdditionalDetails


@synthesize currentHCPINFOEXT;

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
    return 3;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *HeaderTitle = @"";
    
    switch (section)
    
    {
        case 0:
            HeaderTitle = @"";  //Address Type
            break;
            
        case 1:            
            HeaderTitle = @"Details";
            break;
            
        case 2:            
            HeaderTitle = @"Communication";
            break;            
    }
    
    return HeaderTitle;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     
    int MRows = 0;
    
    switch (section)
    
    {
        case 0:
            MRows=1;    //Address Type
            break;
            
        case 1:
            MRows=7;    //Details
            break;
            
        case 2:
            MRows=3;    //Communication
            break;
            
    }
    
    return MRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *MyFormType = @"_typeA";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyFormType forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}





- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
        
    switch (indexPath.section)
    
    {
        case 0: //Address Type
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Address Type:";
                cell.detailTextLabel.text = currentHCPINFOEXT[8];
            }
            break;
            			
        case 1: //Details
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Facility Name:";
                cell.detailTextLabel.text = currentHCPINFOEXT[9];
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Address 1:";
                cell.detailTextLabel.text = currentHCPINFOEXT[10];
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"Address 2:";
                cell.detailTextLabel.text = currentHCPINFOEXT[11];
            }
            if (indexPath.row == 3) {
                cell.textLabel.text = @"Address 3:";
                cell.detailTextLabel.text = currentHCPINFOEXT[12];
            }
            if (indexPath.row == 4) {
                cell.textLabel.text = @"Province:";
                cell.detailTextLabel.text = currentHCPINFOEXT[13];
            }
            if (indexPath.row == 5) {
                cell.textLabel.text = @"City:";
                cell.detailTextLabel.text = currentHCPINFOEXT[14];
            }
            if (indexPath.row == 6) {
                cell.textLabel.text = @"Postal:";
                cell.detailTextLabel.text = currentHCPINFOEXT[15];
            }            
            break;
            
            
        case 2:  //Communication
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Telephone:";
                cell.detailTextLabel.text = currentHCPINFOEXT[5];
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Extension:";
                cell.detailTextLabel.text = currentHCPINFOEXT[16];
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"Fax:";
                cell.detailTextLabel.text = currentHCPINFOEXT[6];
            }
            
            break;
    }
    
    
}

@end
