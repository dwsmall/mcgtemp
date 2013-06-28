//
//  OrderLineItem.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-17.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderLineItem : NSManagedObject

@property (nonatomic, retain) NSString * clientid;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * datemodified;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * orderid;
@property (nonatomic, retain) NSString * productid;
@property (nonatomic, retain) NSNumber * quantityordered;
@property (nonatomic, retain) NSManagedObject *toOrderHeader;

@end
