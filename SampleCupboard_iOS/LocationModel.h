//
//  LocationModel.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "JSONModel.h"

@interface LocationModel : JSONModel

@property (strong, nonatomic) NSString* country_code;
@property (strong, nonatomic) NSString* country;

@end
