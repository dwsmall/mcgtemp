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
    
    // get language setting
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    
    // set english
    
    NSString *hometext1 = @"Welcome to the IPAD sampling application HOME page that contains many useful links and resources to facilitate the IPAD sampling process:";
    
    NSString *hometext2 = @"Click here to Access the IPAD user manual";
    
    NSString *fileName = @"http://www.samplecupboard.com/content/ipad/MCG_Sampling_IPAD_EN.pdf";
    
    NSString *hometext3 = @"To contact us please use one of the links below:";
    
    NSString *hometext4 = @"Email MCG for questions regarding your samples or application functionality and training:";
    
    NSString *hometext5 = @"Email Canada, SFE for any questions relating to the IPAD device issues, suggestions or tips:";
    
    NSString *hometext6 = @"If HELP desk cannot help you with an application issue you may contact the MCG application support team:";
    
    NSString *hometext6a = @"Useful Websites:";
    
    NSString *hometext7 = @"Click here to access the ATS Healthcare tracking website to track the delivery of your sample requests:";
    
    NSString *hometext8 = @"Link To SampleCupboard:";
    
    
    // french override
    
    if ([preferredLang isEqualToString:@"fr"]) {
        
        hometext1 = @"Bienvenue sur la page d'accueil de l'application MCG pour iPad oú vous y trouverez plusieurs liens utiles ainsi que des ressources pour faciliter le processus d'échantillonnage sur iPad:";
        
        hometext2 = @"Veuillez cliquer ici pour accéder le Guide de l'utilisateur";
        
        fileName = @"http://www.samplecupboard.com/content/ipad/MCG_Sampling_IPAD_FR.pdf";
        
        hometext3 = @"Pour nous contacter, veuillez utiliser l'un des liens ci-dessous:";
        
        hometext4 = @"courriel à MCG pour les questions concernant vos échantillons ou les fonctions de l'application et de la formation:";
        
        hometext5 = @"courriel à Canada, SFE pour toutes questions relatives aux problèmes de l'appareil IPAD ou pour soumettre vos suggestions ou des conseils:";
        
        hometext6 = @"Si le Bureau d'assistance ne peut vous seconder avec un problème d'application MCG, vous pouvez contacter l'équipe de support MCG:";
        
        hometext6a = @"Liens à certains sites Web utiles:";
        
        hometext7 = @"Cliquez ici pour accéder le site ATS Santé pour faire le suivi sur la livraison de vos demandes d'échantillons:";
        
        hometext8 = @"Lien à SampleCupboard:";
        
    }
    
    
    
    // Build String Using Values From Localized Files
    NSArray  *array1 = [NSArray arrayWithObjects: @"<body style='background-color:white;color:#000'>",
                        @"<div>",
                        @"<span>",
                        hometext1,
                        @"</span>",
                        
                        @"<p><ul><li>",
                        @"<a href='",
                        fileName,
                        @"'>",
                        hometext2,
                        @"</a>",
                        @"</li></ul></p>",
                        
                        @"<span>",
                        hometext3,
                        @"</span>",
                        @"<p><ul><li>",
                        hometext4,
                        @"</li></ul></p>",
                        
                        @"<p><ul><li>",
                        @"<a href='mailto:",
                        @"merck@medcommunications.ca",
                        @"'>",
                        @"merck@medcommunications.ca",
                        @"</a> ",
                        @"</li></ul></p>",
                        
                        @"<p><ul><li>",
                        hometext5,
                        @"</li></ul></p>",
                        
                        @"<span>",
                        hometext6,
                        @"</span>",
                        
                        @"<p><ul><li>",
                        @"<a href='mailto:",
                        @"support@medcommunications.ca",
                        @"'>",
                        @"support@medcommunications.ca",
                        @"</a> ",
                        @"</li></ul></p>",
                        
                        @"<span>",
                        hometext6a,
                        @"</span>",
                        
                        @"<p><ul><li>",
                        @"<span>",
                        hometext7,
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
                        hometext8,
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


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    
    // open links in safari
    
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
