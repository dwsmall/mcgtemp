//
//  OrderDetailViewController_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface OrderDetailViewController_iPad : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
{
    


    // Dict for Order Processing
    NSDictionary *orderValue_Dict;
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
    NSManagedObject *moCreateOrderHCP;
    
    NSManagedObject *moHCPDATA;
    
    
    // Drawing Objects
    CGPoint lastPoint;
    UIImageView *drawImage;
    
    UIActionSheet* actionSheet_;
    
    
    
}

// Capture Order Values For xml Conversion
@property (strong, nonatomic) NSDictionary *orderValue_Dict;
@property (strong, nonatomic) NSDictionary *orderValueExt_Dict;
@property (strong, nonatomic) NSArray *orderValueDetails_Arr;

@property (strong, nonatomic) NSMutableDictionary *selectableProducts_Dict;

// Keyboard Observable
@property (nonatomic) NSInteger keyboardObservable;


@property (strong, nonatomic) IBOutlet UIView *odMainView;



@property (strong, nonatomic) IBOutlet UIButton *ok_btn;


@property (weak, nonatomic) IBOutlet UITextField *hiddenTextField;

@property (nonatomic) NSInteger selectedButton;


@property (nonatomic) NSString *selectedCARRIER;
@property (nonatomic) NSString *selectedSHIPINFO;


@property (nonatomic) NSInteger selectedHCP;

@property (nonatomic) NSInteger selectedADDPRODUCT;
@property (nonatomic) NSArray *selectedCHOSENPRODUCT;


@property (nonatomic) NSInteger selectedHCPNUMBER;
@property (nonatomic) NSArray *selectedHCPINFO;


@property (nonatomic) NSMutableArray *donotdisplayPRODUCTS;
@property (nonatomic) NSArray *donotdisplayPRODUCTS2;

@property (nonatomic) NSInteger selectedPRODUCTNUMBER;


@property (nonatomic) NSMutableArray *arrTempProducts;
@property (nonatomic) NSMutableArray *arrScrnProducts;


@property (nonatomic) NSString *templateName;
@property (nonatomic, weak) IBOutlet UILabel *otemplateName;

@property (nonatomic) NSString *rtnOrderID;
@property (nonatomic, weak) IBOutlet UILabel *ortnOrderID;


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

@property (nonatomic, weak) IBOutlet UILabel *outputlabelG;


@property (nonatomic, weak) IBOutlet UILabel *outputlabel5;

@property (nonatomic, weak) IBOutlet UILabel *outputlabel6;

@property (nonatomic, weak) IBOutlet UILabel *outputREMOVEDPRODUCTS;


@property (nonatomic, weak) IBOutlet UILabel *outputREMOVEDPRODUCTS2;


@property (nonatomic, weak) IBOutlet UILabel *outputCHOSENPRODUCT;

@property (nonatomic, weak) IBOutlet UILabel *outputarrTempProducts;
@property (nonatomic, weak) IBOutlet UILabel *outputarrScrnProducts;


@property (nonatomic, weak) IBOutlet UILabel *outputodMainView;

@property (nonatomic, weak) IBOutlet UILabel *oselectedCARRIER;
@property (nonatomic, weak) IBOutlet UILabel *oselectedSHIPINFO;




@property (strong, nonatomic) IBOutlet UIView *viewContainer;

@property (strong, nonatomic) IBOutlet UITableView *ordTableView;



@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContextToken;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController2;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext2;
@property (nonatomic) NSArray *myresults;

@property (strong, nonatomic) NSFetchRequest *fetchRequest2;
@property (strong, nonatomic) NSObject *fetchOBJ2;


@property (nonatomic,retain) NSManagedObject *moDATA;
@property (strong, nonatomic) NSManagedObject *moCreateOrderHCP;
@property (strong, nonatomic) NSManagedObject *moHCPDATA;


+ (NSString*)globsig;

+ (NSString*)preventEdit;

+ (NSMutableArray*)globprod;

+ (NSMutableArray*)globhcp;

@end