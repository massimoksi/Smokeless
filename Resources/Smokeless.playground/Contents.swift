//: Playground - noun: a place where people can play

import UIKit

let barWidth: CGFloat = 10.0
let context = UIGraphicsGetCurrentContext()
let drawingRect = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
let percentage: CGFloat = 0.33
let fullAngle = CGFloat(2 * M_PI)
let startAngle = -0.25 * fullAngle
let endAngle = CGFloat(percentage) * fullAngle + startAngle
let centerPoint = CGPoint(x: drawingRect.midX, y: drawingRect.midY)
let radius = (drawingRect.width - barWidth) / 2

CGContextSetLineWidth(context, barWidth)
CGContextSetLineCap(context, kCGLineCapRound)
CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, fullAngle, 0)
CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
CGContextStrokePath(context)
