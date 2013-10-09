//
//  SetupConfig.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-07-25.
//  Copyright (c) 2013 MCG. All rights reserved.
//

@interface SetupConfig : NSObject {
    NSString *_myString;
}

@property (retain) NSString *myString;
@property (retain) NSString *currentHCP;

- (void)sharedSetupConfig;

@end
