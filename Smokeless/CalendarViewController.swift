//
//  CalendarViewController.swift
//  Smokeless
//
//  Created by Massimo Peri on 18/07/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit


class CalendarViewController: UIViewController {

    @IBOutlet weak var yearUnitLabel: UILabel!
    @IBOutlet weak var monthUnitLabel: UILabel!
    @IBOutlet weak var weekUnitLabel: UILabel!
    @IBOutlet weak var dayUnitLabel: UILabel!
    
    @IBOutlet weak var yearQuantityLabel: UILabel!
    @IBOutlet weak var monthQuantityLabel: UILabel!
    @IBOutlet weak var weekQuantityLabel: UILabel!
    @IBOutlet weak var dayQuantityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
