//
//  OrderTemplateLine.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-07-04.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderTemplateLine : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * ordertemplateid;
@property (nonatomic, retain) NSString * productid;
@property (nonatomic, retain) NSNumber * quantityordered;
@property (nonatomic, retain) NSManagedObject *toOrdTempHdr;

@end
