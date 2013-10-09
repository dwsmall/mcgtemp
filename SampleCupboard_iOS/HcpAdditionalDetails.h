//
//  HcpAdditionalDetails.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-12.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@class HcpAdditionalDetails;


@interface HcpAdditionalDetails : UIViewController <NSFetchedResultsControllerDelegate> {

    NSArray *currentHCPINFOEXT;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewX;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSArray *currentHCPINFOEXT;

@end
