//
//  OrderTemplate.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-07-04.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderTemplateLine;

@interface OrderTemplate : NSManagedObject

@property (nonatomic, retain) NSString * allocationid;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * ownerid;
@property (nonatomic, retain) NSString * shipping_addressid;
@property (nonatomic, retain) NSString * shipping_instructions;
@property (nonatomic, retain) NSString * shiptoid;
@property (nonatomic, retain) NSString * templatename;
@property (nonatomic, retain) NSString * territoryid;
@property (nonatomic, retain) NSSet *toOrdTempDetails;
@end

@interface OrderTemplate (CoreDataGeneratedAccessors)

- (void)addToOrdTempDetailsObject:(OrderTemplateLine *)value;
- (void)removeToOrdTempDetailsObject:(OrderTemplateLine *)value;
- (void)addToOrdTempDetails:(NSSet *)values;
- (void)removeToOrdTempDetails:(NSSet *)values;

@end
