//
//  MPDisclosureIndicator.m
//  Smokeless
//
//  Created by Massimo Peri on 23/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "MPDisclosureIndicator.h"


#define FRAME_WIDTH     15.0
#define FRAME_HEIGHT    15.0
#define ARROW_SIZE      4.5


@implementation MPDisclosureIndicator

@synthesize orientation = _orientation;
@synthesize highlighted = _highlighted;
@synthesize normalColor = _normalColor;
@synthesize highlightedColor = _highlightedColor;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0,
                                           0.0,
                                           FRAME_WIDTH,
                                           FRAME_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.orientation = MPDisclosureIndicatorOrientationRight;
        
        self.normalColor = [UIColor darkGrayColor];
        self.highlightedColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark Accessors

- (void)setHighlighted:(BOOL)h
{
    if (_highlighted != h) {
        _highlighted = h;
        
        [self setNeedsDisplay];
    }
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    CGPoint tip;
    
    // get graphic context
    CGContextRef context = UIGraphicsGetCurrentContext();

    // draw arrow
    switch (self.orientation) {
        case MPDisclosureIndicatorOrientationRight:
            tip.x = CGRectGetMaxX(self.bounds) - 4.0;
            tip.y = CGRectGetMidY(self.bounds);
            
            CGContextMoveToPoint(context,
                                 tip.x - ARROW_SIZE,
                                 tip.y - ARROW_SIZE);
            CGContextAddLineToPoint(context,
                                    tip.x,
                                    tip.y);
            CGContextAddLineToPoint(context,
                                    tip.x - ARROW_SIZE,
                                    tip.y + ARROW_SIZE);
            break;

        case MPDisclosureIndicatorOrientationLeft:
        case MPDisclosureIndicatorOrientationUp:
        case MPDisclosureIndicatorOrientationDown:
            break;
    }

    // configure line
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    CGContextSetLineWidth(context, 3);
    
    if (_highlighted == YES) {
        CGContextSetStrokeColorWithColor(context, self.highlightedColor.CGColor);
    }
    else {
        CGContextSetStrokeColorWithColor(context, self.normalColor.CGColor);
    }
    
    CGContextStrokePath(context);
}

@end
