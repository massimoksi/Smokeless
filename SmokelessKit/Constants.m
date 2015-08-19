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

NSString * const kPlaySoundsKey                  = @"PlaySounds";
NSString * const kNotificationsEnabledKey        = @"NotificationsEnabled";
NSString * const kLastSavingsKey                 = @"LastSavings";
NSString * const SLKSoftwareVersionKey           = @"SLKSoftwareVersion";

NSString * const kAppStoreURL                    = @"itms-apps://itunes.apple.com/app/id438027793";


#pragma mark - Custom colors


@implementation UIColor (Smokeless)

+ (UIColor *)sml_highlightColor
{
    return [UIColor colorWithRed:29.0/255.0
                           green:195.0/255.0
                            blue:255.0/255.0
                           alpha:1.0];
}

+ (UIColor *)sml_detailTextColor
{
    return [UIColor colorWithRed:122.0/255.0
                           green:122.0/255.0
                            blue:127.0/255.0
                           alpha:1.0];
}

+ (UIColor *)sml_completedColor
{
    return [UIColor colorWithRed:126.0/255.0
                           green:211.0/255.0
                            blue:33.0/255.0
                           alpha:1.0];
}

+ (UIColor *)sml_cancelColor
{
    return [UIColor colorWithRed:255.0/255.0
                           green:0.0/255.0
                            blue:0.0/255.0
                           alpha:1.0];
}

+ (UIColor *)sml_backgroundCompletedColor
{
    return [UIColor colorWithRed:247.0/255.0
                           green:247.0/255.0
                            blue:247.0/255.0
                           alpha:1.0];
}

@end
