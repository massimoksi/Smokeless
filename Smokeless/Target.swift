//
//  Target.swift
//  Smokeless
//
//  Created by Massimo Peri on 15/02/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import Foundation


@objc class Target : NSObject {

    var years: UInt
    var months: UInt
    var weeks: UInt
    var days: UInt
    var text: String
    
    override init() {
        self.years = 0
        self.months = 0
        self.weeks = 0
        self.days = 0
        self.text = ""
    }

}
