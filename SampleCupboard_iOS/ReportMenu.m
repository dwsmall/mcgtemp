//
//  ReportMenu.m
//  SampleCupboard_iOS
//
//  Created by David Small on 8/29/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "ReportMenu.h"
#import "ReportDetails.h"

#import "Reachability.h"



static NSString* myglobRptChoice = nil;


NSArray *tableData;
NSArray *tableDataX;
NSArray *tableDataY;


@interface ReportMenu ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation ReportMenu

@synthesize reportchoice, oreportchoice;

#pragma mark - viewDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableData = [NSArray arrayWithObjects:NSLocalizedString(@"My Usage", nil), NSLocalizedString(@"Territory Allocation", nil), NSLocalizedString(@"My Team", nil), nil];
    tableDataX = [NSArray arrayWithObjects:NSLocalizedString(@"MyUsageDescription", nil),
                  NSLocalizedString(@"TerritoryAllocationDescription", nil),
                  NSLocalizedString(@"MyTeamDescription", nil),
                  nil];
    tableDataY = [NSArray arrayWithObjects:@"my_usage.png", @"my_allocations.png", @"my_team.png", nil];
    
    // self.navBarItem.title = NSLocalizedString(@"Reports", nil);
    
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    // create first cell
    
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
    
    // check internet status
    
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    
    
    // show msg if offline
    if([indexPath row] != 1  && internetStatus == NotReachable) {
    
    if (internetStatus == NotReachable){
        
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:NSLocalizedString(@"No internet connection", nil)
                                       message:NSLocalizedString(@"Internet connection is required to view reporting", nil) 
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        
        [errorAlertView show];
        
        
    }
    
    }
    
    // populate rpt choice
    
    if( ([indexPath row] < 3  && internetStatus != NotReachable) || (internetStatus == NotReachable && [indexPath row] == 1) ) {
        
        
        myglobRptChoice = [NSString stringWithFormat:@"%ld", (long)[indexPath row]];
       
        // used notification cause delgate in tab has issues

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshList" object:nil];
  
    }
    
    
    
        
        
}



#pragma mark - utilities

+ (NSString*)globRptChoice {
    return myglobRptChoice;
}





@end
