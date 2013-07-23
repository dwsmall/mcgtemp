//
//  OrderDetailViewController_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@interface OrderDetailViewController_iPad : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    

    NSMutableDictionary *orderValue_Dict;
    NSMutableDictionary *orderValueExt_Dict;
    NSMutableArray *orderValueDetails_Arr;
    
    NSInteger keyboardObservable;
    
    NSInteger selectedButton;
    NSInteger selectedHCP;
    
    NSInteger selectedHCPNUMBER;
    NSArray *selectedHCPINFO;

    NSInteger selectedPRODUCTNUMBER;
    
    NSFetchedResultsController *fetchedResultsController2;
    NSManagedObjectContext *managedObjectContext2;
    NSArray *myresults;
    
    NSFetchRequest *fetchRequest2;
    NSObject *fetchOBJ2;
    
    
    NSManagedObject *moDATA;
    
    NSManagedObject *moHCPDATA;
    
    
    
    
}

// Capture Order Values For xml Conversion
@property (strong, nonatomic) NSDictionary *orderValue_Dict;
@property (strong, nonatomic) NSDictionary *orderValueExt_Dict;
@property (strong, nonatomic) NSArray *orderValueDetails_Arr;

// Keyboard Observable
@property (nonatomic) NSInteger keyboardObservable;


@property (strong, nonatomic) IBOutlet UIButton *ok_btn;


@property (weak, nonatomic) IBOutlet UITextField *hiddenTextField;

@property (nonatomic) NSInteger selectedButton;
@property (nonatomic) NSInteger selectedHCP;

@property (nonatomic) NSInteger selectedHCPNUMBER;
@property (nonatomic) NSArray *selectedHCPINFO;

@property (nonatomic) NSInteger selectedPRODUCTNUMBER;

@property (nonatomic, weak) IBOutlet UILabel *outputlabel;
@property (nonatomic, weak) IBOutlet UILabel *outputlabel1;
@property (nonatomic, weak) IBOutlet UILabel *outputlabel2;
@property (nonatomic, weak) IBOutlet UILabel *outputlabel3;
@property (nonatomic, weak) IBOutlet UILabel *outputlabel4;

@property (nonatomic, weak) IBOutlet UILabel *outputlabelA;
@property (nonatomic, weak) IBOutlet UILabel *outputlabelB;

@property (nonatomic, weak) IBOutlet UILabel *outputlabelC;
@property (nonatomic, weak) IBOutlet UILabel *outputlabelD;

@property (nonatomic, weak) IBOutlet UILabel *outputlabelE;

@property (nonatomic, weak) IBOutlet UILabel *outputlabelF;

@property (nonatomic, weak) IBOutlet UILabel *outputlabel5;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContextToken;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController2;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext2;
@property (nonatomic) NSArray *myresults;

@property (strong, nonatomic) NSFetchRequest *fetchRequest2;
@property (strong, nonatomic) NSObject *fetchOBJ2;


@property (strong, nonatomic) NSManagedObject *moDATA;

@property (strong, nonatomic) NSManagedObject *moHCPDATA;


@end