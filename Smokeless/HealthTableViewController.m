//
//  HealthTableViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 14/02/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

#import "HealthTableViewController.h"

#import "Constants.h"

#import "Smokeless-Swift.h"
#import "TTTLocalizedPluralString.h"


@implementation HealthTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64.0;
}

#pragma mark - Private methods

- (NSString *)timeIntervalForAchievement:(Achievement *)achievement
{
    if (achievement.years) {
        return TTTLocalizedPluralString(achievement.years, @"year", nil);
    }
    else if (achievement.months) {
        return TTTLocalizedPluralString(achievement.months, @"month", nil);
    }
    else if (achievement.weeks) {
        return TTTLocalizedPluralString(achievement.weeks, @"week", nil);
    }
    else if (achievement.days) {
        return TTTLocalizedPluralString(achievement.days, @"day", nil);
    }
    else if (achievement.hours) {
        return TTTLocalizedPluralString(achievement.hours, @"hour", nil);
    }
    else if (achievement.minutes) {
        return TTTLocalizedPluralString(achievement.minutes, @"minute", nil);
    }
    else {
        return nil;
    }
}

- (CGFloat)completionPercentageForAchievement:(Achievement *)achievement
{
    CGFloat percentage = 0.0;
    
    NSDate *lastCigaretteDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastCigaretteKey];
    
    if (lastCigaretteDate) {
        NSDate *completionDate = [achievement completionDateFromDate:lastCigaretteDate];
    
        NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
        NSInteger totalDays = [[gregorianCalendar components:NSCalendarUnitDay
                                                    fromDate:lastCigaretteDate
                                                      toDate:completionDate
                                                     options:0] day];
        NSInteger elapsedDays = [[gregorianCalendar components:NSCalendarUnitDay
                                                      fromDate:lastCigaretteDate
                                                        toDate:[NSDate date]
                                                       options:0] day];
    
        if (elapsedDays >= totalDays) {
            percentage = 1.0;
        }
        else {
            percentage = (CGFloat)elapsedDays / (CGFloat)totalDays;
        }
    }
    
    return percentage;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return AchievementsManager.sharedManager.achievements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AchievementCell"
                                                            forIndexPath:indexPath];
    
    Achievement *achievement = AchievementsManager.sharedManager.achievements[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"After %@", nil), [self timeIntervalForAchievement:achievement]] ;
    cell.subtitleLabel.text = achievement.text;

    CGFloat percentage = [self completionPercentageForAchievement:achievement];
    cell.completionProgressView.value = percentage;
    
    return cell;
}

@end
