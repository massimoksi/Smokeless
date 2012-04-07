//
//  AchievementsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 02/04/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import "AchievementsViewController.h"

#import "PreferencesManager.h"

#import "Achievement.h"


@interface AchievementsViewController ()

@property (nonatomic, retain) NSArray *achievements;

- (void)checkAchievementsState;

@end

@implementation AchievementsViewController

@synthesize achievements = _achievements;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
        
        // create achievements
        self.achievements = [NSArray arrayWithObjects:
                             step1,
                             step2,
                             step3,
                             step4,
                             step5,
                             step6,
                             step7,
                             step8,
                             nil];
        
        // relase objects
        [step1 release];
        [step2 release];
        [step3 release];
        [step4 release];
        [step5 release];
        [step6 release];
        [step7 release];
        [step8 release];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// set background
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
	self.view.backgroundColor = [UIColor clearColor];
    
    // get rid of the separator libe between cells
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // retrieve state for all achievements
    [self checkAchievementsState];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.achievements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        
        // inhibit selection
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // customize text label
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        
        // customize detail text label
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        cell.detailTextLabel.numberOfLines = 3;
    }
    
//    // retrieve achievement
//    Achievement *step = [self.achievements objectAtIndex:indexPath.row];
//    
//    // setup cell
//    cell.textLabel.text = [NSString stringWithFormat:MPString(@"After %@"), [step timeInterval]];
//    cell.detailTextLabel.text = MPString(step.text);
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Achievement *currStep = [self.achievements objectAtIndex:indexPath.row];
    
    switch (currStep.state) {
        case AchievementStateCompleted:
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealthTableViewCell_completed"]] autorelease];
            break;
            
        case AchievementStatePending:
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealthTableViewCell_pending"]] autorelease];
            break;

        case AchievementStateNone:
        case AchievementStateWaiting:
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealthTableViewCell_waiting"]] autorelease];
            break;
    }
}

#pragma mark - Private methods

- (void)checkAchievementsState
{
    // get last cigarette date
    NSDate *lastCigaretteDate = [[PreferencesManager sharedManager] lastCigaretteDate];
    
    // set achievement state
    if (lastCigaretteDate == nil) {
        for (Achievement *step in self.achievements) {
            step.state = AchievementStateNone;
        }
    }
    else {
        AchievementState nextState = AchievementStatePending;
        for (Achievement *step in self.achievements) {
            if ([step isCompletedFromDate:lastCigaretteDate]) {
                step.state = AchievementStateCompleted;
            }
            else {
                step.state = nextState;
                
                switch (nextState) {
                    default:
                    case AchievementStateNone:
                    case AchievementStateCompleted:
                        break;
                        
                    case AchievementStatePending:
                        nextState = AchievementStateWaiting;
                        break;
                        
                    case AchievementStateWaiting:
                        nextState = AchievementStateNone;
                        break;
                }
            }        
        }
    }
}

@end
