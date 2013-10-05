//
//  HealthCareProfessional.h
//  SampleCupboard_iOS
//
//  Created by David Small on 8/8/13.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HealthCareProfessional : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * address3;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * clientid;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * datemodified;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facility;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * identitymanagerid;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * phlid;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postal;
@property (nonatomic, retain) NSString * preferredlanguage;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSNumber * rejected;
@property (nonatomic, retain) NSString * specialty;
@property (nonatomic, retain) NSString * specialty2;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * title;

@end
