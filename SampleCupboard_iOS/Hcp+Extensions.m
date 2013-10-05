//
//  Hcp+Extensions.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-08-07.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "Hcp+Extensions.h"

@implementation HealthCareProfessional (Extensions)

+ (void)importDataToMoc:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HealthCareProfessional"
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
            HealthCareProfessional *country = [NSEntityDescription insertNewObjectForEntityForName:@"HealthCareProfessional"
                                                           inManagedObjectContext:moc];
            country.firstname = [item valueForKey:@"firstname"];
            country.lastname = [item valueForKey:@"lastname"];
            country.province = [item valueForKey:@"province"];
            country.postal = [item valueForKey:@"postal"];
            
        }
        
        if (![moc save:&error])
        {
            NSLog(@"failed to import data: %@", [error localizedDescription]);
        }
    }
}


- (NSString *)sectionTitle
{
    return [self.lastname substringToIndex:1];
}
@end
