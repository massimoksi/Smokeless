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
        
        NSString *localization = [NSBundle mainBundle].preferredLocalizations.firstObject;
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:localization];
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
                                            forKey:SLKPlaySoundsKey];
}

- (IBAction)notificationsEnabled:(UISwitch *)sender
{
    BOOL enabled = sender.on;

    [[NSUserDefaults standardUserDefaults] setBool:enabled
                                            forKey:SLKNotificationsEnabledKey];

    // Schedule/unschedule local notifications.
    if (enabled) {
        [[AchievementsManager sharedManager] registerNotificationsForDate:[SmokelessManager sharedManager].lastCigaretteDate];

        // Check if notifications are enabled by user settings, if not alert user.
        if (([[UIApplication sharedApplication] currentUserNotificationSettings].types & UIUserNotificationTypeAlert) == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NOTIFICATIONS_ALERT_TITLE", nil)
                                                                                     message:NSLocalizedString(@"NOTIFICATIONS_ALERT_MESSAGE", nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NOTIFICATIONS_ALERT_ACTION_BUTTON", nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction *action){
                                                                        // Open Settings.
                                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                   }];
            [alertController addAction:settingsAction];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"COMMON_CANCEL", nil)
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
    
    NSDate *lastCigaretteDate = [SmokelessManager sharedManager].lastCigaretteDate;
    self.lastCigaretteDateLabel.text = (lastCigaretteDate) ? [self.dateFormatter stringFromDate:lastCigaretteDate] : @"";

    self.lastCigaretteDatePicker.maximumDate = [NSDate date];
    
    self.smokingHabits = [SmokelessManager sharedManager].smokingHabits;
    self.smokingHabitsLabel.text = [self formattedStringFromSmokingHabits:self.smokingHabits];
    
    NSInteger size = [SmokelessManager sharedManager].packetSize;
    self.packetSizeTextField.text = (size != 0) ? [NSString stringWithFormat:@"%zd", size] : @"";
    
    CGFloat price = [SmokelessManager sharedManager].packetPrice;
    self.packetPriceTextField.text = (price != 0.0) ? [self.currencyFormatter stringFromNumber:@(price)] : @"";
    
    self.soundsSwitch.on = [userDefaults boolForKey:SLKPlaySoundsKey];
    self.notificationsSwitch.on = [userDefaults boolForKey:SLKNotificationsEnabledKey];
}

- (NSString *)formattedStringFromSmokingHabits:(NSDictionary *)smokingHabits
{
    NSString *formattedString = @" ";
    
    if (smokingHabits) {
        NSInteger quantity = [smokingHabits[SLKHabitsQuantityKey] integerValue];
        NSInteger unit = [smokingHabits[SLKHabitsUnitKey] integerValue];
        NSInteger period = [smokingHabits[SLKHabitsPeriodKey] integerValue];
        
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
                periodString = NSLocalizedString(@"SETTINGS_HABITS_PERIOD_DAY", nil);
                break;

            case 1:
                periodString = NSLocalizedString(@"SETTINGS_HABITS_PERIOD_WEEK", nil);
                break;
        }
        
        formattedString = [unitFormat stringByAppendingString:periodString];
    }

    return formattedString;
}

- (void)resetSettings
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:NSLocalizedString(@"RESET_SETTINGS_ALERT_MESSAGE", nil)
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"RESET_SETTINGS_ACTION_BUTTON", nil)
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action){
                                                            [SmokelessManager sharedManager].lastCigaretteDate = nil;
                                                            [SmokelessManager sharedManager].smokingHabits = nil;
                                                            [SmokelessManager sharedManager].packetSize = 0;
                                                            [SmokelessManager sharedManager].packetPrice = 0.0;

                                                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                            [userDefaults removeObjectForKey:SLKPlaySoundsKey];
                                                            [userDefaults removeObjectForKey:SLKNotificationsEnabledKey];
                                                            [userDefaults removeObjectForKey:SLKLastSavingsKey];

                                                            [self updateSettings];

                                                            // Cancel scheduled local notifications.
                                                            UIApplication *application = [UIApplication sharedApplication];
                                                            if ([application scheduledLocalNotifications]) {
                                                                [application cancelAllLocalNotifications];
                                                            }
                                                        }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"COMMON_CANCEL", nil)
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

                    [SmokelessManager sharedManager].lastCigaretteDate = actualDate;

                    // Cancel scheduled local notifications.
                    UIApplication *application = [UIApplication sharedApplication];
                    if ([application scheduledLocalNotifications]) {
                        [application cancelAllLocalNotifications];
                    }

                    // Register local notifications for the new date if they are enabled.
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:SLKNotificationsEnabledKey]) {
                        [[AchievementsManager sharedManager] registerNotificationsForDate:actualDate];
                    }

                    [self deleteRowsAtIndexPaths:@[lastCigaretteIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];

                    self.lastCigaretteDateLabel.textColor = [UIColor slk_detailTextColor];
                }
                else {
                    NSDate *lastCigaretteDate = [SmokelessManager sharedManager].lastCigaretteDate;
                    if (lastCigaretteDate) {
                        self.lastCigaretteDatePicker.date = lastCigaretteDate;
                    }
                    else {
                        self.lastCigaretteDatePicker.date = [NSDate date];
                    }

                    [self insertRowsAtIndexPaths:@[lastCigaretteIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];

                    self.lastCigaretteDateLabel.textColor = [UIColor slk_highlightColor];
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
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            numberFormatter.minimumFractionDigits = 2;
            numberFormatter.maximumFractionDigits = 2;
            
            textField.text = [numberFormatter stringFromNumber:price];
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
    
    if (textField == self.packetSizeTextField) {
        NSInteger size = [textField.text integerValue];
        if (size != 0) {
            [SmokelessManager sharedManager].packetSize = size;
        }
        else {
            [SmokelessManager sharedManager].packetSize = 0;
            
            self.packetSizeTextField.text = @"";
        }
    }
    else if (textField == self.packetPriceTextField) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        numberFormatter.minimumFractionDigits = 2;
        numberFormatter.maximumFractionDigits = 2;
        
        NSNumber *num = [numberFormatter numberFromString:textField.text];

        CGFloat price = [num floatValue];
        if (price != 0.0) {
            [SmokelessManager sharedManager].packetPrice = price;
            
            textField.text = [self.currencyFormatter stringFromNumber:@(price)];
        }
        else {
            [SmokelessManager sharedManager].packetPrice = 0.0;
            
            self.packetPriceTextField.text = @"";
        }
    }
}

@end
