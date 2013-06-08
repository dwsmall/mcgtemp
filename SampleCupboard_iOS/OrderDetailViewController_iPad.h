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
    NSInteger appStage;
}

@property (nonatomic) NSInteger selectedButton;
@property (nonatomic) NSInteger appStage;

@property (nonatomic, weak) IBOutlet UILabel *outputlabel;

@end