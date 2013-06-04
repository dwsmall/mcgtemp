//
//  ReportAllocationUsage.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreData/CoreData.h>

@interface ReportAllocationUsage : UIViewController <NSFetchedResultsControllerDelegate>
    
    @property (strong, nonatomic) id detailItem;
    @property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
    @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
