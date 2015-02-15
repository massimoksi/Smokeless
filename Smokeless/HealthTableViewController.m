//
//  HealthTableViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 14/02/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

#import "HealthTableViewController.h"

#import "Smokeless-Swift.h"
#import "TTTLocalizedPluralString.h"

#import "Achievement.h"


@interface HealthTableViewController ()

@property (strong, nonatomic) NSArray *targets;

@end


@implementation HealthTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64.0;
    
    Target *step1 = [[Target alloc] init];
    step1.days = 2;
    step1.text = NSLocalizedString(@"All nicotine will have left your body. Your sense of taste and smell will return to a normal level.", nil);
    
    Target *step2 = [[Target alloc] init];
    step2.days = 3;
    step2.text = NSLocalizedString(@"Your bronchial tubes will relax, and your over-all energy will rise.", nil);
    
    Target *step3 = [[Target alloc] init];
    step3.weeks = 2;
    step3.text = NSLocalizedString(@"Your circulation will increase, and it will continue improving for the next 10 weeks.", nil);
    
    Target *step4 = [[Target alloc] init];
    step4.months = 9;
    step4.text = NSLocalizedString(@"Coughs, wheezing and breathing problems will dissipate as your lung capacity improves by 10%.", nil);
    
    Target *step5 = [[Target alloc] init];
    step5.years = 1;
    step5.text = NSLocalizedString(@"Your risk of having a heart attack will have now dropped by half.", nil);
    
    Target *step6 = [[Target alloc] init];
    step6.years = 5;
    step6.text = NSLocalizedString(@"Your risk of having a stroke returns to that of a non-smoker.", nil);
    
    Target *step7 = [[Target alloc] init];
    step7.years = 10;
    step7.text = NSLocalizedString(@"Your risk of lung cancer will have returned to that of a non-smoker.", nil);
    
    Target *step8 = [[Target alloc] init];
    step8.years = 15;
    step8.text = NSLocalizedString(@"Your risk of heart attack will have returned to that of a non-smoker.", nil);
    
    _targets = @[step1, step2, step3, step4, step5, step6, step7, step8];
}

#pragma mark - Private methods

- (NSString *)timeIntervalForTarget:(Target *)target
{
    if (target.years) {
        return TTTLocalizedPluralString(target.years, @"year", nil);
    }
    else if (target.months) {
        return TTTLocalizedPluralString(target.months, @"month", nil);
    }
    else if (target.weeks) {
        return TTTLocalizedPluralString(target.weeks, @"week", nil);
    }
    else if (target.days) {
        return TTTLocalizedPluralString(target.days, @"day", nil);
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
    return self.targets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AchievementCell"
                                                            forIndexPath:indexPath];
    
    Target *target = self.targets[indexPath.row];
    cell.titleLabel.text = [self timeIntervalForTarget:target];
    cell.subtitleLabel.text = target.text;
    
    return cell;
}

@end
