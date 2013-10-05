//
//  ReportSVC.m
//  SampleCupboard_iOS
//
//  Created by David Small on 9/24/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "ReportSVC.h"

@interface ReportSVC ()

@end

@implementation ReportSVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UISplitViewDelegate methods
-(void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)ViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    
    /*
     
     //Grab a reference to the popover
     self.popover = pc;
     
     //Set the title of the bar button item
     barButtonItem.title = @"Reports";
     
     //Set the bar button item as the Nav Bar's leftBarButtonItem
     [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
     
     */
    
    NSLog(@"dw1 - show SPLITVIEW");
    
    
}

-(void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)ViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
    NSLog(@"dw1 - SPV_1999A");
    
    //Remove the barButtonItem.
    // [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
    
    //Nil out the pointer to the popover.
    // _popover = nil;
}


- (void) splitViewController:(UISplitViewController *)splitViewController popoverController: (UIPopoverController *)pc
   willPresentViewController: (UIViewController *)ViewController
{
    
    NSLog(@"dw1 - SPV_19999B");
    
    
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		NSLog(@"ERR_POPOVER_IN_LANDSCAPE");
	}
}

@end
