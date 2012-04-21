//
//  PreferencesManager.h
//  Smokeless
//
//  Created by Massimo Peri on 26/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LAST_CIGARETTE_KEY          @"LastCigarette"
#define HABITS_KEY                  @"Habits"
#define HABITS_QUANTITY_KEY         @"HabitsQuantity"
#define HABITS_UNIT_KEY             @"HabitsUnit"
#define HABITS_PERIOD_KEY           @"HabitsPeriod"
#define PACKET_SIZE_KEY             @"PacketSize"
#define PACKET_PRICE_KEY            @"PacketPrice"
#define SHAKE_ENABLED_KEY           @"ShakeEnabled"
#define NOTIFICATIONS_ENABLED_KEY   @"NotificationsEnabled"


@interface PreferencesManager : NSObject

@property (nonatomic, retain) NSMutableDictionary *prefs;
@property (nonatomic, copy) NSString *path;

+ (PreferencesManager *)sharedManager;

- (void)loadPrefs;
- (void)savePrefs;
- (void)deletePrefs;

- (NSDate *)lastCigaretteDate;
- (NSDateComponents *)nonSmokingInterval;
- (NSInteger)nonSmokingDays;
- (NSUInteger)totalPackets;
- (CGFloat)totalSavings;

@end
