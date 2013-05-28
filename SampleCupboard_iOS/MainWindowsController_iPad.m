//
//  MainWindowsController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "MainWindowsController_iPad.h"

@interface MainWindowsController_iPad ()

// @property (weak, nonatomic) IBOutlet UITabBar *tabviewCTL;

@end

@implementation MainWindowsController_iPad

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MainWindow Execute 5301!"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Later"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    
    [self performSegueWithIdentifier: @"loginAA" sender: self];  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end