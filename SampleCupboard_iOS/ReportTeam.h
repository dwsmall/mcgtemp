//
//  ReportTeam.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-06-05.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface ReportTeam : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
