//
//  OrderDetailViewController_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@interface OrderDetailViewController_iPad : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger selectedButton;
    NSInteger selectedHCP;
    
    NSInteger selectedHCPNUMBER;
    NSArray *selectedHCPINFO;

    NSInteger selectedPRODUCTNUMBER;
    
}

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

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end