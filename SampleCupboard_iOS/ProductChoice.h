//
//  ProductChoice.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-11.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@interface ProductChoice : UIViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate> {
    
    NSIndexPath *checkedCell;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end