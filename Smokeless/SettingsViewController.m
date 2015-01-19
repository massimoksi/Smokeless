//
//  SettingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 11/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SettingsViewController.h"

#import "LastCigaretteViewController.h"
#import "HabitsViewController.h"
#import "PacketSizeViewController.h"
#import "PacketPriceViewController.h"
#import "AboutViewController.h"


enum : NSUInteger {
    SettingsSectionLastCigarette = 0,
    SettingsSectionHabits,
    SettingsSectionGeneral,
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
    
    // Create the reset button.
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 55.0)];
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.frame = CGRectMake(0.0, 0.0, 320.0, 45.0);
    [resetButton setBackgroundImage:[UIImage imageNamed:@"ButtonReset-normal"]
                           forState:UIControlStateNormal];
    resetButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    resetButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    [resetButton setTitleShadowColor:[UIColor colorWithWhite:0.200
                                                       alpha:0.750]
                            forState:UIControlStateNormal];
    [resetButton setTitle:MPString(@"Reset settings")
                 forState:UIControlStateNormal];
    [resetButton addTarget:self
                    action:@selector(resetTapped:)
          forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:resetButton];
    self.tableView.tableFooterView = footerView;
}

- (void)viewWillAppear:(BOOL)animated
{	
	// Update the table view.
	[self.tableView reloadData];
    
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    
    self.shakeSwitch = nil;
    self.notificationSwitch = nil;
}

#pragma mark - Actions

- (IBAction)shakeEnabled:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on
                                            forKey:@"ShakeEnabled"];
}

- (IBAction)notificationEnabled:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on
                                            forKey:@"NotificationsEnabled"];
}

- (void)resetTapped:(id)sender
{
    // Show action sheet to ask confirmation before deleting preferences.
    UIActionSheet *resetSheet = [[UIActionSheet alloc] initWithTitle:MPString(@"Do you really want to delete all your settings?")
                                                            delegate:self
                                                   cancelButtonTitle:MPString(@"Cancel")
                                              destructiveButtonTitle:MPString(@"Delete")
                                                   otherButtonTitles:nil];
    [resetSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - Private methods

- (NSString *)lastCigaretteFormattedDate;
{
    return [NSDateFormatter localizedStringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"LastCigarette"]
                                          dateStyle:NSDateFormatterLongStyle
                                          timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)smokingHabits
{
    NSString *habitsString;
    
    NSDictionary *habitsDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"Habits"];
    if (habitsDict != nil) {
        NSInteger quantity = [habitsDict[@"HabitsQuantity"] integerValue];
        NSInteger unit = [habitsDict[@"HabitsUnit"] integerValue];
        NSInteger period = [habitsDict[@"HabitsPeriod"] integerValue];

        NSString *unitString = nil;
        switch (unit) {
            case 0:
                unitString = (quantity == 1) ?
                MPString(@"cigarette") :
                MPString(@"cigarettes");
                break;
                
            case 1:
                unitString = (quantity == 1) ?
                MPString(@"packet") :
                MPString(@"packets");
                break;
        }

        NSString *periodString = nil;
        switch (period) {
            case 0:
                periodString = MPString(@"a day");
                break;
                
            case 1:
                periodString = MPString(@"a week");
                break;
        }
        
        habitsString = [NSString stringWithFormat:@"%ld %@ %@", quantity, unitString, periodString];
    }
    else {
        habitsString = nil;
    }
    
    // TODO: shorten string.
    return habitsString;
}

- (NSString *)packetSize
{
    NSString *packetSizeString;
    
    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:@"PacketSize"];
    
    if (size != 0) {
        if (size > 1) {
            packetSizeString = [[NSString stringWithFormat:@"%ld ", size] stringByAppendingString:MPString(@"cigarettes")];
        }
        else {
            packetSizeString = [[NSString stringWithFormat:@"%ld ", size] stringByAppendingString:MPString(@"cigarette")];
        }
    }
    else {
        packetSizeString = nil;
    }
    
    return packetSizeString;
}

- (NSString *)packetPrice
{
    NSString *packetPriceString;
    
    CGFloat price = [[NSUserDefaults standardUserDefaults] floatForKey:@"PacketPrice"];
    
    if (price != 0.0) {
        packetPriceString = [NSNumberFormatter localizedStringFromNumber:@(price)
                                                             numberStyle:NSNumberFormatterCurrencyStyle];
    }
    else {
        packetPriceString = nil;
    }
    
    return packetPriceString;
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	switch (indexPath.section) {
        case SettingsSectionLastCigarette:
            cell.position = MPTableViewCellPositionSingle;
            cell.textLabel.text = MPString(@"Last cigarette");
            cell.detailTextLabel.text = [self lastCigaretteFormattedDate];
            break;
            
        case SettingsSectionHabits:
            switch (indexPath.row) {
                case 0:
                    cell.position = MPTableViewCellPositionTop;
                    cell.textLabel.text = MPString(@"Habits");
                    cell.detailTextLabel.text = [self smokingHabits];
                    break;
                    
                case 1:
                    cell.position = MPTableViewCellPositionMiddle;
                    cell.textLabel.text = MPString(@"Packet size");
                    cell.detailTextLabel.text = [self packetSize];
                    break;
                    
                case 2:
                    cell.position = MPTableViewCellPositionBottom;
                    cell.textLabel.text = MPString(@"Packet price");
                    cell.detailTextLabel.text = [self packetPrice];
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
                    self.shakeSwitch.on = [userDefaults boolForKey:@"ShakeEnabled"];
                    break;
                    
                case 1:
                    cell.position = MPTableViewCellPositionBottom;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = MPString(@"Notifications");
                    cell.accessoryView = self.notificationSwitch;
                    self.notificationSwitch.on = [userDefaults boolForKey:@"NotificationsEnabled"];
                    break;
            }
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
	// Editing rows is not enabled.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Perform cell action.
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
                    
                case 2:
                {
                    PacketPriceViewController *packetPriceController = [[PacketPriceViewController alloc] init];
                    packetPriceController.delegate = self;
                    [self presentModalViewController:packetPriceController
                                            animated:YES];
                    break;
                }
            }
            break;
            
		case SettingsSectionAbout:
			[self.navigationController pushViewController:[[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped]
												 animated:YES];
			break;			
	}
	
	// Deselect row.
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	switch (buttonIndex) {
		case 0:
            [userDefaults removeObjectForKey:@"LastCigarette"];
            [userDefaults removeObjectForKey:@"Habits"];
            [userDefaults removeObjectForKey:@"PacketSize"];
            [userDefaults removeObjectForKey:@"PacketPrice"];
            
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
