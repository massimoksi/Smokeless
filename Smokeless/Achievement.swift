//
//  Achievement.swift
//  Smokeless
//
//  Created by Massimo Peri on 15/02/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import Foundation


@objc class Achievement {

    enum State {
        case Pending, Next, Completed
    }
    
    var years: Int = 0
    var months: Int = 0
    var weeks: Int = 0
    var days: Int = 0
    var hours: Int = 0
    var minutes: Int = 0

    var text: String = ""
    
    var state = State.Pending
    
    var isCompleted: Bool {
        return (state == .Completed)
    }
    
    func completionDateFromDate(date: NSDate) -> NSDate? {
        let dateComps = NSDateComponents()
        dateComps.year = years
        dateComps.month = months
        dateComps.weekOfMonth = weeks
        dateComps.day = days
        dateComps.hour = hours
        dateComps.minute = minutes
        
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let completionDate = gregorianCalendar?.dateByAddingComponents(dateComps, toDate: date, options: NSCalendarOptions(0))
        
        return completionDate
    }
    
    func completionPercentageFromDate(date: NSDate?) -> Double {
        var percentage: Double = 0.0
        
        if (date != nil) {
            let completionDate = completionDateFromDate(date!)
            if let completionDate_ = completionDate {
                let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
                
                if let gregorianCalendar_ = gregorianCalendar {
                    let totalDays = gregorianCalendar_.components(NSCalendarUnit.CalendarUnitDay, fromDate: date!, toDate: completionDate_, options: NSCalendarOptions(0)).day
                    let elapsedDays = gregorianCalendar_.components(NSCalendarUnit.CalendarUnitDay, fromDate: date!, toDate: NSDate(), options: NSCalendarOptions(0)).day
                    
                    if (elapsedDays >= totalDays) {
                        percentage = 1.0
                    }
                    else {
                        percentage = Double(elapsedDays) / Double(totalDays)
                    }
                }
            }
        }
        
        return percentage
    }

}
