//
//  Constants.m
//  Smokeless
//
//  Created by Massimo Peri on 20/01/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

#import "Constants.h"


NSString * const kLastCigaretteKey               = @"LastCigarette";
NSString * const kHabitsKey                      = @"Habits";
NSString * const kHabitsQuantityKey              = @"HabitsQuantity";
NSString * const kHabitsUnitKey                  = @"HabitsUnit";
NSString * const kHabitsPeriodKey                = @"HabitsPeriod";
NSString * const kPacketSizeKey                  = @"PacketSize";
NSString * const kPacketPriceKey                 = @"PacketPrice";
NSString * const kShakeEnabledKey                = @"ShakeEnabled";
NSString * const kNotificationsEnabledKey        = @"NotificationsEnabled";
NSString * const kUserSettingsImportedKey        = @"UserSettingsImported";
NSString * const kHasUpdatedLastCigaretteDateKey = @"HasUpdatedLastCigaretteDate";
NSString * const kLastSavingsKey                 = @"LastSavings";


@implementation UIColor (Smokeless)

+ (UIColor *)sml_backgroundDarkColor
{
    return [UIColor colorWithRed:136.0/255.0
                           green:201.0/255.0
                            blue:234.0/255.0
                           alpha:1.0];
}

+ (UIColor *)sml_backgroundLightColor
{
    return [UIColor colorWithRed:243.0/255.0
                           green:246.0/255.0
                            blue:247.0/255.0
                           alpha:1.0];
}

+ (UIColor *)sml_highlightColor
{
    return [UIColor colorWithRed:129.0/255.0
                           green:186.0/255.0
                            blue:255.0/255.0
                           alpha:1.0];
}

@end
