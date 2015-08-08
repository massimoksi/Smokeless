//
//  CalendarViewController.swift
//  Smokeless
//
//  Created by Massimo Peri on 18/07/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit


class CalendarViewController: UIViewController {

//    @IBOutlet weak var yearDateLabel: UILabel!
//    @IBOutlet weak var monthDateLabel: UILabel!
//    @IBOutlet weak var dayDateLabel: UILabel!
    
    @IBOutlet weak var yearRadialBar: RadialBarView!
    @IBOutlet weak var monthRadialBar: RadialBarView!
    @IBOutlet weak var weekRadialBar: RadialBarView!
    @IBOutlet weak var dayRadialBar: RadialBarView!
    
    @IBOutlet weak var yearQuantityLabel: UILabel!
    @IBOutlet weak var monthQuantityLabel: UILabel!
    @IBOutlet weak var weekQuantityLabel: UILabel!
    @IBOutlet weak var dayQuantityLabel: UILabel!
    
    @IBOutlet weak var yearUnitLabel: UILabel!
    @IBOutlet weak var monthUnitLabel: UILabel!
    @IBOutlet weak var weekUnitLabel: UILabel!
    @IBOutlet weak var dayUnitLabel: UILabel!
    
//    private var monthFormatter: NSDateFormatter {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale.currentLocale()
//        dateFormatter.dateFormat = "MMMM"
//        
//        return dateFormatter
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let lastCigaretteDate = NSUserDefaults.standardUserDefaults().objectForKey(kLastCigaretteKey) as! NSDate? {
            if let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
                let unitFlags: NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitWeekOfMonth | .CalendarUnitDay
                
                let dateComponents = gregorianCalendar.components(unitFlags, fromDate: lastCigaretteDate)
//                yearDateLabel.text = String(dateComponents.year)
//                monthDateLabel.text = monthFormatter.stringFromDate(lastCigaretteDate).capitalizedString
//                dayDateLabel.text = String(dateComponents.day)
                
                let intervalComponents = gregorianCalendar.components(unitFlags, fromDate: lastCigaretteDate, toDate: NSDate(), options: NSCalendarOptions(0))
                
                let years = intervalComponents.year
                let months = intervalComponents.month
                let weeks = intervalComponents.weekOfMonth
                let days = intervalComponents.day
                
                yearRadialBar.value = years
                monthRadialBar.value = months
                weekRadialBar.value = weeks
                dayRadialBar.value = days
                
//                yearQuantityLabel.text = String(years)
//                monthQuantityLabel.text = String(months)
//                weekQuantityLabel.text = String(weeks)
//                dayQuantityLabel.text = String(days)
//                
//                yearUnitLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%d year(s) (unit)", comment: ""), years) as String
//                monthUnitLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%d month(s) (unit)", comment: ""), months) as String
//                weekUnitLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%d week(s) (unit)", comment: ""), weeks) as String
//                dayUnitLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%d day(s) (unit)", comment: ""), days) as String
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
