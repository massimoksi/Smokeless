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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AchievementsManager sharedManager] updateForDate:[[NSUserDefaults standardUserDefaults] objectForKey:kLastCigaretteKey]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:[[AchievementsManager sharedManager] nextAchievementIndex]
                                                     inSection:0];
    [self.tableView scrollToRowAtIndexPath:nextIndexPath
                          atScrollPosition:UITableViewRowAnimationTop
                                  animated:YES];
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

    NSDate *lastCigaretteDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastCigaretteKey];

    CGFloat percentage = [achievement completionPercentageFromDate:lastCigaretteDate];
    cell.completionProgressView.value = percentage;
    
    if (achievement.isCompleted) {
        cell.backgroundColor = [UIColor sml_backgroundCompletedColor];
    }
    else {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset.
    cell.separatorInset = UIEdgeInsetsZero;

    // Prevent the cell from inheriting the table view's margin settings.
    cell.preservesSuperviewLayoutMargins = NO;

    // Explictly set your cell's layout margins.
    cell.layoutMargins = UIEdgeInsetsZero;
}

@end
