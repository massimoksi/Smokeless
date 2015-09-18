//
//  HealthTableViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 14/02/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

#import "HealthTableViewController.h"

@import SmokelessKit;

#import "Smokeless-Swift.h"


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
    
    [[AchievementsManager sharedManager] updateForDate:[[SmokelessManager sharedManager] lastCigaretteDate]];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:[[AchievementsManager sharedManager] nextAchievementIndex]
                                                     inSection:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:nextIndexPath
                              atScrollPosition:UITableViewRowAnimationTop
                                      animated:YES];
    });
}

#pragma mark - Private methods

- (NSString *)timeIntervalForAchievement:(Achievement *)achievement
{
    if (achievement.years) {
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%d year(s)", nil), achievement.years];
    }
    else if (achievement.months) {
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%d month(s)", nil), achievement.months];
    }
    else if (achievement.weeks) {
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%d week(s)", nil), achievement.weeks];
    }
    else if (achievement.days) {
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%d day(s)", nil), achievement.days];
    }
    else if (achievement.hours) {
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%d hour(s)", nil), achievement.hours];
    }
    else if (achievement.minutes) {
        return [NSString localizedStringWithFormat:NSLocalizedString(@"%d minute(s)", nil), achievement.minutes];
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

    NSDate *lastCigaretteDate = [SmokelessManager sharedManager].lastCigaretteDate;

    CGFloat percentage = [achievement completionPercentageFromDate:lastCigaretteDate];
    cell.completionProgressView.value = percentage;
    
    if (achievement.isCompleted) {
        cell.backgroundColor = [UIColor slk_backgroundCompletedColor];
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
