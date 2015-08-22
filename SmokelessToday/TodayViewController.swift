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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        lastCigaretteLabel.text = SmokelessManager.sharedManager().formattedNonSmokingInterval()
        savingsLabel.text = SmokelessManager.sharedManager().formattedTotalSavings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Widget providing
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

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
    
}
