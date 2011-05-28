//
//  SettingsViewController.h
//  Smokeless
//
//  Created by Massimo Peri on 11/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


enum {
    SettingsSectionGeneral = 0,
	SettingsSectionReset,
	SettingsSectionAbout,
	
	SettingsNoOfSections
};


@interface SettingsViewController : UITableViewController <UIActionSheetDelegate> {
    UISwitch *_shakeSwitch;
    UISwitch *_notificationSwitch;
}

@property (nonatomic, retain) UISwitch *shakeSwitch;
@property (nonatomic, retain) UISwitch *notificationSwitch;

- (void)shakeEnabled:(id)sender;
- (void)notificationEnabled:(id)sender;

@end