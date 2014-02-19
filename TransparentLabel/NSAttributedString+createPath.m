//
//  NSAttributedString+GWBezierPath.m
//  TransparentLabel
//
//  Created by David Berry on 2/19/14.
//  Copyright (c) 2014 David W. Berry. All rights reserved.
//
//  Taken from http://stackoverflow.com/questions/9976454/cgpathref-from-string
//

#import "NSAttributedString+createPath.h"

@implementation NSAttributedString (createPath)

-(CGPathRef)createPath {
    CGMutablePathRef    letters = CGPathCreateMutable();
    
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)self);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // Get PATH of outline
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }

    CGPathRef   path = CGPathCreateCopy(letters);
    
    CFRelease(line);
    CFRelease(letters);
    
    return path;
}

@end
