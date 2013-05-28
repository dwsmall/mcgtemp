//
//  SyncViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-18.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "SyncViewController_iPad.h"

@interface SyncViewController_iPad ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLoadHCPs;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnReloadData;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSync;

- (IBAction)btnLoadHCPsClick:(id)sender;

- (IBAction)btnReloadDataClick:(id)sender;

- (IBAction)btnSyncClick:(id)sender;


@end


@implementation SyncViewController_iPad

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

- (IBAction)btnLoadHCPsClick:(id)sender {
    
    // DATA OBJECT INSERT
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *model = [NSEntityDescription
                              insertNewObjectForEntityForName:@"People"
                              inManagedObjectContext:context];
    [model setValue:@"Sample Event" forKey:@"first_name"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }

    
    // Grab Json Data From Server
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=twitterapi&count=3333"];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    if(jsonData != nil)
    {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSArray *resultX = (NSArray*)result;
        
        for(int i=0;i<[resultX count];i++)
        {
            NSDictionary *valuesX = (NSDictionary*)[resultX objectAtIndex:i];
           //  NSLog(@"TESTX1_Code: %@  TESTX2_Duration: %@",[valuesX objectForKey:@"Training_Code"],[valuesX objectForKey:@"Training_Duration"]);
            
            NSManagedObject *model = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"People"
                                      inManagedObjectContext:context];
            [model setValue:@"Wentworth" forKey:@"first_name"];
            [model setValue:@"Small" forKey:@"last_name"];
            
        }
        
        
        if (![context save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Announcement"
                              message: @"Processing Complete!"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
        if (error == nil)
            NSLog(@"%@", result);
    }
   
    NSError *jsonErrorMSG = nil;
    NSDictionary *SampleDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonErrorMSG];
    
    
    
    
    
}

- (IBAction)btnReloadDataClick:(id)sender {
}

- (IBAction)btnSyncClick:(id)sender {
    
}

@end