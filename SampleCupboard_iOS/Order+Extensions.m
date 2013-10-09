//
//  Order+Extensions.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-08-07.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "Order+Extensions.h"

@implementation Order (Extensions)

+ (void)importDataToMoc:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order"
                                              inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSUInteger count = [moc countForFetchRequest:fetchRequest error:&error];
    
    if (count == 0)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"plist"];
        NSArray *countries = [[NSArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *item in countries)
        {
            Order *country = [NSEntityDescription insertNewObjectForEntityForName:@"Order"
                                                             inManagedObjectContext:moc];
            country.shipping_firstname = [item valueForKey:@"shipping_firstname"];
            country.shipping_lastname = [item valueForKey:@"shipping_lastname"];
            country.orderid = [item valueForKey:@"orderid"];
            country.reference = [item valueForKey:@"reference"];
            
        }
        
        if (![moc save:&error])
        {
            NSLog(@"failed to import data: %@", [error localizedDescription]);
        }
    }
}


- (NSString *)sectionTitle
{
    return [self.shipping_lastname substringToIndex:1];
}
@end

