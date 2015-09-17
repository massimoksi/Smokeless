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

    @IBInspectable var completedColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var checkmarkColor: UIColor? {
        didSet {
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
            //// Path Drawing
            let pathPath = UIBezierPath(ovalInRect: CGRectMake(drawingRect.minX, drawingRect.minY, 24, 24))

            if let completedColor_ = completedColor {
                completedColor_.setFill()
            }
            else {
                tintColor.setFill()
            }
            pathPath.fill()
            
            
            //// Checkmark Drawing
            let checkmarkPath = UIBezierPath()
            checkmarkPath.moveToPoint(CGPointMake(drawingRect.minX + 20.89, drawingRect.minY + 7.05))
            checkmarkPath.addLineToPoint(CGPointMake(drawingRect.minX + 18.27, drawingRect.minY + 4.42))
            checkmarkPath.addCurveToPoint(CGPointMake(drawingRect.minX + 17.73, drawingRect.minY + 4.42), controlPoint1: CGPointMake(drawingRect.minX + 18.12, drawingRect.minY + 4.28), controlPoint2: CGPointMake(drawingRect.minX + 17.88, drawingRect.minY + 4.28))
            checkmarkPath.addLineToPoint(CGPointMake(drawingRect.minX + 8.62, drawingRect.minY + 13.53))
            checkmarkPath.addLineToPoint(CGPointMake(drawingRect.minX + 6.27, drawingRect.minY + 11.17))
            checkmarkPath.addCurveToPoint(CGPointMake(drawingRect.minX + 5.73, drawingRect.minY + 11.17), controlPoint1: CGPointMake(drawingRect.minX + 6.12, drawingRect.minY + 11.03), controlPoint2: CGPointMake(drawingRect.minX + 5.88, drawingRect.minY + 11.03))
            checkmarkPath.addLineToPoint(CGPointMake(drawingRect.minX + 3.11, drawingRect.minY + 13.8))
            checkmarkPath.addCurveToPoint(CGPointMake(drawingRect.minX + 3.11, drawingRect.minY + 14.33), controlPoint1: CGPointMake(drawingRect.minX + 2.96, drawingRect.minY + 13.94), controlPoint2: CGPointMake(drawingRect.minX + 2.96, drawingRect.minY + 14.18))
            checkmarkPath.addLineToPoint(CGPointMake(drawingRect.minX + 8.36, drawingRect.minY + 19.58))
            checkmarkPath.addCurveToPoint(CGPointMake(drawingRect.minX + 8.62, drawingRect.minY + 19.69), controlPoint1: CGPointMake(drawingRect.minX + 8.43, drawingRect.minY + 19.65), controlPoint2: CGPointMake(drawingRect.minX + 8.53, drawingRect.minY + 19.69))
            checkmarkPath.addCurveToPoint(CGPointMake(drawingRect.minX + 8.89, drawingRect.minY + 19.58), controlPoint1: CGPointMake(drawingRect.minX + 8.72, drawingRect.minY + 19.69), controlPoint2: CGPointMake(drawingRect.minX + 8.82, drawingRect.minY + 19.65))
            checkmarkPath.addLineToPoint(CGPointMake(drawingRect.minX + 20.89, drawingRect.minY + 7.58))
            checkmarkPath.addCurveToPoint(CGPointMake(drawingRect.minX + 20.89, drawingRect.minY + 7.05), controlPoint1: CGPointMake(drawingRect.minX + 21.04, drawingRect.minY + 7.43), controlPoint2: CGPointMake(drawingRect.minX + 21.04, drawingRect.minY + 7.19))
            checkmarkPath.closePath()
            checkmarkPath.miterLimit = 4
            
            checkmarkPath.usesEvenOddFillRule = true
            
            if let checkmarkColor_ = checkmarkColor {
                checkmarkColor_.setFill()
            }
            else {
                UIColor.whiteColor().setFill()
            }
            checkmarkPath.fill()
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
            CGContextDrawPath(context, CGPathDrawingMode.EOFill)
        }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        setNeedsDisplay()
    }
    
}
