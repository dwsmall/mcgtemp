//
//  LoginViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import "AppDelegate.h"


#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"

#import "MBProgressHUD.h"


Reachability *internetReachableFoo;


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIButton *BtnSignin;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;

@property (weak, nonatomic) IBOutlet UISwitch *cbRememberMe;

@property (weak, nonatomic) IBOutlet UILabel *lblInvalidUserName;

@property (weak, nonatomic) IBOutlet UIView *loadingPanel;

@property (weak, nonatomic) IBOutlet UIImageView *loginBackgroundImage;

@property (weak, nonatomic) IBOutlet UIView *loginErrorPanel;

@property (weak, nonatomic) IBOutlet UIImageView *loginIcon;

@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UIButton *UserLoginBtn;


@property (strong, atomic) IBOutlet UITextField *userName;

@property (strong, atomic) IBOutlet UITextField *password;


@property (strong, nonatomic) IBOutlet UISwitch *Remember_Button;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *myActIndicator;


@property (strong, nonatomic) IBOutlet UILabel *lblUsername;

@property (strong, nonatomic) IBOutlet UILabel *lblPassword;


@property (strong, nonatomic) IBOutlet UILabel *lblRememberMe;


- (IBAction)LoginButton:(UIButton *)sender;

@end



@implementation LoginViewController

@synthesize userName, password, Remember_Button;

@synthesize myActIndicator;


#pragma mark - ViewDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // show spinning wheel
    [myActIndicator stopAnimating];
    myActIndicator.hidden=TRUE;
    

    // Get OutStanding Badges on Login
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    // NSError *error;
    NSArray *list =
    [NSArray arrayWithObjects:
     @"OFFLINE",
     @"REJECTED", nil];
    
    // Get UNSENT item count
    NSFetchRequest *fetchRequestBadge = [[NSFetchRequest alloc] init];
    fetchRequestBadge.entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:context];
    fetchRequestBadge.predicate = [NSPredicate predicateWithFormat:@"projectcode IN %@", list];
    
    NSError *error = nil;
    NSUInteger numberOfRecords = [context countForFetchRequest:fetchRequestBadge error:&error];
    
    
        // Set the button Text Color
        [_UserLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _UserLoginBtn.layer.cornerRadius = 10; // this value vary as per your desire
        _UserLoginBtn.clipsToBounds = YES;
    

        // Set All TabBar Badges Upon Load
        for (UIViewController *viewController in self.tabBarController.viewControllers) {
            
            // update text of tab...
            
            if (viewController.tabBarItem.tag == 1) {
                viewController.tabBarItem.title = NSLocalizedString(@"Home", nil);
            }
            
            
            if (viewController.tabBarItem.tag == 2) {
                viewController.tabBarItem.title = NSLocalizedString(@"Requests", nil);
            }
            
            if (viewController.tabBarItem.tag == 3) {
                viewController.tabBarItem.title = NSLocalizedString(@"HCPs", nil);
            }
            
            if (viewController.tabBarItem.tag == 4) {
                viewController.tabBarItem.title = NSLocalizedString(@"Sync", nil);
            }
            
            if (viewController.tabBarItem.tag == 5) {
                viewController.tabBarItem.title = NSLocalizedString(@"Reports", nil);
            }
            
            
            // disable tabs
            
            if (viewController.tabBarItem.tag != 0) {
                [viewController.tabBarItem setEnabled:NO];
            }
            
            
            // update unsynced orders
        
            if (viewController.tabBarItem.tag == 4 && numberOfRecords > 0) {
                viewController.tabBarItem.badgeValue = [@(numberOfRecords) description];
                [viewController.tabBarItem setEnabled:NO];
            }
        }
        
    
    
    // show username/password if creds stored...
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"MCG_usernameKey"] > 0) {
        userName.text = [defaults valueForKey:@"MCG_usernameKey"];
        password.text = [defaults valueForKey:@"MCG_passwordKey"];
        Remember_Button.on = YES;
    }
    
    
    
    
    // update label values
    
    _lblUsername.text = NSLocalizedString(@"User Name", nil);
    _lblPassword.text = NSLocalizedString(@"Password", nil);
    _lblRememberMe.text = NSLocalizedString(@"Remember Me", nil);
    userName.placeholder = NSLocalizedString(@"user name", nil);
    password.placeholder = NSLocalizedString(@"password", nil);
    
    [_UserLoginBtn setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IB Actions

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    // show spinning wheel
    myActIndicator.hidden = FALSE;
    [myActIndicator startAnimating];
    
    [self ProcessLogin];
    
    return NO;
    
}


- (IBAction)LoginButton:(UIButton *)sender {
    
    // show spinning wheel
    myActIndicator.hidden = FALSE;
    [myActIndicator startAnimating];
    
    [self ProcessLogin];
}




- (void)ProcessLogin {
    
    
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    if (internetStatus == NotReachable){
        
        // NO INTERNET ?
        
#pragma Offline Login
        
        // Check For Offline Login Credentials
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSError *error;
        
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
        NSArray *currentitems = [[context executeFetchRequest:request error:&error] lastObject];
        
        
        NSString *comp_username = [[[currentitems valueForKey:@"username"] description] lowercaseString];
        NSString *comp_password = [[[currentitems valueForKey:@"password"] description] lowercaseString];

        // NSLog(@"These Are The Values %@, %@", userName.text, [userName.text copy]);
        
        if ( [[userName.text lowercaseString] isEqualToString:comp_username] )
        {
            
            if ( [[password.text lowercaseString] isEqualToString:comp_password] ) {
                
                // remember password for offline login ? (naw...)
                
                [self sucessfulLogin];
                
                
            } else {
                
                UIAlertView *errorAlertView = [[UIAlertView alloc]
                                               initWithTitle:NSLocalizedString(@"Invalid Login", nil)
                                               message:NSLocalizedString(@"Invalid User Name or Password", nil)
                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [errorAlertView show];
                
            }
            
            
            
        } else {
            
            // stop animating
            [myActIndicator stopAnimating];
            myActIndicator.hidden=TRUE;
        
            UIAlertView *errorAlertView = [[UIAlertView alloc]
                                           initWithTitle:NSLocalizedString(@"Invalid Login", nil)
                                           message:NSLocalizedString(@"Offline Login Requires Previous User Credentials", nil)
                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [errorAlertView show];
            
            
        }
        
       
        
        
    } else {
        
        // INTERNET FOUND ?

#pragma Online Login
        
        
        NSURL *url=[NSURL URLWithString:@"http://dev.samplecupboard.com/Data/MobileServices.svc/Login"];
                
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // Store Login Credentials
        if (Remember_Button.on) {
            
            // store credentials
            [defaults setObject:userName.text forKey:@"MCG_usernameKey"];
            [defaults setObject:password.text forKey:@"MCG_passwordKey"];
        
        } else {
        
            // clear previous credentials
            [defaults setObject:nil forKey:@"MCG_usernameKey"];
            [defaults setObject:nil forKey:@"MCG_passwordKey"];
        }
        

            
        NSDictionary* infoTEST = [NSDictionary dictionaryWithObjectsAndKeys:
                                  userName.text,
                                  @"userName",
                                  password.text,
                                  @"password",
                                  @"IPadApp",
                                  @"sourceApp",
                                  nil];
     
        
        NSError *errorMSG = nil;
        
        //convert object to data
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoTEST options:kNilOptions error:&errorMSG];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        
        
// #if NS_BLOCKS_AVAILABLE
        
        
        [connection start];
        
// #endif
        
        
    }
    
    
}


#pragma mark - NSUrl Connection Methods

- (void)startLoadWithURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    CFRunLoopRun();
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Do something with the finished connection
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Handle the error
    CFRunLoopStop(CFRunLoopGetCurrent());
}

-   (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData{
    
    
    
    // NSLog(@"String sent from server %@",[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding]);

    
    NSError *error = nil;
    
    NSDictionary *dictResult = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
    
    // get root node
    NSDictionary* dictRow = [dictResult objectForKey:@"LoginResult"];
    
    
    
    // INVALID PASSWORD
    if ([dictRow isKindOfClass:[NSNull class]]) {
        
        
        // stop animating
        [myActIndicator stopAnimating];
        myActIndicator.hidden=TRUE;

        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:NSLocalizedString(@"Invalid Login", nil)
                                       message:NSLocalizedString(@"Invalid User Name or Password", nil)
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [errorAlertView show];
        
    }
        else
    {

        
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        NSManagedObjectContext *context = [self managedObjectContext];
        
        // 1. check for Token_Credentials
        NSFetchRequest * fetchrequest = [[NSFetchRequest alloc] init];
        [fetchrequest setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
        [fetchrequest setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
        
        NSUInteger usercount = [context countForFetchRequest:fetchrequest error:&error];
        
        NSArray *tokendata = [[context executeFetchRequest:fetchrequest error:&error] lastObject];
        
        NSString *UserChangeOccured = @"";
        int userfound = 1;
        
        if (usercount == 0) {
            userfound = 0;
        }
        
        
#pragma mark New User Login
        
            // NO - RECORD, CREATE
            if (userfound == 0 ||  (userfound == 1 && ![userName.text isEqualToString:[tokendata valueForKey:@"username"]]) ) {
                
                // USER LOGIN CHANGED
                
                if (userfound == 1 && ![userName.text isEqualToString:[tokendata valueForKey:@"username"]]) {
                
                    UserChangeOccured = @"YES";

#pragma mark Remove Previous User
                    
                    
                    // NEW USER LOGIN HAS OCCURED
                    
                    NSArray *arrkeys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
                    NSArray *non_delete = @[@"MCG_clientid",@"MCG_token", @"MCG_userid"];
                    
                    NSString *searchStr = @"MCG_";
                    NSPredicate *usr_predicate = [NSPredicate predicateWithFormat:@"self BEGINSWITH[cd] %@ AND NOT self in %@", searchStr, non_delete];
                    NSArray *resultArray = [arrkeys filteredArrayUsingPredicate:usr_predicate];
                    
                    for (int i = 0; i < resultArray.count; i++) {
                        // NSLog(@"Delete Key: %@", [resultArray objectAtIndex:i]);
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[resultArray objectAtIndex:i]];
                    }
                
                                        
                    // msg (new login detected/previous update/rmvd...)
                    /* should show with choice to cont. or cancel
                    
                    */
                    
                    // clear previous NSUSER values
                    // NSLog(@" show all keys %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

                    
                    
                    // remove all entities
                    NSArray *deletionEntity;
                    
                    deletionEntity = @[@"ClientInfo",@"Order",@"Product",@"Allocation",@"AllocationHeader",@"TerritoryFSA",@"Territory",@"Rep",@"OrderTemplate",@"OrderTemplateLine",@"Tokenized_Credentials",@"HealthCareProfessional"];
                    
                    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
                    self.managedObjectContext = [appDelegate managedObjectContext];
                    NSManagedObjectContext *context = [self managedObjectContext];
                    
                    
                    for(int i=0;i<[deletionEntity count];i++)
                    {
                        
                        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                        
                        NSEntityDescription *entity = [NSEntityDescription entityForName:[deletionEntity objectAtIndex:i] inManagedObjectContext:context];
                        [fetchRequest setEntity:entity];
                        
                        NSError *error;
                        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
                        
                        for (NSManagedObject *managedObject in items) {
                            [_managedObjectContext deleteObject:managedObject];
                            // NSLog(@"%@ object deleted",[deletionEntity objectAtIndex:i]);
                        }
                        if (![_managedObjectContext save:&error]) {
                            NSLog(@"Error deleting %@ - error:%@",[deletionEntity objectAtIndex:i],error);
                        }
                        
                    }
                    
                
                }  //end of new usr removal
                
                
#pragma mark Create New User Info                
                
                // GET USER INFORMATION
                NSString *user_id = [dictRow objectForKey:@"UserId"];
                NSString *client_id = [dictRow objectForKey:@"ClientId"];
                NSString *token = [dictRow objectForKey:@"Token"];
                
                // Insert New Record
                NSManagedObject *TCred = [NSEntityDescription
                                             insertNewObjectForEntityForName:@"Tokenized_Credentials"
                                             inManagedObjectContext:context];
                [TCred setValue:@"current_rep" forKey:@"id"];
                [TCred setValue:user_id forKey:@"user_id"];
                [TCred setValue:client_id forKey:@"clientid"];
                [TCred setValue:userName.text forKey:@"username"];
                [TCred setValue:password.text forKey:@"password"];
                [TCred setValue:[self sha1:password.text] forKey:@"password_hash"];
                [TCred setValue:token forKey:@"token"];
                [TCred setValue:[NSDate date] forKey:@"date_validated"];
                
                
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
               
                
                [self sucessfulLogin];
                
                
                if ([UserChangeOccured isEqualToString:@"YES"]) {
                    
                    UIAlertView *errorAlertView = [[UIAlertView alloc]
                                                   initWithTitle:NSLocalizedString(@"New User Detected!", nil)
                                                   message:NSLocalizedString(@"You are attempting to login as a new user, previous data will be removed from device...", nil)
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [errorAlertView show];
                    
                
                } else {
                    
                    UIAlertView *errorAlertView = [[UIAlertView alloc]
                                                   initWithTitle:NSLocalizedString(@"First Time Login: Update Data!", nil)
                                                   message:NSLocalizedString(@"You Must Sync Data Before Performing Any Operations", nil)
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [errorAlertView show];
                    
                }
                
                
                
            }
        
        
#pragma mark Login Existing User
        
            // YES - UPDATE RECORD
            if (userfound == 1 && [userName.text isEqualToString:[tokendata valueForKey:@"username"]]) {
                
                NSError *error = nil;
              
                    // REP IS SAME
                    
                    // get user info
                    NSString *user_id = [dictRow objectForKey:@"UserId"];
                    NSString *client_id = [dictRow objectForKey:@"ClientId"];
                    NSString *token = [dictRow objectForKey:@"Token"];
                    
                    //Set up to get the thing you want to update
                    NSFetchRequest * request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
                    
                    // get token_cred data
                    NSArray *savechange = [[context executeFetchRequest:request error:&error] lastObject];
                    
                    // update (AllocationID)
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[savechange valueForKey:@"allocationid"] forKey:@"MCG_allocationid"];
                    
                    
                    if (error) {
                        //Handle any errors
                    }	
                    
                    if (!savechange) {
                        //Nothing there to update
                    }
                    
                    //Update the object
                    [savechange setValue:user_id forKey:@"user_id"];
                    [savechange setValue:client_id forKey:@"clientid"];
                    [savechange setValue:token forKey:@"token"];
                    [savechange setValue:password.text forKey:@"password"];
                    [savechange setValue:[self sha1:password.text] forKey:@"password_hash"];
                    [savechange setValue:[NSDate date] forKey:@"date_validated"];
                    
                    //Save it
                    error = nil;
                    if (![context save:&error]) {
                        //Handle any error with the saving of the context
                    }
                
                
                [self sucessfulLogin];
                
                
                
            }
        
              
        
        
        
    }
    
    
    
    
    
    
    

    
}


#pragma mark - Custom

-(void) sucessfulLogin {
    
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error = nil;
    
    // fetch credentials
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
    NSArray *currentitems = [[context executeFetchRequest:request error:&error] lastObject];
    
    
    // update user credentials  (should be replaced with delegates)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[currentitems valueForKey:@"user_id"] description] forKey:@"MCG_userid"];
    [defaults setObject:[[currentitems valueForKey:@"token"] description] forKey:@"MCG_token"];
    [defaults setObject:[[currentitems valueForKey:@"clientid"] description] forKey:@"MCG_clientid"];
    [defaults setObject:[[currentitems valueForKey:@"allocationid"] description] forKey:@"MCG_allocationid"];
    
    
    // update user credentials    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.globalUserID = [[currentitems valueForKey:@"user_id"] description];
    app.globalToken = [[currentitems valueForKey:@"token"] description];
    app.globalClientId = [[currentitems valueForKey:@"clientid"] description];
    app.globalAllocationId = [[currentitems valueForKey:@"allocationid"] description];
    app.globalClientOptionBO = [[currentitems valueForKey:@"allow_backorder"] description];
    
    app.globalBaseUrl = @"http://dev.samplecupboard.com/Data/MobileServices.svc";
    
    
    for (UIViewController *viewController in self.tabBarController.viewControllers) {
         
         if (viewController.tabBarItem.tag == 0) {
             [viewController.tabBarItem setEnabled:NO];
         } else {
             [viewController.tabBarItem setEnabled:YES];
         }
         
    }
    
    [self.tabBarController setSelectedIndex:1];

}


#pragma mark - Utillities

- (NSString *)urlEncodeValue:(NSString *)str
{
NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
return result;
}


- (NSString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}


+(NSString *)stringToSha1:(NSString *)str{
    const char *s = [str cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, keyData.length, digest);
    
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    // description converts to hex but puts <> around it and spaces every 4 bytes
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    
    return hash;
}




@end
