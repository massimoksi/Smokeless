//
//  CalendarViewController.swift
//  Smokeless
//
//  Created by Massimo Peri on 18/07/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit
import SmokelessKit

class CalendarViewController: UIViewController {

    var years: Int = 0
    var months: Int = 0
    var weeks:Int = 0
    var days: Int = 0
    
    @IBOutlet weak var yearDateLabel: UILabel!
    @IBOutlet weak var monthDateLabel: UILabel!
    @IBOutlet weak var dayDateLabel: UILabel!
    
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
    
    private lazy var monthFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        let localization: String = NSBundle.mainBundle().preferredLocalizations.first as String!
        dateFormatter.locale = NSLocale(localeIdentifier: localization)
        dateFormatter.dateFormat = "MMMM"
        
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let lastCigaretteDate = SmokelessManager.sharedManager().lastCigaretteDate {
            yearDateLabel.hidden = false
            monthDateLabel.hidden = false
            dayDateLabel.hidden = false
            
            let dateComponents = SmokelessManager.sharedManager().lastCigaretteDateComponents()
            yearDateLabel.text = String(dateComponents.year)
            monthDateLabel.text = monthFormatter.stringFromDate(lastCigaretteDate).capitalizedString
            dayDateLabel.text = String(dateComponents.day)
            
            let nonSmokingInterval = SmokelessManager.sharedManager().nonSmokingInterval()
            years = nonSmokingInterval.year
            months = nonSmokingInterval.month
            weeks = nonSmokingInterval.weekOfMonth
            days = nonSmokingInterval.day
        }
        else {
            yearDateLabel.hidden = true
            monthDateLabel.hidden = true
            dayDateLabel.hidden = true
            
            years = 0
            months = 0
            weeks = 0
            days = 0
        }
        
        yearQuantityLabel.text = String(years)
        monthQuantityLabel.text = String(months)
        weekQuantityLabel.text = String(weeks)
        dayQuantityLabel.text = String(days)
        
        yearUnitLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%d year(s) (unit)", comment: ""), years) as String
        monthUnitLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%d month(s) (unit)", comment: ""), months) as String
        weekUnitLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%d week(s) (unit)", comment: ""), weeks) as String
        dayUnitLabel.text = NSString.localizedStringWithFormat(NSLocalizedString("%d day(s) (unit)", comment: ""), days) as String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if (years != 0 || months != 0 || weeks != 0 || days != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.yearRadialBar.value = self.years
                self.monthRadialBar.value = self.months
                self.weekRadialBar.value = self.weeks
                self.dayRadialBar.value = self.days
            }
        }
        else {
            self.yearRadialBar.value = self.years
            self.monthRadialBar.value = self.months
            self.weekRadialBar.value = self.weeks
            self.dayRadialBar.value = self.days
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
