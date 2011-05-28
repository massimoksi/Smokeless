//
//  SettingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 11/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SettingsViewController.h"

#import "PreferencesManager.h"
#import "AboutViewController.h"


@implementation SettingsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// set background
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
	self.view.backgroundColor = [UIColor clearColor];
    
    // create shake switch
    self.shakeSwitch = [[[UISwitch alloc] init] autorelease];
    [self.shakeSwitch addTarget:self
                         action:@selector(shakeEnabled:)
               forControlEvents:UIControlEventValueChanged];
    
    // create notification switch
    self.notificationSwitch = [[[UISwitch alloc] init] autorelease];
    [self.notificationSwitch addTarget:self
                                action:@selector(notificationEnabled:)
                      forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{	
	// update table
	[self.tableView reloadData];
    
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	[super viewDidUnload];
    
    self.shakeSwitch = nil;
    self.notificationSwitch = nil;
}

- (void)dealloc
{
    self.shakeSwitch = nil;
    self.notificationSwitch = nil;
    
	[super dealloc];
}

#pragma mark Accessors

@synthesize shakeSwitch;
@synthesize notificationSwitch;

#pragma mark Actions

- (void)shakeEnabled:(id)sender
{
    // set preference
    [[PreferencesManager sharedManager].prefs setObject:[NSNumber numberWithBool:[self.shakeSwitch isOn]]
                                                 forKey:SHAKE_ENABLED_KEY];
    
    // save preferences
    [[PreferencesManager sharedManager] savePrefs];
}

- (void)notificationEnabled:(id)sender
{
    BOOL notificationsEnabled = [self.notificationSwitch isOn];
    
    // set preference
    [[PreferencesManager sharedManager].prefs setObject:[NSNumber numberWithBool:notificationsEnabled]
                                                 forKey:NOTIFICATIONS_ENABLED_KEY];
    
    // save preferences
    [[PreferencesManager sharedManager] savePrefs];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return SettingsNoOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRows = 0;
	
	// set title for the sections
	switch (section) {
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
		cell = [[[MPTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
		
		// customize cells appearence
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.710 alpha:1.000];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];

        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.710 alpha:1.000];
        
        cell.backgroundView.style = MPCellStyleColorFill;
        cell.backgroundView.cornerRadius = 5.0;
        cell.backgroundView.borderColor = [UIColor colorWithWhite:0.710 alpha:0.750];
        cell.backgroundView.fillColor = [UIColor colorWithWhite:0.000 alpha:0.750];
        
        cell.selectedBackgroundView.cornerRadius = 5.0;
        cell.selectedBackgroundView.borderColor = [UIColor colorWithWhite:0.710 alpha:0.750];
	}
		
	// set cells content
	switch (indexPath.section) {
        case SettingsSectionGeneral:
            switch (indexPath.row) {
                case 0:
                    cell.position = MPTableViewCellPositionTop;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = MPString(@"Shake piggy bank");
                    cell.accessoryView = self.shakeSwitch;
                    // update switch
                    self.shakeSwitch.on = [[[PreferencesManager sharedManager].prefs objectForKey:SHAKE_ENABLED_KEY] boolValue];            
                    break;
                    
                case 1:
                    cell.position = MPTableViewCellPositionBottom;
                    cell.selectionStyle = UITableViewCellEditingStyleNone;
                    cell.textLabel.text = MPString(@"Notifications");
                    cell.accessoryView = self.notificationSwitch;
                    // update switch
                    self.notificationSwitch.on = [[[PreferencesManager sharedManager].prefs objectForKey:NOTIFICATIONS_ENABLED_KEY] boolValue];
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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// perform cell action
	switch (indexPath.section) {
		case SettingsSectionReset:
		{
			// show action sheet to ask confirmation before deleting preferences
			UIActionSheet *resetSheet = [[[UIActionSheet alloc] initWithTitle:MPString(@"Do you really want to delete all your settings?")
																	 delegate:self
															cancelButtonTitle:MPString(@"Cancel")
													   destructiveButtonTitle:MPString(@"Delete")
															otherButtonTitles:nil] autorelease];
			[resetSheet showFromTabBar:self.tabBarController.tabBar];
			break;
		}
						
		case SettingsSectionAbout:
			[self.navigationController pushViewController:[[[AboutViewController alloc] init] autorelease]
												 animated:YES];
			break;			
	}
	
	// deselect row
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			[[PreferencesManager sharedManager] deletePrefs];
            
			// reload data on table view
			[self.tableView reloadData];
			break;
			
		case 1:
			// do nothing
			[self.tableView reloadData];
			break;
	}
}

@end