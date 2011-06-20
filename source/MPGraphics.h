//
//  MPGraphics.h
//  Smokeless
//
//  Created by Massimo Peri on 28/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


void MPDrawLinearGradientInRect(CGContextRef context, CGRect rect, UIColor *startColor, UIColor *endColor);
void MPDrawPlainColorInRect(CGContextRef context, CGRect rect, UIColor *color);
void MPDrawLineWithStrokeWidth(CGContextRef context, CGPoint startPoint, CGPoint endPoint, UIColor *color, CGFloat width);

CGColorRef MPColorCreateWithColor(UIColor *color);
