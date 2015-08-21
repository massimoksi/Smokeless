//
//  HabitsTableViewController.swift
//  Smokeless
//
//  Created by Massimo Peri on 26/06/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit
import SmokelessKit


class HabitsTableViewController: UITableViewController {
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var unitCigarettesCell: UITableViewCell!
    @IBOutlet weak var unitPacketsCell: UITableViewCell!
    @IBOutlet weak var periodDayCell: UITableViewCell!
    @IBOutlet weak var periodWeekCell: UITableViewCell!

    var quantity: Int = 0 {
        didSet {
            quantityLabel.text = String(quantity)
        }
    }

    var unit: Int = -1 {
        didSet {
            if (unit == 0) {
                unitCigarettesCell.accessoryType = .Checkmark
                unitPacketsCell.accessoryType = .None
            }
            else if (unit == 1) {
                unitCigarettesCell.accessoryType = .None
                unitPacketsCell.accessoryType = .Checkmark
            }
            else {
                unitCigarettesCell.accessoryType = .None
                unitPacketsCell.accessoryType = .None
            }
        }
    }
    
    var period: Int = -1 {
        didSet {
            if (period == 0) {
                periodDayCell.accessoryType = .Checkmark
                periodWeekCell.accessoryType = .None
            }
            else if (period == 1) {
                periodDayCell.accessoryType = .None
                periodWeekCell.accessoryType = .Checkmark
            }
            else {
                periodDayCell.accessoryType = .None
                periodWeekCell.accessoryType = .None
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let habits = SmokelessManager.sharedManager().smokingHabits {
            quantity = habits[SLKHabitsQuantityKey] as! Int
            unit = habits[SLKHabitsUnitKey] as! Int
            period = habits[SLKHabitsPeriodKey] as! Int
        }
        
        quantityStepper.value = Double(quantity)
    }

    override func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        
        // Save new settings to user defaults.
        if ((quantity != 0) && (unit != -1) && (period != -1)) {
            let habits = [
                SLKHabitsQuantityKey: quantity,
                SLKHabitsUnitKey: unit,
                SLKHabitsPeriodKey: period
            ]
        
            SmokelessManager.sharedManager().smokingHabits = habits
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            unit = indexPath.row
            
        case 2:
            period = indexPath.row
            
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func quantityChanged(sender: UIStepper) {
        quantity = Int(sender.value)
    }

}
