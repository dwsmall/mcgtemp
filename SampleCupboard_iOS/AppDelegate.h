//
//  AppDelegate.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-17.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UISplitViewController *splitViewController;


// current view
@property (strong, nonatomic) NSString *globalMode;

// transition modes (user chose...)
@property (strong, nonatomic) NSString *globalHcpChosen;
@property (strong, nonatomic) NSString *globalProductChosen;

// hcp dictionary
@property (strong, nonatomic) NSDictionary *globalHcpDictionary;

// retain values
@property (strong, nonatomic) NSString *globalShipInfo;
@property (strong, nonatomic) NSString *globalShipType;

// screen handling
@property (strong, retain) NSMutableArray *globalProductsRmv;
@property (strong, retain) NSMutableArray *globalProductsScrn;

@property (strong, nonatomic) NSString *globalRmvProductsFetch;


// credentials on login
@property (strong, retain) NSString *globalUserID;
@property (strong, retain) NSString *globalToken;
@property (strong, retain) NSString *globalBaseUrl;
@property (strong, retain) NSString *globalClientId;
@property (strong, retain) NSString *globalAllocationId;





// not really needed
@property (strong, nonatomic) NSManagedObject *globalOrderMO;
@property (strong, nonatomic) NSManagedObject *globalHcpMO;



// Data Management

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// Data Management



@end
