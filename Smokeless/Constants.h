//
//  Constants.h
//  Smokeless
//
//  Created by Massimo Peri on 20/01/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

@import UIKit;


extern NSString * const kLastCigaretteKey;
extern NSString * const kHabitsKey;
extern NSString * const kHabitsQuantityKey;
extern NSString * const kHabitsUnitKey;
extern NSString * const kHabitsPeriodKey;
extern NSString * const kPacketSizeKey;
extern NSString * const kPacketPriceKey;
extern NSString * const kPlaySoundsKey;
extern NSString * const kNotificationsEnabledKey;
extern NSString * const kUserSettingsImportedKey;
extern NSString * const kHasUpdatedLastCigaretteDateKey;
extern NSString * const kLastSavingsKey;


@interface UIColor (Smokeless)

+ (UIColor *)sml_backgroundDarkColor;
+ (UIColor *)sml_backgroundLightColor;
+ (UIColor *)sml_highlightColor;
+ (UIColor *)sml_completedColor;
+ (UIColor *)sml_detailTextColor;

@end
