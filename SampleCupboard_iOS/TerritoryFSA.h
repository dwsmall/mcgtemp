//
//  TerritoryFSA.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-07-04.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Territory;

@interface TerritoryFSA : NSManagedObject

@property (nonatomic, retain) NSString * clientid;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * datemodified;
@property (nonatomic, retain) NSString * fsa;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * territory_id;
@property (nonatomic, retain) Territory *toTerritory;

@end
