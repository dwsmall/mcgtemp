//
//  HcpListViewController_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@class HcpListViewController;

@interface HcpListViewController : UIViewController <UISearchBarDelegate, NSFetchedResultsControllerDelegate>
    
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end