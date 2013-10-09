//
//  LoginViewController_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

// #import "IndentTextField.h"

#import "MBProgressHUD.h"

NSFetchedResultsController *fetchedResultsController;
NSManagedObjectContext *managedObjectContext;

@interface LoginViewController : UIViewController {
    
    MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end