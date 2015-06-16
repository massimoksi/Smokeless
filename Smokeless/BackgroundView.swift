//
//  BackgroundView.swift
//  Smokeless
//
//  Created by Massimo Peri on 16/06/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit


@IBDesignable
class BackgroundView: UIView {

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let colors = [
            UIColor.sml_backgroundLightColor().CGColor,
            UIColor.sml_backgroundDarkColor().CGColor
        ]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, nil)
        
        let size = bounds.size
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        CGContextDrawRadialGradient(context, gradient, center, 0.0, center, max(size.width, size.height), CGGradientDrawingOptions(kCGGradientDrawsAfterEndLocation))
    }

}
