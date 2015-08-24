//
//  AchievementsManager.swift
//  Smokeless
//
//  Created by Massimo Peri on 06/07/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import Foundation


@objc class AchievementsManager {
   
    static let sharedManager = AchievementsManager()
    
    var achievements: [Achievement]
    
    private init() {
        let step1 = Achievement()
        step1.minutes = 20
        step1.text = NSLocalizedString("ACHIEVEMENT_01_MESSAGE", comment: "")
        
        let step2 = Achievement()
        step2.hours = 8
        step2.text = NSLocalizedString("ACHIEVEMENT_02_MESSAGE", comment: "")

        let step3 = Achievement()
        step3.days = 1
        step3.text = NSLocalizedString("ACHIEVEMENT_03_MESSAGE", comment: "")

        let step4 = Achievement()
        step4.days = 2
        step4.text = NSLocalizedString("ACHIEVEMENT_04_MESSAGE", comment: "")

        let step5 = Achievement()
        step5.days = 3
        step5.text = NSLocalizedString("ACHIEVEMENT_05_MESSAGE", comment: "")

        let step6 = Achievement()
        step6.weeks = 2
        step6.text = NSLocalizedString("ACHIEVEMENT_06_MESSAGE", comment: "")

        let step7 = Achievement()
        step7.months = 1
        step7.text = NSLocalizedString("ACHIEVEMENT_07_MESSAGE", comment: "")

        let step8 = Achievement()
        step8.months = 3
        step8.text = NSLocalizedString("ACHIEVEMENT_08_MESSAGE", comment: "")

        let step9 = Achievement()
        step9.months = 9
        step9.text = NSLocalizedString("ACHIEVEMENT_09_MESSAGE", comment: "")

        let step10 = Achievement()
        step10.years = 1
        step10.text = NSLocalizedString("ACHIEVEMENT_10_MESSAGE", comment: "")

        let step11 = Achievement()
        step11.years = 5
        step11.text = NSLocalizedString("ACHIEVEMENT_11_MESSAGE", comment: "")

        let step12 = Achievement()
        step12.years = 10
        step12.text = NSLocalizedString("ACHIEVEMENT_12_MESSAGE", comment: "")

        let step13 = Achievement()
        step13.years = 15
        step13.text = NSLocalizedString("ACHIEVEMENT_13_MESSAGE", comment: "")
        
        let step14 = Achievement()
        step14.years = 20
        step14.text = NSLocalizedString("ACHIEVEMENT_14_MESSAGE", comment: "")
        
        achievements = [step1, step2, step3, step4, step5, step6, step7, step8, step9, step10, step11, step12, step13, step14]
    }
    
    func updateForDate(date: NSDate?) {
        var nextFound = false
        
        for achievement in achievements {
            let percentage = achievement.completionPercentageFromDate(date)
            if (percentage == 1.0) {
                achievement.state = .Completed
            }
            else {
                if (!nextFound) {
                    achievement.state = .Next
                    
                    nextFound = true
                }
                else {
                    achievement.state = .Pending
                }
            }
        }
    }

    func nextAchievementIndex() -> Int {
        var index = 0
        
        for achievement in achievements {
            if (achievement.state == .Next) {
                break
            }
            else {
                index++
            }
        }
        
        return index
    }
    
    // MARK: - Local notifications
    
    func registerNotificationsForDate(date: NSDate?) {
        if (date != nil) {
            updateForDate(date)
            
            for achievement in achievements {
                if (!achievement.isCompleted) {
                    let notification = UILocalNotification()
                    notification.fireDate = achievement.completionDateFromDate(date!)
                    notification.alertBody = achievement.text
                    
                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                    
                    // Register yearly notitifications.
                    registerYearlyNotificationForDate(date!)
                }
            }
            
#if DEBUG
            println("AchievementsManager - Registered notification: \(UIApplication.sharedApplication().scheduledLocalNotifications)")
#endif
        }
    }
    
    func registerYearlyNotificationForDate(date: NSDate) {
        let notification = UILocalNotification()
        
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        if let calendar = gregorianCalendar {
            let components = NSDateComponents()
            components.year = 1
            
            notification.fireDate = calendar.dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(0))
            notification.repeatInterval = NSCalendarUnit.CalendarUnitYear
            notification.alertTitle = NSLocalizedString("ACHIEVEMENT_YEARLY_TITLE", comment: "")
            notification.alertBody = NSLocalizedString("ACHIEVEMENT_YEARLY_MESSAGE", comment: "")
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
}
