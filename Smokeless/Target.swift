//
//  Achievement.swift
//  Smokeless
//
//  Created by Massimo Peri on 15/02/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import Foundation


@objc class Achievement : NSObject {

    var years:  Int    = 0
    var months: Int    = 0
    var weeks:  Int    = 0
    var days:   Int    = 0
    var text:   String  = ""
    
    func completionDateFromDate(date: NSDate) -> NSDate? {
        let dateComps = NSDateComponents()
        dateComps.year = years
        dateComps.month = months
        dateComps.weekOfMonth = weeks
        dateComps.day = days
        
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let completionDate = gregorianCalendar?.dateByAddingComponents(dateComps, toDate: date, options: NSCalendarOptions(0))
        
        return completionDate
    }

}
