//
//  HcpDetailController.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-06.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@class HCPDetailController;


@interface HcpDetailController : UIViewController <NSFetchedResultsControllerDelegate> {

    NSString *selectedHCPMSG;
    NSInteger *selectedHCPNUMBER;
    NSIndexPath *selectedHCPINDEX;
    NSArray *currentHCPINFO;
    
    NSNumber *previousOrdersRetrieved;
    
    NSManagedObject *moDATAHCP;
        
}


@property (weak, nonatomic) IBOutlet UITableView *tableViewX;
@property (strong, nonatomic) HCPDetailController *player;

@property (nonatomic) NSNumber *previousOrdersRetrieved;
@property (nonatomic, strong) NSMutableArray *storePreviousOrders;

// PASSED VALUES
@property (nonatomic) NSString *selectedHCPMSG;
@property (nonatomic) NSInteger *selectedHCPNUMBER;
@property (nonatomic) NSIndexPath *selectedHCPINDEX;

@property (nonatomic) NSArray *currentHCPINFO;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UILabel *outputlabelA;
@property (strong, nonatomic) NSManagedObject *moDATAHCP;

@end
