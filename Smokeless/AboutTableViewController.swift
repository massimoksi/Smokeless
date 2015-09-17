//
//  AboutTableViewController.swift
//  Smokeless
//
//  Created by Massimo Peri on 15/08/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

import UIKit
import Accounts
import Social
import MessageUI
import SmokelessKit

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let versionString = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        let buildString = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as! String
        versionLabel.text = NSLocalizedString("ABOUT_SOFTWARE_VERSION", comment: "") + versionString + " (" + buildString + ")"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["massimoperi@gmail.com"])
            
            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    }
    
    func followOnTwitter() {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        var followError = false
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            
            if granted {
                let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                
                if (twitterAccounts.count > 0) {
                    let account = twitterAccounts[0] as! ACAccount
                    let parametersDict = [
                        "screen_name": "massimoksi",
                        "follow": true
                    ]
                    
                    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, URL: NSURL(string: "https://api.twitter.com/1/friendships/create.json"), parameters: parametersDict)
                    request.account = account
                    request.performRequestWithHandler() {
                        responseData, urlResponse, error in
                        
                        if (error != nil) {
                            followError = true
                        }
                        else {
                            followError = false
                        }
                    }
                }
                else {
                    followError = true
                }
            }
            else {
                followError = true
            }
        }
        
        if (followError) {
            TAOverlay.showOverlayWithLabel(nil, options: [.AutoHide, .OverlayTypeError, .OverlaySizeRoundedRect])
        }
        else {
            TAOverlay.showOverlayWithLabel(nil, options: [.AutoHide, .OverlayTypeSuccess, .OverlaySizeRoundedRect])
        }
    }
    
    func rateApp() {
        UIApplication.sharedApplication().openURL(NSURL(string: SLKAppStoreURL)!)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        if (row == 0) {
            sendEmail()
        }
        else if (row == 1) {
            followOnTwitter()
        }
        else if (row == 2) {
            rateApp()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Mail compose view controller delegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
