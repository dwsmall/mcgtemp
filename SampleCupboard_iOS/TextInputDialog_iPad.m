//
//  TextInputDialog_iPad.m
//  SampleCupboard_iOS
//
//  Created by David Small on 13-05-21.
//  Copyright (c) 2013 MCG. All rights reserved.
//

#import "TextInputDialog_iPad.h"
#import "OrderDetailViewController_iPad.h"

@implementation TextInputDialog_iPad
@synthesize textToDisplay;

#pragma mark - Init Methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textToDisplay = [[NSMutableString alloc] initWithString:@""];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    {
        if(self)
        {
            textToDisplay = [[NSMutableString alloc] initWithString:@""];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.textToDisplay drawInRect:rect withFont:[UIFont systemFontOfSize:14.0]];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    
    // self.keyboardType = UIKeyboardTypeNumberPad;
    self.keyboardType = UIKeyboardTypeDecimalPad;
    [self becomeFirstResponder];
}

#pragma mark - UIKeyInput Protocol Methods

- (BOOL)hasText
{
    return YES;
}

- (void)insertText:(NSString *)theText
{
    [self.textToDisplay appendString:theText];
    [self setNeedsDisplay];
    NSLog(@"Text Inserted %@",self.textToDisplay);
    
    UIView *v = self;
    while (v && ![v isKindOfClass:[UITableView class]]) v = v.superview;
    
    NSLog(@"show all subviews %@",v.subviews);

    
    NSLog(@"test123 %@",@"testX");
    
    
    for (UITableView *someObject in [self.superview subviews]) {
        NSLog(@"show all objects - 1 %@",someObject.subviews);
        
        // NSLog(@"show all objects - 2 %@",someObject.nextResponder);
        // no work - NSLog(@"show all objects - 3 %@",someObject.delegate);
        //  NSLog(@"show all objects - 4 %@",someObject.description);
        // NSLog(@"show all objects - 5 %@",someObject.indexPathForSelectedRow);
         // NSLog(@"show all objects - 6 %@",someObject.indexPathsForVisibleRows);
       // NSLog(@"show all objects - 7  %@",someObject.visibleCells);
        
       
    }
    
    // NSIndexPath *selectedIndexPath = [(UITableView *)OrderDetailViewController_iPad indexPathForSelectedRow];
    
    //NSIndexPath *indexPath = [(UITableView *)self.superview indexPathForCell: self];
    
    
    
}

- (void)deleteBackward
{
    NSRange rangeToDelete = NSMakeRange(self.textToDisplay.length-1, 1);
    [self.textToDisplay deleteCharactersInRange:rangeToDelete];
    [self setNeedsDisplay];
}



@end

