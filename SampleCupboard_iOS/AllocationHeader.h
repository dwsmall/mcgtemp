//
//  AllocationHeader.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-07-04.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AllocationHeader : NSManagedObject

@property (nonatomic, retain) NSString * allocdescription;
@property (nonatomic, retain) NSString * clientid;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * dateend;
@property (nonatomic, retain) NSDate * datemodified;
@property (nonatomic, retain) NSDate * datestart;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * inactive;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSSet *toAllocDetails;
@end

@interface AllocationHeader (CoreDataGeneratedAccessors)

- (void)addToAllocDetailsObject:(NSManagedObject *)value;
- (void)removeToAllocDetailsObject:(NSManagedObject *)value;
- (void)addToAllocDetails:(NSSet *)values;
- (void)removeToAllocDetails:(NSSet *)values;

@end
