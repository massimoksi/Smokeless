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
        let w = CGRectGetWidth(frame)
        let h = CGRectGetHeight(frame)

        let drawingRect: CGRect
        
        if (value == 1.0) {
            if (w > h) {
                drawingRect = CGRectMake(((w - h) / 2.0), 0.0, h, h)
            }
            else if (w < h) {
                drawingRect = CGRectMake(0.0, ((h - w) / 2.0), w, w)
            }
            else {
                drawingRect = CGRectMake(0.0, 0.0, w, h)
            }
            
            // --- PaintCode
            var oval1Path = UIBezierPath()
            oval1Path.moveToPoint(CGPointMake(drawingRect.minX + 12, drawingRect.minY + 24))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 24, drawingRect.minY + 12), controlPoint1: CGPointMake(drawingRect.minX + 18.63, drawingRect.minY + 24), controlPoint2: CGPointMake(drawingRect.minX + 24, drawingRect.minY + 18.63))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 12, drawingRect.minY), controlPoint1: CGPointMake(drawingRect.minX + 24, drawingRect.minY + 5.37), controlPoint2: CGPointMake(drawingRect.minX + 18.63, drawingRect.minY))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX, drawingRect.minY + 12), controlPoint1: CGPointMake(drawingRect.minX + 5.37, drawingRect.minY), controlPoint2: CGPointMake(drawingRect.minX, drawingRect.minY + 5.37))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 12, drawingRect.minY + 24), controlPoint1: CGPointMake(drawingRect.minX, drawingRect.minY + 18.63), controlPoint2: CGPointMake(drawingRect.minX + 5.37, drawingRect.minY + 24))
            oval1Path.closePath()
            oval1Path.moveToPoint(CGPointMake(drawingRect.minX + 20.89, drawingRect.minY + 7.05))
            oval1Path.addLineToPoint(CGPointMake(drawingRect.minX + 18.27, drawingRect.minY + 4.42))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 17.73, drawingRect.minY + 4.42), controlPoint1: CGPointMake(drawingRect.minX + 18.12, drawingRect.minY + 4.28), controlPoint2: CGPointMake(drawingRect.minX + 17.88, drawingRect.minY + 4.28))
            oval1Path.addLineToPoint(CGPointMake(drawingRect.minX + 8.62, drawingRect.minY + 13.53))
            oval1Path.addLineToPoint(CGPointMake(drawingRect.minX + 6.27, drawingRect.minY + 11.17))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 5.73, drawingRect.minY + 11.17), controlPoint1: CGPointMake(drawingRect.minX + 6.12, drawingRect.minY + 11.03), controlPoint2: CGPointMake(drawingRect.minX + 5.88, drawingRect.minY + 11.03))
            oval1Path.addLineToPoint(CGPointMake(drawingRect.minX + 3.11, drawingRect.minY + 13.8))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 3.11, drawingRect.minY + 14.33), controlPoint1: CGPointMake(drawingRect.minX + 2.96, drawingRect.minY + 13.94), controlPoint2: CGPointMake(drawingRect.minX + 2.96, drawingRect.minY + 14.18))
            oval1Path.addLineToPoint(CGPointMake(drawingRect.minX + 8.36, drawingRect.minY + 19.58))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 8.62, drawingRect.minY + 19.69), controlPoint1: CGPointMake(drawingRect.minX + 8.43, drawingRect.minY + 19.65), controlPoint2: CGPointMake(drawingRect.minX + 8.53, drawingRect.minY + 19.69))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 8.89, drawingRect.minY + 19.58), controlPoint1: CGPointMake(drawingRect.minX + 8.72, drawingRect.minY + 19.69), controlPoint2: CGPointMake(drawingRect.minX + 8.82, drawingRect.minY + 19.65))
            oval1Path.addLineToPoint(CGPointMake(drawingRect.minX + 20.89, drawingRect.minY + 7.58))
            oval1Path.addCurveToPoint(CGPointMake(drawingRect.minX + 20.89, drawingRect.minY + 7.05), controlPoint1: CGPointMake(drawingRect.minX + 21.04, drawingRect.minY + 7.43), controlPoint2: CGPointMake(drawingRect.minX + 21.04, drawingRect.minY + 7.19))
            oval1Path.closePath()
            oval1Path.miterLimit = 4;
            
            oval1Path.usesEvenOddFillRule = true;
            
            tintColor.setFill()
            oval1Path.fill()
            // ---
        }
        else {
            let context = UIGraphicsGetCurrentContext()
            
            tintColor.set()
            
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

    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        setNeedsDisplay()
    }
    
}
