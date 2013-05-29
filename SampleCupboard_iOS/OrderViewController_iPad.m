//
//  OrderViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "OrderViewController_iPad.h"

@interface OrderViewController_iPad ()


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UISegmentedControl *orderStatusFilter;

@property (weak, nonatomic) IBOutlet UISegmentedControl *orderStatusFilterValueChanged;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)OrderStatusFilterValueChanged:(UISegmentedControl *)sender;


@end

@implementation OrderViewController_iPad

NSArray *tableData;
NSArray *tableDataX;
NSArray *prodDataX;
NSArray *unitDataX;
NSArray *statusDataX;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return [tableData count];
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    if(indexPath.row==0){
        // Create first cell
        
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"_topHeader"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        }
        
        UILabel *PDate = (UILabel *)[cell viewWithTag:600];
        [PDate setText:[tableData objectAtIndex:[indexPath row]]];
        
        UILabel *PName = (UILabel *)[cell viewWithTag:601];
        [PName setText:[tableDataX objectAtIndex:[indexPath row]]];
        
        return cell;
        
        
    }
    
    if(indexPath.row==1){
        // Create second cell
        
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"_lineItem"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        }
        
        // cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
        
        
        
        UILabel *XName = (UILabel *)[cell viewWithTag:602	];
        [XName setText:[prodDataX objectAtIndex:[indexPath row]]];
        
        
        UILabel *YName = (UILabel *)[cell viewWithTag:603	];
        [YName setText:[unitDataX objectAtIndex:[indexPath row]]];
        
        
        return cell;
    }
    
    else{
        // Create all others
        
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"_summary"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
        }
        
        // cell.textLabel.text = [statusDataX objectAtIndex:indexPath.row];
        
        UILabel *XName = (UILabel *)[cell viewWithTag:604];
        [XName setText:[statusDataX objectAtIndex:[indexPath row]]];
        
        return cell;
        
        
    }
    
    // UPDATE TOP ROW
    
    
    
    // cell.textLabel.text = identifier;
    
        

   
}












- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     tableData = [NSArray arrayWithObjects:@"April 27, 2013", @"April 28, 2013", @"April 29, 2013", nil];
    
    tableDataX = [NSArray arrayWithObjects:@"To:John Smith", @"To:Dale Smith", @"To:Doug Smith", nil];
    
    prodDataX = [NSArray arrayWithObjects:@"Januvia 100mg (7 tablets)", @"Janumet 50 mg (3 tablets)", @"Olmetec 40mg (3 tablets)", nil];
    
    unitDataX = [NSArray arrayWithObjects:@"5 Units", @"4 Units", @"7 Units", nil];
    
    statusDataX = [NSArray arrayWithObjects:@"IN PROGRESS", @"IN PROGRESS", @"ON HOLD", nil];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)OrderStatusFilterValueChanged:(UISegmentedControl *)sender {
}
@end