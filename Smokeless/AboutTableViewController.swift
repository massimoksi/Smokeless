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

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    let appStoreURL = "itms-apps://itunes.apple.com/app/id"
    let appStoreID = "438027793"
    
    var twitterAccessGranted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

                        // TODO: implement.
                    }
                }
            }
        }
    }
    
    func rateApp() {
        UIApplication.sharedApplication().openURL(NSURL(string: appStoreURL + appStoreID)!)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
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
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
