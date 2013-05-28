//
//  LoginViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "LoginViewController_iPad.h"

@interface LoginViewController_iPad ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIButton *BtnSignin;

@property (weak, nonatomic) IBOutlet UILabel *UserName;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;

@property (weak, nonatomic) IBOutlet UISwitch *cbRememberMe;

@property (weak, nonatomic) IBOutlet UILabel *lblInvalidUserName;

@property (weak, nonatomic) IBOutlet UIView *loadingPanel;

@property (weak, nonatomic) IBOutlet UIImageView *loginBackgroundImage;

@property (weak, nonatomic) IBOutlet UIView *loginErrorPanel;

@property (weak, nonatomic) IBOutlet UIImageView *loginIcon;

@property (weak, nonatomic) IBOutlet UIView *loginView;


@property (weak, nonatomic) IBOutlet UIButton *signInClick;

@property (weak, nonatomic) IBOutlet IndentTextField *txtUserName;


@property (weak, nonatomic) IBOutlet IndentTextField *txtPassword;


- (IBAction)signInClick:(id)sender;

@end



@implementation LoginViewController_iPad



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInClick:(id)sender {
}
@end