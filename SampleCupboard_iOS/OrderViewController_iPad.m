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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"creme_brelee.jpg"];

    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     tableData = [NSArray arrayWithObjects:@"April 27, 2013", @"April 28, 2013", @"April 29, 2013", nil];
    
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