//
//  SettingsTableViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 11/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SettingsTableViewController.h"

#import "Constants.h"


@interface SettingsTableViewController ()

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *lastCigaretteDate;

@property (weak, nonatomic) IBOutlet UILabel *lastCigaretteDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *lastCigaretteDatePicker;

@end


@implementation SettingsTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.lastCigaretteDate = [[NSUserDefaults standardUserDefaults] objectForKey:LastCigaretteKey];
    if (self.lastCigaretteDate) {
        self.lastCigaretteDateLabel.text = [self.dateFormatter stringFromDate:self.lastCigaretteDate];
    }
    else {
        self.lastCigaretteDateLabel.text = @"";
    }
    
    self.lastCigaretteDatePicker.maximumDate = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated
{	
	[super viewWillAppear:animated];

    NSIndexPath *lastCigaretteDatePickerIndexPath = [NSIndexPath indexPathForRow:1
                                                                       inSection:0];
    
    [self deleteRowsAtIndexPaths:@[lastCigaretteDatePickerIndexPath]];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    
    self.lastCigaretteDate = nil;
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

//- (NSString *)lastCigaretteFormattedDate;
//{
//    return [NSDateFormatter localizedStringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:LastCigaretteKey]
//                                          dateStyle:NSDateFormatterLongStyle
//                                          timeStyle:NSDateFormatterNoStyle];
//}
//
//- (NSString *)smokingHabits
//{
//    NSString *habitsString;
//    
//    NSDictionary *habitsDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:HabitsKey];
//    if (habitsDict != nil) {
//        NSInteger quantity = [habitsDict[HabitsQuantityKey] integerValue];
//        NSInteger unit = [habitsDict[HabitsUnitKey] integerValue];
//        NSInteger period = [habitsDict[HabitsPeriodKey] integerValue];
//
//        NSString *unitString = nil;
//        switch (unit) {
//            case 0:
//                unitString = (quantity == 1) ?
//                MPString(@"cigarette") :
//                MPString(@"cigarettes");
//                break;
//                
//            case 1:
//                unitString = (quantity == 1) ?
//                MPString(@"packet") :
//                MPString(@"packets");
//                break;
//        }
//
//        NSString *periodString = nil;
//        switch (period) {
//            case 0:
//                periodString = MPString(@"a day");
//                break;
//                
//            case 1:
//                periodString = MPString(@"a week");
//                break;
//        }
//        
//        habitsString = [NSString stringWithFormat:@"%ld %@ %@", quantity, unitString, periodString];
//    }
//    else {
//        habitsString = nil;
//    }
//    
//    // TODO: shorten string.
//    return habitsString;
//}
//
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

#pragma mark - Table view data source

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
            
        default:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
}

@end
