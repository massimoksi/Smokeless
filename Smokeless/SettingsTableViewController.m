//
//  SettingsTableViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 11/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SettingsTableViewController.h"

#import "TTTLocalizedPluralString.h"

#import "Constants.h"


@interface SettingsTableViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;
@property (strong, nonatomic, readonly) NSNumberFormatter *currencyFormatter;

@property (copy, nonatomic) NSDictionary *smokingHabits;

@property (weak, nonatomic) IBOutlet UILabel *lastCigaretteDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *lastCigaretteDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *smokingHabitsLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *smokingHabitsPickerView;
@property (weak, nonatomic) IBOutlet UITextField *packetSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *packetPriceTextField;
@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;

@end


@implementation SettingsTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

    [self updateSettings];
}

- (void)viewWillAppear:(BOOL)animated
{	
	[super viewWillAppear:animated];

    NSIndexPath *lastCigaretteDatePickerIndexPath = [NSIndexPath indexPathForRow:1
                                                                       inSection:0];
    NSIndexPath *smokingHabitsPickerViewIndexPath = [NSIndexPath indexPathForRow:1
                                                                       inSection:1];
    
    [self deleteRowsAtIndexPaths:@[lastCigaretteDatePickerIndexPath, smokingHabitsPickerViewIndexPath]];
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

- (IBAction)shakeEnabled:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on
                                            forKey:kShakeEnabledKey];
}

- (IBAction)notificationsEnabled:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on
                                            forKey:kNotificationsEnabledKey];
}

#pragma mark - Private methods

- (void)updateSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
#if DEBUG
    NSLog(@"%@", [userDefaults dictionaryRepresentation]);
#endif
    
    NSDate *lastCigaretteDate = [userDefaults objectForKey:kLastCigaretteKey];
    self.lastCigaretteDateLabel.text = (lastCigaretteDate) ? [self.dateFormatter stringFromDate:lastCigaretteDate] : @"";
    
    self.lastCigaretteDatePicker.maximumDate = [NSDate date];
    
    self.smokingHabits = [userDefaults dictionaryForKey:kHabitsKey];
    self.smokingHabitsLabel.text = [self formattedStringFromSmokingHabits:self.smokingHabits];
    
    NSInteger size = [userDefaults integerForKey:kPacketSizeKey];
    self.packetSizeTextField.text = (size != 0) ? [NSString stringWithFormat:@"%zd", size] : @"";
    
    CGFloat price = [userDefaults floatForKey:kPacketPriceKey];
    self.packetPriceTextField.text = (price != 0.0) ? [self.currencyFormatter stringFromNumber:@(price)] : @"";
    
    self.shakeSwitch.on = [userDefaults boolForKey:kShakeEnabledKey];
    self.notificationsSwitch.on = [userDefaults boolForKey:kNotificationsEnabledKey];
}

- (NSString *)formattedStringFromSmokingHabits:(NSDictionary *)smokingHabits
{
    if (smokingHabits) {
        NSInteger quantity = [smokingHabits[kHabitsQuantityKey] integerValue];
        NSInteger unit = [smokingHabits[kHabitsUnitKey] integerValue];
        NSInteger period = [smokingHabits[kHabitsPeriodKey] integerValue];
        
        NSString *unitFormat;
        switch (unit) {
            default:
            case 0:
                unitFormat = TTTLocalizedPluralString(quantity, @"cigarette", nil);
                break;
                

            case 1:
                unitFormat = TTTLocalizedPluralString(quantity, @"packet", nil);
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
        
        return [unitFormat stringByAppendingString:periodString];
    }
    else {
        return @"";
    }
}

- (void)resetSettings
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:NSLocalizedString(@"Do you really want to delete all your settings?", nil)
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil)
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction *action){
                                                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                                            [userDefaults removeObjectForKey:kLastCigaretteKey];
                                                            [userDefaults removeObjectForKey:kHabitsKey];
                                                            [userDefaults removeObjectForKey:kPacketSizeKey];
                                                            [userDefaults removeObjectForKey:kPacketPriceKey];
                                                            [userDefaults removeObjectForKey:kShakeEnabledKey];
                                                            [userDefaults removeObjectForKey:kNotificationsEnabledKey];
                                                            [userDefaults removeObjectForKey:kLastSavingsKey];
                                                            
                                                            [self updateSettings];
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
            if (row == 0) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:++row
                                                               inSection:section];
                
                if ([self isRowVisible:newIndexPath]) {
                    NSDate *actualDate = self.lastCigaretteDatePicker.date;

                    [[NSUserDefaults standardUserDefaults] setObject:actualDate
                                                              forKey:kLastCigaretteKey];
                    
                    [self deleteRowsAtIndexPaths:@[newIndexPath]
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
                    
                    [self insertRowsAtIndexPaths:@[newIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];

                    self.lastCigaretteDateLabel.textColor = [UIColor sml_highlightColor];
                }
            }
            break;

        case 1:
            if (row == 0) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:++row
                                                               inSection:section];
                
                if ([self isRowVisible:newIndexPath]) {
                    NSDictionary *habits = @{
                                             kHabitsQuantityKey: @([self.smokingHabitsPickerView selectedRowInComponent:0] + 1),
                                             kHabitsUnitKey: @([self.smokingHabitsPickerView selectedRowInComponent:1]),
                                             kHabitsPeriodKey: @([self.smokingHabitsPickerView selectedRowInComponent:2])
                                             };
                    if (![habits isEqualToDictionary:self.smokingHabits]) {
                        [[NSUserDefaults standardUserDefaults] setObject:habits
                                                                  forKey:kHabitsKey];
                    }
                    
                    [self deleteRowsAtIndexPaths:@[newIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];
                    
                    self.smokingHabitsLabel.textColor = [UIColor sml_detailTextColor];
                }
                else {
                    if (self.smokingHabits) {
                        NSInteger quantity = [self.smokingHabits[kHabitsQuantityKey] integerValue];
                        NSInteger unit = [self.smokingHabits[kHabitsUnitKey] integerValue];
                        NSInteger period = [self.smokingHabits[kHabitsPeriodKey] integerValue];
                        
                        // Set values from preferences to the picker view.
                        [self.smokingHabitsPickerView selectRow:(quantity - 1)
                                                    inComponent:0
                                                       animated:NO];
                        [self.smokingHabitsPickerView selectRow:unit
                                                    inComponent:1
                                                       animated:NO];
                        [self.smokingHabitsPickerView selectRow:period
                                                    inComponent:2
                                                       animated:NO];
                    }
                    
                    [self insertRowsAtIndexPaths:@[newIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];

                    self.smokingHabitsLabel.textColor = [UIColor sml_highlightColor];
                }
            }
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

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows;
    
    switch (component) {
        case 0:
            rows = 99;
            break;
            
        case 1:
        case 2:
            rows = 2;
            break;
            
        default:
            rows = 0;
            break;
    }
    
    return rows;
}

#pragma mark - Picker view delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0.0;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    switch (component) {
        case 0:
            width = viewWidth / 6;
            break;
            
        case 1:
            width = viewWidth / 2; // 3/6
            break;
            
        case 2:
            width = viewWidth / 3; // 2/6
            break;
    }
    
    return width;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // TODO: add comments to localized strings.
    NSString *title = nil;
    
    switch (component) {
        case 0:
            title = [NSString stringWithFormat:@"%ld", row + 1];
            break;
            
        case 1:
            if (row == 0) {
                title = [NSLocalizedString(@"Cigarette(s)", nil) lowercaseString];
            }
            else {
                title = [NSLocalizedString(@"Packet(s)", nil) lowercaseString];
            }
            break;
            
        case 2:
            if (row == 0) {
                title = [NSLocalizedString(@"Day", nil) lowercaseString];
            }
            else {
                title = [NSLocalizedString(@"Week", nil) lowercaseString];
            }
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *habits = @{
                             kHabitsQuantityKey: @([self.smokingHabitsPickerView selectedRowInComponent:0] + 1),
                             kHabitsUnitKey: @([self.smokingHabitsPickerView selectedRowInComponent:1]),
                             kHabitsPeriodKey: @([self.smokingHabitsPickerView selectedRowInComponent:2])
                             };
    
    self.smokingHabitsLabel.text = [self formattedStringFromSmokingHabits:habits];
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
