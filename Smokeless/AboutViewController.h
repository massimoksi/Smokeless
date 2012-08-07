//
//  AboutViewController.h
//  Smokeless
//
//  Created by Massimo Peri on 16/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "CreditsViewController.h"
#import "TwitterViewController.h"


enum {
	AboutSectionVersion = 0,
	AboutSectionCredits,
	AboutSectionContacts,
	
	AboutNoOfSections
};

enum {
	ContactsRowEmail = 0,
	ContactsRowTwitter,
	
	ContactsNoOfRows
};


@interface AboutViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@end
