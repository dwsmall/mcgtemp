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
    
    NSManagedObject *moDATA;
        
}


@property (weak, nonatomic) IBOutlet UITableView *tableViewX;
@property (strong, nonatomic) HCPDetailController *player;

// PASSED VALUES
@property (nonatomic) NSString *selectedHCPMSG;
@property (nonatomic) NSInteger *selectedHCPNUMBER;
@property (nonatomic) NSIndexPath *selectedHCPINDEX;

@property (nonatomic) NSArray *currentHCPINFO;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) IBOutlet UILabel *outputlabelA;
@property (strong, nonatomic) NSManagedObject *moDATA;

@end
