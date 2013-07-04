//
//  LoginViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//



#import "LoginViewController.h"

@interface LoginViewController ()

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

@property (weak, nonatomic) IBOutlet IndentTextField *txtUserName;

@property (weak, nonatomic) IBOutlet UIButton *UserLoginBtn;

@property (weak, nonatomic) IBOutlet IndentTextField *txtPassword;

- (IBAction)LoginButton:(UIButton *)sender;

@end



@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set the button Text Color
    [_UserLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _UserLoginBtn.layer.cornerRadius = 10; // this value vary as per your desire
    _UserLoginBtn.clipsToBounds = YES;
    

    // Set All TabBar Badges Upon Load
    for (UIViewController *viewController in self.tabBarController.viewControllers) {

        if (viewController.tabBarItem.tag == 4) {
            //Check UnSent Orders in Temp
            viewController.tabBarItem.badgeValue = @"1";
        }
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginButton:(UIButton *)sender {
    
    
    
    NSURL *url=[NSURL URLWithString:@"http://dev.samplecupboard.com/Data/MobileServices.svc/Login"];
    NSString *nameX = @"testx";
    NSString *languageX = @"French";
    
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:nameX, @"name", languageX, @"language", nil];
    
    NSError *errorMSG = nil;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&errorMSG];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    // print json:
    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding]);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
    
        
    
    UIAlertView *errorAlertView = [[UIAlertView alloc]
                                   initWithTitle:@"TEST555"
                                   message:@"Internet connection is TEST777"
                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlertView show];
    
}






-   (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData{
    NSLog(@"String sent from server %@",[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    UIAlertView *errorAlertView = [[UIAlertView alloc]
                                   initWithTitle:@"CONNECTION DONE LOADING"
                                   message:@"Internet connection is DONE"
                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlertView show];
    
}

- (NSString *)urlEncodeValue:(NSString *)str
{
NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
return result;
}

@end

