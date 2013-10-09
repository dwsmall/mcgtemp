//
//  Order+Extensions.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-08-07.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "Order.h"

@interface Order (Extensions)

+ (void)importDataToMoc:(NSManagedObjectContext *)moc;
- (NSString *)sectionTitle;

@end

