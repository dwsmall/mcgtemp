//
//  Allocation.h
//  SampleCupboard_iOS
//
//  Created by David Small on 10/7/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllocationHeader;

@interface Allocation : NSManagedObject

@property (nonatomic, retain) NSString * allocationheaderid;
@property (nonatomic, retain) NSNumber * avail_allocation;
@property (nonatomic, retain) NSNumber * avail_inventory;
@property (nonatomic, retain) NSString * clientid;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * datemodified;
@property (nonatomic, retain) NSNumber * defaultordermax;
@property (nonatomic, retain) NSNumber * hasavailableinventory;
@property (nonatomic, retain) NSString * hcptargetlistid;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * inventory;
@property (nonatomic, retain) NSNumber * ishcp;
@property (nonatomic, retain) NSNumber * ishcptargetlist;
@property (nonatomic, retain) NSNumber * isrep;
@property (nonatomic, retain) NSNumber * isterritory;
@property (nonatomic, retain) NSNumber * ordermax;
@property (nonatomic, retain) NSNumber * originalordermax;
@property (nonatomic, retain) NSNumber * originaltotalmax;
@property (nonatomic, retain) NSString * parentid;
@property (nonatomic, retain) NSString * personalid;
@property (nonatomic, retain) NSString * productcode;
@property (nonatomic, retain) NSString * productdescription;
@property (nonatomic, retain) NSString * productid;
@property (nonatomic, retain) NSString * productname;
@property (nonatomic, retain) NSString * productstatus;
@property (nonatomic, retain) NSNumber * productvisibleflag;
@property (nonatomic, retain) NSString * territoryid;
@property (nonatomic, retain) NSString * territoryname;
@property (nonatomic, retain) NSNumber * totalmax;
@property (nonatomic, retain) NSNumber * quantity_used;
@property (nonatomic, retain) NSNumber * percentage_used;
@property (nonatomic, retain) AllocationHeader *toAllocHdr;

@end
