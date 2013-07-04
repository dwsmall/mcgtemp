//
//  TextInputDialog_iPad.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputDialog_iPad : UIView <UIKeyInput>
{
    NSMutableString *textToDisplay;
}

@property (nonatomic, retain) NSMutableString *textToDisplay;
@end