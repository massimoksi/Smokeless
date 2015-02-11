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

@property (strong, nonatomic) NSDate *lastCigaretteDate;
@property (copy, nonatomic) NSDictionary *smokingHabits;
@property (nonatomic) NSInteger packetSize;

@property (weak, nonatomic) IBOutlet UILabel *lastCigaretteDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *lastCigaretteDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *smokingHabitsLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *smokingHabitsPickerView;
@property (weak, nonatomic) IBOutlet UITextField *packetSizeTextField;

@end


@implementation SettingsTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.lastCigaretteDate = [userDefaults objectForKey:LastCigaretteKey];
    if (self.lastCigaretteDate) {
        self.lastCigaretteDateLabel.text = [self.dateFormatter stringFromDate:self.lastCigaretteDate];
    }
    else {
        self.lastCigaretteDateLabel.text = @"";
    }
    
    self.lastCigaretteDatePicker.maximumDate = [NSDate date];
    
    self.smokingHabits = [userDefaults dictionaryForKey:HabitsKey];
    self.smokingHabitsLabel.text = [self formattedStringFromSmokingHabits:self.smokingHabits];
    
    self.packetSize = [userDefaults integerForKey:PacketSizeKey];
    self.packetSizeTextField.text = (self.packetSize != 0) ? [NSString stringWithFormat:@"%zd", self.packetSize] : @"";
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
}

//- (IBAction)shakeEnabled:(UISwitch *)sender
//{
//    [[NSUserDefaults standardUserDefaults] setBool:sender.on
//                                            forKey:ShakeEnabledKey];
//}
//
//- (IBAction)notificationEnabled:(UISwitch *)sender
//{
//    [[NSUserDefaults standardUserDefaults] setBool:sender.on
//                                            forKey:NotificationsEnabledKey];
//}
//
//- (void)resetTapped:(id)sender
//{
//    // Show action sheet to ask confirmation before deleting preferences.
//    UIActionSheet *resetSheet = [[UIActionSheet alloc] initWithTitle:MPString(@"Do you really want to delete all your settings?")
//                                                            delegate:self
//                                                   cancelButtonTitle:MPString(@"Cancel")
//                                              destructiveButtonTitle:MPString(@"Delete")
//                                                   otherButtonTitles:nil];
//    [resetSheet showFromTabBar:self.tabBarController.tabBar];
//}

#pragma mark - Private methods

- (NSString *)formattedStringFromSmokingHabits:(NSDictionary *)smokingHabits
{
    if (smokingHabits) {
        NSInteger quantity = [smokingHabits[HabitsQuantityKey] integerValue];
        NSInteger unit = [smokingHabits[HabitsUnitKey] integerValue];
        NSInteger period = [smokingHabits[HabitsPeriodKey] integerValue];
        
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

//- (NSString *)packetSize
//{
//    NSString *packetSizeString;
//    
//    NSInteger size = [[NSUserDefaults standardUserDefaults] integerForKey:PacketSizeKey];
//    
//    if (size != 0) {
//        if (size > 1) {
//            packetSizeString = [[NSString stringWithFormat:@"%ld ", size] stringByAppendingString:MPString(@"cigarettes")];
//        }
//        else {
//            packetSizeString = [[NSString stringWithFormat:@"%ld ", size] stringByAppendingString:MPString(@"cigarette")];
//        }
//    }
//    else {
//        packetSizeString = nil;
//    }
//    
//    return packetSizeString;
//}
//
//- (NSString *)packetPrice
//{
//    NSString *packetPriceString;
//    
//    CGFloat price = [[NSUserDefaults standardUserDefaults] floatForKey:PacketPriceKey];
//    
//    if (price != 0.0) {
//        packetPriceString = [NSNumberFormatter localizedStringFromNumber:@(price)
//                                                             numberStyle:NSNumberFormatterCurrencyStyle];
//    }
//    else {
//        packetPriceString = nil;
//    }
//    
//    return packetPriceString;
//}

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
                    if ([actualDate compare:self.lastCigaretteDate] != NSOrderedSame) {
                        self.lastCigaretteDate = actualDate;
                        
                        [[NSUserDefaults standardUserDefaults] setObject:actualDate
                                                                  forKey:LastCigaretteKey];
                    }
                    
                    [self deleteRowsAtIndexPaths:@[newIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];
                }
                else {
                    if (self.lastCigaretteDate) {
                        self.lastCigaretteDatePicker.date = self.lastCigaretteDate;
                    }
                    else {
                        self.lastCigaretteDatePicker.date = [NSDate date];
                    }
                    
                    [self insertRowsAtIndexPaths:@[newIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];
                }
            }
            break;

        case 1:
            if (row == 0) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:++row
                                                               inSection:section];
                
                if ([self isRowVisible:newIndexPath]) {
                    NSDictionary *habits = @{
                                             HabitsQuantityKey: @([self.smokingHabitsPickerView selectedRowInComponent:0] + 1),
                                             HabitsUnitKey: @([self.smokingHabitsPickerView selectedRowInComponent:1]),
                                             HabitsPeriodKey: @([self.smokingHabitsPickerView selectedRowInComponent:2])
                                             };
                    if (![habits isEqualToDictionary:self.smokingHabits]) {
                        [[NSUserDefaults standardUserDefaults] setObject:habits
                                                                  forKey:HabitsKey];
                    }
                    
                    [self deleteRowsAtIndexPaths:@[newIndexPath]
                                withRowAnimation:UITableViewRowAnimationTop];
                }
                else {
                    if (self.smokingHabits) {
                        NSInteger quantity = [self.smokingHabits[HabitsQuantityKey] integerValue];
                        NSInteger unit = [self.smokingHabits[HabitsUnitKey] integerValue];
                        NSInteger period = [self.smokingHabits[HabitsPeriodKey] integerValue];
                        
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
                }
            }
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
    // TODO: create constants to get rid of magic numbers.
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
                             HabitsQuantityKey: @([self.smokingHabitsPickerView selectedRowInComponent:0] + 1),
                             HabitsUnitKey: @([self.smokingHabitsPickerView selectedRowInComponent:1]),
                             HabitsPeriodKey: @([self.smokingHabitsPickerView selectedRowInComponent:2])
                             };
    
    self.smokingHabitsLabel.text = [self formattedStringFromSmokingHabits:habits];
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
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
                              forKey:PacketSizeKey];
        }
        else {
            [userDefaults removeObjectForKey:PacketSizeKey];
            
            self.packetSizeTextField.text = @"";
        }
    }
}

@end
