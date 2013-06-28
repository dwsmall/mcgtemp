//
//  HcpChoice.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@interface HcpChoice : UIViewController <NSFetchedResultsControllerDelegate> {

NSIndexPath *checkedCell;
NSIndexPath *path;
}



@property (nonatomic, copy) NSIndexPath *path;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end