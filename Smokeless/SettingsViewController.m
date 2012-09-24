//
//  SettingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 11/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SettingsViewController.h"

#import "PreferencesManager.h"
#import "LastCigaretteViewController.h"
#import "HabitsViewController.h"
#import "PacketSizeViewController.h"
#import "AboutViewController.h"


enum : NSUInteger {
    SettingsSectionLastCigarette = 0,
    SettingsSectionHabits,
    SettingsSectionGeneral,
	SettingsSectionReset,   // TODO: remove.
	SettingsSectionAbout,
	
	SettingsNoOfSections
};


@interface SettingsViewController ()

@property (nonatomic, strong) UISwitch *shakeSwitch;
@property (nonatomic, strong) UISwitch *notificationSwitch;

@end


@implementation SettingsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Set background.
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
	self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Create the shake switch.
    self.shakeSwitch = [[UISwitch alloc] init];
    [self.shakeSwitch addTarget:self
                         action:@selector(shakeEnabled:)
               forControlEvents:UIControlEventValueChanged];
    
    // Create the notification switch.
    self.notificationSwitch = [[UISwitch alloc] init];
    [self.notificationSwitch addTarget:self
                                action:@selector(notificationEnabled:)
                      forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{	
	// Update table view.
	[self.tableView reloadData];
    
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    
    self.shakeSwitch = nil;
    self.notificationSwitch = nil;
}

#pragma mark Actions

- (void)shakeEnabled:(id)sender
{
    // Set preference.
    ([PreferencesManager sharedManager].prefs)[SHAKE_ENABLED_KEY] = @([self.shakeSwitch isOn]);
    
    // Save preferences.
    [[PreferencesManager sharedManager] savePrefs];
}

- (void)notificationEnabled:(id)sender
{
    BOOL notificationsEnabled = [self.notificationSwitch isOn];
    
    // Set preference.
    ([PreferencesManager sharedManager].prefs)[NOTIFICATIONS_ENABLED_KEY] = @(notificationsEnabled);
    
    // Save preferences.
    [[PreferencesManager sharedManager] savePrefs];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return SettingsNoOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRows = 0;
	
	// Set titles for the sections.
	switch (section) {
        case SettingsSectionLastCigarette:
            numberOfRows = 1;
            break;
            
        case SettingsSectionHabits:
            numberOfRows = 3;
            break;
            
        case SettingsSectionGeneral:
            numberOfRows = 2;
            break;
            
		case SettingsSectionReset:
			numberOfRows = 1;
			break;
			
		case SettingsSectionAbout:
			numberOfRows = 1;
			break;
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	MPTableViewCell *cell = (MPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[MPTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
		
		// Customize cells appearence.
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.710
                                                     alpha:1.000];
        cell.textLabel.shadowColor = [UIColor colorWithWhite:0.000
                                                       alpha:1.000];
        cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];

        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.710
                                                           alpha:1.000];
        cell.detailTextLabel.shadowColor = [UIColor colorWithWhite:0.000
                                                             alpha:1.000];
        cell.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        cell.backgroundView.style = MPCellStyleColorFill;
        cell.backgroundView.cornerRadius = 5.0;
        cell.backgroundView.borderColor = [UIColor colorWithWhite:0.710
                                                            alpha:0.750];
        cell.backgroundView.fillColor = [UIColor colorWithWhite:0.000
                                                          alpha:0.750];
        
        cell.selectedBackgroundView.cornerRadius = 5.0;
        cell.selectedBackgroundView.borderColor = [UIColor colorWithWhite:0.710
                                                                    alpha:0.750];
	}

	// Set cells content.
	switch (indexPath.section) {
        case SettingsSectionLastCigarette:
            cell.position = MPTableViewCellPositionSingle;
            cell.textLabel.text = MPString(@"Last cigarette");  // TODO: localize string.
            cell.detailTextLabel.text = [[PreferencesManager sharedManager] lastCigaretteFormattedDate];
            break;
            
        case SettingsSectionHabits:
            switch (indexPath.row) {
                case 0:
                    cell.position = MPTableViewCellPositionTop;
                    cell.textLabel.text = MPString(@"Habits");
                    cell.detailTextLabel.text = [[PreferencesManager sharedManager] smokingHabits]; // TODO: shorten string.
                    break;
                    
                case 1:
                    cell.position = MPTableViewCellPositionMiddle;
                    cell.textLabel.text = MPString(@"Packet size");
                    cell.detailTextLabel.text = [[PreferencesManager sharedManager] packetSize];
                    break;
                    
                case 2:
                    cell.position = MPTableViewCellPositionBottom;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    ((MPDisclosureIndicator *)cell.accessoryView).orientation = MPDisclosureIndicatorOrientationRight;
                    ((MPDisclosureIndicator *)cell.accessoryView).highlighted = NO;
                    ((MPDisclosureIndicator *)cell.accessoryView).normalColor = [UIColor colorWithWhite:0.710 alpha:1.000];
                    ((MPDisclosureIndicator *)cell.accessoryView).highlightedColor = [UIColor whiteColor];
                    cell.textLabel.text = MPString(@"Packet price");
                    cell.detailTextLabel.text = [[PreferencesManager sharedManager] packetPrice];
                    break;
            }
            break;
            
        case SettingsSectionGeneral:
            switch (indexPath.row) {
                case 0:
                    cell.position = MPTableViewCellPositionTop;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.adjustsFontSizeToFitWidth = YES;
                    cell.textLabel.text = MPString(@"Shake piggy bank");
                    cell.accessoryView = self.shakeSwitch;
                    self.shakeSwitch.on = [([PreferencesManager sharedManager].prefs)[SHAKE_ENABLED_KEY] boolValue];
                    break;
                    
                case 1:
                    cell.position = MPTableViewCellPositionBottom;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = MPString(@"Notifications");
                    cell.accessoryView = self.notificationSwitch;
                    self.notificationSwitch.on = [([PreferencesManager sharedManager].prefs)[NOTIFICATIONS_ENABLED_KEY] boolValue];
                    break;
            }
            break;
            
		case SettingsSectionReset:
            cell.position = MPTableViewCellPositionSingle;
            cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.text = MPString(@"Reset settings");
			break;
			
		case SettingsSectionAbout:
            cell.position = MPTableViewCellPositionSingle;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            ((MPDisclosureIndicator *)cell.accessoryView).orientation = MPDisclosureIndicatorOrientationRight;
            ((MPDisclosureIndicator *)cell.accessoryView).highlighted = NO;
            ((MPDisclosureIndicator *)cell.accessoryView).normalColor = [UIColor colorWithWhite:0.710 alpha:1.000];
            ((MPDisclosureIndicator *)cell.accessoryView).highlightedColor = [UIColor whiteColor];
			cell.textLabel.text = MPString(@"About");
			break;
	}
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	// editing rows is not enabled
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// perform cell action
	switch (indexPath.section) {
        case SettingsSectionLastCigarette:
        {
            LastCigaretteViewController *lastCigaretteController = [[LastCigaretteViewController alloc] init];
            lastCigaretteController.delegate = self;
            [self presentModalViewController:lastCigaretteController
                                    animated:YES];
            break;
        }
            
        case SettingsSectionHabits:
            switch (indexPath.row) {
                case 0:
                {
                    HabitsViewController *habitsController = [[HabitsViewController alloc] init];
                    habitsController.delegate = self;
                    [self presentModalViewController:habitsController
                                            animated:YES];
                    break;
                }
                    
                case 1:
                {
                    PacketSizeViewController *packetSizeController = [[PacketSizeViewController alloc] init];
                    packetSizeController.delegate = self;
                    [self presentModalViewController:packetSizeController
                                            animated:YES];
                    break;
                }
            }
            break;
            
		case SettingsSectionReset:
		{
			// show action sheet to ask confirmation before deleting preferences
			UIActionSheet *resetSheet = [[UIActionSheet alloc] initWithTitle:MPString(@"Do you really want to delete all your settings?")
                                                                    delegate:self
                                                           cancelButtonTitle:MPString(@"Cancel")
                                                      destructiveButtonTitle:MPString(@"Delete")
                                                           otherButtonTitles:nil];
			[resetSheet showFromTabBar:self.tabBarController.tabBar];
			break;
		}
						
		case SettingsSectionAbout:
			[self.navigationController pushViewController:[[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped]
												 animated:YES];
			break;			
	}
	
	// deselect row
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			[[PreferencesManager sharedManager] deletePrefs];
            
			// Reload data on the table view.
			[self.tableView reloadData];
			break;
			
		case 1:
			// Do nothing.
			[self.tableView reloadData];
			break;
	}
}

#pragma mark - Setting view delegate

- (void)viewControllerDidClose
{
    // Close modal view.
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [self.tableView reloadData];
                             }];
}

@end
