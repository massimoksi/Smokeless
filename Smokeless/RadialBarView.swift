//
//  RadialBarView.swift
//  Smokeless
//
//  Created by Massimo Peri on 27/07/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit


@IBDesignable
class RadialBarView: UIView {

    @IBInspectable var value: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var minValue: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var maxValue: Int = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var barWidth: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var barBackgroundColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var barColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        let percentage = CGFloat(value) / CGFloat(maxValue - minValue) + CGFloat(minValue);
        
        // Calculate drawing angles.
        let fullAngle = CGFloat(2 * M_PI)
        let startAngle = -0.25 * fullAngle
        let endAngle = CGFloat(percentage) * fullAngle + startAngle
        
        // Calculate drawing references.
        let drawingRect = squaredRect()
        let centerPoint = CGPoint(x: drawingRect.midX, y: drawingRect.midY)
        let radius = (drawingRect.width - barWidth) / 2
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, barWidth)
        CGContextSetLineCap(context, kCGLineCapRound)
        
        // Draw the background bar.
        if let barBackgroundColor = barBackgroundColor {
            CGContextSetStrokeColorWithColor(context, barBackgroundColor.CGColor)
        }
        else {
            CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        }
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, fullAngle, 0)
        CGContextStrokePath(context)
        
        // Draw the percentage bar.
        if let barColor = barColor {
            CGContextSetStrokeColorWithColor(context, barColor.CGColor)
        }
        else {
            CGContextSetStrokeColorWithColor(context, tintColor.CGColor)
        }
//        CGContextSetLineWidth(context, 0.8 * barWidth)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, 0)
        CGContextStrokePath(context)
    }

    // MARK: - Private methods
    
    private func squaredRect() -> CGRect {
        let w = frame.width
        let h = frame.height
        
        if (w >= h) {
            return CGRect(x: (w - h) / 2, y: 0.0, width: h, height: h)
        }
        else {
            return CGRect(x: 0.0, y: (h - w) / 2, width: w, height: w)
        }
    }
    
}
