//
//  SignatureControl.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "Base64.h"
#import "SignatureControl.h"
#import "OrderDetailViewController_iPad.h"
#import "SetupConfig.h"

static NSMutableArray* myglobsigCoordinates = nil;


#pragma mark - *** Private Interface ***

@interface SignatureControl() {
    
@private
	__strong NSMutableArray *handwritingCoords_;
	__weak UIImage *currentSignatureImage_;
	float lineWidth_;
	float signatureImageMargin_;
	BOOL shouldCropSignatureImage_;
	__strong UIColor *foreColor_;
	CGPoint lastTapPoint_;
}

@property(atomic,strong) NSMutableArray *handwritingCoords;

-(void)processPoint:(CGPoint)touchLocation;

@end



@implementation SignatureControl


@synthesize handWRITING, ohandWRITING;

@synthesize
handwritingCoords = handwritingCoords_,
lineWidth = lineWidth_,
signatureImageMargin = signatureImageMargin_,
shouldCropSignatureImage = shouldCropSignatureImage_,
foreColor = foreColor_;

#pragma mark - *** Drawing ***


- (void)view:(UIView *)view didBeginDragging:(UIEvent *)event {
   
}


- (void)vView:(UIView *)view didFinishDragging:(UIEvent *)event {

}




- (void)drawRect:(CGRect)rect {
    
    
    // initilization
    
    // if (handWRITING == nil) {
    if (myglobsigCoordinates == nil) {
    
        handWRITING = [[NSMutableArray alloc] init];
        self.handwritingCoords = [[NSMutableArray alloc] init];
		self.lineWidth = 3.0f;
		self.signatureImageMargin = 3.0f;
		self.shouldCropSignatureImage = YES;
		self.foreColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
		lastTapPoint_ = CGPointZero;
        
        myglobsigCoordinates = [[NSMutableArray alloc] init];
        
    }
    
    
    
    
    NSString *mySignature = [OrderDetailViewController_iPad globsig];

    
    if ([mySignature length] > 0)
    {
        
            // SHOW SIGNATURE
        
            [self showSignature];
    
        
    } else {
        
            // DRAW SIGNATURE
    
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            // Set drawing params
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextSetStrokeColorWithColor(context, [self.foreColor CGColor]);
            CGContextSetLineCap(context, kCGLineCapButt);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextBeginPath(context);
            
            // This flag tells us to move to the point
            // rather than draw a line to the point
            BOOL isFirstPoint = YES;
            
            // Loop through the strings in the array
            // which are just serialized CGPoints
        
            // bx1 for (NSString *touchString in self.handwritingCoords) {
                for (NSString *touchString in myglobsigCoordinates) {
                
                // NSLog(@"dw1 - show handWRITE %@", self.handwritingCoords);
                
                // Unserialize
                CGPoint tapLocation = CGPointFromString(touchString);
                
                // If we have a CGPointZero, that means the next
                // iteration of this loop will represent the first
                // point after a user has lifted their finger.
                if (CGPointEqualToPoint(tapLocation, CGPointZero)) {
                    isFirstPoint = YES;
                    continue;
                }
                
                // If first point, move to it and continue. Otherwize, draw a line from
                // the last point to this one.
                if (isFirstPoint) {
                    CGContextMoveToPoint(context, tapLocation.x, tapLocation.y);
                    isFirstPoint = NO;
                    // NSLog(@"dw1 - %f, %f", tapLocation.x, tapLocation.y);
                    
                } else {
                    CGPoint startPoint = CGContextGetPathCurrentPoint(context);
                    CGContextAddQuadCurveToPoint(context, startPoint.x, startPoint.y, tapLocation.x, tapLocation.y);
                    CGContextAddLineToPoint(context, tapLocation.x, tapLocation.y);

                }
                
            }
            
            // Stroke it, baby!
            CGContextStrokePath(context);
        
    } // end of if
    
}




#pragma mark - *** Touch Handling ***

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SteadySignature" object:nil];

}

    


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	[self processPoint:touchLocation];

}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    [myglobsigCoordinates addObject:NSStringFromCGPoint(CGPointZero)];
    
    
}





-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
    [myglobsigCoordinates addObject:NSStringFromCGPoint(CGPointZero)];
    
}


#pragma mark - *** Private Methods ***


-(void)processPoint:(CGPoint)touchLocation {
	
    
	// Only keep the point if it's > 5 points from the last
	if (CGPointEqualToPoint(CGPointZero, lastTapPoint_) ||
		fabs(touchLocation.x - lastTapPoint_.x) > 2.0f ||
		fabs(touchLocation.y - lastTapPoint_.y) > 2.0f) {
		
		[myglobsigCoordinates addObject:NSStringFromCGPoint(touchLocation)];
        
		[self setNeedsDisplay];
		lastTapPoint_ = touchLocation;
		
	}
	
}


#pragma mark - *** Public Methods ***

-(UIImage *)getSignatureImage {
	
	// Grab the image
	UIGraphicsBeginImageContext(self.bounds.size);
	[self drawRect: self.bounds];
	UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// Stop here if we're not supposed to crop
	if (!self.shouldCropSignatureImage) {
		return signatureImage;
	}
	
	// Crop bound floats
	// Give really high limits to min values so at least one tap
	// location will be set as the minimum...
	float minX = 99999999.0f, minY = 999999999.0f, maxX = 0.0f, maxY = 0.0f;
	
	// Loop through current coordinates to get the crop bounds
	// bx1 for (NSString *touchString in self.handwritingCoords) {
		for (NSString *touchString in myglobsigCoordinates) {
            
		// Unserialize
		CGPoint tapLocation = CGPointFromString(touchString);
		
		// Ignore CGPointZero
		if (CGPointEqualToPoint(tapLocation, CGPointZero)) {
			continue;
		}
		
		// Set boundaries
		if (tapLocation.x < minX) minX = tapLocation.x;
		if (tapLocation.x > maxX) maxX = tapLocation.x;
		if (tapLocation.y < minY) minY = tapLocation.y;
		if (tapLocation.y > maxY) maxY = tapLocation.y;
		
	}
	
	// Crop to the bounds (include a margin)
	CGRect cropRect = CGRectMake(minX - lineWidth_ - self.signatureImageMargin,
								 minY - lineWidth_ - self.signatureImageMargin,
								 maxX - minX + (lineWidth_ * 1.0f) + (self.signatureImageMargin * 1.0f),
								 maxY - minY + (lineWidth_ * 1.0f) + (self.signatureImageMargin * 1.0f));
	CGImageRef imageRef = CGImageCreateWithImageInRect([signatureImage CGImage], cropRect);
	
	// Convert back to UIImage
	UIImage *signatureImageCropped = [UIImage imageWithCGImage:imageRef];
	
	// All done!
	CFRelease(imageRef);
	return signatureImageCropped;
	
}


+(void)clearSignature {
    
    [myglobsigCoordinates removeAllObjects];
    myglobsigCoordinates = nil;
	
}


-(void)resetSignature {

[self setNeedsDisplay];

}



// - (void)drawRect:(CGRect)rect;
 
- (void)showSignature {
    
    // Get VarBinary String...
    // this is in orders entity (signature) and can be passwed as var...
    
    
        
    NSString *mySignature = [OrderDetailViewController_iPad globsig];
    
    
    if ([mySignature length] > 0)
    {

        // Change BackGround Color
        // self.backgroundColor = [UIColor lightGrayColor];
        
        // Set WaterMark Label
        
        // Decode Base64 String
        NSString *convertedString = [NSString stringWithBase64EncodedString:mySignature];
        
        // Convert to Dictionary from JSON
        NSError *error = nil;
        NSData *jsonData =[convertedString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arrContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
        NSDictionary *dotpoint;
    
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
        
        
        CGContextBeginPath(context);
    
            // Iterate JSON Objects
            for(int i=0;i<[arrContainer count];i++)
                {
                        // NSLog(@"TEST ARR1 %@", [arrContainer objectAtIndex:i]);
                        dotpoint = [arrContainer objectAtIndex:i];
        
                        BOOL isEnabled  = [[NSString stringWithFormat:@"%@",[dotpoint objectForKey:@"isStart"]] intValue];
        
                        if (isEnabled)
                            {
            
                                CGContextMoveToPoint(context, [[dotpoint objectForKey:@"x"] floatValue], [[dotpoint objectForKey:@"y"] floatValue]);
                            } else {
            
                                CGContextAddLineToPoint(context, [[dotpoint objectForKey:@"x"] floatValue], [[dotpoint objectForKey:@"y"] floatValue]);
                            }
                }
    
        CGContextClosePath(context); // close path
        CGContextSetLineWidth(context, 2.0); // this is set from now on until you explicitly change i
        CGContextStrokePath(context); // do actual stroking
    
    }
}



+ (NSMutableArray*)globsigCoordinates {
    return myglobsigCoordinates;
}

@end









