//
//  ProgressView.swift
//  Smokeless
//
//  Created by Massimo Peri on 20/06/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit


@IBDesignable
class ProgressView: UIView {

    var value: Double = 0.0 {
        didSet {
            if (value < 0.0) {
                value = 0.0;
            }
            else if (value > 1.0) {
                value = 1.0;
            }
            
            setNeedsDisplay()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            let radius = min(CGRectGetWidth(frame), CGRectGetHeight(frame)) - 1.0
            if (borderWidth < 1.0) {
                borderWidth = 1.0
            }
            else if (borderWidth > radius) {
                borderWidth = radius
            }
            
            setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        tintColor.set()

        let w = CGRectGetWidth(frame)
        let h = CGRectGetHeight(frame)

        let drawingRect: CGRect
        if (w > h) {
            drawingRect = CGRectMake(
                ((w - h) / 2.0) + borderWidth / 2.0,
                borderWidth / 2.0,
                h - borderWidth,
                h - borderWidth
            )
        }
        else if (w < h) {
            drawingRect = CGRectMake(
                borderWidth / 2.0,
                ((h - w) / 2.0) + borderWidth / 2.0,
                w - borderWidth,
                w - borderWidth
            )
        }
        else {
            drawingRect = CGRectMake(
                borderWidth / 2.0,
                borderWidth / 2.0,
                w - borderWidth,
                h - borderWidth);
        }
        
        CGContextSetLineWidth(context, borderWidth)
        CGContextStrokeEllipseInRect(context, drawingRect)
        
        if (value > 0.0) {
            let center = CGPoint(x: CGRectGetMidX(drawingRect), y: CGRectGetMidY(drawingRect))
            let radius: CGFloat = drawingRect.size.width / 2.0
            let angle: CGFloat = CGFloat((M_PI * 2.0 * value) - M_PI_2)
            
            let points: [CGPoint] = [
                CGPoint(x: center.x, y: CGRectGetMidY(drawingRect)),
                center,
                CGPoint(x: center.x + radius * CGFloat(cos(angle)), y: center.y + radius * CGFloat(sin(angle)))
            ]
            
            CGContextAddLines(context, points, 3)
            CGContextAddArc(context, center.x, center.y, radius, CGFloat(-M_PI_2), angle, 1)
            CGContextDrawPath(context, kCGPathEOFill)
        }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        setNeedsDisplay()
    }
    
}
