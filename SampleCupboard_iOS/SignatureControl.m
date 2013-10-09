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

/**
 * Main drawing method. We keep an array of touch coordinates to represent
 * the user dragging their finter across the screen. This method loops through
 * those coordinates and draws a line to each. When the user lifts their finger,
 * we insert a CGPointZero object into the array and handle that here.
 * @author Jesse Bunch
 **/



- (void)view:(UIView *)view didBeginDragging:(UIEvent *)event {
    
    NSLog(@"dw1 - drag baby 1");
    
    /*
     [self setHighlighted:NO animated:NO];
     [self setSelectionStyle:UITableViewCellSelectionStyleNone];
     */
}


- (void)vView:(UIView *)view didFinishDragging:(UIEvent *)event {
    
    NSLog(@"dw1 - drag baby 2");
    
    // [self setSelectionStyle:UITableViewCellSelectionStyleGray];
}




- (void)drawRect:(CGRect)rect {
    
    
    // initilization
    
    // if (handWRITING == nil) {
    if (myglobsigCoordinates == nil) {
    
        NSLog(@"dw1 - cheap method but works");
        handWRITING = [[NSMutableArray alloc] init];
        self.handwritingCoords = [[NSMutableArray alloc] init];
		self.lineWidth = 3.0f;
		self.signatureImageMargin = 3.0f;
		self.shouldCropSignatureImage = YES;
		self.foreColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
		lastTapPoint_ = CGPointZero;
        
        myglobsigCoordinates = [[NSMutableArray alloc] init];
        
        // OrderDetailViewController_iPad *details = [[OrderDetailViewController_iPad alloc] init];
        
        // UIView *hview = details.viewContainer;
        
        // UITableView *tview = details.ordTableView;
  
        
        NSLog(@"dw1 - draw rect called A");
        
        
        /*
        tview.scrollEnabled = NO;
        tview.bounces = NO;
        
        [tview setScrollEnabled:NO];
        
        // [hview setContentOffset: offsetof(3, 0) animated: YES]
        [tview setContentOffset:tview.contentOffset animated:NO];
        NSLog(@"dw1 - sig was here!!");
        
        CGRect contentRect = tview.bounds;
        [tview scrollRectToVisible:contentRect animated:NO];
        
        NSLog(@"dw1 - show offset %f, %f", tview.contentOffset.x, tview.contentOffset.y);
        
        [tview setContentOffset:CGPointMake(tview.contentOffset.x, tview.contentOffset.y) animated:NO];
        
        */
        
        // details.viewContainer.subviews;
        
        
        /* freeze screen
         
        OrderDetailViewController_iPad *details = [[OrderDetailViewController_iPad alloc] init];
        details.viewContainer.subviews
        UIView *tab1 = [super viewWithTag:877];
        
        
        // tab1.scrollEnabled = NO;
        */
        
        
        
    }
    
    
    
    
    NSString *mySignature = [OrderDetailViewController_iPad globsig];

    
    if ([mySignature length] > 0)
    {
        
            // SHOW SIGNATURE
        
            [self showSignature];
    
        
    } else {
    
                    NSLog(@"dw1 - draw rect called B");
        
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
                    // NSLog(@"dw1 - %f, %f", tapLocation.x, tapLocation.y);
                    
                    // bx1 NSLog(@"dw1 - handwritingCoords_: %@", handwritingCoords_);
                    
                    
                    // BX1 NSLog(@"dw1 - handwritingCoords_: %@", myglobsigCoordinates);
                }
                
            }
            
            // Stroke it, baby!
            CGContextStrokePath(context);
        
    } // end of if
    
}




#pragma mark - *** Touch Handling ***

/**
 * Not implemented.
 * @author Jesse Bunch
 **/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"dw1 - prevent drag1");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SteadySignature" object:nil];

}

    

/**
 * This method adds the touch to our array.
 * @author Jesse Bunch
 **/
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
	[self processPoint:touchLocation];

	NSLog(@"dw1 - prevent drag2");

}


/**
 * Add a CGPointZero to our array to denote the user's finger has been
 * lifted.
 * @author Jesse Bunch
 **/
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// bx1 [self.handwritingCoords addObject:NSStringFromCGPoint(CGPointZero)];
    
    [myglobsigCoordinates addObject:NSStringFromCGPoint(CGPointZero)];
    
    NSLog(@"dw1 - prevent drag3");

}




/**
 * Touches Cancelled.
 * @author Jesse Bunch
 **/
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	// bx1 [self.handwritingCoords addObject:NSStringFromCGPoint(CGPointZero)];
    
    [myglobsigCoordinates addObject:NSStringFromCGPoint(CGPointZero)];
    
    // NSLog(@"dw1 - show valueD:%f", CGPointZero.x);
    // NSLog(@"dw1 - show valueD:%f", CGPointZero.y);
    
    NSLog(@"dw1 - prevent drag4	");

}


#pragma mark - *** Private Methods ***

/**
 * Processes the point received from touch events
 * @author Jesse Bunch
 **/
-(void)processPoint:(CGPoint)touchLocation {
	
    // NSLog(@"dw1 - point #3a: %@" , NSStringFromCGPoint(touchLocation));
    
	// Only keep the point if it's > 5 points from the last
	if (CGPointEqualToPoint(CGPointZero, lastTapPoint_) ||
		fabs(touchLocation.x - lastTapPoint_.x) > 2.0f ||
		fabs(touchLocation.y - lastTapPoint_.y) > 2.0f) {
		
		// bx1 [self.handwritingCoords addObject:NSStringFromCGPoint(touchLocation)];
        [myglobsigCoordinates addObject:NSStringFromCGPoint(touchLocation)];
        
		[self setNeedsDisplay];
		lastTapPoint_ = touchLocation;
		
        // NSLog(@"dw1 - point #3b: %@" , NSStringFromCGPoint(touchLocation));
	}
	
}


#pragma mark - *** Public Methods ***

/**
 * Returns a UIImage with the signature cropped and centered with the margin
 * specified in the signatureImageMargin property.
 * @author Jesse Bunch
 **/
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
    


    
    
    // NO [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
    // NO [self performSelectorOnMainThread:@selector(resetSignature) withObject:nil waitUntilDone:NO];
    
    // [SignatureControl setNeedsDisplay];
    
    // NO [self resetSignature];
    
    
    // [[self view] setNeedsDisplay];
    
    // [[self view] setNeedsDisplay:YES];
    
    // crash [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:self waitUntilDone:TRUE];
    
    
   // NSLog(@"dw1 - signature cleared");
    
	
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
        NSLog(@"dw1 - show my signature: %@", mySignature);
        
        NSString *convertedString = [NSString stringWithBase64EncodedString:mySignature];
        

        
        NSLog(@"dw1 - ConvertedString:%@", convertedString);
        
        
        // Convert to Dictionary from JSON
        NSError *error = nil;
        NSData *jsonData =[convertedString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arrContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
        NSDictionary *dotpoint;
    
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
        
        
        NSLog(@"dw1 - show array container:%@" , arrContainer);
        
        
        
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









