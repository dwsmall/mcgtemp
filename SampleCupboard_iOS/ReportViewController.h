//
//  ReportViewController.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-29.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@class ReportDetailContainer;

@interface ReportViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ReportDetailContainer *reportDetailContainer;

@end

