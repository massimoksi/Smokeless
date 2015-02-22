//
//  SavingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 10/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SavingsViewController.h"

#import "Constants.h"


#define ACCELERATION_THRESHOLD  2.0


@interface SavingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *savedMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *savedPacketsLabel;

@property (nonatomic, readonly) NSNumberFormatter *currencyFormatter;

@property (nonatomic, strong) NSDate *lastCigaretteDate;
@property (nonatomic, copy) NSDictionary *habits;
@property (nonatomic) CGFloat price;
@property (nonatomic) NSInteger size;
//
//@property (nonatomic, strong) AVAudioPlayer *tinklePlayer;
//
//@property (nonatomic) BOOL shakeEnabled;
@property (nonatomic) CGFloat totalSavings;
@property (nonatomic) NSUInteger totalPackets;

@end


@implementation SavingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    // Become first responder: it's necessary to react to shake gestures.
//    [self becomeFirstResponder];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.lastCigaretteDate = [userDefaults objectForKey:LastCigaretteKey];
    self.habits = [userDefaults dictionaryForKey:HabitsKey];
    self.price = [userDefaults floatForKey:PacketPriceKey];
    self.size = [userDefaults integerForKey:PacketSizeKey];

    if (self.habits && (self.price > 0.0) && self.size) {
        self.savedMoneyLabel.text = [self.currencyFormatter stringFromNumber:@(self.totalSavings)];
        self.savedPacketsLabel.text = [NSString stringWithFormat:@"%@", @(self.totalPackets)];
	}
    else {
        // TODO: implement.
    }

//    // Create the tinkle player.
//    if (!self.tinklePlayer) {
//        NSError *error;
//        self.tinklePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Tinkle"
//                                                                                                                                ofType:@"m4a"]]
//                                                                    error:&error];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors

//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}

- (NSNumberFormatter *)currencyFormatter
{
    static NSNumberFormatter *_currencyFormatter = nil;
    if (_currencyFormatter) {
        return _currencyFormatter;
    }
    
    _currencyFormatter = [[NSNumberFormatter alloc] init];
    _currencyFormatter.locale = [NSLocale currentLocale];
    _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    return _currencyFormatter;
}

#pragma mark - Private methods

- (NSInteger)nonSmokingDays
{
    NSInteger nonSmokingDays = 0;
    
    if (self.lastCigaretteDate) {
        // create gregorian calendar
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        nonSmokingDays = [[gregorianCalendar components:NSCalendarUnitDay
                                               fromDate:self.lastCigaretteDate
                                                 toDate:[NSDate date]
                                                options:0] day];
    }
    
    return nonSmokingDays;
}

- (NSUInteger)totalPackets
{
    NSUInteger totalPackets = 0;
    
    if (self.habits && self.lastCigaretteDate) {
        NSInteger quantity = [self.habits[HabitsQuantityKey] integerValue];
        NSInteger unit = [self.habits[HabitsUnitKey] integerValue];
        NSInteger period = [self.habits[HabitsPeriodKey] integerValue];
        
        // Calculate constants.
        NSInteger kUnit = (unit == 0) ? 1 : self.size;
        NSInteger kPeriod = (period == 0) ? 1 : 7;
        
        // Calculate the number of cigarettes/day.
        CGFloat cigarettesPerDay = quantity * kUnit / kPeriod;
        
        // Calculate the number of saved cigarettes.
        CGFloat totalCigarettes = [self nonSmokingDays] * cigarettesPerDay;
        
        // Calculate the number of saved packets.
        totalPackets = totalCigarettes / self.size + 1;
    }
    
    return totalPackets;
}

- (CGFloat)totalSavings
{
    return [self totalPackets] * self.price;
}

//#pragma mark - Accelerometer delegate
//
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
//{
//    if ((self.shakeEnabled == YES) && (self.totalSavings > 0.0)) {
//        if ((acceleration.x * acceleration.x) + (acceleration.y * acceleration.y) + (acceleration.z * acceleration.z) > ACCELERATION_THRESHOLD * ACCELERATION_THRESHOLD) {
//            if (self.tinklePlayer.playing == NO) {
//                [self.tinklePlayer play];
//            }
//        }
//    }
//}

@end
