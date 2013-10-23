//
//  ReportMenu.h
//  SampleCupboard_iOS
//
//  Created by David Small on 8/29/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//


// @protocol ReportSelectionDelegate

// @end

#import <UIKit/UIKit.h>


@class DetailViewController;


@interface ReportMenu : UITableViewController {

    
    NSInteger reportchoice;
    
}

@property (strong, nonatomic) DetailViewController *detailViewController;


@property (nonatomic) NSInteger reportchoice;
@property (nonatomic, weak) IBOutlet UILabel *oreportchoice;








+ (NSString*)globRptChoice;

@end
