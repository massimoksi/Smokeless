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
            if (value == 1.0) {
                var oval1Path = UIBezierPath()
                oval1Path.moveToPoint(CGPointMake(12, 24))
                oval1Path.addCurveToPoint(CGPointMake(24, 12), controlPoint1: CGPointMake(18.63, 24), controlPoint2: CGPointMake(24, 18.63))
                oval1Path.addCurveToPoint(CGPointMake(12, 0), controlPoint1: CGPointMake(24, 5.37), controlPoint2: CGPointMake(18.63, 0))
                oval1Path.addCurveToPoint(CGPointMake(0, 12), controlPoint1: CGPointMake(5.37, 0), controlPoint2: CGPointMake(0, 5.37))
                oval1Path.addCurveToPoint(CGPointMake(12, 24), controlPoint1: CGPointMake(0, 18.63), controlPoint2: CGPointMake(5.37, 24))
                oval1Path.closePath()
                oval1Path.moveToPoint(CGPointMake(20.89, 7.05))
                oval1Path.addLineToPoint(CGPointMake(18.27, 4.42))
                oval1Path.addCurveToPoint(CGPointMake(17.73, 4.42), controlPoint1: CGPointMake(18.12, 4.28), controlPoint2: CGPointMake(17.88, 4.28))
                oval1Path.addLineToPoint(CGPointMake(8.62, 13.53))
                oval1Path.addLineToPoint(CGPointMake(6.27, 11.17))
                oval1Path.addCurveToPoint(CGPointMake(5.73, 11.17), controlPoint1: CGPointMake(6.12, 11.03), controlPoint2: CGPointMake(5.88, 11.03))
                oval1Path.addLineToPoint(CGPointMake(3.11, 13.8))
                oval1Path.addCurveToPoint(CGPointMake(3.11, 14.33), controlPoint1: CGPointMake(2.96, 13.94), controlPoint2: CGPointMake(2.96, 14.18))
                oval1Path.addLineToPoint(CGPointMake(8.36, 19.58))
                oval1Path.addCurveToPoint(CGPointMake(8.62, 19.69), controlPoint1: CGPointMake(8.43, 19.65), controlPoint2: CGPointMake(8.53, 19.69))
                oval1Path.addCurveToPoint(CGPointMake(8.89, 19.58), controlPoint1: CGPointMake(8.72, 19.69), controlPoint2: CGPointMake(8.82, 19.65))
                oval1Path.addLineToPoint(CGPointMake(20.89, 7.58))
                oval1Path.addCurveToPoint(CGPointMake(20.89, 7.05), controlPoint1: CGPointMake(21.04, 7.43), controlPoint2: CGPointMake(21.04, 7.19))
                oval1Path.closePath()
                oval1Path.miterLimit = 4;
                
                oval1Path.usesEvenOddFillRule = true;
                
                tintColor.setFill()
                oval1Path.fill()
            }
            else {
                let center = CGPoint(x: CGRectGetMidX(drawingRect), y: CGRectGetMidY(drawingRect))
                let radius: CGFloat = drawingRect.size.width / 2.0
                let angle: CGFloat = CGFloat((M_PI * 2.0 * value) - M_PI_2)
                
                let points = [
                    CGPoint(x: center.x, y: CGRectGetMinY(drawingRect)),
                    center,
                    CGPoint(x: center.x + radius * CGFloat(cos(angle)), y: center.y + radius * CGFloat(sin(angle)))
                ]
                
                CGContextAddLines(context, points, 3)
                CGContextAddArc(context, center.x, center.y, radius, CGFloat(-M_PI_2), angle, 0)
                CGContextDrawPath(context, kCGPathEOFill)
            }
        }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        setNeedsDisplay()
    }
    
}
