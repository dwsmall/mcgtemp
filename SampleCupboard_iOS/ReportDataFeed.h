//
//  ReportDataFeed.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "JSONModel.h"
#import "LoanModel.h"

@interface ReportDataFeed : JSONModel

@property (strong, nonatomic) NSArray<LoanModel>* loans;

@end
