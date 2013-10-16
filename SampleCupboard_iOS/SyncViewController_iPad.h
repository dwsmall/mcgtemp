//
//  SyncViewController_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "MBProgressHUD.h"

NSFetchedResultsController *fetchedResultsController;
NSManagedObjectContext *managedObjectContext;

@class MBProgressHUD;

@interface SyncViewController_iPad : UIViewController <MBProgressHUDDelegate, NSFetchedResultsControllerDelegate> {

    MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
    
    // xml container
    NSMutableDictionary *orderValue_Dict;
    NSMutableDictionary *orderValueExt_Dict;
    
}


// xml container
@property (strong, nonatomic) NSDictionary *orderValue_Dict;
@property (strong, nonatomic) NSDictionary *orderValueExt_Dict;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UILabel *_hcp_stamp;

@property (strong, nonatomic) IBOutlet UILabel *_data_stamp;

@end