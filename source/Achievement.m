//
//  Achievement.m
//  Smokeless
//
//  Created by Massimo Peri on 26/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "Achievement.h"


#define COMPLETION_DATE_HOUR    8
#define COMPLETION_DATE_MINUTE  0


@implementation Achievement

- (id)init
{
    self = [super init];
    if (self) {
        self.years = 0;
        self.months = 0;
        self.weeks = 0;
        self.days = 0;
    }
    
    return self;
}

- (void)dealloc
{
    self.text = nil;
    
    [super dealloc];
}

#pragma mark Accessors

@synthesize state = _state;
@synthesize years = _years;
@synthesize months = _months;
@synthesize weeks = _weeks;
@synthesize days = _days;
@synthesize text = _text;

- (NSString *)timeInterval
{
    NSString *timeInterval = @"";
    
    // create time interval
    if (self.years != 0) {
        timeInterval = (self.years != 1) ? [NSString stringWithFormat:MPString(@"%d years"), self.years] : [NSString stringWithFormat:MPString(@"%d year"), self.years];
    }
    if (self.months != 0) {
        timeInterval = (self.months != 1) ? [NSString stringWithFormat:MPString(@"%d months"), self.months] : [NSString stringWithFormat:MPString(@"%d month"), self.months];
    }
    if (self.weeks != 0) {
        timeInterval = (self.weeks != 1) ? [NSString stringWithFormat:MPString(@"%d weeks"), self.weeks] : [NSString stringWithFormat:MPString(@"%d week"), self.weeks];
    }
    if (self.days != 0) {
        timeInterval = (self.days != 1) ? [NSString stringWithFormat:MPString(@"%d days"), self.days] : [NSString stringWithFormat:MPString(@"%d day"), self.days];
    }
    
    return timeInterval;
}

- (NSDate *)completionDateFromDate:(NSDate *)startingDate
{
    // create date components
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:self.years];
    [dateComps setMonth:self.months];
    [dateComps setWeek:self.weeks];
    [dateComps setDay:self.days];
    
    // get last cigarette date from preferences
    if (startingDate == nil) {
        [dateComps release];
        
        return nil;
    }

    // create gregorian calendar
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    // calculate completion date
    NSDate *completionDate = [gregorianCalendar dateByAddingComponents:dateComps
                                                                toDate:startingDate
                                                               options:0];
    [dateComps release];

    // adjust completion date hour
//    NSDateComponents *completionDateComps = [gregorianCalendar components:(NSYearCalendarUnit |
//                                                                           NSMonthCalendarUnit |
//                                                                           NSWeekCalendarUnit |
//                                                                           NSDayCalendarUnit |
//                                                                           NSHourCalendarUnit |
//                                                                           NSMinuteCalendarUnit)
//                                                                 fromDate:completionDate];
//    [completionDateComps setHour:COMPLETION_DATE_HOUR];
//    [completionDateComps setMinute:COMPLETION_DATE_MINUTE];
//
//    completionDate = [gregorianCalendar dateFromComponents:completionDateComps];
    
    // release gregorian calendar
    [gregorianCalendar release];

#ifdef DEBUG
    NSLog(@"%@ - Completation date: %@", [self class], completionDate);
#endif
    
    return completionDate;
}

- (BOOL)isCompletedFromDate:(NSDate *)startingDate
{
    // get completion date
    NSDate *completionDate = [self completionDateFromDate:startingDate];
    if (completionDate == nil) {
        return NO;
    }
    
    // compare completion date with today
    if ([completionDate compare:[NSDate date]] == NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

- (CGFloat)completionPercentageFromDate:(NSDate *)startingDate
{
    NSDate *completionDate = [self completionDateFromDate:startingDate];
    NSDate *today = [NSDate date];

    if (completionDate == nil) {
        return 0.0;
    }

    // create gregorian calendar
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger totalDays = [[gregorianCalendar components:NSDayCalendarUnit
                                                fromDate:startingDate
                                                  toDate:completionDate
                                                 options:0] day];
    NSInteger elapsedDays = [[gregorianCalendar components:NSDayCalendarUnit
                                                  fromDate:startingDate
                                                    toDate:today
                                                   options:0] day];
    
    // release gregorian calendar
    [gregorianCalendar release];
    
#ifdef DEBUG
    NSLog(@"%@ - Total days: %d", [self class], totalDays);
    NSLog(@"%@ - Elapsed days: %d", [self class], elapsedDays);
#endif
    
    if (elapsedDays >= totalDays) {
        return 0.0;
    }
    else {
        CGFloat percentage = (CGFloat)elapsedDays / (CGFloat)totalDays;

#ifdef DEBUG
        NSLog(@"%@ - Completion percentage: %f", [self class], percentage);
#endif
        
        return percentage;
    }
}

@end
