//
//  HcpChoice.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreData/CoreData.h>

@interface HcpChoice : UIViewController <NSFetchedResultsControllerDelegate> {

NSIndexPath *checkedCell;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end