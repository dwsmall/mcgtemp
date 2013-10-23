//
//  ReportDetails.h
//  SampleCupboard_iOS
//
//  Created by David Small on 8/29/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>

@interface ReportDetails : UIViewController <UISplitViewControllerDelegate, MBProgressHUDDelegate> {

    MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
    NSNumber *countFromJson;
}


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UIPopoverController *popover;

@property (strong, nonatomic) IBOutlet UINavigationItem *navBarItem;


@property (nonatomic) NSNumber *countFromJSON;
@property (nonatomic, strong) NSMutableArray *storeRcdsJSON;

@property (nonatomic, strong) NSMutableArray *arraySectionCount;


@property (strong, nonatomic) IBOutlet UILabel *reportTitle;

@property (nonatomic, strong) UIPopoverController *popoverX;

@end
