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

    private class RadialBarLayer: CALayer {
        @NSManaged var progress: CGFloat

        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init!() {
            super.init()
        }
        
        override init!(layer: AnyObject!) {
            super.init(layer: layer)
        }
        
        override class func needsDisplayForKey(key: String!) -> Bool {
            // A change in the custom "progress" property should automatically trigger a redraw of the layer.
            if (key == "progress") {
                return true
            }

            return super.needsDisplayForKey(key)
        }

        override func actionForKey(event: String!) -> CAAction! {
            if (event == "progress") {
                let anim = CABasicAnimation(keyPath: event)
                anim.fromValue = presentationLayer().valueForKey(event)
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                anim.duration = CFTimeInterval(1.0)

                return anim
            }

            return super.actionForKey(event)
        }
    }

    // MARK: -

    @IBInspectable var value: UInt = 0 {
        didSet {
            radialBarLayer.progress = progress()

            setNeedsDisplay()
        }
    }

    @IBInspectable var maxValue: UInt = 10 {
        didSet {
            radialBarLayer.progress = progress()

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

    private var radialBarLayer: RadialBarLayer {
        return layer as! RadialBarLayer
    }

    override class func layerClass() -> AnyClass {
        return RadialBarLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        customInit()
    }

    override func drawRect(rect: CGRect) {
        // http://stackoverflow.com/questions/1208265/calayer-delegate-method-drawlayer-not-getting-called
        // UIView uses the existence of -drawRect: to determine if it should allow its CALayer to be invalidated,
        // which would then lead to the layer creating a backing store and -drawLayer:inContext: being called.
        // By implementing an empty -drawRect: method, we allow UIKit to continue to implement this logic,
        // while doing our real drawing work inside of -drawLayer:inContext:.
    }

    // MARK: - Layer delegate

    override func drawLayer(layer: CALayer!, inContext context: CGContext!) {
        let layer = layer as! RadialBarLayer
        let progress = layer.progress
        
        // Calculate drawing angles.
        let fullAngle = CGFloat(2 * M_PI)
        let startAngle = -0.25 * fullAngle
        let endAngle = progress * fullAngle + startAngle
        
        // Calculate drawing references.
        let drawingRect = squaredRect()
        let centerPoint = CGPoint(x: drawingRect.midX, y: drawingRect.midY)
        let radius = (drawingRect.width - barWidth) / 2
        
        // ---------------------------
        // Background bar
        // ---------------------------
        
        // Set stroke color.
        if let barBackgroundColor = barBackgroundColor {
            CGContextSetStrokeColorWithColor(context, barBackgroundColor.CGColor)
        }
        else {
            CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        }
        
        // Stroke path.
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, fullAngle, 0)
        CGContextSetLineWidth(context, barWidth)
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextStrokePath(context)
        
        // ---------------------------
        // Foreground bar
        // ---------------------------
        
        // Calculate radii.
        let radiusExt = drawingRect.width / 2
        let radiusInt = radiusExt - barWidth
        let radiusCap = barWidth / 2
        
        // Calculate centers.
        let centerCapBgn = CGPoint(x: drawingRect.midX, y: barWidth / 2)
        let centerCapEnd = CGPoint(x: centerPoint.x + radius * cos(endAngle), y: centerPoint.y + radius * sin(endAngle))
        
        // TODO: fill bar with gradient.
        // TODO: add shadow to the end cap.
        
        // Set fill color.
        if let barColor = barColor {
            CGContextSetFillColorWithColor(context, barColor.CGColor)
        }
        else {
            CGContextSetFillColorWithColor(context, tintColor.CGColor)
        }
        
        // Draw path.
        CGContextAddArc(context, centerCapBgn.x, centerCapBgn.y, radiusCap, CGFloat(M_PI_2), -CGFloat(M_PI_2), 0)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radiusExt, startAngle, endAngle, 0)
        CGContextAddArc(context, centerCapEnd.x, centerCapEnd.y, radiusCap, endAngle, endAngle + CGFloat(M_PI), 0)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radiusInt, endAngle, startAngle, 1)
        CGContextFillPath(context)
    }

    // MARK: - Private methods

    private func customInit() {
        // By setting opaque to false it defines our backing store to include an alpha channel.
        layer.opaque = false
    }

    private func progress() -> CGFloat {
        return CGFloat(value) / CGFloat(maxValue)
    }

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
