//
//  Achievement.h
//  Smokeless
//
//  Created by Massimo Peri on 26/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    AchievementStateNone = 0,
    AchievementStateCompleted,
    AchievementStatePending,
    AchievementStateWaiting
} AchievementState;


@interface Achievement : NSObject

@property (nonatomic, assign) AchievementState state;
@property (nonatomic, assign) NSUInteger years;
@property (nonatomic, assign) NSUInteger months;
@property (nonatomic, assign) NSUInteger weeks;
@property (nonatomic, assign) NSUInteger days;
@property (nonatomic, copy) NSString *text;

- (NSString *)timeInterval;
- (NSDate *)completionDateFromDate:(NSDate *)startingDate;
- (BOOL)isCompletedFromDate:(NSDate *)startingDate;
- (CGFloat)completionPercentageFromDate:(NSDate *)startingDate;

@end
