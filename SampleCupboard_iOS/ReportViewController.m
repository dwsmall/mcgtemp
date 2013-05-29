//
//  ReportViewController.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-29.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "ReportViewController.h"


@interface ReportViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation ReportViewController


NSArray *tableData;
NSArray *tableDataX;
NSArray *tableDataY;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [tableData count];
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    // Create first cell
    // static NSString *CellIdentifier = @"Cell";
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"_reportItem"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    //UIImage *imageFile = [tableDataY objectAtIndex:indexPath.row];
    //UIImageView *rImageView = (UIImageView *)[cell viewWithTag:8003];
    //rImageView.image = [UIImage imageNamed:imageFile];
    
    UILabel *PDate = (UILabel *)[cell viewWithTag:8001];
    [PDate setText:[tableData objectAtIndex:[indexPath row]]];
    
    UILabel *PName = (UILabel *)[cell viewWithTag:8002];
    [PName setText:[tableDataX objectAtIndex:[indexPath row]]];
    
   // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    // cell.detailTextLabel.text = [tableDataX objectAtIndex:indexPath.row];
    
    return cell;
    
    
    // cell.textLabel.text = identifier;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    tableData = [NSArray arrayWithObjects:@"My Usage", @"Territory Allocation", @"My Team", nil];
    tableDataX = [NSArray arrayWithObjects:@"Show your total usage per product, by period (YTD, allocation period, current month)",
                  @"Shows product allocations for your territory, quantity used (in units and %) and remaining MCG Inventory levels.",
                  @"Lists all representatives in your territory(ies), group by territory name",
                  nil];
    tableDataY = [NSArray arrayWithObjects:@"my_allocations.png", @"my_allocations.png", @"my_allocations.png", nil];
    
    
    
    [self.tableView reloadData];
}



@end
