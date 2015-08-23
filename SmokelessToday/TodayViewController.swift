//
//  TodayViewController.swift
//  SmokelessToday
//
//  Created by Massimo Peri on 22/08/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit
import NotificationCenter
import SmokelessKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lastCigaretteLabel: UILabel!
    @IBOutlet weak var savingsLabel: UILabel!

    var lastCigaretteDate: NSDate?
    var totalSavings: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

        lastCigaretteDate = SmokelessManager.sharedManager().lastCigaretteDate
        totalSavings = SmokelessManager.sharedManager().totalSavings()
        
        updateWidget()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let url = NSURL(scheme: "smokeless", host: nil, path: "/")
        extensionContext?.openURL(url!, completionHandler: nil)
    }
    
    // MARK: - Widget providing
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        SmokelessManager.sharedManager().update()
        
        updateWidget()
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: defaultMarginInsets.top,
            left: defaultMarginInsets.left - 30.0,
            bottom: defaultMarginInsets.bottom,
            right: defaultMarginInsets.right
        )
    }
    
    // MARK: - Privare methods
    
    private func updateWidget() {
        lastCigaretteLabel.text = SmokelessManager.sharedManager().formattedNonSmokingInterval()
        savingsLabel.text = SmokelessManager.sharedManager().formattedTotalSavings()
    }
    
}
