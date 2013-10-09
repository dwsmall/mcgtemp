//
//  SetupConfig.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-07-25.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "SetupConfig.h"

SetupConfig *g_sharedSetupConfig = nil;

@implementation SetupConfig

@synthesize myString = _myString;
@synthesize currentHCP = _currentHCP;


- (void)sharedSetupConfig {
    if (!g_sharedSetupConfig) {
        g_sharedSetupConfig = [[SetupConfig alloc] init];
    }
}

@end
