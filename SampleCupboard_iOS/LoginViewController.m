//
//  LoginViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//



#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"

Reachability *internetReachableFoo;


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


@property (strong, atomic) IBOutlet UITextField *userName;

@property (strong, atomic) IBOutlet UITextField *password;


- (IBAction)LoginButton:(UIButton *)sender;

@end



@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Get OutStanding Badges on Login
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // NSError *error;
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Orders" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"projectcode=%@",@"unsent"]];
    
    // PX2 Handle 0 returned items
    // NSArray *currentitems = [[context executeFetchRequest:request error:&error] lastObject];
    
    
    // Prepare to Update Badge Number
    for (UIViewController *viewController in self.tabBarController.viewControllers) {
        
        if (viewController.tabBarItem.tag == 4) {
            // PX2 viewController.tabBarItem.badgeValue = [currentitems count];
        }
    }
    
    
    
    
    // FAKE CODE FOR DEV PURPOSES
    if (1 == 2) {
    
        [self.tabBarController setSelectedIndex:1];
    
    } else {
    
        // Set the button Text Color
        [_UserLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _UserLoginBtn.layer.cornerRadius = 10; // this value vary as per your desire
        _UserLoginBtn.clipsToBounds = YES;
    

        // Set All TabBar Badges Upon Load
        for (UIViewController *viewController in self.tabBarController.viewControllers) {
        
            if (viewController.tabBarItem.tag != 0) {
                [viewController.tabBarItem setEnabled:NO];
            }
        
            if (viewController.tabBarItem.tag == 4) {
                //Check UnSent Orders in Temp
                viewController.tabBarItem.badgeValue = @"1";
                [viewController.tabBarItem setEnabled:NO];
            }
        }
        
    } //END OF FOR
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginButton:(UIButton *)sender {
    
    // NSLog(@"Credentials %@ %@", _userName.text, _password.text);

    
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    if (internetStatus == NotReachable){
        
        // NO INTERNET ?
        
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

        NSLog(@"These Are The Values %@, %@", _userName.text, [_userName.text copy]);
        
        if ( [[_userName.text lowercaseString] isEqualToString:comp_username] )
        {
            NSLog(@"Offline Login Confirmed");
            
            if ( [[_password.text lowercaseString] isEqualToString:comp_password] ) {
                
                // SUCCESS ROUTINE
                for (UIViewController *viewController in self.tabBarController.viewControllers) {
                    
                    
                    if (viewController.tabBarItem.tag == 0)
                    {
                        [viewController.tabBarItem setEnabled:NO];
                    }
                    else
                    {
                        [viewController.tabBarItem setEnabled:YES];
                    }
                    
                    
                }
                [self.tabBarController setSelectedIndex:1];
                
                
                
            } else {
                
                UIAlertView *errorAlertView = [[UIAlertView alloc]
                                               initWithTitle:@"INVALID LOGIN"
                                               message:@"Please Check Your UserName and Password"
                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [errorAlertView show];
                
            }
            
            
            
        } else {
        
            UIAlertView *errorAlertView = [[UIAlertView alloc]
                                           initWithTitle:@"INVALID LOGIN"
                                           message:@"Offline Login Requires Previous User Credentials"
                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [errorAlertView show];
            
            
            // SUCCESS ROUTINE - TEMP CODE
            for (UIViewController *viewController in self.tabBarController.viewControllers) {
                
                
                if (viewController.tabBarItem.tag == 0)
                {
                    [viewController.tabBarItem setEnabled:NO];
                }
                else
                {
                    [viewController.tabBarItem setEnabled:YES];
                }
                
                
            }
            [self.tabBarController setSelectedIndex:1];
            
        }
        
        
        //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context];
        // [fetchRequest setEntity:entity];
        
        // NSError *error;
        // NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        
       
        
        
    } else {
        
        
        // NSLog(@"Internet connection is OK");
        
        // CONNECTION FOUND ?
        
        NSURL *url=[NSURL URLWithString:@"http://dev.samplecupboard.com/Data/MobileServices.svc/Login"];
        NSString *nameX = _userName.text;
        NSString *passwordX = _password.text;
        
     
        NSDictionary* infoTEST = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"greg.lee@merck.com",
                                 @"userName",
                                 @"qa",
                                 @"password",
                                 @"IPadApp",
                                 @"sourceApp",
                                 nil];
        
        NSLog(@"first show TEST %@", infoTEST);
        
        
        
        NSDictionary* infoRAW = [NSDictionary dictionaryWithObjectsAndKeys:
                                [_userName.text copy],
                                @"userName",
                                [_password.text copy],
                                @"password",
                                @"IPadApp",
                                @"sourceApp",
                                nil];
        
        NSLog(@"first show %@", infoRAW);
        CFShow(CFBridgingRetain(infoRAW));
        
        NSDictionary* infoDB = [NSDictionary dictionaryWithObjectsAndKeys:
                              nameX,
                              @"userName",
                              passwordX,
                              @"password",
                              @"IPadApp",
                              @"sourceApp",
                              nil];

        
        NSLog(@"first show %@", infoDB);
        
        
        NSError *errorMSG = nil;
        
        //convert object to data
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoTEST options:kNilOptions error:&errorMSG];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        // print json:
        // NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
           //                                               encoding:NSUTF8StringEncoding]);
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    
    }
    
    
}






-   (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData{
    
    
    
    
    
    NSLog(@"String sent from server %@",[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding]);

    
    NSError *error = nil;
    
    NSDictionary *dictContainer = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&error];
    NSString *LoginResultContainer = [dictContainer objectForKey:@"LoginResult"];
    
    NSLog(@"The Dictionary %@", dictContainer);
    
    // INVALID PASSWORD
    if ([LoginResultContainer isKindOfClass:[NSNull class]]) {
        
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"INVALID CREDENTIALS"
                                       message:@"Invalid Username or Password"
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [errorAlertView show];
        
        
    } else if ([LoginResultContainer length] > 0)
    {
        
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        NSManagedObjectContext *context = [self managedObjectContext];
        
        // 1. CHECK IF RECORD EXISTS ?
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        NSError *error;
        NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
        
        
            // NO - RECORD, CREATE
            if ([items count] == 0) {
                
                
                // GET USER INFORMATION
                NSString *user_id = @"0BB9FDAD-DDD9-4CEA-861B-073BB6D1A590";
                
                
                
                // Insert New Record
                NSManagedObject *TCred = [NSEntityDescription
                                             insertNewObjectForEntityForName:@"Tokenized_Credentials"
                                             inManagedObjectContext:context];
                [TCred setValue:@"current_rep" forKey:@"id"];
                [TCred setValue:user_id forKey:@"user_id"];
                [TCred setValue:_userName.text forKey:@"username"];
                [TCred setValue:_password.text forKey:@"password"];
                [TCred setValue:[self sha1:_password.text] forKey:@"password_hash"];
                [TCred setValue:LoginResultContainer forKey:@"token"];
                [TCred setValue:[NSDate date] forKey:@"date_validated"];
                
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
               
                
                // Mark Initial Database Message
                // Set All TabBar Badges Upon Load
                for (UIViewController *viewController in self.tabBarController.viewControllers) {
                    
                    
                    if (viewController.tabBarItem.tag == 0)
                    {
                        [viewController.tabBarItem setEnabled:NO];
                    }
                    else
                    {
                        [viewController.tabBarItem setEnabled:YES];
                    }
                    
                    
                }
                [self.tabBarController setSelectedIndex:1];
                
            }
        
        
            // YES - UPDATE RECORD
            if ([items count] == 1) {
                
                NSError *error = nil;
                
                
                // Delete All Date If Rep Name Not Equal...
                

                // RETRIEVE USER ID
                // GET USER INFORMATION
                NSString *user_id = @"0BB9FDAD-DDD9-4CEA-861B-073BB6D1A590";
                
                //Set up to get the thing you want to update
                NSFetchRequest * request = [[NSFetchRequest alloc] init];
                [request setEntity:[NSEntityDescription entityForName:@"Tokenized_Credentials" inManagedObjectContext:context]];
                [request setPredicate:[NSPredicate predicateWithFormat:@"id=%@",@"current_rep"]];
                
                //Ask for it
                NSArray *savechange = [[context executeFetchRequest:request error:&error] lastObject];
                
                if (error) {
                    //Handle any errors
                }	
                
                if (!savechange) {
                    //Nothing there to update
                }
                
                //Update the object
                [savechange setValue:user_id forKey:@"user_id"];
                [savechange setValue:LoginResultContainer forKey:@"token"];
                [savechange setValue:_password.text forKey:@"password"];
                [savechange setValue:[self sha1:_password.text] forKey:@"password_hash"];
                [savechange setValue:[NSDate date] forKey:@"date_validated"];
                
                //Save it
                error = nil;
                if (![context save:&error]) {
                    //Handle any error with the saving of the context
                }
                
                
                // - success ROUTINE = -- open menu items  / segue to home screen
                // Set All TabBar Badges Upon Load
                for (UIViewController *viewController in self.tabBarController.viewControllers) {
                    
                    
                    if (viewController.tabBarItem.tag == 0)
                    {
                        [viewController.tabBarItem setEnabled:NO];
                    }
                    else
                    {
                        [viewController.tabBarItem setEnabled:YES];
                    }
                    
                
                }
                    [self.tabBarController setSelectedIndex:1];
            
            }
        
        
        
        
        //Store Password As Hashed (if successful)
        // NSString *doogood = [self sha1:_password.text];
        
        UIAlertView *errorAlertView = [[UIAlertView alloc]
                                       initWithTitle:@"LOGIN SUCCESSFUL"
                                       message:@"Invalid Username or Password"
                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [errorAlertView show];
        
        
    }
    
    
    
    
    
    
    

    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    
}

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
    
    NSLog(@"Hash is %@ for string %@", hash, str);
    
    return hash;
}


@end
