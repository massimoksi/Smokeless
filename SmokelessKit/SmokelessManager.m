//
//  SmokelessManager.m
//  Smokeless
//
//  Created by Massimo Peri on 20/08/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

#import "SmokelessManager.h"


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

#pragma mark - Accessors

- (NSUserDefaults *)userSettings
{
    static NSUserDefaults *_userSettings = nil;
    if (!_userSettings) {
        _userSettings = [[NSUserDefaults alloc] initWithSuiteName:SLKAppGroupID];
    }
    
    return _userSettings;
}

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

@end
