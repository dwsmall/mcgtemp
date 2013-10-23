//
//  TemplateSelection.h
//  SampleCupboard_iOS
//
//  Created by David Small on 8/13/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//


@interface TemplateSelection : UIViewController <NSFetchedResultsControllerDelegate> {
    
    NSIndexPath *checkedCell;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
