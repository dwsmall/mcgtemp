//
//  ReportDetailContainer.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-01.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "ReportViewController.h"


@interface ReportDetailContainer : UIViewController <UISplitViewControllerDelegate> {
    UIViewController* topController;
}

-(void)showViewWithId:(int)viewId;

@property (strong, nonatomic) ReportViewController *detailViewController1;
@property (strong, nonatomic) ReportViewController *detailViewController2;
@property (strong, nonatomic) ReportViewController *detailViewController3;

@end