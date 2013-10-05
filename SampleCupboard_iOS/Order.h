//
//  Order.h
//  SampleCupboard_iOS
//
//  Created by David Small on 9/19/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderLineItem;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSString * allocationid;
@property (nonatomic, retain) NSString * applicationsource;
@property (nonatomic, retain) NSString * clientid;
@property (nonatomic, retain) NSString * creatorid;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * datemodified;
@property (nonatomic, retain) NSDate * datereleased;
@property (nonatomic, retain) NSDate * dateshipped;
@property (nonatomic, retain) NSDate * datesigned;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * options_isfinalized;
@property (nonatomic, retain) NSString * ordercontenttype;
@property (nonatomic, retain) NSString * orderid;
@property (nonatomic, retain) NSString * ownerid;
@property (nonatomic, retain) NSString * projectcode;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSString * refprefix;
@property (nonatomic, retain) NSString * shipping_addressid;
@property (nonatomic, retain) NSString * shipping_addressline1;
@property (nonatomic, retain) NSString * shipping_addressline2;
@property (nonatomic, retain) NSString * shipping_addressline3;
@property (nonatomic, retain) NSString * shipping_city;
@property (nonatomic, retain) NSString * shipping_country;
@property (nonatomic, retain) NSString * shipping_email;
@property (nonatomic, retain) NSString * shipping_facilityname;
@property (nonatomic, retain) NSString * shipping_fax;
@property (nonatomic, retain) NSString * shipping_firstname;
@property (nonatomic, retain) NSString * shipping_instructions;
@property (nonatomic, retain) NSString * shipping_lastname;
@property (nonatomic, retain) NSString * shipping_licence;
@property (nonatomic, retain) NSString * shipping_notes;
@property (nonatomic, retain) NSString * shipping_partner;
@property (nonatomic, retain) NSString * shipping_phone;
@property (nonatomic, retain) NSString * shipping_phoneextension;
@property (nonatomic, retain) NSString * shipping_postalcode;
@property (nonatomic, retain) NSString * shipping_province;
@property (nonatomic, retain) NSString * shipping_status;
@property (nonatomic, retain) NSString * shipping_suite;
@property (nonatomic, retain) NSString * shipping_territory;
@property (nonatomic, retain) NSString * shipping_type;
@property (nonatomic, retain) NSString * shiptoid;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * statusreason;
@property (nonatomic, retain) NSString * territoryid;
@property (nonatomic, retain) NSString * trackingnumbers;
@property (nonatomic, retain) NSString * formnumber;
@property (nonatomic, retain) NSSet *toOrderDetails;
@end

@interface Order (CoreDataGeneratedAccessors)

- (void)addToOrderDetailsObject:(OrderLineItem *)value;
- (void)removeToOrderDetailsObject:(OrderLineItem *)value;
- (void)addToOrderDetails:(NSSet *)values;
- (void)removeToOrderDetails:(NSSet *)values;

@end
