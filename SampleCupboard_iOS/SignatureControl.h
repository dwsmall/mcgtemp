//
//  SignatureControl.h
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//


#import <UIKit/UIKit.h>


// @interface SignatureControl : UIViewController {
@interface SignatureControl : UIView {

NSMutableArray *handWRITING;

}

@property (strong, nonatomic) NSMutableArray *handWRITING;
@property (nonatomic, weak) IBOutlet UILabel *ohandWRITING;

// Sets the stroke width
@property(nonatomic) float lineWidth;

// The stroke color
@property(nonatomic,strong) UIColor *foreColor;

// When you get the signature UIIMage, this var
// lets you wrap a point margin around the image.
@property(nonatomic) float signatureImageMargin;

// If YES, the control will crop and center the signature
@property(nonatomic) BOOL shouldCropSignatureImage;


+ (NSMutableArray*)globsigCoordinates;


// Returns the signature as a UIImage
-(UIImage *)getSignatureImage;

// Clears the signature from the screen
+(void)clearSignature;



@end
