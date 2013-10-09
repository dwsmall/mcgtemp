//
//  Territory.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-07-04.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Territory : NSManagedObject

@property (nonatomic, retain) NSString * clientid;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * datemodified;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * territorynumber;
@property (nonatomic, retain) NSString * territory_id;
@property (nonatomic, retain) NSSet *toFSA;
@end

@interface Territory (CoreDataGeneratedAccessors)

- (void)addToFSAObject:(NSManagedObject *)value;
- (void)removeToFSAObject:(NSManagedObject *)value;
- (void)addToFSA:(NSSet *)values;
- (void)removeToFSA:(NSSet *)values;

@end
