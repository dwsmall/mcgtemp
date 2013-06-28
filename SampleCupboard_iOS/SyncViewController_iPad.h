//
//  SyncViewController_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

NSFetchedResultsController *fetchedResultsController;
NSManagedObjectContext *managedObjectContext;

@interface SyncViewController_iPad : UIViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end