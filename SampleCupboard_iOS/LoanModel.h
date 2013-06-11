//
//  LoanModel.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "JSONModel.h"
#import "LocationModel.h"

@protocol LoanModel @end

@interface LoanModel : JSONModel

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSString* use;

@property (strong, nonatomic) LocationModel* location;

@end

