//
//  MPGraphics.m
//  Smokeless
//
//  Created by Massimo Peri on 28/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "MPGraphics.h"


void MPDrawLinearGradientInRect(CGContextRef context, CGRect rect, UIColor *startColor, UIColor *endColor)
{
	// retrieve color space
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create color locations
	CGFloat locations[2] = { 0.0, 1.0 };
	
    // convert colors
    CGColorRef startCGColor = MPColorCreateWithColor(startColor);
    CGColorRef endCGColor = MPColorCreateWithColor(endColor);
    
	// create colors
	NSArray *colors = [NSArray arrayWithObjects:
					   (__bridge id)startCGColor,
					   (__bridge id)endCGColor,
					   nil];
	
	// create gradient
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
														(__bridge CFArrayRef)colors,
														locations);
	
	// get gradient location
	CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
	
	// draw gradient
	CGContextSaveGState(context);
	CGContextAddRect(context, rect);
	CGContextClip(context);
	CGContextDrawLinearGradient(context,
								gradient,
								startPoint,
								endPoint,
								0);
	CGContextRestoreGState(context);
	
	// release objects
    CGColorRelease(startCGColor);
    CGColorRelease(endCGColor);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

void MPDrawPlainColorInRect(CGContextRef context, CGRect rect, UIColor *color)
{
    // convert color
    CGColorRef fillCGColor = MPColorCreateWithColor(color);
    
    // fill rect with color
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, fillCGColor);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    // release objects
    CGColorRelease(fillCGColor);
}

void MPDrawLineWithStrokeWidth(CGContextRef context, CGPoint startPoint, CGPoint endPoint, UIColor *color, CGFloat width)
{
    // convert color
    CGColorRef lineCGColor = MPColorCreateWithColor(color);
    
	// draw line
	CGContextSaveGState(context);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextSetStrokeColorWithColor(context, lineCGColor);
	CGContextSetLineWidth(context, width);
	CGContextMoveToPoint(context,
						 startPoint.x,
						 startPoint.y);
	CGContextAddLineToPoint(context,
							endPoint.x,
							endPoint.y);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
    
    // release objects
    CGColorRelease(lineCGColor);
}

CGColorRef MPColorCreateWithColor(UIColor *color)
{
    CGColorRef oldColor = color.CGColor;
    
    CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(oldColor);
    CGFloat newComponents[4];
    
    NSInteger numComponents = CGColorGetNumberOfComponents(oldColor);
    switch(numComponents) {
        // gray scale color space
        case 2:
            newComponents[0] = oldComponents[0];
            newComponents[1] = oldComponents[0];
            newComponents[2] = oldComponents[0];
            newComponents[3] = oldComponents[1];
            break;
            
        // RGB color space
        case 4:
            newComponents[0] = oldComponents[0];
            newComponents[1] = oldComponents[1];
            newComponents[2] = oldComponents[2];
            newComponents[3] = oldComponents[3];
            break;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
    CGColorSpaceRelease(colorSpace);
    
    return newColor;
}
