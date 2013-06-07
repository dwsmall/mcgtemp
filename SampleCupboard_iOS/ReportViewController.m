//
//  ReportViewController.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-29.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportDetailContainer.h"

NSArray *tableData;
NSArray *tableDataX;
NSArray *tableDataY;




@interface ReportViewController () {
     NSMutableArray *_objects;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end


@implementation ReportViewController


- (void)awakeFromNib
{
    // self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableData = [NSArray arrayWithObjects:@"My Usage", @"Territory Allocation", @"My Team", nil];
    tableDataX = [NSArray arrayWithObjects:@"Show your total usage per product, by period (YTD, allocation period, current month)",
                  @"Shows product allocations for your territory, quantity used (in units and %) and remaining MCG Inventory levels.",
                  @"Lists all representatives in your territory(ies), group by territory name",
                  nil];
    tableDataY = [NSArray arrayWithObjects:@"Images/my_usage.png", @"Images/my_allocations.png", @"Images/my_team.png", nil];
    
        
    [self.tableView reloadData];
    self.reportDetailContainer = (ReportDetailContainer *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [tableData count];
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    // Create first cell
   
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"_reportItem"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
   
    UILabel *PDate = (UILabel *)[cell viewWithTag:8001];
    [PDate setText:[tableData objectAtIndex:[indexPath row]]];
    
    UILabel *PName = (UILabel *)[cell viewWithTag:8002];
    [PName setText:[tableDataX objectAtIndex:[indexPath row]]];
    
    
    UIImageView *PicView = (UIImageView *)[cell viewWithTag:8003];
    UIImage *PicName = [UIImage imageNamed:[tableDataY objectAtIndex:[indexPath row]]];
    [PicView setImage:PicName];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] < 3) {
        [self.reportDetailContainer showViewWithId:[indexPath row]];
    }
}

@end
