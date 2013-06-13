//
//  HcpDetailController.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-06.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreData/CoreData.h>

@class HCPDetailController;


@interface HcpDetailController : UIViewController <NSFetchedResultsControllerDelegate> {

    NSString *selectedHCPMSG;
    NSInteger *selectedHCPNUMBER;
    NSIndexPath *selectedHCPINDEX;
    NSArray *currentHCPINFO;
        
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


@end
