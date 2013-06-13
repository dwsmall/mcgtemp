//
//  OrderDetailViewController_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreData/CoreData.h>

@interface OrderDetailViewController_iPad : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger selectedButton;
    NSInteger selectedHCP;
    NSInteger selectedHCPNUMBER;
    NSInteger selectedPRODUCTNUMBER;
}

@property (nonatomic) NSInteger selectedButton;
@property (nonatomic) NSInteger selectedHCP;
@property (nonatomic) NSInteger selectedHCPNUMBER;
@property (nonatomic) NSInteger selectedPRODUCTNUMBER;

@property (nonatomic, weak) IBOutlet UILabel *outputlabel;
@property (nonatomic, weak) IBOutlet UILabel *outputlabel1;
@property (nonatomic, weak) IBOutlet UILabel *outputlabel2;
@property (nonatomic, weak) IBOutlet UILabel *outputlabel3;


@end