//
//  HomeViewController.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-28.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end


@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Build String Using Values From Localized Files
    NSArray  *array1 = [NSArray arrayWithObjects: @"<body style='background-color:white;color:#000'>",
                        @"<div>",
                        @"<span>",
                        @"Welcome to the IPAD sampling application HOME page that contains many useful links and resources to facilitate the IPAD sampling process:",
                        @"</span>",
                        
                        @"<p><ul><li>",
                        @"<a href='",
                        @"MCG_Sampling_IPAD_EN.pdf",
                        @"'>",
                        @"Click here to Access the IPAD user manual",
                        @"</a>",
                        @"</li></ul></p>",
                        
                        @"<span>",
                        @"To contact us please use one of the links below:",
                        @"</span>",
                        @"<p><ul><li>",
                        @"Email MCG for questions regarding your samples or application functionality and training:",
                        @"</li></ul></p>",
                        
                        @"<p><ul><li>",
                        @"<a href='mailto:",
                        @"merck@medcommunications.ca",
                        @"'>",
                        @"merck@medcommunications.ca",
                        @"</a> ",
                        @"</li></ul></p>",
                        
                        @"<span>",
                        @"If HELP desk cannot help you with an application issue you may contact the MCG application support team:",
                        @"</span>",
                        
                        @"<p><ul><li>",
                        @"<a href='mailto:",
                        @"support@medcommunications.ca",
                        @"'>",
                        @"support@medcommunications.ca",
                        @"</a> ",
                        @"</li></ul></p>",
                        
                        @"<span>",
                        @"Useful Websites:",
                        @"</span>",
                        
                        @"<p><ul><li>",
                        @"<span>",
                        @"Click here to access the ATS Healthcare tracking website to track the delivery of your sample requests:",
                        @"</span>",
                        @"</li></ul></p>",
                        
                        @"<p><ul><li>",
                        @"<a href='",
                        @"http://www.atshealthcare.ca/en/index.aspx",
                        @"'>",
                        @"http://www.atshealthcare.ca/en/index.aspx",
                        @"</a> ",
                        @"</li></ul></p>",
                        
                        @"<p><ul><li>",
                        @"<span>",
                        @"Link To SampleCupboard:",
                        @"</span>",
                        @"</li></ul></p>",
                        
                        @"<p><ul><li>",
                        @"<a href='",
                        @"http://www.samplecupboard.com",
                        @"'>",
                        @"http://www.samplecupboard.com",
                        @"</a> ",
                        @"</li></ul></p>",
                        
                        @"</div>",
                        @"</body>",
                        nil];
    
    NSString *joinedString = [array1 componentsJoinedByString:@" "];
    
    [_viewWeb loadHTMLString:joinedString baseURL:nil];
    
    
}


@end
