//
//  SettingsTableViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 11/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SettingsTableViewController.h"

@import SmokelessKit;

#import "Smokeless-Swift.h"


@interface SettingsTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;
@property (strong, nonatomic, readonly) NSNumberFormatter *currencyFormatter;

@property (strong, nonatomic) NSDictionary *smokingHabits;

@property (weak, nonatomic) IBOutlet UILabel *lastCigaretteDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *lastCigaretteDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *smokingHabitsLabel;
@property (weak, nonatomic) IBOutlet UITextField *packetSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *packetPriceTextField;
@property (weak, nonatomic) IBOutlet UISwitch *soundsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;

@end


@implementation SettingsTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1
                                                      inSection:0]]];
    
    [self updateSettings];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1
                                                 inSection:0];
    
    if ([self isRowVisible:indexPath]) {
        if (animated) {
            [self deleteRowsAtIndexPaths:@[indexPath]
                        withRowAnimation:UITableViewRowAnimationTop];
        }
        else {
            [self deleteRowsAtIndexPaths:@[indexPath]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter = nil;
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateIntervalFormatterLongStyle;
        _dateFormatter.locale = [NSLocale currentLocale];
    }
    
    return _dateFormatter;
}

- (NSNumberFormatter *)currencyFormatter
{
    static NSNumberFormatter *_currencyFormatter = nil;
    if (!_currencyFormatter) {
        _currencyFormatter = [[NSNumberFormatter alloc] init];
        _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    return _currencyFormatter;
}

#pragma mark - Actions

- (IBAction)lastCigaretteDateChanged:(UIDatePicker *)sender
{
    self.lastCigaretteDateLabel.text = [self.dateFormatter stringFromDate:sender.date];
}

- (IBAction)doneTapped:(id)sender
{
    if ([self.packetSizeTextField isFirstResponder]) {
        [self.packetSizeTextField resignFirstResponder];
    }
    else if ([self.packetPriceTextField isFirstResponder]) {
        [self.packetPriceTextField resignFirstResponder];
    }
}

- (IBAction)soundsEnabled:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on
                                            forKey:kPlaySoundsKey];
}

- (IBAction)notificationsEnabled:(UISwitch *)sender
{
    BOOL enabled = sender.on;

    [[NSUserDefaults standardUserDefaults] setBool:enabled
                                            forKey:kNotificationsEnabledKey];

    // Schedule/unschedule local notifications.
    if (enabled) {
        [[AchievementsManager sharedManager] registerNotificationsForDate:[[NSUserDefaults standardUserDefaults] objectForKey:kLastCigaretteKey]];

        // Check if notifications are enabled by user settings, if not alert user.
        if (([[UIApplication sharedApplication] currentUserNotificationSettings].types & UIUserNotificationTypeAlert) == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NOTIFICATIONS_ALERT_TITLE", @"Disabled notifications alert: title.")
                                                                                     message:NSLocalizedString(@"NOTIFICATIONS_ALERT_MESSAGE", @"Disabled notifications alert: message.")
                                                                              preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open Settings", @"Disabled notifications alert: button.")
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action){
                                                                        // Open Settings.
                                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                   }];
            [alertController addAction:settingsAction];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            [alertController addAction:cancelAction];

            [self presentViewController:alertController
                               animated:YES
                             completion:nil];
        }
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

#pragma mark - Private methods

- (void)updateSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *lastCigaretteDate = [userDefaults objectForKey:kLastCigaretteKey];
    self.lastCigaretteDateLabel.text = (lastCigaretteDate) ? [self.dateFormatter stringFromDate:lastCigaretteDate] : @"";

    self.lastCigaretteDatePicker.maximumDate = [NSDate date];
    
    self.smokingHabits = [userDefaults dictionaryForKey:kHabitsKey];
    self.smokingHabitsLabel.text = [self formattedStringFromSmokingHabits:self.smokingHabits];
    
    NSInteger size = [userDefaults integerForKey:kPacketSizeKey];
    self.packetSizeTextField.text = (size != 0) ? [NSString stringWithFormat:@"%zd", size] : @"";
    
    CGFloat price = [userDefaults floatForKey:kPacketPriceKey];
    self.packetPriceTextField.text = (price != 0.0) ? [self.currencyFormatter stringFromNumber:@(price)] : @"";
    
    self.soundsSwitch.on = [userDefaults boolForKey:kPlaySoundsKey];
    self.notificationsSwitch.on = [userDefaults boolForKey:kNotificationsEnabledKey];
}

- (NSString *)formattedStringFromSmokingHabits:(NSDictionary *)smokingHabits
{
    NSString *formattedString = @" ";
    
    if (smokingHabits) {
        NSInteger quantity = [smokingHabits[kHabitsQuantityKey] integerValue];
        NSInteger unit = [smokingHabits[kHabitsUnitKey] integerValue];
        NSInteger period = [smokingHabits[kHabitsPeriodKey] integerValue];
        
        NSString *unitFormat;
        switch (unit) {
            default:
            case 0:
                unitFormat = [NSString localizedStringWithFormat:NSLocalizedString(@"%d cigarette(s)", nil), quantity];
                break;
                

            case 1:
                unitFormat = [NSString localizedStringWithFormat:NSLocalizedString(@"%d packet(s)", nil), quantity];
                break;
        }

        NSString *periodString;
        switch (period) {
            default:
            case 0:
                periodString = NSLocalizedString(@" a day", nil);
                break;

            case 1:
                periodString = NSLocalizedString(@" a week", nil);
                break;
        }
        
        formattedString = [unitFormat stringByAppendingString:periodString];
    }

    return formattedString;
}

- (void)resetSettings
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:NSLocalizedString(@"Do you really want to delete all your settings?", @"Reset alert: message.")
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", @"Reset alert: button.")
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action){
                                                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                            [userDefaults removeObjectForKey:kLastCigaretteKey];
                                                            [userDefaults removeObjectForKey:kHabitsKey];
                                                            [userDefaults removeObjectForKey:kPacketSizeKey];
                                                            [userDefaults removeObjectForKey:kPacketPriceKey];
                                                            [userDefaults removeObjectForKey:kPlaySoundsKey];
                                                            [userDefaults removeObjectForKey:kNotificationsEnabledKey];
                                                            [userDefaults removeObjectForKey:kLastSavingsKey];

                                                            [self updateSettings];

                                                            // Cancel scheduled local notifications.
                                                            UIApplication *application = [UIApplication sharedApplication];
                                                            if ([application scheduledLocalNotifications]) {
                                                                [application cancelAllLocalNotifications];
                                                            }
                                                        }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    [alertController addAction:resetAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    switch (section) {
        case 0:
        {
            NSIndexPath *lastCigaretteIndexPath = [NSIndexPath indexPathForItem:1
                                                                      inSection:0];

            if (row == 0) {
                if ([self isRowVisible:lastCigaretteIndexPath]) {
                    NSDate *actualDate = self.lastCigaretteDatePicker.date;

                    [[NSUserDefaults standardUserDefaults] setObject:actualDate
                                                              forKey:kLastCigaretteKey];

                    // Cancel scheduled local notifications.
                    UIApplication *application = [UIApplication sharedApplication];
                    if ([application scheduledLocalNotifications]) {
                        [application cancelAllLocalNotifications];
                    }

                    // Register local notifications for the new date if they are enabled.
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:kNotificationsEnabledKey]) {
                        [[AchievementsManager sharedManager] registerNotificationsForDate:actualDate];
                    }

                    [self deleteRowsAtIndexPaths:@[lastCigaretteIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];

                    self.lastCigaretteDateLabel.textColor = [UIColor sml_detailTextColor];
                }
                else {
                    NSDate *lastCigaretteDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastCigaretteKey];
                    if (lastCigaretteDate) {
                        self.lastCigaretteDatePicker.date = lastCigaretteDate;
                    }
                    else {
                        self.lastCigaretteDatePicker.date = [NSDate date];
                    }

                    [self insertRowsAtIndexPaths:@[lastCigaretteIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];

                    self.lastCigaretteDateLabel.textColor = [UIColor sml_highlightColor];
                }
            }
            break;
        }

        case 1:
            break;

        case 2:
            if (row == 0) {
                [self.packetSizeTextField becomeFirstResponder];
            }
            else if (row == 1) {
                [self.packetPriceTextField becomeFirstResponder];
            }
            break;

        case 4:
            [self resetSettings];
            break;

        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.packetPriceTextField) {
        NSNumber *price = [self.currencyFormatter numberFromString:textField.text];
        
        if (price) {
            textField.text = [NSString stringWithFormat:@"%@", price];
        }
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneTapped:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (textField == self.packetSizeTextField) {
        NSInteger size = [textField.text integerValue];
        if (size != 0) {
            [userDefaults setInteger:size
                              forKey:kPacketSizeKey];
        }
        else {
            [userDefaults removeObjectForKey:kPacketSizeKey];
            
            self.packetSizeTextField.text = @"";
        }
    }
    else if (textField == self.packetPriceTextField) {
        CGFloat price = [textField.text floatValue];
        if (price != 0.0) {
            [userDefaults setFloat:price
                            forKey:kPacketPriceKey];
            
            textField.text = [self.currencyFormatter stringFromNumber:@(price)];
        }
        else {
            [userDefaults removeObjectForKey:kPacketPriceKey];
            
            self.packetPriceTextField.text = @"";
        }
    }
}

@end
