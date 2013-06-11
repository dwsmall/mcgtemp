//
//  ReportTeam.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-05.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "ReportTeam.h"

#import "JSONModelLib.h"
#import "ReportDataFeed.h"
// #import "HUD.h"


@interface ReportTeam () {
        ReportDataFeed* _feed;
}

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end





@implementation ReportTeam


-(void)viewDidLoad
{
    [super viewDidLoad];
    //show loader view
    // [HUD showUIBlockingIndicatorWithText:@"Fetching JSON"];
    
    //fetch the feed
    _feed = [[ReportDataFeed alloc] initFromURLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"
                                         completion:^(JSONModel *model, JSONModelError *err) {
                                             
                                             //hide the loader view
                                             // [HUD hideUIBlockingIndicator];
                                             
                                             //json fetched
                                             NSLog(@"loans: %@", _feed.loans);
                                             
                                             [self.tableView reloadData];
                                             
                                }];
}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feed.loans.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoanModel* loan = _feed.loans[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_team" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ from %@",
                           loan.name, loan.location.country
                           ];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LoanModel* loan = _feed.loans[indexPath.row];
    
    NSString* message = [NSString stringWithFormat:@"%@ from %@ needs a loan %@",
                         loan.name, loan.location.country, loan.use
                         ];
    
    
    // [HUD showAlertWithTitle:@"Loan details" text:message];
}

@end