//
//  TransparentLabel.m
//  TransparentLabel
//
//  Created by David W. Berry on 2/19/14.
//  Copyright (c) 2014 David W. Berry. All rights reserved.
//

#import "TransparentLabel.h"
#import "NSAttributedString+createPath.h"

@implementation TransparentLabel

-(void)drawRect:(CGRect)rect {
    CGContextRef        ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    // Convert the attributed text to a UIBezierPath
    CGPathRef           path = [self.attributedText createPath];
    
    // Adjust the path bounds horizontally as requested by the view
    CGRect              bounds = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    CGAffineTransform   xform = CGAffineTransformMakeTranslation(bounds.origin.x, bounds.origin.y);
    
    // Adjust the path bounds vertically because it doesn't seem to be taken into account yet
    bounds = CGPathGetBoundingBox(path);
    xform = CGAffineTransformTranslate(xform, 0., (self.bounds.size.height - bounds.size.height) / 2.);
    
    // Apply the transform to the path
    path = CGPathCreateCopyByTransformingPath(path, &xform);
                                              
    // Set colors, the fill color should be the background color because we're going
    //  to draw everything BUT the text, the text will be left clear.
    CGContextSetFillColorWithColor(ctx, self.textColor.CGColor);
    
    // Flip and offset things
    CGContextScaleCTM(ctx, 1., -1.);
    CGContextTranslateCTM(ctx, 0., 0. - self.bounds.size.height);
    
    // Invert the path
    CGContextAddRect(ctx, self.bounds);
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    // Discard the path
    CFRelease(path);
    
    // Restore gstate
    CGContextRestoreGState(ctx);
}

@end
