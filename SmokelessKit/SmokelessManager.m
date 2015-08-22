//
//  SmokelessManager.m
//  Smokeless
//
//  Created by Massimo Peri on 20/08/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

#import "SmokelessManager.h"

#import "Constants.h"


#if DEBUG
static NSString * const SLKAppGroupID           = @"group.com.gmail.massimoperi.Smokeless-debug";
#else
static NSString * const SLKAppGroupID           = @"group.com.gmail.massimoperi.Smokeless";
#endif

static NSString * const SLKLastCigaretteKey     = @"SLKLastCigarette";
static NSString * const SLKHabitsKey            = @"SLKHabits";
//static NSString * const SLKHabitsQuantityKey           = @"SLKHabitsQuantity";
//static NSString * const SLKHabitsUnitKey               = @"SLKHabitsUnit";
//static NSString * const SLKHabitsPeriodKey             = @"SLKHabitsPeriod";
static NSString * const SLKPacketSizeKey        = @"SLKPacketSize";
static NSString * const SLKPacketPriceKey       = @"SLKPacketPrice";


@interface SmokelessManager ()

@property (nonatomic, readonly) NSUserDefaults *userSettings;

@end


@implementation SmokelessManager

+ (instancetype)sharedManager
{
    static id _sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastCigaretteDate = [self.userSettings objectForKey:SLKLastCigaretteKey];
        _smokingHabits = [self.userSettings dictionaryForKey:SLKHabitsKey];
        _packetSize = [self.userSettings integerForKey:SLKPacketSizeKey];
        _packetPrice = [self.userSettings doubleForKey:SLKPacketPriceKey];
    }
    
    return self;
}

#pragma mark - Properties

@synthesize lastCigaretteDate = _lastCigaretteDate;
@synthesize smokingHabits = _smokingHabits;
@synthesize packetSize = _packetSize;
@synthesize packetPrice = _packetPrice;

- (NSDate *)lastCigaretteDate
{
    return _lastCigaretteDate;
}

- (void)setLastCigaretteDate:(NSDate *)lastCigaretteDate
{
    if (![lastCigaretteDate isEqualToDate:_lastCigaretteDate]) {
        _lastCigaretteDate = lastCigaretteDate;
        
        if (_lastCigaretteDate) {
            [self.userSettings setObject:_lastCigaretteDate
                                  forKey:SLKLastCigaretteKey];
        }
        else {
            [self.userSettings removeObjectForKey:SLKLastCigaretteKey];
        }
    }
}

- (NSDictionary *)smokingHabits
{
    return _smokingHabits;
}

- (void)setSmokingHabits:(NSDictionary *)smokingHabits
{
    if (![smokingHabits isEqualToDictionary:_smokingHabits]) {
        _smokingHabits = smokingHabits;
        
        if (_smokingHabits) {
            [self.userSettings setObject:_smokingHabits
                                  forKey:SLKHabitsKey];
        }
        else {
            [self.userSettings removeObjectForKey:SLKHabitsKey];
        }
    }
}

- (NSInteger)packetSize
{
    return _packetSize;
}

- (void)setPacketSize:(NSInteger)packetSize
{
    if (packetSize != _packetSize) {
        _packetSize = packetSize;
        
        if (packetSize > 0) {
            [self.userSettings setInteger:_packetSize
                                   forKey:SLKPacketSizeKey];
        }
        else {
            [self.userSettings removeObjectForKey:SLKPacketSizeKey];
        }
    }
}

- (double)packetPrice
{
    return _packetPrice;
}

- (void)setPacketPrice:(double)packetPrice
{
    if (packetPrice != _packetPrice) {
        _packetPrice = packetPrice;
        
        if (_packetPrice >= 0.0) {
            [self.userSettings setDouble:_packetPrice
                                  forKey:SLKPacketPriceKey];
        }
        else {
            [self.userSettings removeObjectForKey:SLKPacketPriceKey];
        }
    }
}

#pragma mark -

- (NSUserDefaults *)userSettings
{
    static NSUserDefaults *_userSettings = nil;
    if (!_userSettings) {
        _userSettings = [[NSUserDefaults alloc] initWithSuiteName:SLKAppGroupID];
    }
    
    return _userSettings;
}

- (BOOL)isConfigured
{
    if (_lastCigaretteDate && _smokingHabits && (_packetSize > 0) && (_packetPrice > 0.0)) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSDateComponentsFormatter *)componentsFormatter
{
    NSDateComponentsFormatter *_componentsFormatter = nil;
    if (!_componentsFormatter) {
        _componentsFormatter = [[NSDateComponentsFormatter alloc] init];
        _componentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    }
    
    return _componentsFormatter;
}

- (NSNumberFormatter *)currencyFormatter
{
    NSNumberFormatter *_currencyFormatter = nil;
    if (!_currencyFormatter) {
        _currencyFormatter = [[NSNumberFormatter alloc] init];
        _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    return _currencyFormatter;
}

#pragma mark - Public methods

- (NSDateComponents *)lastCigaretteDateComponents
{
    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay;
    
    return [gregorianCalendar components:unitFlags
                                fromDate:self.lastCigaretteDate];
}

- (NSDateComponents *)nonSmokingInterval
{
    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay;
    
    return [gregorianCalendar components:unitFlags
                                fromDate:self.lastCigaretteDate
                                  toDate:[NSDate date]
                                 options:0];
}

- (NSString *)formattedNonSmokingInterval
{
    return [[self componentsFormatter] stringFromDateComponents:[self nonSmokingInterval]];
}

- (double)totalSavings
{
    double savings = 0.0;
    
    if (self.lastCigaretteDate) {
        // Calculate non smoking days.
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger nonSmokingDays = [[gregorianCalendar components:NSCalendarUnitDay
                                                         fromDate:self.lastCigaretteDate
                                                           toDate:[NSDate date]
                                                          options:0] day];
        
        if (self.smokingHabits) {
            NSInteger quantity = [self.smokingHabits[SLKHabitsQuantityKey] integerValue];
            NSInteger unit = ([self.smokingHabits[SLKHabitsUnitKey] integerValue] == 0) ? 1 : self.packetSize;
            NSInteger period = ([self.smokingHabits[SLKHabitsPeriodKey] integerValue] == 0) ? 1 : 7;
            
            // Calculate the number of cigarettes/day.
            double cigarettesPerDay = quantity * unit / period;
            
            // Calculate the number of saved cigarettes.
            double totalCigarettes = nonSmokingDays * cigarettesPerDay;
            
            // Calculate the number of saved packets.
            // +1 beacuse in the moment you quit smoking you save the first packet.
            NSInteger totalPackets = totalCigarettes / self.packetSize + 1;
            
#if DEBUG
            NSLog(@"Savings - Total packets: %ld.", (long)totalPackets);
#endif
            
            // Calculate the total savings.
            savings = totalPackets * self.packetPrice;
        }
    }
    
    return savings;
}

- (NSString *)formattedTotalSavings
{
    return [[self currencyFormatter] stringFromNumber:@([self totalSavings])];
}

@end
