//
//  Constants.h
//  Smokeless
//
//  Created by Massimo Peri on 20/01/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

@import UIKit;


extern NSString * const SLKHabitsQuantityKey;
extern NSString * const SLKHabitsUnitKey;
extern NSString * const SLKHabitsPeriodKey;

extern NSString * const SLKPlaySoundsKey;
extern NSString * const SLKNotificationsEnabledKey;
extern NSString * const SLKLastSavingsKey;
extern NSString * const SLKSoftwareVersionKey;

extern NSString * const SLKAppStoreURL;


@interface UIColor (Smokeless)

// TODO: rename into slk_...
+ (UIColor *)sml_highlightColor;
+ (UIColor *)sml_detailTextColor;
+ (UIColor *)sml_completedColor;
+ (UIColor *)sml_cancelColor;
+ (UIColor *)sml_backgroundCompletedColor;

@end
