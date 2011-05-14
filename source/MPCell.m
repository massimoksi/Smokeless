//
//  MPCell.m
//  Smokeless
//
//  Created by Massimo Peri on 20/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "MPCell.h"


@implementation MPCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.borderWidth = 1.0;
        self.cornerRadius = 10.0;
        
        self.borderColor = [UIColor darkGrayColor];
        self.fillColor = [UIColor whiteColor];
        self.startColor = [UIColor whiteColor];
        self.endColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)dealloc
{
    self.borderColor = nil;
    self.fillColor = nil;
    self.startColor = nil;
    self.endColor = nil;
    
    [super dealloc];
}

#pragma Accessors

@synthesize style;
@synthesize position;
@synthesize borderWidth;
@synthesize cornerRadius;
@synthesize borderColor;
@synthesize fillColor;
@synthesize startColor;
@synthesize endColor;

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    CGRect cellRect;
    CGFloat maxX, midX, minX, maxY, midY, minY;
    
    // get graphic context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set border width
    CGContextSetLineWidth(context, self.borderWidth);
    
    // create paths
    CGMutablePathRef cellBorder = CGPathCreateMutable();
    
    // draw path according to position
    switch (self.position) {
        case MPCellPositionSingle:
            // get cell coordinates
            cellRect = CGRectMake(self.bounds.origin.x + self.borderWidth/2,
                                  self.bounds.origin.y + self.borderWidth/2,
                                  self.bounds.size.width - self.borderWidth,
                                  self.bounds.size.height - self.borderWidth);
            maxX = CGRectGetMaxX(cellRect);
            midX = CGRectGetMidX(cellRect);
            minX = CGRectGetMinX(cellRect);
            maxY = CGRectGetMaxY(cellRect);
            midY = CGRectGetMidY(cellRect);
            minY = CGRectGetMinY(cellRect);
            
            // create border path
			CGPathMoveToPoint(cellBorder, NULL, minX, midY);
			CGPathAddArcToPoint(cellBorder, NULL, minX, minY, midX, minY, self.cornerRadius);
			CGPathAddArcToPoint(cellBorder, NULL, maxX, minY, maxX, midY, self.cornerRadius);
			CGPathAddArcToPoint(cellBorder, NULL, maxX, maxY, midX, maxY, self.cornerRadius);
			CGPathAddArcToPoint(cellBorder, NULL, minX, maxY, minX, midY, self.cornerRadius);
			CGPathCloseSubpath(cellBorder);
            
            break;
            
        case MPCellPositionTop:
            // get cell coordinates
            cellRect = CGRectMake(self.bounds.origin.x + self.borderWidth/2,
                                  self.bounds.origin.y + self.borderWidth/2,
                                  self.bounds.size.width - self.borderWidth,
                                  self.bounds.size.height - self.borderWidth);
            maxX = CGRectGetMaxX(cellRect);
            midX = CGRectGetMidX(cellRect);
            minX = CGRectGetMinX(cellRect);
            maxY = CGRectGetMaxY(cellRect);
            minY = CGRectGetMinY(cellRect);

            CGPathMoveToPoint(cellBorder, NULL, minX, maxY);
			CGPathAddArcToPoint(cellBorder, NULL, minX, minY, midX, minY, self.cornerRadius);
			CGPathAddArcToPoint(cellBorder, NULL, maxX, minY, maxX, maxY, self.cornerRadius);
			CGPathAddLineToPoint(cellBorder, NULL, maxX, maxY);
			CGPathAddLineToPoint(cellBorder, NULL, minX, maxY);
			CGPathCloseSubpath(cellBorder);

            break;
            
        case MPCellPositionMiddle:
            // get cell coordinates
            cellRect = CGRectMake(self.bounds.origin.x + self.borderWidth/2,
                                  self.bounds.origin.y - self.borderWidth/2,
                                  self.bounds.size.width - self.borderWidth,
                                  self.bounds.size.height);
            maxX = CGRectGetMaxX(cellRect);
            minX = CGRectGetMinX(cellRect);
            maxY = CGRectGetMaxY(cellRect);
            minY = CGRectGetMinY(cellRect);
            
			CGPathMoveToPoint(cellBorder, NULL, minX, minY);
			CGPathAddLineToPoint(cellBorder, NULL, maxX, minY);
			CGPathAddLineToPoint(cellBorder, NULL, maxX, maxY);
			CGPathAddLineToPoint(cellBorder, NULL, minX, maxY);
			CGPathAddLineToPoint(cellBorder, NULL, minX, minY);
			CGPathCloseSubpath(cellBorder);

            break;
            
        case MPCellPositionBottom:
            // get cell coordinates
            cellRect = CGRectMake(self.bounds.origin.x + self.borderWidth/2,
                                  self.bounds.origin.y - self.borderWidth/2,
                                  self.bounds.size.width - self.borderWidth,
                                  self.bounds.size.height);
            maxX = CGRectGetMaxX(cellRect);
            midX = CGRectGetMidX(cellRect);
            minX = CGRectGetMinX(cellRect);
            maxY = CGRectGetMaxY(cellRect);
            minY = CGRectGetMinY(cellRect);

            CGPathMoveToPoint(cellBorder, NULL, minX, minY);
			CGPathAddArcToPoint(cellBorder, NULL, minX, maxY, midX, maxY, self.cornerRadius);
			CGPathAddArcToPoint(cellBorder, NULL, maxX, maxY, maxX, minY, self.cornerRadius);
			CGPathAddLineToPoint(cellBorder, NULL, maxX, minY);
			CGPathAddLineToPoint(cellBorder, NULL, minX, minY);
			CGPathCloseSubpath(cellBorder);

            break;
    }
    
    // fill cell
    switch (self.style) {
        default:
        case MPCellStyleEmpty:
            break;
            
        case MPCellStyleColorFill:
            // fill cell
            CGContextSaveGState(context);
            CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
            CGContextAddPath(context, cellBorder);
            CGContextFillPath(context);
            CGContextRestoreGState(context);
            break;
            
        case MPCellStyleGradient:
        {
            // retrieve color space
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            
            // create color locations
            CGFloat locations[2] = { 0.0, 1.0 };
            
            // create colors
            CGColorRef startCGColor = MPColorCreateWithColor(self.startColor);
            CGColorRef endCGColor = MPColorCreateWithColor(self.endColor);
            NSArray *colors = [NSArray arrayWithObjects:
                               (id)startCGColor,
                               (id)endCGColor,
                               nil];
            
            // create gradient
            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                                (CFArrayRef)colors,
                                                                locations);
            
            // draw gradient
            CGContextSaveGState(context);
            CGContextAddPath(context, cellBorder);
            CGContextClip(context);
            CGContextDrawLinearGradient(context,
                                        gradient,
                                        (CGPoint){ midX, minY },
                                        (CGPoint){ midX, maxY },
                                        0);
            CGContextRestoreGState(context);
            
            // release objects
            CGColorRelease(startCGColor);
            CGColorRelease(endCGColor);
            CGGradientRelease(gradient);
            CGColorSpaceRelease(colorSpace);
            
            break;
        }
    }
    
    // stroke cell
    CGContextSaveGState(context);    
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextAddPath(context, cellBorder);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
        
    // release objects
    CGPathRelease(cellBorder);
}

@end
