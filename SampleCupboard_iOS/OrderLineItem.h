//
//  OrderLineItem.h
//  SampleCupboard_iOS
//
//  Created by David Small on 10/9/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface OrderLineItem : NSManagedObject

@property (nonatomic, retain) NSString * clientid;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * datemodified;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * orderid;
@property (nonatomic, retain) NSString * productid;
@property (nonatomic, retain) NSNumber * quantityordered;
@property (nonatomic, retain) NSString * stored_product_code;
@property (nonatomic, retain) NSString * stored_product_description;
@property (nonatomic, retain) NSString * stored_product_name;
@property (nonatomic, retain) Order *toOrderHeader;

@end
