//
//  HealthTableViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 14/02/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

#import "HealthTableViewController.h"

#import "Smokeless-Swift.h"

#import "Achievement.h"


@interface HealthTableViewController ()

@property (strong, nonatomic) NSArray *achievements;

@end


@implementation HealthTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Achievement *step1 = [[Achievement alloc] init];
    step1.days = 2;
    step1.text = @"All nicotine will have left your body. Your sense of taste and smell will return to a normal level.";
    
    Achievement *step2 = [[Achievement alloc] init];
    step2.days = 3;
    step2.text = @"Your bronchial tubes will relax, and your over-all energy will rise.";
    
    Achievement *step3 = [[Achievement alloc] init];
    step3.weeks = 2;
    step3.text = @"Your circulation will increase, and it will continue improving for the next 10 weeks.";
    
    Achievement *step4 = [[Achievement alloc] init];
    step4.months = 9;
    step4.text = @"Coughs, wheezing and breathing problems will dissipate as your lung capacity improves by 10%.";
    
    Achievement *step5 = [[Achievement alloc] init];
    step5.years = 1;
    step5.text = @"Your risk of having a heart attack will have now dropped by half.";
    
    Achievement *step6 = [[Achievement alloc] init];
    step6.years = 5;
    step6.text = @"Your risk of having a stroke returns to that of a non-smoker.";
    
    Achievement *step7 = [[Achievement alloc] init];
    step7.years = 10;
    step7.text = @"Your risk of lung cancer will have returned to that of a non-smoker.";
    
    Achievement *step8 = [[Achievement alloc] init];
    step8.years = 15;
    step8.text = @"Your risk of heart attack will have returned to that of a non-smoker.";
    
    _achievements = @[step1, step2, step3, step4, step5, step6, step7, step8];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64.0;
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
    cell.subtitleLabel.text = achievement.text;
    
    return cell;
}

@end
