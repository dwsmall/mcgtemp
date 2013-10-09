//
//  OrderDetailViewController_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "AppDelegate.h"

#import "Base64.h"
#import "SVProgressHUD.h"

#import "Allocation.h"

#import "Order.h"
#import "OrderLineItem.h"
#import "HcpDetailController.h"
#import "TextInputDialog_iPad.h"
#import "SetupConfig.h"
#import "SignatureControl.h"
#import "OrderDetailViewController_iPad.h"

#import "Reachability.h"

Reachability *internetReachableFoo;

static NSString* myglobsig = nil;
static NSString* mypreventEdit = nil;
static NSMutableArray* myglobRmvdProducts = nil;
static NSMutableArray* myglobChosenHcp = nil;

@interface OrderDetailViewController_iPad ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *tbActions;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UILabel *carrier_display_label;

@property (strong, nonatomic) IBOutlet UIView *sigview;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *TemplateMenuButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *done_btn;


@property (strong, nonatomic) IBOutlet UINavigationBar *odNavBar;

@property (strong, nonatomic) IBOutlet UINavigationItem *odNavBarTitle;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *SaveDraftButton;





- (IBAction)delete_sig:(id)sender;

- (IBAction)accept_sig:(id)sender;




- (IBAction)SaveDraft:(UIBarButtonItem *)sender;

- (IBAction)TemplateMenu_Clicked:(UIBarButtonItem *)sender;

- (IBAction)NewProductClick:(id)sender;

- (IBAction)tbActionsClick:(id)sender;

- (IBAction)CellEditorBegunEditing:(id)sender;

- (IBAction)CellEditorEndedEdit:(id)sender;


- (IBAction)CancelOrderDetail:(UIBarButtonItem *)sender;


- (IBAction)Carrier_Ground:(UIButton *)sender;

- (IBAction)Carrier_Air:(UIButton *)sender;


- (IBAction)Done_Clicked:(UIBarButtonItem *)sender;




@end


@implementation OrderDetailViewController_iPad

NSArray *tableData;
NSArray *tableDataX;
NSArray *prodDataX;
NSArray *unitDataX;
NSArray *statusDataX;


@synthesize selectedButton, outputlabel;

@synthesize selectedADDPRODUCT, outputlabel6;

@synthesize selectedHCP, outputlabel1;
@synthesize selectedHCPNUMBER, outputlabel2;
@synthesize selectedHCPINFO, outputlabel4;
@synthesize selectedPRODUCTNUMBER, outputlabel3;
@synthesize selectedCHOSENPRODUCT, outputCHOSENPRODUCT;

@synthesize donotdisplayPRODUCTS, outputREMOVEDPRODUCTS;
@synthesize donotdisplayPRODUCTS2, outputREMOVEDPRODUCTS2;

@synthesize myresults, outputlabel5;

@synthesize fetchedResultsController2, outputlabelA;
@synthesize managedObjectContext2, outputlabelB;

@synthesize fetchRequest2, outputlabelC;
@synthesize fetchOBJ2, outputlabelD;

@synthesize moDATA, outputlabelE;
@synthesize moHCPDATA, outputlabelF;
@synthesize moCreateOrderHCP, outputlabelG;


@synthesize keyboardObservable;

@synthesize orderValueExt_Dict;
@synthesize orderValueDetails_Arr;
@synthesize orderValue_Dict;

@synthesize TemplateMenuButton;

@synthesize odMainView, outputodMainView;

@synthesize arrScrnProducts, outputarrTempProducts;
@synthesize arrTempProducts, outputarrScrnProducts;

@synthesize selectedSHIPINFO, oselectedSHIPINFO;
@synthesize selectedCARRIER, oselectedCARRIER;

@synthesize hiddenTextField;

@synthesize viewContainer;

@synthesize myTableView;


@synthesize templateName, otemplateName;

@synthesize rtnOrderID, ortnOrderID;



#pragma mark - view Delegate Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // DETERMINE STAGE OF APPLICATION
    
    //STAGE 1 - [SEGUE 1 AND NO HCP SELECTED] =  NEW ORDER
    //STAGE 2 - [SEGUE 1 AND HCP SELECTED AND PRODUCT TOTAL = 0] = NEW ORDER AND HCP SELECTED
    //STAGE 3 - [SEGUE 1 AND HCP SELECTED AND PRODUCT TOTAL <> 0] = NEW ORDER AND WITH PRODUCTS SELECTED
    //STAGE 4 - [SEGUE 2] = SHOW ORDER DETAIL INFORMATION
    
    
    // [[self fetchedResultsController] fetchedObjects] count]
    //Loop Through fetchedResults And Build Dictionary To Hold Values
    
    
    // clear previous signature
    myglobsig = @"";
    
    // enable edit
    mypreventEdit = @"";
    
    // initialize dictionary
    _selectableProducts_Dict = [[NSMutableDictionary alloc] init];
    donotdisplayPRODUCTS = [[NSMutableArray alloc] init];
    
    
    // Initialize Arrays
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if(!app.globalProductsRmv){
        app.globalProductsRmv = [[NSMutableArray alloc] init];
    }
    
    if(!app.globalProductsScrn){
        app.globalProductsScrn = [[NSMutableArray alloc] init];
    }
    
        
    if ( !arrScrnProducts)
    {
        arrScrnProducts = [[NSMutableArray alloc] init];
    }
    
    
    if ( !arrScrnProducts)
    {
        arrScrnProducts = [[NSMutableArray alloc] init];
    }
    
    if ( !arrTempProducts)
    {
        arrTempProducts = [[NSMutableArray alloc] init];
    }
    
    if ( !myglobRmvdProducts)
    {
        myglobRmvdProducts = [[NSMutableArray alloc] init];
    }
    
    
    if ( !myglobChosenHcp)
    {
        myglobChosenHcp = [[NSMutableArray alloc] init];
    }
    
    

    
    
    
    
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // default color for mode
    NSString *currentMode = app.globalMode;
    
    if (app.globalShipType == nil) {
        app.globalShipType = @"Ground";
    }
    
    
    if ([currentMode isEqualToString:@"VIEW"]) {
    
        _odNavBar.tintColor = [UIColor blueColor];
        _odNavBarTitle.title = @"View Order Details";
        
        _SaveDraftButton.enabled = FALSE;
        TemplateMenuButton.enabled = FALSE;
        
        _SaveDraftButton.image = nil;
        TemplateMenuButton.image = nil;
        
        _SaveDraftButton.width = 0.0f;
        TemplateMenuButton.width = 0.0f;
        
    }
    
    
    if ([currentMode isEqualToString:@"TEMPLATE"]) {
        
        _odNavBar.tintColor = [UIColor brownColor];
        _odNavBarTitle.title = [NSString stringWithFormat:@"Template Mode {%@}" , [[defaults objectForKey:@"MCG_templatename"] description] ];
        
    }
    
    
    if ([currentMode isEqualToString:@"DRAFT"]) {
        
        _odNavBar.tintColor = [UIColor redColor];
        _odNavBarTitle.title = @"Sample Request {Draft Mode}";
        
        // update hcp/product chosen based on mode
        // app.globalHcpChosen = @"EXISTING";
        // app.globalProductChosen = @"EXISTING";
        
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToBottom) name:@"SteadySignature" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.myTableView addGestureRecognizer:tap];
    
    
    // clear signature
    [SignatureControl clearSignature];
    
    
    
    NSLog(@"dw1 - SHOW DRAFT_PRODUCTS %@", app.globalProductsScrn);
    
    
    // clear initial load ???
    NSArray *initialproducts = [defaults objectForKey:@"MCG_detail_products"];
    
    if ([initialproducts count] > 0) {
        [defaults setObject:nil forKey:@"MCG_detail_products"];
    }
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:tapLocation];
    
   myTableView.scrollEnabled = YES;
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    } else { // release scroll
        // perfom non-cell function (cant regonize cell vs. non-cell good.
    }
}


#pragma mark - Custom Methods


- (IBAction)delete_sig:(id)sender {
    
    
        // Clear Signature - method to clear
    
        [SignatureControl clearSignature];
    
    
        // reset view within tableView cell
    
        UIView *viewX=(UIView *)[self.view viewWithTag:322];
        [viewX setNeedsDisplay];
    
        myTableView.scrollEnabled = YES;
    
}

- (IBAction)accept_sig:(id)sender {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    // how much data ?
    
    NSMutableArray *signatureCapture = [SignatureControl globsigCoordinates];
    
    
    // check products for min. 1 qty
    
    int show_signature = 0;
        
        int total_products = 0;
        // total_products = [arrScrnProducts count];
        total_products = [app.globalProductsScrn count];
        for (int i = 0; i < total_products; i++)
        {
            
            // double user_qty = [[[arrScrnProducts objectAtIndex:i] objectAtIndex:3] doubleValue];
            double user_qty = [[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:3] doubleValue];
            
            // check for qty > 0
            if (user_qty > 0) {
                
                // show signature
                show_signature = 1;
            }
            
        }
    
    
    
        if (show_signature == 0) {
            
            // msg - min. 1 qty
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle: @"No Qty Entered"
                                      message: @"Signature Not Accepted" delegate: nil
                                      cancelButtonTitle: @"OK" otherButtonTitles: nil];
            
            [alertView show];
            
            
            
        } else {
            
                NSLog(@"dw1 - check signature count %lu" , (unsigned long)[signatureCapture count]);
            
                if ([signatureCapture count] < 2) {
                    
                    // no sig. entered
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle: @"Signature Required"
                                              message: @"Signature Not Entered on Device" delegate: nil
                                              cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    
                    [alertView show];
                    
                } else {
                
                // accept signature
                
                UIButton* myButton = (UIButton*)sender;
                myButton.hidden = YES;
                
                
                UIButton *senderButton = (UIButton *)sender;
                UITableViewCell *buttonCell = (UITableViewCell *)[senderButton superview];
                
                // hide button
                [(UILabel *)[buttonCell viewWithTag:552] setHidden:YES];
                
                
                // change bckground color
                [(UILabel *)[buttonCell viewWithTag:322] setBackgroundColor:[UIColor lightGrayColor]];
                    
                // set watermark
                NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                                          dateStyle:NSDateFormatterShortStyle
                                                                          timeStyle:NSDateFormatterShortStyle];
                
                /*
                 if they need the secondS ???
                NSString *FormatString = [NSDateFormatter dateFormatFromTemplate:@"MM/dd/yyyy HH:mm" options:0 locale:[NSLocale currentLocale]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:FormatString];
                */
                    
                [(UILabel *)[buttonCell viewWithTag:554] setText:dateString];
                [(UILabel *)[buttonCell viewWithTag:554] setHidden:NO];
                
                 
                    
                    
                // prevent user interaction in cells
                
                int CellCount = 0;
                    
                NSInteger sections = [myTableView numberOfSections];
                    
                    
                for (NSInteger i = 0; i < sections; i++) {
                
                    CellCount = [myTableView numberOfRowsInSection:i];

                        for (NSInteger x = 0; x < CellCount; x++) {
                            
                            // apply style to section/cell
                            UITableViewCell *cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:x inSection:i]];
                            
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            /* 
                             a. [disable Hcp Button]
                             b. [disable ship ins input]
                             c. [disable carrier input]
                             d. [disable new prod button]
                            */
                            
                            // disable hcp button
                            if (x == 0 && i == 1) {
                                
                                UIButton  *btnhcp = (UIButton*)[cell viewWithTag:22];
                                btnhcp.enabled = NO;
                                btnhcp.hidden = YES;
                            }
                            
                            // disable prod selection
                            if (x == (CellCount-1) && i == 2) {
                                UIButton  *btnprod = (UIButton*)[cell viewWithTag:2];
                                btnprod.enabled = NO;
                                btnprod.hidden = YES;
                            }
                            
                            // disable delivery instructions
                            if (x == 0 && i == 3) {
                                UITextField *shipinput = (UITextField*)[cell viewWithTag:1002];
                                shipinput.enabled = NO;
                            }
                            
                            // disable carrier buttons
                            if (x == 0 && i == 4) {
                                UIButton  *btnCarrierA = (UIButton*)[cell viewWithTag:231];
                                UIButton  *btnCarrierB = (UIButton*)[cell viewWithTag:232];
                                
                                btnCarrierA.enabled = NO;
                                btnCarrierB.enabled = NO;
                            }
                            
                        
                        }
                }
                    

            
            
                    
                // prevent user interaction after sig accept
                    
                UIView *viewX=(UIView *)[self.view viewWithTag:322];
                    [viewX setUserInteractionEnabled:NO];
                    
                
                    
                // [viewx.exclusiveTouch]
                    
                    
                // [myTableView setUserInteractionEnabled:FALSE];
                    
                // [myTableView setAllowsSelection:NO];
                
                // myTableView.scrollEnabled = YES;
                
                // Enable Done Button
                _done_btn.enabled = YES;
                    
                
                // prevent editing afterward
                mypreventEdit = @"YES";
                    
                    // disable buttons {save draft, template}
                    
                    TemplateMenuButton.enabled = FALSE;
                    _SaveDraftButton.enabled = FALSE;
                    
                
                }
            
        }
    
    
    myTableView.scrollEnabled = YES;
    
}




- (IBAction)SaveDraft:(UIBarButtonItem *)sender {
   
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *currentMode = app.globalMode;
    NSString *hcpfound = app.globalHcpChosen;
    
    
    // check for hcp populate
    NSLog(@"dw1 - show freebee INFO %@" , selectedHCPINFO );
    NSLog(@"dw1 - show freebee NUM %ld" , (long)selectedHCPNUMBER);
    NSLog(@"dw1 - %ld", (unsigned long)[selectedHCPINFO count]);
    
        
    if(hcpfound == nil) {
        
        // msg no hcp
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"No Hcp Chosen"
                                  message: @"Draft Cannot Be Saved" delegate: nil
                                  cancelButtonTitle: @"OK" otherButtonTitles: nil];
        
        alertView.tag = 200;
        [alertView show];
        
    } else {
        
        if ([currentMode isEqualToString:@"DRAFT"]) {
            
            // delete previous draft
            
            [self removeDraft];
            
        }
        
        // execute order creation method (DRAFT)
        [self performSelectorOnMainThread:@selector(createOrder:) withObject:@"draft" waitUntilDone:YES];
        
        
        
        
        // exit with manual segue
        [self performSegueWithIdentifier:@"_uwindToOrders" sender:self];
    
    }    
    
    
}




- (IBAction)TemplateMenu_Clicked:(UIBarButtonItem *)sender {
    
    
    if (actionSheet_) {
        [actionSheet_ dismissWithClickedButtonIndex:-1 animated:YES];
        actionSheet_ = nil;
        return;
    }
    

    
    actionSheet_ = [[UIActionSheet alloc] initWithTitle: @"Order"
                                                              delegate: self
                                                     cancelButtonTitle: nil
                                                destructiveButtonTitle: nil
                                                     otherButtonTitles: @"Save Template",
                                   @"Load Template", nil];
    
    
    [actionSheet_ showFromBarButtonItem:sender animated:YES];
    
}




- (void)actionSheet:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *hcpfound = app.globalHcpChosen;

    
    if (buttonIndex == 1) {
        
        // load template
        [self performSegueWithIdentifier:@"_usrOrderTemplate" sender:self];
        
    }
    
    
    if (buttonIndex == 0) {
        
        // save template w/ name
        if (hcpfound != nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Template Name", @"new_list_dialog")
                                                              message:@"chose your template name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 300;
        [alertView show];
        
        // *template creation called from actionview
        
        } else {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"No HCP Selected"
                                                            message: @"Must Select HCP To Save Template!"
                                                           delegate: nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            
    }
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // just set to nil
    actionSheet_ = nil;
    
    NSLog(@"ActionSheet Dismissed");
    
}



/*
 
 Remove Properly
 
- (IBAction)NewProductClick:(id)sender {
}

- (IBAction)tbActionsClick:(id)sender {
}

- (IBAction)tbSaveDraftClick:(id)sender {
}

- (IBAction)CellEditorBegunEditing:(id)sender {
}

- (IBAction)CellEditorEndedEdit:(id)sender {
}
*/




/*
- (IBAction)CancelOrderDetail:(UIBarButtonItem *)sender {
    
    NSLog(@"dw1 - Cancel Has Occured");
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle: @"Cancel Request" message: @"Warning! All Entered Data Will Be Lost" delegate: self
                              cancelButtonTitle: @"cancel" otherButtonTitles: @"OK", nil];
    alertView.tag = 400;
    [alertView show];
}
*/



- (IBAction)Carrier_Ground:(UIButton *)sender {
    
    // get sender cell
    UIButton *senderButton = (UIButton *)sender;
    
    UITableViewCell *buttonCell = (UITableViewCell *)[senderButton superview];
    
    // change text
    [(UILabel *)[buttonCell viewWithTag:33] setText:@"Ground"];
    selectedCARRIER = @"Ground";
    
    
}

- (IBAction)Carrier_Air:(UIButton *)sender {
    
   
    // get sender cell
    UIButton *senderButton = (UIButton *)sender;
    
    UITableViewCell *buttonCell = (UITableViewCell *)[senderButton superview];
    
    // hide button
    [(UILabel *)[buttonCell viewWithTag:33] setText:@"Air"];
    selectedCARRIER = @"Air";
    
    UIAlertView *alertView = [[UIAlertView alloc]
                            initWithTitle: @"Warning" message: @"This shipment will be sent by ATS Air" delegate: self
                          cancelButtonTitle: @"OK" otherButtonTitles:nil];
    
    [alertView show];
    
}



- (void)retainValues
{
    
    // retrieve screen values
    
    UITableViewCell *cella = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    UITextField *shipinput = (UITextField*)[cella viewWithTag:1002];
    
    UITableViewCell *cellb = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    UITextField *shiptype = (UITextField*)[cellb viewWithTag:33];
    
    // store in app delegate
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.globalOrderMO = moDATA;
    
    
    NSLog(@"dw1 - value to retain:%@", shiptype.text);
    
    app.globalShipType = shiptype.text;
    app.globalShipInfo = shipinput.text;
    
    
}


- (void)removeValues
{
    
    // initialize values in app delegate
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.globalMode = nil;
    
    app.globalHcpChosen = nil;
    app.globalProductChosen = nil;
    
    app.globalOrderMO = nil;
    app.globalHcpMO = nil;
    
    app.globalHcpDictionary = nil;
    
    app.globalProductsRmv = nil;
    app.globalProductsScrn = nil;
    app.globalRmvProductsFetch = nil;
    
    
    
    [SignatureControl clearSignature];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"MCG_territoryid"];
    
    
    // carrier
    /*
    UITableViewCell *cella = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    UITextField *shipinput = (UITextField*)[cella viewWithTag:1002];
    
    UITableViewCell *cellb = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    UITextField *shiptype = (UITextField*)[cellb viewWithTag:33];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:shipinput.text forKey:@"MCG_shipnote"];
    [defaults setObject:shiptype.text forKey:@"MCG_shiptype"];
    
    // Store Data
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.globalOrderMO = moDATA;
    */
    
    
    
}


-(void) removeDraft {

        AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
        NSManagedObject *object = app.globalOrderMO;
        
        NSLog(@"dw1 - HAPPY_DRAFT Removal:%@", [object valueForKey:@"shipping_firstname"]);
        NSLog(@"dw1 - HAPPY_DRAFT Removal:%@", [object valueForKey:@"projectcode"]);
        NSLog(@"dw1 - HAPPY_DRAFT Removal:%@", [object valueForKey:@"orderid"]);
        
        // delete row from fetchResults
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        NSManagedObjectContext *context = [self managedObjectContext];
        [context deleteObject:object];
        
        // [_managedObjectContext deleteObject:object];
        
        // Commit the change.
        NSError *error = nil;
        
        // Update the array and table view.
        if (![_managedObjectContext save:&error])
        {
            // Handle the error.
        }

}


#pragma mark - TableView Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *currentMode = app.globalMode;
    NSString *hcpFound = app.globalHcpChosen;
    NSString *productFound = app.globalProductChosen;
    
    int NSections = 2;
    
    // NEW RECORD
    if (currentMode == nil)
    {
        if (hcpFound != nil) {
            NSections = 6;  // Stage 2 - SHOW HCP INFO...
        } else {
            NSections = 2;  // Stage 1
        }
        
        if (productFound != nil) {
            NSections = 6;  // Stage 3 - SHOW ALL INFO...
        }
    }
    
    
    // 2 - [existing order]  / 3 [template] / 4 [Draft]
    if ([currentMode isEqualToString:@"DRAFT"] || [currentMode isEqualToString:@"VIEW"] || [currentMode isEqualToString:@"TEMPLATE"])
    {
        NSections = 6;
    }
    
    NSLog(@"dw1 - Show Selected Button %ld" , (long)selectedButton);
    NSLog(@"dw1 - Show Selected Button %@" , currentMode);

    return NSections;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *HeaderTitle = @"Default";
    
    switch (section)
    
    {
        case 0:
            
            HeaderTitle = @"";
            break;
            
        case 1:
            
            HeaderTitle = @"Requested Physician";
            break;
            
        case 2:
            HeaderTitle = @"To be delivered to Physician";
            break;
            
        case 3:
            
            HeaderTitle = @"Delivery Instructions";
            break;
            
            
        case 4:
            
            HeaderTitle = @"Shipping Carrier";
            break;
            
            
        case 5:
            
            HeaderTitle = @"Signature (required)";
            break;
            
        default:
            
            HeaderTitle = @"";
            break;
            
    }
    
    return HeaderTitle;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *currentMode = app.globalMode;
    
    NSManagedObject *object = moDATA;
    
    
    int MRows = 0;
    int SubtractRows = 0;
    switch (section)
    
    {
        case 0:
            
            //Header
            MRows=1;
            break;
            
        case 1:
            
            //Requested Physician
            MRows=2;
            break;
            
        case 2:

            // Products - To Be Delivered To Physician

            if (currentMode == nil || [currentMode isEqualToString:@"TEMPLATE"]  || [currentMode isEqualToString:@"DRAFT"]) // NEW ORDER / TEMPLATE / DRAFT
            {
                
                // state before row count
                NSLog(@"@dw1 - HG1 globalProductChosen: %@", app.globalProductChosen);
                NSLog(@"@dw1 - HG1 globalHcpChosen: %@", app.globalHcpChosen);
                NSLog(@"@dw1 - HG1 globalProductsRmv Count: %lu", (unsigned long)[app.globalProductsRmv count]);
                
                
                // filter rows after hcp selection
                MRows = [[[self fetchedResultsController] fetchedObjects] count] + 1;   //Total Products
                
                
                NSLog(@"@dw1 - HG1 ProductsFromFetch: %u", MRows);
                
                
                
                // do this when previous rmv products exist (and use tries to delete/add)
                
                if (![app.globalProductChosen isEqualToString:@"NEW"] && ![app.globalHcpChosen isEqualToString:@"NEW"] ) {
                    
                    // no fetch, manually removed rows
                    SubtractRows = [app.globalProductsRmv count];
                    
                                    NSLog(@"@dw1 - HG1 ProductsFromRemove: %u", SubtractRows);
                    
                    if (app.globalRmvProductsFetch.length > 0) {
                        
                        // remove rows cause predicate has not..
                        int IgnoreRows = [app.globalRmvProductsFetch integerValue];
                        
                        MRows = MRows - (SubtractRows - IgnoreRows);
                        NSLog(@"@dw1 - HG1 ShowPositive: %u", MRows);
                    } else {
                        MRows = MRows - SubtractRows;
                    }
                    
                
                }
                
                
                
                NSLog(@"@dw1 - HG1 TOTAL_MROWS: %d", MRows);
                
                NSLog(@"dw1 - show Rmv: %@", app.globalProductsRmv);
                
                
                // reset values
                
                if ([app.globalProductChosen isEqualToString:@"NEW"]) {
                 
                    app.globalProductChosen = @"EXISTING";
                
                }
                
                if ([app.globalHcpChosen isEqualToString:@"NEW"]) {
                    
                    app.globalHcpChosen = @"EXISTING";
                
                }
                
                
                break;
            }
           
            if ([currentMode isEqualToString:@"VIEW"]) // show details
            {            
                MRows = [[object valueForKey:@"toOrderDetails"] count];
                break;
            }
            
            
            /*
            if ([currentMode isEqualToString:@"DRAFT"]) // draft
            {
                MRows = [[object valueForKey:@"toOrderDetails"] count] + 1;
                break;
            }
            */
            
            
            
        case 3:
            //Delivery Instructions
            MRows=1;
            break;
            
        case 4:
            //Shipping Carrier
            MRows=1;
            break;
        
        case 5:
            
            //Signature
            MRows=1;
            break;
            
        default:
            
            MRows=1;
            break;
            
    }
    
    return MRows;
    
    
}









- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *MyFormType = @"_header";
    
    switch (indexPath.section)
    
    {
        case 0:
            
            //Header
            MyFormType=@"_header";
            break;
            
        case 1:
            
            //Requested Physician
            if (indexPath.row == 0) {
                MyFormType = @"_shipTo";
            }
            else {
                MyFormType = @"_address";
            }
            
            break;
            
        case 2:
            
            //To Be Delivered To Physician
            // Iterate based on fetched products from table
            NSLog(@"dw1 - MercyJust %lu",  (unsigned long)[[[self fetchedResultsController] fetchedObjects] count]);
            
            if (indexPath.row == [[[self fetchedResultsController] fetchedObjects] count]) {
                MyFormType=@"_newLineItem";
            } else {
                MyFormType=@"_lineItem";
            }			            
            break;
            
        case 3:
            
            //Delivery Instructions
            MyFormType=@"_instructions";
            break;
            
        case 4:
            
            //Shipping Carrier
            MyFormType=@"_carrier";
            break;
            
        case 5:
            
            //Signature
            MyFormType=@"_signature";
            break;
            
        default:
            
            MyFormType=@"";
            break;
            
    }
    
    
    
 
    
    

    
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyFormType forIndexPath:indexPath];
    
        [self configureCell:cell atIndexPath:indexPath];
    
    
    
        return cell;
    
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    // safety measure (not really used)
    
    [hiddenTextField resignFirstResponder];
    
    return YES;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view {

    NSLog(@"dw1 - is this being called");
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *currentMode = app.globalMode;

    NSLog(@"dw1 - why no keyboard dude: %ld", (long)selectedButton);
    
    tableView.scrollEnabled = YES;
    
  
    // signature selected
    
    if (indexPath.section == 5 && ![mypreventEdit isEqualToString:@"YES"]) {
     
        // position signature
        [self scrollToBottom];
        
    }
    
    
    
    if (indexPath.section == 3 && ![mypreventEdit isEqualToString:@"YES"]) {
        
        [self.view becomeFirstResponder];
        
    }
    
    
    if (indexPath.section == 2 && ![currentMode isEqualToString:@"VIEW"] && ![mypreventEdit isEqualToString:@"YES"])
    {
        
        /*
        for (UIView *view in [self.view subviews]) {
            if ([view isFirstResponder]) {
                [view resignFirstResponder];
            }
        }
        */
        
        
        BOOL isExists = NO;
        for (UIWindow *keyboardWindow in [[UIApplication sharedApplication] windows])   {
            if ([[keyboardWindow description] hasPrefix:@"<UITextEffectsWindow"] == YES) {
                isExists = YES;
            }
        }
        
        
        NSLog(@"dw1 - show Keyboard Noww? %c", isExists);
        
        
        
        
        if ([self.hiddenTextField isFirstResponder]) {
            NSLog(@"dw1 - textf is first responder");
        } else {
            NSLog(@"dw1 - textf is NOT first responder");
        }
        
        
        
        /* UIKeyInput Protocol Methods
           Should Use Custom Keyboard to Prevent Negatives...
        */
        
        // New Entry Mode
        keyboardObservable = 0;
        
        // hiddenTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        // hiddenTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                
        [self.hiddenTextField becomeFirstResponder];
        // hiddenTextField.becomeFirstResponder;
        
    }

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // only allow deletion of products
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    // NSLog(@"show global count: %@", app.globalProductsScrn);
    
    
    if (indexPath.section == 2 && ![mypreventEdit isEqualToString:@"YES"]) {
        if (indexPath.row < [app.globalProductsScrn count]) {
            return YES;
        }
    }
    
    
    return NO;
    
    
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        NSLog(@"dw1 - show mysection %ld" , (long)indexPath.section);
        
        if (indexPath.section == 2) {
            
        // store in do not show array
            
            UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
            
            NSLog(@"dw1 - SSS: %@", cell.textLabel.text);
            
            
            // store proper accessors
            
            int rmv_id = 0;
            
            // add object with matching product id
            
            for (int p = 0; p < [app.globalProductsScrn count]; p++)
            {
                
                NSString *pdesc = [NSString stringWithFormat:@"%@ %@",
                                   [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:1],
                                   [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:2]];
                
                NSLog(@"dw1 - SSSCOMP1: %@", cell.textLabel.text);
                NSLog(@"dw1 - SSSCOMP2: %@", pdesc);
                
                if ([pdesc isEqualToString:cell.textLabel.text]) {
                    rmv_id = p;
                }
                
            }
            
            
            // remove from existing productandqty (templates/draft)
            
            NSString *myProductId = [[app.globalProductsScrn objectAtIndex:rmv_id] objectAtIndex:0];
            
            // remove object from productandqty if exists
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *productandqty = [defaults objectForKey:@"MCG_productandqty"];
            NSMutableDictionary *new_productandqty = [[NSMutableDictionary alloc] init];
            
            for (NSString *dkey in productandqty) {
                
                if (![dkey isEqualToString:myProductId]) {
                    
                    // populate narray
                    
                    [new_productandqty setObject:[productandqty objectForKey:dkey] forKey:dkey];
                }
                
            }
            
            // update array
            [defaults setObject:nil forKey:@"MCG_productandqty"];
            [defaults setObject:new_productandqty forKey:@"MCG_productandqty"];
            
            
            
            // add to remove
            [app.globalProductsRmv addObject:[[app.globalProductsScrn objectAtIndex:rmv_id] objectAtIndex:0]];
            
            // remove object based on id
            [app.globalProductsScrn removeObjectAtIndex:rmv_id];
            

            
            
            
           NSLog(@"dw1 - Was product added to Rmv? %@", app.globalProductsRmv);
            
            // NSLog(@"dw1 - Was product added to Rmv? %@", app.globalProductsRmv);
            
            
        // remove from screen
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        }

    }
}






#pragma mark - Configure Cell

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *currentMode = app.globalMode;
    
    NSString *productFound = app.globalProductChosen;
    NSString *hcpFound = app.globalHcpChosen;
    NSDictionary *myHcp = app.globalHcpDictionary;
    
    
    NSManagedObject *object = nil;
    
    
    if ([currentMode isEqualToString:@"VIEW"] ) {
        object = moDATA;
    }
    
    
    
    
    // Populate object when null from Prod/Hcp Choice
    
    if (object == nil) {
        
        // retrieve value
        
        if ([hcpFound isEqualToString:@"FROMHCP"]) {
            AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            object = app.globalOrderMO;
        }
        
    }
    
#pragma mark request header
    
    // HEADER
    if (indexPath.section == 0) {
        
        // Initialize Values
        
        [(UILabel *)[cell viewWithTag:1] setText:@""];  //reference
        [(UILabel *)[cell viewWithTag:5] setText:@"New"]; //status
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"dd-MM-yyyy"];
        [(UILabel *)[cell viewWithTag:2] setText:[DateFormatter stringFromDate:[NSDate date]]]; //Date Created
        
        [(UILabel *)[cell viewWithTag:3] setText:@""]; //date released
        [(UILabel *)[cell viewWithTag:4] setText:@""]; //date shipped
        
        [(UILabel *)[cell viewWithTag:6] setText:@""]; //reason label
        [(UILabel *)[cell viewWithTag:7] setText:@""]; //reason value
        
        [(UILabel *)[cell viewWithTag:8] setText:@""]; //tracking label
        [(UILabel *)[cell viewWithTag:9] setText:@""]; //tracking value
        
        
        if ([currentMode isEqualToString:@"VIEW"])
        {
            [(UILabel *)[cell viewWithTag:1] setText:[[object valueForKey:@"reference"] description]];
            [(UILabel *)[cell viewWithTag:5] setText:[[object valueForKey:@"status"] description]]; //status
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"dd-MM-yyyy"];
            [(UILabel *)[cell viewWithTag:2] setText:[DateFormatter stringFromDate:[object valueForKey:@"datecreated"] ]]; //Date Created
            
            [(UILabel *)[cell viewWithTag:3] setText:[DateFormatter stringFromDate:[object valueForKey:@"datereleased"] ]]; //date released
            [(UILabel *)[cell viewWithTag:4] setText:[DateFormatter stringFromDate:[object valueForKey:@"dateshipped"] ]]; //date shipped
            
            
            // display of tracking number
            
            if ([[[object valueForKey:@"status"] description] isEqualToString:@"Shipped"]) {
                
                [(UILabel *)[cell viewWithTag:8] setText:@"Tracking #:"] ; //tracking label
                [(UILabel *)[cell viewWithTag:8] setHidden:FALSE]; //tracking value
                
                // concatenate url
                NSString * pass1String = [[object valueForKey:@"trackingnumbers"] stringByReplacingOccurrencesOfString:@"{" withString:@""];
                NSString * pass2String = [pass1String stringByReplacingOccurrencesOfString:@"}" withString:@""];
                NSString * pass3String = [pass2String stringByReplacingOccurrencesOfString:@"-1" withString:@""];

                NSString *trackingurl = [NSString stringWithFormat:@"<a href='http://www.atshealthcare.ca/quickTrackResult.aspx?ship=%@'> %@ </a>", pass3String, pass3String];
                
                [(UIWebView *)[viewContainer viewWithTag:11] setHidden:FALSE]; //tracking value
                [(UIWebView *)[viewContainer viewWithTag:11] loadHTMLString:trackingurl baseURL:nil]; //tracking value
                
                
            }
            
            if ([[[object valueForKey:@"status"] description] isEqualToString:@"OnHold"]) {
                [(UILabel *)[cell viewWithTag:8] setText:@"Reason:"] ; //tracking label
                [(UILabel *)[cell viewWithTag:8] setHidden:FALSE]; //tracking value
                [(UILabel *)[cell viewWithTag:9] setText:[object valueForKey:@"trackingnumbers"]]; //tracking value
                
            }
            
        }
        
    }
    
#pragma mark request hcp
    
    // REQUESTED PHYSICIAN
    if (indexPath.section == 1) {
        
        // defaul values is null
        
        [(UILabel *)[cell viewWithTag:1] setText:@" " ]; // load hcp Name
        
        
        
        
        if (indexPath.row == 0) {
            
            if (currentMode == nil) // NEW ORDER
            {
                
                // replace existing values
                
                if (hcpFound != nil || productFound != nil) {
                    
                    // hcp value from delegate
                    
                    // NSDictionary *myHcp = app.globalHcpDictionary;
                    
                    [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%@, %@", [myHcp valueForKey:@"lastname"], [myHcp valueForKey:@"firstname"]] ]; // load hcp Name
                    
                }
                
                
            } else {
                
                
                // selectedButton 2 & 4 (view & drafts)
                
                if([currentMode isEqualToString:@"VIEW"]) {
                    
                    [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%@, %@",
                                                              [[object valueForKey:@"shipping_lastname"] description],
                                                              [[object valueForKey:@"shipping_firstname"] description]]];
                    
                }
                
                
                if ([currentMode isEqualToString:@"VIEW"]) {
                    UILabel *label = (UILabel *)[cell viewWithTag:2];
                    label.hidden = YES;
                }
                
                
                
                if ([currentMode isEqualToString:@"TEMPLATE"] || [currentMode isEqualToString:@"DRAFT"])  // Template or Draft
                {
                                        
                    [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%@, %@", [myHcp valueForKey:@"lastname"], [myHcp valueForKey:@"firstname"]] ]; // load hcp Name
                    
                    
                }
                
                
            }  //end of selectButton = 0
            
            
            
            
        } else {
            
            
            // display address
            
            if (currentMode == nil) // NEW ORDER
            {
                if (hcpFound != nil || productFound != nil) {
                    
                    //  NSDictionary *myHcp = app.globalHcpDictionary;
                    
                    NSMutableString *address = [NSMutableString string];
                    
                    if ([[myHcp valueForKey:@"facility"] description].length > 2) {
                        [address appendString:[[myHcp valueForKey:@"facility"] description]];
                        [address appendString:@" \n"];
                    }
                    
                    if ([[myHcp valueForKey:@"address1"] description].length > 2) {
                        [address appendString:[[myHcp valueForKey:@"address1"] description]];
                        [address appendString:@" \n"];
                    }
                    
                    if ([[myHcp valueForKey:@"address2"] description].length > 2) {
                        [address appendString:[[myHcp valueForKey:@"address2"] description]];
                        [address appendString:@" \n"];
                    }
                    
                    if ([[myHcp valueForKey:@"address3"] description].length > 2) {
                        [address appendString:[[myHcp valueForKey:@"address3"] description]];
                        [address appendString:@" \n"];
                    }
                    
                    
                    NSString *AddressBuilder = [NSString stringWithFormat:@"%@ %@,%@,%@",
                                                address,
                                                [[myHcp valueForKey:@"city"] description],
                                                [[myHcp valueForKey:@"province"] description],
                                                [[myHcp valueForKey:@"postal"] description]];
                    
                    
                    [(UILabel *)[cell viewWithTag:0] setText:AddressBuilder]; // load Address
                    
                    
                    
                } else {
                    [(UILabel *)[cell viewWithTag:0] setText:@""];
                }
                
            }
            
            
            
            
            
            if ([currentMode isEqualToString:@"VIEW"])  // SHOW DETAILS
            {
                
                
                NSMutableString *address = [NSMutableString string];
                
                if ([[object valueForKey:@"shipping_facilityname"] description].length > 2) {
                    [address appendString:[[object valueForKey:@"shipping_facilityname"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[object valueForKey:@"shipping_addressline1"] description].length > 2) {
                    [address appendString:[[object valueForKey:@"shipping_addressline1"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[object valueForKey:@"shipping_addressline2"] description].length > 2) {
                    [address appendString:[[object valueForKey:@"shipping_addressline2"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[object valueForKey:@"shipping_addressline3"] description].length > 2) {
                    [address appendString:[[object valueForKey:@"shipping_addressline3"] description]];
                    [address appendString:@" \n"];
                }
                
                
                NSString *AddressBuilder = [NSString stringWithFormat:@"%@ %@,%@,%@",
                                            address,
                                            [[object valueForKey:@"shipping_city"] description],
                                            [[object valueForKey:@"shipping_province"] description],
                                            [[object valueForKey:@"shipping_postalcode"] description]];
                
                [(UILabel *)[cell viewWithTag:0] setText:AddressBuilder];  // load Address
                
            }
            
            
            if ([currentMode isEqualToString:@"TEMPLATE"] || [currentMode isEqualToString:@"DRAFT"])  // Template
            {
                
                NSMutableString *address = [NSMutableString string];
                
                if ([[myHcp valueForKey:@"facility"] description].length > 2) {
                    [address appendString:[[myHcp valueForKey:@"facility"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[myHcp valueForKey:@"address1"] description].length > 2) {
                    [address appendString:[[myHcp valueForKey:@"address1"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[myHcp valueForKey:@"address2"] description].length > 2) {
                    [address appendString:[[myHcp valueForKey:@"address2"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[myHcp valueForKey:@"address3"] description].length > 2) {
                    [address appendString:[[myHcp valueForKey:@"address3"] description]];
                    [address appendString:@" \n"];
                }
                
                
                NSString *AddressBuilder = [NSString stringWithFormat:@"%@ %@,%@,%@",
                                            address,
                                            [[myHcp valueForKey:@"city"] description],
                                            [[myHcp valueForKey:@"province"] description],
                                            [[myHcp valueForKey:@"postal"] description]];
                
                
                [(UILabel *)[cell viewWithTag:0] setText:AddressBuilder]; // load Address
                
                /*
                 NSLog(@"dw1 - address %@" , selectedHCPINFO[1]);
                 
                 [(UILabel *)[cell viewWithTag:0] setText:selectedHCPINFO[1]]; // load Address
                 
                 // save hcp address
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:selectedHCPINFO[1] forKey:@"MCG_hcpaddress"];
                 [defaults setObject:selectedHCPINFO[9] forKey:@"MCG_shiptoaddressid"];
                 */
                
            }
            
            
            /*
            if ([currentMode isEqualToString:@"DRAFT"])  // DRAFT
            {
                
                NSMutableString *address = [NSMutableString string];
                
                if ([[object valueForKey:@"shipping_facilityname"] description].length > 2) {
                    [address appendString:[[object valueForKey:@"shipping_facilityname"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[object valueForKey:@"shipping_addressline1"] description].length > 2) {
                    [address appendString:[[object valueForKey:@"shipping_addressline1"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[object valueForKey:@"shipping_addressline2"] description].length > 2) {
                    [address appendString:[[object valueForKey:@"shipping_addressline2"] description]];
                    [address appendString:@" \n"];
                }
                
                if ([[object valueForKey:@"shipping_addressline3"] description].length > 2) {
                    [address appendString:[[object valueForKey:@"shipping_addressline3"] description]];
                    [address appendString:@" \n"];
                }
                
                
                NSString *AddressBuilder = [NSString stringWithFormat:@"%@ %@,%@,%@",
                                            address,
                                            [[object valueForKey:@"shipping_city"] description],
                                            [[object valueForKey:@"shipping_province"] description],
                                            [[object valueForKey:@"shipping_postalcode"] description]];
                
                [(UILabel *)[cell viewWithTag:0] setText:AddressBuilder];  // load Address
                
            }
             */
            
            
            
            
        }
    }
    
    
    
    
#pragma mark request products
    
    // DELIVERED TO PHYSICIAN
    if (indexPath.section == 2) {
        
        
        NSLog(@"dw1 - Monitor Products: %@", currentMode);
        
        
        
        // new order (first time pass)
        
        if (currentMode == nil && (indexPath.row < [[self.fetchedResultsController fetchedObjects] count]))
        {
            NSLog(@"This is the count %d", [[self.fetchedResultsController fetchedObjects] count]);
            NSLog(@"This is the problem %ld", (long)indexPath.row);
            
            NSManagedObject *ProductObject = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                                   [[ProductObject valueForKey:@"productname"] description],
                                   [[ProductObject valueForKey:@"productdescription"] description]];
            
            
            cell.detailTextLabel.text = @"0";
            

            
            // grey text for unavailable products please...
            
            if([[ProductObject valueForKey:@"avail_allocation"] integerValue] == 0 || [[ProductObject valueForKey:@"avail_inventory"] integerValue] == 0) {
                
                cell.textLabel.textColor = [UIColor grayColor];
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
            
            
            NSLog(@"dw1 - arrScrnProducts: %@", app.globalProductsScrn);
            NSLog(@"dw1 - is BCCD hcpfound_existing: %@", hcpFound);
            NSLog(@"dw1 - is BCCD productFound_existing: %@", productFound);
            
            
            NSLog(@"dw1 - PRODUCTFOUND_VALUE: %@", productFound);
            
            
            
            
            // update qty for fetched results
            if (productFound != nil) {
                
                NSLog(@"dw1 - WAS HERE_A23");
                
                NSLog(@"dw1 - WAS HERE_A23_1:%lu", (unsigned long)[app.globalProductsScrn count]);
                
                NSLog(@"dw1 - WAS HERE_A23_2:%@", [[ProductObject valueForKey:@"productid"] description]);
                
                NSLog(@"dw1 - WAS HERE_A23_3:%@", [[app.globalProductsScrn objectAtIndex:indexPath.row] objectAtIndex:0] );
                
                
                
                // update existing values
                
                if ([app.globalProductsScrn count] > 0) {
                    
                    
                    // get index of object before updating
                    
                    for (int p = 0; p < [app.globalProductsScrn count]; p++)
                    {
                        
                        NSString *pdesc = [NSString stringWithFormat:@"%@ %@",
                                           [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:1],
                                           [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:2]];
                        
                        // if ([pdesc isEqualToString:cell.textLabel.text]) {
                        
                        if ([ [[ProductObject valueForKey:@"productid"] description] isEqualToString: [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:0] ] ) {
                            
                            cell.detailTextLabel.text = [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:3];
                            
                        }
                        
                    }
                    
                
                    
                }
                
                
            }
            
            
            NSLog(@"dw1 - BBC - show added products on screen");
            
            
            
            
            // add product based on initial load
            
            if (productFound == nil) {
                
                NSLog(@"dw1 - WAS HERE_B");
                
                arrTempProducts = [NSMutableArray array];
                [arrTempProducts addObject:[[ProductObject valueForKey:@"productid"] description]];
                [arrTempProducts addObject:[[ProductObject valueForKey:@"productname"] description]];
                [arrTempProducts addObject:[[ProductObject valueForKey:@"productdescription"] description]];
                [arrTempProducts addObject:@"0"];
                [app.globalProductsScrn addObject:arrTempProducts]; /* first row is added */
            }
            
            
            
            NSLog(@"dw1 - Monitor Products2: %@", currentMode);
            
            
            
            
        }
        
        
        if ([currentMode isEqualToString:@"VIEW"]) // EXISTING ORDER
        {
            // Iterate based on fetched products from table
            if (indexPath.row == [[[self fetchedResultsController] fetchedObjects] count])
            {
                cell.textLabel.text = @"";
                
            } else {
                
                NSArray *oRecords = [[object valueForKey:@"toOrderDetails"] allObjects];
                
                if ([oRecords count] > 0) {
                    
                    int total_rcds = 0;
                    total_rcds = [oRecords count];
                    
                    // add xtra rcd for draft
                    if ([currentMode isEqualToString:@"DRAFT"]) {
                        total_rcds += 1;
                    }
                    
                    
                    
                    for (int i = 0; i < total_rcds; i++)
                    {
                        
                        if (indexPath.row == i) {
                            
                            // product with qty
                            
                            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                                                   [[oRecords objectAtIndex:i] valueForKey:@"stored_product_name"],
                                                   [[oRecords objectAtIndex:i] valueForKey:@"stored_product_description"] ];
                            
                            cell.detailTextLabel.text = [[[oRecords objectAtIndex:i] valueForKey:@"quantityordered"] stringValue];
                            
                        }
                        
                        
                        NSLog(@"dw1 - Show Current Mode %@", currentMode);
                        NSLog(@"dw1 - Show ProductFound %@", productFound);
                        NSLog(@"dw1 - Show ProductFound %lu", (unsigned long)productFound.length);
                        
                        
                        // add product based on initial load for Draft
                        /*
                        if ([currentMode isEqualToString:@"DRAFT"] && productFound.length == 0) {
                            
                            NSLog(@"dw1 - WAS HERE_C");
                            if (indexPath.row == i) {
                                
                                arrTempProducts = [NSMutableArray array];
                                [arrTempProducts addObject:[[[oRecords objectAtIndex:i] valueForKey:@"productid"] description]];
                                [arrTempProducts addObject:[[[oRecords objectAtIndex:i] valueForKey:@"stored_product_name"] description]];
                                [arrTempProducts addObject:[[[oRecords objectAtIndex:i] valueForKey:@"stored_product_description"] description]];
                                [arrTempProducts addObject:[[[oRecords objectAtIndex:i] valueForKey:@"quantityordered"] stringValue]];
                                [app.globalProductsScrn addObject:arrTempProducts];
                                
                                
                            }
                        }
                        */
                
                        
                        
                        // [productandqty setObject:[[oRecords objectAtIndex:i] valueForKey:@"quantityordered"]
                        //               forKey:[ valueForKey:@"productid"]];
                        
                    }
                    
                }
                
                
            }
        }
        
        
        if ([currentMode isEqualToString:@"TEMPLATE"] || [currentMode isEqualToString:@"DRAFT"] ) // TEMPLATE ORDER OR DRAFT
        {
            // Iterate based on fetched products from table
            if (indexPath.row == [[[self fetchedResultsController] fetchedObjects] count])
            {
                cell.textLabel.text = @"";
                
            } else {
                
                NSManagedObject *ProductObject = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
                
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                                       [[ProductObject valueForKey:@"productname"] description],
                                       [[ProductObject valueForKey:@"productdescription"] description]];
                
                // check for corresponding qty
                // a. Loop Through Products
                // b. get productid = [[ProductObject valueForKey:@"productname"] description]
                // c. output qty
                
                
                // grey text for unavailable products please...
                
                if([[ProductObject valueForKey:@"avail_allocation"] integerValue] == 0 || [[ProductObject valueForKey:@"avail_inventory"] integerValue] == 0) {
                    
                    cell.textLabel.textColor = [UIColor grayColor];
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                }
                
                
                
                
                /* perform if initial load of values */
                
                
                // User Defaults
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                
                // dictionary with pairing
                NSDictionary *productandqty = [defaults objectForKey:@"MCG_productandqty"];
                
                // get qty of product
                int prodqty = [[productandqty objectForKey:[[ProductObject valueForKey:@"productid"] description]] integerValue];
                
                NSLog(@"show prodqty value %d" ,  prodqty);
                NSLog(@"show dictionary %@", productandqty);
                NSLog(@"show dictionary %@", [defaults objectForKey:@"MCG_productandqty"]);
                
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",prodqty];
                
                NSLog(@"dw1 - BBC2 - show added products on screen");
                
                
                // Prevent Addition of Existing Projects
                
                NSString *add_productid = @"YES";
                
                
                for (int p = 0; p < [app.globalProductsScrn count]; p++)
                {
                    NSString *myproductfoundid = [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:0];
                    
                    if ([myproductfoundid isEqualToString:[[ProductObject valueForKey:@"productid"] description] ]) {
                        
                        add_productid = @"NO";
                        
                    }
                }
                
                
                if ([add_productid isEqualToString:@"YES"]) {
                    
                    // add product array entries
                    arrTempProducts = [NSMutableArray array];
                    [arrTempProducts addObject:[[ProductObject valueForKey:@"productid"] description]];
                    [arrTempProducts addObject:[[ProductObject valueForKey:@"productname"] description]];
                    [arrTempProducts addObject:[[ProductObject valueForKey:@"productdescription"] description]];
                    [arrTempProducts addObject:[NSString stringWithFormat:@"%d",prodqty]];
                    [app.globalProductsScrn addObject:arrTempProducts]; /* first row is added */
                
                }
                
                
                
            }
        }
        
        
    }
    
#pragma mark request delivery notes
    
    // DELIVERY INSTRUCTIONS
    if (indexPath.section == 3) {
        
        NSLog(@"dw1 - matchbook1a:%@", hcpFound);
        NSLog(@"dw1 - matchbook1b:%@", productFound);
        NSLog(@"dw1 - matchbook1c:%@", object);
        
        // new
        
        [(UILabel *)[cell viewWithTag:1002] setText:@""];
        
        
        // MO
        
        if (object != nil) {
            
            [(UILabel *)[cell viewWithTag:1002] setText:[[object valueForKey:@"shipping_instructions"] description]];
            NSLog(@"dw1 - matchbook1");
            
        }
        
        
        // hcp/product (initial load)
        
        if (hcpFound != nil || productFound != nil) {
            
            
            // get ship info based on type
            
            
            
            
            [(UILabel *)[cell viewWithTag:1002] setText:app.globalShipInfo];
            NSLog(@"dw1 - matchbook2");
            
            NSLog(@"dw1 - matchbook2a:%@", hcpFound);
            NSLog(@"dw1 - matchbook2b:%@", productFound);
        }
        
        
        
        if ([currentMode isEqualToString:@"VIEW"])
        {
            UILabel *label = (UILabel *)[cell viewWithTag:1002];
            label.enabled = NO;
            
            
            
        }
        
        
        
        
        
    }
    
#pragma mark request shiptype
    
    // SHIPPING CARRIER
    if (indexPath.section == 4) {
        
        [(UILabel *)[cell viewWithTag:231] setHidden:NO];
        [(UILabel *)[cell viewWithTag:232] setHidden:NO];
        
        
        
        // new
        
        [(UILabel *)[cell viewWithTag:33] setText:@"Ground"];
        
        
        // MO
        
        if (object != nil) {
            
            [(UILabel *)[cell viewWithTag:33] setText:[[object valueForKey:@"shipping_type"] description]];
            
        }
        
        // hcp/product (initial load)
        
        if (hcpFound != nil || productFound != nil) {
            
            [(UILabel *)[cell viewWithTag:33] setText:app.globalShipType];
        }
        
        
        
        
        
        
        
        if ([currentMode isEqualToString:@"VIEW"])
        {
            // hide buttons in view mode
            
            [(UILabel *)[cell viewWithTag:231] setHidden:YES];
            [(UILabel *)[cell viewWithTag:232] setHidden:YES];
            
            UILabel *label = (UILabel *)[cell viewWithTag:33];
            label.enabled = NO;
        }
        
        
        
        
        
    }
    
#pragma mark request signature
    
    // SIGNATURE
    if (indexPath.section == 5) {
        
        if ([mypreventEdit isEqual:@"YES"]) {
            
            [(UILabel *)[cell viewWithTag:322] setBackgroundColor:[UIColor lightGrayColor]];
            
        } else {
        
        // Clear WaterMark
        [(UILabel *)[cell viewWithTag:554] setText:@""];
        [(UILabel *)[cell viewWithTag:554] setHidden:YES];
        
        // Change BackGround Color To White
        [(UILabel *)[cell viewWithTag:322] setBackgroundColor:[UIColor whiteColor]];
        
        // Show Buttons
        [(UILabel *)[cell viewWithTag:552] setHidden:NO];
        [(UILabel *)[cell viewWithTag:553] setHidden:NO];
        
        }
        
        
        // addTarget Method
        // [[(UILabel *)[cell viewWithTag:553] setTag:indexPath.row];
        // [[cell] addTarget:self action:@selector(showName:) forControlEvents:UIControlEventTouchDown];
        // buttonName.tag = indexPath.row;
        // [buttonName addTarget:self action:@selector(showName:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if ([currentMode isEqualToString:@"VIEW"])
        {
            
            // chg background color
            
            [(UILabel *)[cell viewWithTag:322] setBackgroundColor:[UIColor lightGrayColor]];
            
            // show watermark
            
            [(UILabel *)[cell viewWithTag:554] setHidden:NO];
            [(UILabel *)[cell viewWithTag:554] setText:@"03/07/2013 3:19:59 PM"];
            
            // hide buttons
            
            [(UILabel *)[cell viewWithTag:552] setHidden:YES];
            [(UILabel *)[cell viewWithTag:553] setHidden:YES];
            
            if([[object valueForKey:@"formnumber"] length] > 0) {
                
                // signature on file
                myglobsig = nil;
                
                [(UILabel *)[cell viewWithTag:554] setText:[NSString stringWithFormat:@"Signature on File %@",[[object valueForKey:@"datecreated"] description]] ];
                
            } else {
                
                // show signature
                
                myglobsig = [[object valueForKey:@"signature"] description];
                [(UILabel *)[cell viewWithTag:554] setText:[[object valueForKey:@"datecreated"] description] ];
            }
            
        } // eo.viewMode
        
        
    } // eo.signature
    
    
    
}


#pragma mark - Signature Methods

float a;

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    a=scrollView.contentOffset.y;
    NSLog(@"dw1 - show offset:%f", a);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=a) {
        // [scrollView setScrollEnabled:NO];
        // [scrollView setContentOffset:CGPointMake(0, a)];
        NSLog(@"dw1 - show offset A:%f", a);
    }
    
    [scrollView setScrollEnabled:YES];
    NSLog(@"dw1 - show offset:%f B", a);
}





- (void) scrollToBottom
{
    CGPoint bottomOffset = CGPointMake(0, myTableView.contentSize.height - myTableView.bounds.size.height);
    if ( bottomOffset.y > 0 ) {
        [myTableView setContentOffset:bottomOffset animated:YES];
        myTableView.scrollEnabled = NO;
        
    }
    
    NSLog(@"dw1 - show mysig: %@" , myglobsig);
    NSLog(@"dw1 - show mysig length: %lu" , (unsigned long)myglobsig.length);
    
    // clear if signature is null (focus on signature box)
    NSMutableArray *signatureCapture = [SignatureControl globsigCoordinates];
    
    if ([signatureCapture count] == 0) {
        
        NSLog(@"dw1 - I HAVE CLEARED");
    
        [SignatureControl clearSignature];
    
        UIView *viewX=(UIView *)[self.view viewWithTag:322];
        [viewX setNeedsDisplay];
        
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"dw1 - alive again ?");
    
    myTableView.scrollEnabled = YES;
    
    [super touchesBegan:touches withEvent:event];
    
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    NSLog(@"touch scroll");
    // If not dragging, send event to next responder
    if (myTableView.dragging)
        NSLog(@"dragging1AA");
    //[self.nextResponder touchesEnded: touches withEvent:event];
    else
        NSLog(@"dragging2AA");
    // [super touchesEnded: touches withEvent: event];
}





#pragma mark - UIKeyInput Protocol Methods

- (BOOL)hasText
{
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSIndexPath *ip = [self.myTableView indexPathForSelectedRow];    
    UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:ip];
    
        NSMutableString *current_text = [[NSMutableString alloc] initWithString:@""];
    
    
        if (keyboardObservable == 0)
        {
            if ([[NSScanner scannerWithString:string] scanInt:nil])
            {
                // replace value
                [current_text appendString:string];
                
                // update dictionary
                // NSString *dictqty = @"QTY_";
                // dictqty = [dictqty stringByAppendingString: [NSString stringWithFormat:@"%d", ip.row]];
                // [_selectableProducts_Dict setObject:current_text forKey:dictqty];
                
                NSLog(@"dw1 - Show GRow Value: %d", ip.row);
                NSLog(@"dw1 - Show GARRAY Value: %@", app.globalProductsScrn);                
                
                
                // find product to populate based on cell text
                
                for (int p = 0; p < [app.globalProductsScrn count]; p++)
                {
                    
                    NSString *pdesc = [NSString stringWithFormat:@"%@ %@",
                                       [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:1],
                                       [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:2]];
                    
                    NSLog(@"dw1 - show AAA:%@",pdesc);
                    
                    NSLog(@"dw1 - show BBB:%@", cell.textLabel.text);
                    
                    
                    
                    if ([pdesc isEqualToString:cell.textLabel.text]) {
                        
                        // double user_qty = [[[app.globalProductsScrn objectAtIndex:p] objectAtIndex:3] doubleValue];
                        
                        [[app.globalProductsScrn objectAtIndex:p] replaceObjectAtIndex:3 withObject:current_text];
                        
                        
                        NSLog(@"dw1 - CCC made update");
                        
                    }
                    
                }
                
                // [[app.globalProductsScrn objectAtIndex:ip.row] replaceObjectAtIndex:3 withObject:current_text];
                
                // _selectableProducts_Dict = @{ dictqty : current_text};
            
            } else {
                
                // non int value [put back orignal value]
                [current_text appendString:cell.detailTextLabel.text];
            }
            
        } else {
            
            if ([[NSScanner scannerWithString:string] scanInt:nil])
            {
                // append value
                [current_text appendString:cell.detailTextLabel.text];
                [current_text appendString:string];
                
                // update dictionary
                // NSString *dictqty = @"QTY_";
                // dictqty = [dictqty stringByAppendingString: [NSString stringWithFormat:@"%d", ip.row]];
                // [_selectableProducts_Dict setObject:current_text forKey:dictqty];
                
                for (int p = 0; p < [app.globalProductsScrn count]; p++)
                {
                    
                    NSString *pdesc = [NSString stringWithFormat:@"%@ %@",
                                       [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:1],
                                       [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:2]];
                    
                    if ([pdesc isEqualToString:cell.textLabel.text]) {
                        
                        [[app.globalProductsScrn objectAtIndex:p] replaceObjectAtIndex:3 withObject:current_text];
                        
                    }
                    
                }
                
                
                // [[app.globalProductsScrn objectAtIndex:ip.row] replaceObjectAtIndex:3 withObject:current_text];
                // _selectableProducts_Dict = @{ dictqty : current_text};
            
            } else {
                
                // non int value [put back original value]
                [current_text appendString:cell.detailTextLabel.text];
            }
        }
    
        keyboardObservable = 1;
    
    // Override Product Maximum (USER ALLOCATION VALUES)
    
    NSManagedObject *prodMOM = [[self.fetchedResultsController fetchedObjects] objectAtIndex:ip.row];
    
        double current_text_double = [current_text doubleValue];
        double allocation_max = [[[prodMOM valueForKey:@"avail_allocation"] description] doubleValue];
        double order_max = [[[prodMOM valueForKey:@"ordermax"] description] doubleValue];
        double set_qty = 0;
    
        // determine qty limitation
        if (allocation_max < order_max) {
            set_qty = allocation_max;
        } else {
            set_qty = order_max;
        }
    
        if (current_text_double > set_qty) {
            current_text = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%g", set_qty]];
            
            
            // update offscreen array (same update applies)
            
            for (int p = 0; p < [app.globalProductsScrn count]; p++)
            {
                
                NSString *pdesc = [NSString stringWithFormat:@"%@ %@",
                                   [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:1],
                                   [[app.globalProductsScrn objectAtIndex:p] objectAtIndex:2]];
                
                NSLog(@"dw1 - show DDD:%@",pdesc);
                NSLog(@"dw1 - show EEE:%@", cell.textLabel.text);
                
                
                if ([pdesc isEqualToString:cell.textLabel.text]) {
                    
                    [[app.globalProductsScrn objectAtIndex:p] replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%g", set_qty]];
                    // [[app.globalProductsScrn objectAtIndex:ip.row] replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%g", set_qty]];
                    
                    NSLog(@"dw1 - FFF made update");
                }
                
            }

            
            
            
        }
    
    cell.detailTextLabel.text = current_text;
    
    return YES;
}






- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.myTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.myTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.myTableView endUpdates];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
     /* access by tag #
     draft = 200 / templatename = 300  / cancelOrderDetail = 400
     */
    
    //NSString *title = [alertView buttonTitleAtIndex:buttonIndex]
    // if ([title isEqualToString: @"Create"]) {
    
    if (alertView.tag == 300) {
        
        templateName = [alertView textFieldAtIndex:0].text;
        
        
        // check if name is existing
        
        id appDelegate = (id)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [appDelegate managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderTemplate" inManagedObjectContext:self.managedObjectContext];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"templatename MATCHES[cd] %@",templateName];
        [request setEntity:entity];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *templateFound = [_managedObjectContext executeFetchRequest:request error:&error];
        
        
       
        NSLog(@"dw1 - show count # %d" , [templateFound count]);
        
        
        if ([templateFound count] == 0) {
        
        // create new template
        [self performSelectorOnMainThread:@selector(createTemplate:) withObject:templateName waitUntilDone:YES];
        
        } else {
        
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Name In Use"
                                  message:@"Your Template Not Created Because That Current Name is in Usage"
                                  delegate:nil //or self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];

            [alert show];
        
        }
        
    
    }
    

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //return [indexPath row] * 20;
    int Npole = 44;
    
    if (indexPath.section == 0) {
        Npole = 100;
    }
    
    
    // custom height for return address
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        Npole = 120;
        
    }
    
    // custom hieght for signature
    if (indexPath.section == 5) {
        Npole = 140;
    }
    
    return Npole;
    
}





#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *currentMode = app.globalMode;
    NSString *hcpFound = app.globalHcpChosen;
    NSString *productFound = app.globalProductChosen;
    
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Allocation" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:200];
        
   
    /* REMOVED - KEEP PRODUCTS / QTYS FOR HCP
    // add predicate only if hcp selected
    if (hcpFound != nil) {
        
        //get predicate from user values
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *territoryid = [defaults objectForKey:@"MCG_territoryid"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"territoryid = %@", territoryid];
        [fetchRequest setPredicate:predicate];
        
    }
    */
    
    
    NSLog(@"dw1 - predicate_check: %@", productFound);
    NSLog(@"dw1 - predicate_check: %@", hcpFound);
    
    //get territory
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *territoryid = [defaults objectForKey:@"MCG_territoryid"];
    
    
    // add predicate only if removed-products exists selected
    if (productFound != nil || hcpFound != nil) {
        
        //get removed products
        NSLog(@"predicate 4 rmvd products %@" , app.globalProductsRmv);
        // NSLog(@"predicate 4 rmvd products %@" , app.globalProductsRmv);
        
        
        // fetch performed with RmvProducts ?
        if ([app.globalProductsRmv count] > 0) {
            app.globalRmvProductsFetch = [NSString stringWithFormat:@"%d", [app.globalProductsRmv count]];
        } else {
            app.globalRmvProductsFetch = @"";
        }
        
        
        //create predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"territoryid = %@ AND NOT (productid IN %@)", territoryid, app.globalProductsRmv];
        
        // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"territoryid = %@ AND NOT (productid IN %@)", territoryid, app.globalProductsRmv];
        
        // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"territoryid = %@", territoryid];
        
        NSLog(@"dw1 - predicate %@" , predicate);
        
        
        [fetchRequest setPredicate:predicate];
    }
    
    
    
    
    // add predicate for selected template
    if ([currentMode isEqualToString:@"TEMPLATE"] || [currentMode isEqualToString:@"DRAFT"] ) {
        
        //get territory
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        // get included products
        NSArray *productsdisplay = nil;
        NSPredicate *predicate = nil;
        
                
        productsdisplay = [defaults objectForKey:@"MCG_detail_products"];        
        
        if ([productsdisplay count] > 0) {
            
            // use screen prod after initial load
            predicate = [NSPredicate predicateWithFormat:@"territoryid = %@ AND (productid IN %@)", territoryid, productsdisplay];
            [fetchRequest setPredicate:predicate];
            
            
            
        }
        
        // clear initial load ???
        /*
         rmv - done in viewdidload
        NSArray *initialproducts = [defaults objectForKey:@"MCG_detail_products"];
        
        if ([initialproducts count] > 0) {
            [defaults setObject:nil forKey:@"MCG_detail_products"];
        }
        */
    }

    

    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productname" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *pFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"ProductList"];
    // pFetchedResultsController.delegate = self;
    self.fetchedResultsController = pFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}   

    return _fetchedResultsController;
}








#pragma mark - Pre-Segue Validation Handling

// segue validation (should I segue or not ?)

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
        
    if ([[identifier description] isEqualToString:@"_choosehcp1"] && [mypreventEdit isEqualToString:@"YES"]) {
        return NO;
    }
    
    
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    // NSLog(@"dw1 - show segue man %@", [identifier description]);
    
    
    if ([[identifier description] isEqualToString:@"_uwindToOrders"]) {
        
        NSString *currentMode = app.globalMode;
        
        // remove if cancelled draft
        if ([currentMode isEqualToString:@"DRAFT"]) {
            
            NSManagedObject *object = app.globalOrderMO;
            
            // delete row from fetchResults
            id appDelegate = (id)[[UIApplication sharedApplication] delegate];
            self.managedObjectContext = [appDelegate managedObjectContext];
            NSManagedObjectContext *context = [self managedObjectContext];
            [context deleteObject:object];
            
            // [_managedObjectContext deleteObject:object];
            
            // Commit the change.
            NSError *error = nil;
            
            // Update the array and table view.
            if (![_managedObjectContext save:&error])
            {
                // Handle the error.
            }
            
            
        }
        
        // app.globalMode = nil;
        
        [self removeValues];
        
        
        NSLog(@"dw1 - show segue - cleared globalMode");
    }
    
    
    // resign kb incase user left open
    [hiddenTextField resignFirstResponder];
    
    if ([[identifier description] isEqualToString:@"_choosehcp1"]) {
        
        
        // turn on products exist flag to retain value when hcp switch occurs
        if ([app.globalProductsScrn count] > 0) {
            app.globalProductChosen = @"EXISTING";
        }
        
        
        [self retainValues];
        
    }
    
    
    if ([[identifier description] isEqualToString:@"_productChoice"]) {
                
        [self retainValues];
        
    }
    
       
    
    return YES;
    
}


#pragma mark - Order Creation

- (IBAction)Done_Clicked:(UIBarButtonItem *)sender {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSString *valid_order = @"NO";
    
    // check qty entered for product
    int total_products = 0;
    total_products = [app.globalProductsScrn count];
    for (int i = 0; i < total_products; i++)
    {
        
        double user_qty = [[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:3] doubleValue];
        
        // check for qty > 0
        if (user_qty > 0) {
            
            valid_order = @"";
        }
        
    }
    
    
    if ([valid_order isEqualToString:@"NO"]) {
        
        // show msg
        // msg no hcp
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: @"Must Select A Product"
                                  message: @"Must Enter A Qty to Create Request" delegate: nil
                                  cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alertView show];
        
        return;
        
    }
    
    

    
    
    [SVProgressHUD showWithStatus:@"Saving Order..."];
    
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"www.samplecupboard.com"];
    NetworkStatus internetStatus = [myNetwork currentReachabilityStatus];
    
    
    if (internetStatus == NotReachable){
        
        // create local order only
        [self performSelectorOnMainThread:@selector(createOrder:) withObject:@"offline" waitUntilDone:YES];
        
        // Increment badge by 1
        for (UIViewController *viewController in self.tabBarController.viewControllers) {
            
            if (viewController.tabBarItem.tag == 4) {
                int totorders_badge;
                totorders_badge = [viewController.tabBarItem.badgeValue integerValue] + 1;
                viewController.tabBarItem.badgeValue = [@(totorders_badge) description];
            }
        }
        
    } else {
        
        // gen guid for Creference  10.8 only
        NSString *uuidString = [[NSUUID UUID] UUIDString];
        
        // non 10.8
        // NSString *uuidStr = [[NSProcessInfo processInfo] globallyUniqueString];
        
        [self performSelectorOnMainThread:@selector(sendOrderToSC:) withObject:uuidString waitUntilDone:YES];
        
        [self performSelectorOnMainThread:@selector(createOrder:) withObject:uuidString waitUntilDone:YES];
        
        
        
        
   
    
    
    // myglobRmvdProducts = nil;
    // myglobChosenHcp = nil;
    
    }  //testx
    
    
    [SVProgressHUD dismiss];
    
    
    
    // remove draft if exists
    
    if ([app.globalMode isEqualToString:@"DRAFT"]) {
        [self removeDraft];
        
    }
    
    
    // remove values
    
    [self removeValues];
    
    
    // Segue to OrderList
    
    [self performSegueWithIdentifier:@"_uwindToOrders" sender:self];
    
    
    
}





- (void) sendOrderToSC:(NSString *) creationMethod {
   
    /*
        Create Order in SC
    */
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    // NSString *projectcode_var = @"TEMP_ORDER";
    
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    
    
    /*
     Get Token(etc) from User Details...
     */
    
    [self populateOrderDictionary:creationMethod];
    
    
    // Build xml
    NSMutableString *order_xml = [[NSMutableString alloc] initWithString:@""];
    
    [order_xml appendString:@"<?xml version=\"1.0\"?>\n<NewMobileOrderModel xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">\n"];
    
    // Convert Dictionary Values
    NSArray *arr = [orderValue_Dict allKeys];
    
    // Conversion Routine
    for(int i=0;i<[arr count];i++)
    {
        id nodeValue = [orderValue_Dict objectForKey:[arr objectAtIndex:i]];
        
        if([nodeValue isKindOfClass:[NSArray class]] )
        {
            if([nodeValue count]>0){
                for(int j=0;j<[nodeValue count];j++)
                {
                    id value = [nodeValue objectAtIndex:j];
                    if([ value isKindOfClass:[NSDictionary class]])
                    {
                        [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                        [order_xml appendString:[NSString stringWithFormat:@"%@",[value objectForKey:@"text"]]];
                        [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
                    }
                }
            }
        }
        else if([nodeValue isKindOfClass:[NSDictionary class]])
        {
            [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
            if([[nodeValue objectForKey:@"Id"] isKindOfClass:[NSString class]])
                [order_xml appendString:[NSString stringWithFormat:@"%@",[nodeValue objectForKey:@"Id"]]];
            else
                [order_xml appendString:[NSString stringWithFormat:@"%@",[[nodeValue objectForKey:@"Id"] objectForKey:@"text"]]];
            [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
        }
        
        else
        {
            if([nodeValue length]>0){
                [order_xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                [order_xml appendString:[NSString stringWithFormat:@"%@",[orderValue_Dict objectForKey:[arr objectAtIndex:i]]]];
                [order_xml appendString:[NSString stringWithFormat:@"</%@>\n",[arr objectAtIndex:i]]];
            }
        }
    }
    
    // OrderLine Details
    [order_xml appendString:[NSString stringWithFormat:@"<IsDraft xsi:nil=\"%@\" />\n", @"true"]];
    [order_xml appendString:[NSString stringWithFormat:@"<DateSigned xsi:nil=\"%@\" />\n", @"true"]];
    
    [order_xml appendString:[NSString stringWithFormat:@"<OrderLineItems>\n"]];
    
    int total_products = 0;
    total_products = [app.globalProductsScrn count];
    for (int i = 0; i < total_products; i++)
    {
        
        double user_qty = [[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:3] doubleValue];
        
        
        // check for qty > 0
        if (user_qty > 0) {
            
            [order_xml appendString:[NSString stringWithFormat:@"<NewMobileOrderLineItem>\n<ProductId>%@</ProductId>\n<QuantityOrdered>%@</QuantityOrdered>\n</NewMobileOrderLineItem>\n", [[app.globalProductsScrn objectAtIndex:i] objectAtIndex:0], [[app.globalProductsScrn objectAtIndex:i] objectAtIndex:3] ]];
        }
        
    }
    
    
    [order_xml appendString:[NSString stringWithFormat:@"</OrderLineItems>\n"]];
    
    // Header End
    [order_xml appendString:[NSString stringWithFormat:@"</NewMobileOrderModel>\n"]];
    
    
    // Should Replace Contradicting XML Characters
    // NSString *order_xml=[order_xml stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    
    // NSLog(@"xmlData: %@", order_xml);
    
    
    //Post XML to SC
    NSData *data = [order_xml dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://dev.samplecupboard.com/Data/MobileServices.svc/CreateOrder"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:data];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *order_response_msg = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    rtnOrderID = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"dw1 - show data response: %@", order_xml);
    NSLog(@"dw1a - show data response: %@", order_response_msg);
    
    
}





- (void) createOrder:(NSString *) orderType {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];

    
    /*
        Order Creation Consists of Different Types:
     
        1. Draft - Draft Order
        2. Local - Creates Entity Within Core Data
    
    */
    
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
 
    NSError *error;
    
    
    
    // populate Order Dictionary
    [self populateOrderDictionary:orderType];
    
 
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *contextINSERT = [self managedObjectContext];
    
    NSManagedObject *OrderHDR = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Order"
                                 inManagedObjectContext:contextINSERT];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"ClientId"] forKey:@"clientid"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"ShippingAddressId"] forKey:@"shiptoid"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"ShippingFirstName"] forKey:@"shipping_firstname"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"ShippingLastName"] forKey:@"shipping_lastname"];
    
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_AddressLine1"] forKey:@"shipping_addressline1"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_AddressLine2"] forKey:@"shipping_addressline2"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_AddressLine3"] forKey:@"shipping_addressline3"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_City"] forKey:@"shipping_city"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_PostalCode"] forKey:@"shipping_postalcode"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_Province"] forKey:@"shipping_province"];
    
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Signature"] forKey:@"signature"];
    
    //get territoryid from user values
    [OrderHDR setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"MCG_territoryid"] forKey:@"territoryid"];
    
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"AllocationId"] forKey:@"allocationid"];
        
    // screen based values
    
    /* can replace 4 lines with ShippingInstructions for consistency
     
     */
    
    UITableViewCell *cella = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    UITextField *shipinput = (UITextField*)[cella viewWithTag:1002];
    
    UITableViewCell *cellb = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    UITextField *shiptype = (UITextField*)[cellb viewWithTag:33];
        
    [OrderHDR setValue:shipinput.text forKey:@"shipping_instructions"];
    [OrderHDR setValue:shiptype.text forKey:@"shipping_type"];
    
    
    // default values
    
    [OrderHDR setValue:@"unassigned" forKey:@"orderid"];
    
    NSString *projectcode_var = @"";
    
    NSString *strprefix = @"";
    NSString *strref = @"";    
    
    
    // draft orders    
    if ([orderType isEqualToString:@"draft"]) {
        projectcode_var = @"DRAFT";
        [OrderHDR setValue:@"DRAFT" forKey:@"status"];
        strprefix = @"DRAFT";
        strref = @"COPY";
    }
    
    
    // offline orders
    if ([orderType isEqualToString:@"offline"]) {
        projectcode_var = @"OFFLINE";
        [OrderHDR setValue:@"999999999" forKey:@"reference"];
        [OrderHDR setValue:@"New" forKey:@"status"];
    }
    
    
    
    
    
    NSLog(@"dw1 - show guid length %d", orderType.length);
    
    
    // on-line orders
    if (orderType.length > 10) {
        projectcode_var = @"TEMP";
        [OrderHDR setValue:[orderValue_Dict valueForKey:@"Creference"] forKey:@"orderid"];
        
        // does return msg contain error
        
        if([rtnOrderID rangeOfString:@"error"].location != NSNotFound) {
            NSLog(@"show error msg");
            /* No Handling of Error Msg Exists */
            
            strprefix = @"ERR";
            strref = @"PENDING";
            projectcode_var = @"REJECTED";
            
        } else {
            
            // substring rtnOrderID
            NSLog(@"dw1 - show me the money: %@", rtnOrderID);
        
            int strpos = [rtnOrderID rangeOfString:@"["].location;  // start position
            int endpos = [rtnOrderID rangeOfString:@"]"].location;  // end position
        
            NSString *basetext = [rtnOrderID substringWithRange:NSMakeRange(strpos+1, (endpos-strpos)-1)];
        
            // split basetext
            int midpos = [basetext rangeOfString:@":"].location;  // mid-point
            strprefix = [basetext substringToIndex:midpos];
            strref = [basetext substringFromIndex:midpos+1];
        
            NSLog(@"dw1a - show me the cash: %@", basetext);
            NSLog(@"dw1b - show me the cash-a: %@", strprefix);
            NSLog(@"dw1b - show me the cash-b: %@", strref);
        }
        
        
        [OrderHDR setValue:strprefix forKey:@"refprefix"];
        [OrderHDR setValue:strref forKey:@"reference"];
        
        [OrderHDR setValue:@"New" forKey:@"status"];
            
    }
    
    
    
    [OrderHDR setValue:projectcode_var forKey:@"projectcode"];
    [OrderHDR setValue:[NSDate date] forKey:@"datecreated"];
    
    
    // show me how many products
    NSLog(@"dw1 - how many products:: %lu", (unsigned long)[app.globalProductsScrn count]);
    
    
    
    // Get Details From Dictionary
    int total_products = 0;
    total_products = [app.globalProductsScrn count];
    
    for (int i = 0; i < total_products; i++)
    {
        
        
        double user_qty = [[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:3] doubleValue];
        
        if (user_qty > 0 || [projectcode_var isEqualToString:@"DRAFT"]) {
            
            NSManagedObject *OrderDTL = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"OrderLineItem"
                                         inManagedObjectContext:contextINSERT];
            [OrderDTL setValue:@"unassigned" forKey:@"orderid"];
            [OrderDTL setValue:[orderValue_Dict valueForKey:@"ClientId"] forKey:@"clientid"];
            
            [OrderDTL setValue:[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:0] forKey:@"productid"];
            [OrderDTL setValue:[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:1] forKey:@"stored_product_name"];
            [OrderDTL setValue:[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:2] forKey:@"stored_product_description"];
            [OrderDTL setValue:@"--" forKey:@"stored_product_code"];
            [OrderDTL setValue:[NSNumber numberWithInt:user_qty] forKey:@"quantityordered"];
            [OrderDTL setValue:[NSDate date] forKey:@"datecreated"];
            [OrderDTL setValue:OrderHDR forKey:@"toOrderHeader"];
        }
        
        
    }
    
    
    // update allocation for real online/offline orders
    
    if (![projectcode_var isEqualToString:@"DRAFT"] && ![projectcode_var isEqualToString:@"TEMPLATE"]) {
        [self updateAllocation];
    }
    
    
    // NSError *error;
    if (![contextINSERT save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } 
   
    
}





- (void) createTemplate:(NSString *) orderType {
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSError *error;
    
    // populate Order Dictionary
    [self populateOrderDictionary:@"normal"];
    
    
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *contextINSERT = [self managedObjectContext];
    
    NSManagedObject *OrderHDR = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"OrderTemplate"
                                 inManagedObjectContext:contextINSERT];
    
    
    NSLog(@"dw1 - tempNameLog: %@", templateName);
    NSLog(@"dw1 - tempNameLog: orderType %@", orderType);
    
    
    [OrderHDR setValue:templateName forKey:@"templatename"];
    
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"ShippingAddressId"] forKey:@"shiptoid"];
    
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"ShippingFirstName"] forKey:@"shipping_firstname"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"ShippingLastName"] forKey:@"shipping_lastname"];
        
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_FacilityName"] forKey:@"shipping_facilityname"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_AddressLine1"] forKey:@"shipping_addressline1"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_AddressLine2"] forKey:@"shipping_addressline2"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_AddressLine3"] forKey:@"shipping_addressline3"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_City"] forKey:@"shipping_city"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_PostalCode"] forKey:@"shipping_province"];
    [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_Province"] forKey:@"shipping_postalcode"];
    
    UITableViewCell *cella = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    UITextField *shipinput = (UITextField*)[cella viewWithTag:1002];
    
    UITableViewCell *cellb = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    UITextField *shiptype = (UITextField*)[cellb viewWithTag:33];
    
    [OrderHDR setValue:shipinput.text forKey:@"shipping_instructions"];
    [OrderHDR setValue:shiptype.text forKey:@"shipping_type"];
    
    
    //get territoryid from user values
    [OrderHDR setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"MCG_territoryid"] forKey:@"territoryid"];
    
    // [OrderHDR setValue:[orderValue_Dict valueForKey:@"Shipping_Province"] forKey:@"shipping_addressid"];
    // Shipping_Partner
    
    [OrderHDR setValue:@"template" forKey:@"orderid"];
    [OrderHDR setValue:[NSDate date] forKey:@"datecreated"];
    
    //Ext Values
    [OrderHDR setValue:@"" forKey:@"reference"];
    
    // Get Details From Dictionary
    int total_products = 0;
    total_products = [app.globalProductsScrn count];
    
    for (int i = 0; i < total_products; i++)
    {
         double user_qty = [[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:3] doubleValue];
        
        // template saves with qty of 0
        
        // if (user_qty > 0) {
        
        NSLog(@"dw1 no write details %lu" , (unsigned long)[app.globalProductsScrn count]);
        
            NSManagedObject *OrderDTL = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"OrderTemplateLine"
                                         inManagedObjectContext:contextINSERT];
            [OrderDTL setValue:@"unassigned" forKey:@"orderid"];
        
            [OrderDTL setValue:[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:0] forKey:@"productid"];
            [OrderDTL setValue:[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:1] forKey:@"stored_product_name"];
            [OrderDTL setValue:[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:2] forKey:@"stored_product_description"];
            [OrderDTL setValue:@"--" forKey:@"stored_product_code"];
            [OrderDTL setValue:[NSNumber numberWithInt:user_qty] forKey:@"quantityordered"];
            [OrderDTL setValue:[NSDate date] forKey:@"datecreated"];
            [OrderDTL setValue:OrderHDR forKey:@"toOrdTempHdr"];
        //}
        
    }
    
    
    // NSError *error;
    if (![contextINSERT save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    
}


- (void) stopscroll {

    self.myTableView.scrollEnabled = NO;

}


- (void) populateOrderDictionary:(NSString *) populationType {
    
    
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSString *hcpFound = app.globalHcpChosen;
    
    NSManagedObject *objectHCP = nil;
    
    
    NSDictionary *myHcp = nil;
    
    
    // get hcp based on input
    
    if (hcpFound != nil || [app.globalMode isEqualToString:@"TEMPLATE"] ) {
        
        // hcp values from chosen activity
        
        myHcp = app.globalHcpDictionary;

        
        // objectHCP = moCreateOrderHCP;
        
    } else {
        
        // no hcp activity, take from order
        objectHCP = moHCPDATA;
        
        myHcp = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[objectHCP valueForKey:@"firstname"] description], @"firstname",
                                   [[objectHCP valueForKey:@"lastname"] description], @"lastname",
                                   [[objectHCP valueForKey:@"facility"] description], @"facility",
                                   [[objectHCP valueForKey:@"address1"] description], @"address1",
                                   [[objectHCP valueForKey:@"address2"] description], @"address2",
                                   [[objectHCP valueForKey:@"address3"] description], @"address3",
                                   [[objectHCP valueForKey:@"province"] description], @"province",
                                   [[objectHCP valueForKey:@"city"] description], @"city",
                                   [[objectHCP valueForKey:@"postal"] description], @"postal",
                                   [[objectHCP valueForKey:@"status"] description], @"status",
                                   [[objectHCP valueForKey:@"phone"] description], @"phone",
                                   [[objectHCP valueForKey:@"fax"] description], @"fax",
                                   [[objectHCP valueForKey:@"email"] description], @"email",
                                   [[objectHCP valueForKey:@"shiptoaddressid"] description], @"shiptoaddressid",
                                   nil];        
    }
    
    
    // format current date
    NSDate *currentDateNTime = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    // [dateformater setDateFormat:@"yyyy-MM-dd,THH:mm:ss"];
    
    NSLog(@"dw1 - show date4mat %@", [dateformater stringFromDate: currentDateNTime]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    // conv. signature to base64
    NSString *sigconv64 = @"";
    NSString *mybase64 = [self SignatureConvertBase64:sigconv64];
    
    // test all keys
    NSDictionary *validUserObjects = [[NSDictionary alloc] initWithObjectsAndKeys:@"MCG_userid", @"MCG_token", @"MCG_territoryid", @"MCG_allocationid", nil];
    
    for(id key in validUserObjects) {
        NSLog(@"key=%@ value=%@", key, [defaults objectForKey:key]);
        
        if ([[defaults objectForKey:key] isKindOfClass:[NSNull class]]) {
            NSLog(@"missing value for %@" , [key description]);
        }
    }
    
    
    UITableViewCell *cella = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    UITextField *shipinput = (UITextField*)[cella viewWithTag:1002];
    
    UITableViewCell *cellb = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    UITextField *shiptype = (UITextField*)[cellb viewWithTag:33];
      
    
    NSLog(@"dw1 - forward:%@", [self stringOrEmptyString:[[myHcp valueForKey:@"shiptoaddressid"] description]]);
    
    NSLog(@"dw1 - forward marc1h:%@", app.globalHcpDictionary );
    
    
    
    // offline mode check for null values
    NSLog(@"dw1 - Userid %@", [defaults objectForKey:@"MCG_userid"] );
    NSLog(@"dw1 - Token %@", [defaults objectForKey:@"MCG_token"] );
    NSLog(@"dw1 - Territoryid %@", [defaults objectForKey:@"MCG_territoryid"] );
    NSLog(@"dw1 - allocationid %@", [defaults objectForKey:@"MCG_allocationid"] );
    NSLog(@"dw1 - Clientid %@", [defaults objectForKey:@"MCG_clientid"] );
    
    
    
    orderValue_Dict = @{   @"UserId" : [defaults objectForKey:@"MCG_userid"],
                           @"Token" : [defaults objectForKey:@"MCG_token"],
                           @"OwnerId" : [defaults objectForKey:@"MCG_userid"],
                           @"TerritoryId" : [defaults objectForKey:@"MCG_territoryid"],
                           @"AllocationId" : [defaults objectForKey:@"MCG_allocationid"],
                           @"ShipToId" : [self stringOrEmptyString:[[myHcp valueForKey:@"shiptoaddressid"] description]],
                           @"CreatorId" : [defaults objectForKey:@"MCG_userid"],
                           @"ClientId" : [defaults objectForKey:@"MCG_clientid"],
                           @"DateEntered" : [[dateformater stringFromDate: currentDateNTime] description],
                           @"DateCreated" : [[dateformater stringFromDate: currentDateNTime] description],
                           @"DateModified" : [[dateformater stringFromDate: currentDateNTime] description],
                           @"ApplicationSource" : @"MobileSampleCupboard",
                           @"Creference" : populationType,
                           @"Shipping_Email" : @" ",
                           @"Shipping_Status" : @"New",
                           @"ShippingAddressId" : [self stringOrEmptyString:[[myHcp valueForKey:@"shiptoaddressid"] description]],
                           @"Shipping_FacilityName" : [self stringOrEmptyString:[[myHcp valueForKey:@"facility"] description]],
                           @"ShippingFirstName" : [self stringOrEmptyString:[[myHcp valueForKey:@"firstname"] description]],
                           @"ShippingLastName" : [self stringOrEmptyString:[[myHcp valueForKey:@"lastname"] description]],
                           @"Shipping_AddressLine1" : [self stringOrEmptyString:[[myHcp valueForKey:@"address1"] description]],
                           @"Shipping_AddressLine2" : [self stringOrEmptyString:[[myHcp valueForKey:@"address2"] description]],
                           @"Shipping_AddressLine3" : [self stringOrEmptyString:[[myHcp valueForKey:@"address3"] description]],
                           @"Shipping_City" : [self stringOrEmptyString:[[myHcp valueForKey:@"city"] description]],
                           @"Shipping_PostalCode" : [self stringOrEmptyString:[[myHcp valueForKey:@"postal"] description]],
                           @"Shipping_Province" : [self stringOrEmptyString:[[myHcp valueForKey:@"province"] description]],
                           @"Shipping_Status" : [self stringOrEmptyString:[[myHcp valueForKey:@"status"] description]],
                           @"Shipping_Phone" : [self stringOrEmptyString:[[myHcp valueForKey:@"phone"] description]],
                           @"Shipping_PhoneExtension" : @" ",
                           @"Shipping_Fax" : [self stringOrEmptyString:[[myHcp valueForKey:@"fax"] description]],
                           @"Shipping_Partner" : @"ATS",
                           @"ShippingInstructions" : [self stringOrEmptyString:shipinput.text],
                           @"Shipping_Type" : [self stringOrEmptyString:shiptype.text],
                           @"Shipping_Email" : [self stringOrEmptyString:[[myHcp valueForKey:@"email"] description]],
                           @"Signature" : mybase64
                           };
    
    
            // @"Shipping_Instructions" : shipinput.text,
}



-(void) updateAllocation {

    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    int total_products = 0;
    total_products = [app.globalProductsScrn count];
    
    for (int i = 0; i < total_products; i++)
    {
        double user_qty = [[[app.globalProductsScrn objectAtIndex:i] objectAtIndex:3] doubleValue];
        
        if (user_qty > 0) {
            
            NSError *error = nil;
            
            //NSManagedObject subclass
            Allocation * aBook = nil;
            
            //obtain allocation for update
            
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Allocation" inManagedObjectContext:context]];            
            
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"territoryid=%@ AND productid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"MCG_territoryid"],
                                     [[app.globalProductsScrn objectAtIndex:i] objectAtIndex:0] ];
            [request setPredicate:predicate];
            
            /*
            [request setPredicate:[NSPredicate predicateWithFormat:@"territoryid=%@ AND productid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"MCG_territoryid"],
                                   [[app.globalProductsScrn objectAtIndex:i] objectAtIndex:0] ]];
            */
            
            
            
            // fetch request
            aBook = [[context executeFetchRequest:request error:&error] lastObject];
            
            
            if (error) {
                //Handle any errors
            }
            
            if (!aBook) {
                //Nothing there to update
            }
            
            //Update the object
            aBook.avail_allocation = [NSNumber numberWithDouble:[aBook.avail_allocation doubleValue] - user_qty];
            
            //Save it
            error = nil;
            if (![context save:&error]) {
                //Handle any error with the saving of the context
            }
            
        }
        
        
    }

}


- (NSString *) SignatureConvertBase64:(NSString *) b64 {
    
    NSMutableArray *preBase64 = [[NSMutableArray alloc] init];

    // Convert captured sig to base64
    NSMutableArray *signatureCapture = [SignatureControl globsigCoordinates];
    NSString *isStart = @"";
    int previousCoord = 0;


    if ([signatureCapture count] > 2) {
        NSLog(@"dw1 - show sigCap: %@", signatureCapture);
    }

    int total_coord = 0;
    total_coord = [signatureCapture count];

    for (int i = 0; i < total_coord; i++)
    {
        
        NSString *coord_handle = [signatureCapture objectAtIndex:i];
        
        
        isStart = @"false";
      
        
        // set isStart
        if (i == 0 || previousCoord == 1 ) {
            isStart = @"true";
        }
        
        // add extra item if previous {0,0}
        if([coord_handle isEqualToString:@"{0, 0}"]) {
            
            previousCoord = 1;
            
        } else {
            
            
            
            // strip values
            int midpoint = [coord_handle rangeOfString:@","].location;  // start position
            
            int endpoint = coord_handle.length;  // end position
            int endpointX = endpoint - (midpoint - 1);
            int stoppoint = [coord_handle rangeOfString:@"}"].location;  // start position
            
            
            NSLog(@"dw1 - show the goods:%@  m:%d e:%d ex:%d s:%d", coord_handle, midpoint, endpoint, endpointX, stoppoint);
            
            
            
            NSString *fstringX = [coord_handle substringWithRange:NSMakeRange(1, midpoint-1)];
            NSLog(@"dw1: fstringX:%@", fstringX);
            
            int endpointS = coord_handle.length - 1;
            NSLog(@"dw1: endpointS:%d", endpointS);
            
            NSString *fstringY = [coord_handle substringWithRange:NSMakeRange(midpoint+2, (stoppoint - (midpoint+2)))];
            NSLog(@"dw1: fstringY:%@", fstringY);
            
            // NSString *fstringYx = [coord_handle substringWithRange:NSMakeRange(midpoint+2, (endpointX - (midpoint+1)))];
            // NSLog(@"dw1: fstringYx:%@", fstringYx);
            
            // NSLog(@"dw1 - show float strings %@, %@", fstringX, fstringY);
                        
            // create new string based on
            [preBase64 addObject:[NSString stringWithFormat:@"{\"isStart\": %@, \"x\": %@, \"y\": %@},", isStart, fstringX, fstringY]];
            
            previousCoord = 0;
        }
    
    }   


        // remove last comma
        NSString *resultX = [[preBase64 valueForKey:@"description"] componentsJoinedByString:@""];
    
        NSString *resultY = @"";
    
        if([resultX hasSuffix:@","]) {
            resultY = [resultX substringToIndex:[resultX length]-1];
        } else {
            resultY = resultX;
        }
    
        // conversion
        NSString *resultZ = [NSString stringWithFormat:@"[%@]", resultY];
    
    
        // Experiment
        // resultZ = @"?[{\"isStart\": true, \"x\": 119, \"y\": 45}, {\"isStart\": false, \"x\": 109, \"y\": 55}, {\"isStart\": false, \"x\": 101, \"y\": 72}, {\"isStart\": false, \"x\": 92, \"y\": 87}, {\"isStart\": false, \"x\": 86, \"y\": 97}, {\"isStart\": false, \"x\": 83, \"y\": 101}, {\"isStart\": false, \"x\": 81, \"y\": 103}, {\"isStart\": false, \"x\": 80, \"y\": 104}, {\"isStart\": false, \"x\": 80, \"y\": 103}, {\"isStart\": false, \"x\": 81, \"y\": 91}, {\"isStart\": false, \"x\": 92, \"y\": 68}, {\"isStart\": false, \"x\": 108, \"y\": 39}, {\"isStart\": false, \"x\": 125, \"y\": 20}, {\"isStart\": false, \"x\": 136, \"y\": 13}, {\"isStart\": false, \"x\": 143, \"y\": 11}, {\"isStart\": false, \"x\": 148, \"y\": 11}, {\"isStart\": false, \"x\": 150, \"y\": 17}, {\"isStart\": false, \"x\": 150, \"y\": 34}, {\"isStart\": false, \"x\": 141, \"y\": 55}, {\"isStart\": false, \"x\": 136, \"y\": 67}, {\"isStart\": false, \"x\": 131, \"y\": 75}, {\"isStart\": false, \"x\": 122, \"y\": 82}, {\"isStart\": false, \"x\": 112, \"y\": 86}, {\"isStart\": false, \"x\": 104, \"y\": 89}, {\"isStart\": false, \"x\": 97, \"y\": 93}, {\"isStart\": false, \"x\": 93, \"y\": 93}, {\"isStart\": false, \"x\": 100, \"y\": 88}, {\"isStart\": false, \"x\": 112, \"y\": 81}, {\"isStart\": false, \"x\": 127, \"y\": 75}, {\"isStart\": false, \"x\": 135, \"y\": 73}, {\"isStart\": false, \"x\": 136, \"y\": 73}, {\"isStart\": false, \"x\": 137, \"y\": 73}, {\"isStart\": false, \"x\": 135, \"y\": 75}, {\"isStart\": false, \"x\": 125, \"y\": 85}, {\"isStart\": false, \"x\": 117, \"y\": 92}, {\"isStart\": false, \"x\": 114, \"y\": 97}, {\"isStart\": false, \"x\": 114, \"y\": 100}, {\"isStart\": false, \"x\": 114, \"y\": 101}, {\"isStart\": false, \"x\": 120, \"y\": 101}, {\"isStart\": false, \"x\": 126, \"y\": 98}, {\"isStart\": false, \"x\": 131, \"y\": 93}, {\"isStart\": false, \"x\": 135, \"y\": 88}, {\"isStart\": false, \"x\": 137, \"y\": 85}, {\"isStart\": false, \"x\": 138, \"y\": 84}, {\"isStart\": false, \"x\": 139, \"y\": 83}, {\"isStart\": false, \"x\": 139, \"y\": 84}, {\"isStart\": false, \"x\": 139, \"y\": 85}, {\"isStart\": false, \"x\": 139, \"y\": 89}, {\"isStart\": false, \"x\": 139, \"y\": 92}, {\"isStart\": false, \"x\": 139, \"y\": 94}, {\"isStart\": false, \"x\": 140, \"y\": 97}, {\"isStart\": false, \"x\": 142, \"y\": 98}, {\"isStart\": false, \"x\": 147, \"y\": 98}, {\"isStart\": false, \"x\": 152, \"y\": 94}, {\"isStart\": false, \"x\": 158, \"y\": 85}, {\"isStart\": false, \"x\": 160, \"y\": 84}, {\"isStart\": true, \"x\": 207, \"y\": 20}, {\"isStart\": false, \"x\": 206, \"y\": 24}, {\"isStart\": false, \"x\": 195, \"y\": 36}, {\"isStart\": false, \"x\": 177, \"y\": 57}, {\"isStart\": false, \"x\": 163, \"y\": 78}, {\"isStart\": false, \"x\": 157, \"y\": 88}, {\"isStart\": false, \"x\": 156, \"y\": 93}, {\"isStart\": false, \"x\": 156, \"y\": 97}, {\"isStart\": false, \"x\": 156, \"y\": 98}, {\"isStart\": false, \"x\": 157, \"y\": 100}, {\"isStart\": true, \"x\": 165, \"y\": 98}, {\"isStart\": false, \"x\": 158, \"y\": 101}, {\"isStart\": false, \"x\": 154, \"y\": 102}, {\"isStart\": false, \"x\": 153, \"y\": 103}, {\"isStart\": false, \"x\": 161, \"y\": 101}, {\"isStart\": false, \"x\": 182, \"y\": 85}, {\"isStart\": false, \"x\": 214, \"y\": 63}, {\"isStart\": false, \"x\": 250, \"y\": 35}, {\"isStart\": false, \"x\": 278, \"y\": 10}, {\"isStart\": false, \"x\": 287, \"y\": -1}, {\"isStart\": false, \"x\": 287, \"y\": -5}, {\"isStart\": false, \"x\": 281, \"y\": -5}, {\"isStart\": false, \"x\": 257, \"y\": 7}, {\"isStart\": false, \"x\": 231, \"y\": 29}, {\"isStart\": false, \"x\": 211, \"y\": 55}, {\"isStart\": false, \"x\": 203, \"y\": 72}, {\"isStart\": false, \"x\": 201, \"y\": 84}, {\"isStart\": false, \"x\": 201, \"y\": 93}, {\"isStart\": false, \"x\": 201, \"y\": 98}, {\"isStart\": false, \"x\": 201, \"y\": 101}, {\"isStart\": false, \"x\": 202, \"y\": 103}, {\"isStart\": false, \"x\": 203, \"y\": 103}, {\"isStart\": false, \"x\": 203, \"y\": 101}, {\"isStart\": false, \"x\": 202, \"y\": 97}, {\"isStart\": false, \"x\": 199, \"y\": 92}, {\"isStart\": false, \"x\": 199, \"y\": 89}, {\"isStart\": false, \"x\": 199, \"y\": 87}, {\"isStart\": false, \"x\": 199, \"y\": 85}, {\"isStart\": false, \"x\": 199, \"y\": 84}, {\"isStart\": false, \"x\": 202, \"y\": 85}, {\"isStart\": false, \"x\": 204, \"y\": 86}, {\"isStart\": false, \"x\": 210, \"y\": 89}, {\"isStart\": false, \"x\": 217, \"y\": 89}, {\"isStart\": false, \"x\": 227, \"y\": 85}, {\"isStart\": false, \"x\": 238, \"y\": 72}, {\"isStart\": false, \"x\": 253, \"y\": 49}, {\"isStart\": false, \"x\": 255, \"y\": 47}]";

    
        NSLog(@"dw1 - show resultX:%@", resultZ);
    
        // NSString *b64 = [[NSString alloc] init];
    
        b64 = [[resultZ description] base64EncodedString];
        NSLog(@"dw1 = b64:%@", b64);
    
        return b64;

}








#pragma mark - utilities


+ (NSString*)preventEdit {
    return mypreventEdit;
}

+ (NSString*)globsig {
    return myglobsig;
}

+ (NSMutableArray*)globprod {
    return myglobRmvdProducts;
}

+ (NSMutableArray*)globhcp {
    return myglobChosenHcp;
}


- (NSString *)stringOrEmptyString:(NSString *)string
{
    if (string)
        return string;
    else
        return @" ";
}

+(BOOL)isKeyBoardInDisplay  {
    
    BOOL isExists = NO;
    for (UIWindow *keyboardWindow in [[UIApplication sharedApplication] windows])   {
        if ([[keyboardWindow description] hasPrefix:@"<UITextEffectsWindow"] == YES) {
            isExists = YES;
        }
    }
    
    return isExists;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    return true;
}


@end

