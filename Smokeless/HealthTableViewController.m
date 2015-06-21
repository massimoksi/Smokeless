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


@interface HealthTableViewController ()

@property (strong, nonatomic) NSArray *achievements;

@end


@implementation HealthTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64.0;
    
    Achievement *step1 = [[Achievement alloc] init];
    step1.days = 2;
    step1.text = NSLocalizedString(@"All nicotine will have left your body. Your sense of taste and smell will return to a normal level.", nil);
    
    Achievement *step2 = [[Achievement alloc] init];
    step2.days = 3;
    step2.text = NSLocalizedString(@"Your bronchial tubes will relax, and your over-all energy will rise.", nil);
    
    Achievement *step3 = [[Achievement alloc] init];
    step3.weeks = 2;
    step3.text = NSLocalizedString(@"Your circulation will increase, and it will continue improving for the next 10 weeks.", nil);
    
    Achievement *step4 = [[Achievement alloc] init];
    step4.months = 9;
    step4.text = NSLocalizedString(@"Coughs, wheezing and breathing problems will dissipate as your lung capacity improves by 10%.", nil);
    
    Achievement *step5 = [[Achievement alloc] init];
    step5.years = 1;
    step5.text = NSLocalizedString(@"Your risk of having a heart attack will have now dropped by half.", nil);
    
    Achievement *step6 = [[Achievement alloc] init];
    step6.years = 5;
    step6.text = NSLocalizedString(@"Your risk of having a stroke returns to that of a non-smoker.", nil);
    
    Achievement *step7 = [[Achievement alloc] init];
    step7.years = 10;
    step7.text = NSLocalizedString(@"Your risk of lung cancer will have returned to that of a non-smoker.", nil);
    
    Achievement *step8 = [[Achievement alloc] init];
    step8.years = 15;
    step8.text = NSLocalizedString(@"Your risk of heart attack will have returned to that of a non-smoker.", nil);
    
    self.achievements = @[step1, step2, step3, step4, step5, step6, step7, step8];
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
    else {
        return nil;
    }
}

- (CGFloat)completionPercentageForAchievement:(Achievement *)achievement
{
    NSDate *today = [NSDate date];
    NSDate *lastCigaretteDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastCigaretteKey];
    
    NSDate *completionDate = [achievement completionDateFromDate:lastCigaretteDate];
    if (!completionDate) {
        return 0.0;
    }
    
    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger totalDays = [[gregorianCalendar components:NSCalendarUnitDay
                                                fromDate:lastCigaretteDate
                                                  toDate:completionDate
                                                 options:0] day];
    NSInteger elapsedDays = [[gregorianCalendar components:NSCalendarUnitDay
                                                  fromDate:lastCigaretteDate
                                                    toDate:today
                                                   options:0] day];
    
    if (elapsedDays >= totalDays) {
        return 1.0;
    }
    else {
        CGFloat percentage = (CGFloat)elapsedDays / (CGFloat)totalDays;
        
        return percentage;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.achievements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AchievementCell"
                                                            forIndexPath:indexPath];
    
    Achievement *achievement = self.achievements[indexPath.row];
    cell.completionProgressView.value = [self completionPercentageForAchievement:achievement];
    cell.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"After %@", nil), [self timeIntervalForAchievement:achievement]] ;
    cell.subtitleLabel.text = achievement.text;
    
    return cell;
}

@end
