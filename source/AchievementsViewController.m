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
- (void)registerLocalNotifications;

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
        
        // register observers
        [[PreferencesManager sharedManager] addObserver:self
                                             forKeyPath:@"prefs.LastCigarette"
                                                options:0
                                                context:NULL];
        [[PreferencesManager sharedManager] addObserver:self
                                             forKeyPath:@"prefs.NotificationsEnabled"
                                                options:0
                                                context:NULL];
        
#ifdef DEBUG
        NSLog(@"%@ - Local notifications: %@", [self class], [[UIApplication sharedApplication] scheduledLocalNotifications]);
#endif
    }
    
    return self;
}

- (void)dealloc
{
    // remove observers
    [[PreferencesManager sharedManager] removeObserver:self
                                            forKeyPath:@"prefs.LastCigarette"];
    [[PreferencesManager sharedManager] removeObserver:self
                                            forKeyPath:@"prefs.NotificationsEnabled"];
    
    // release achievements array
    self.achievements = nil;
    
    [super dealloc];
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	// set background
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
	self.view.backgroundColor = [UIColor clearColor];
    
    // get rid of the separator libe between cells
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // create the footer for the table view
    UILabel *rightsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    rightsLabel.backgroundColor = [UIColor clearColor];
    rightsLabel.font = [UIFont systemFontOfSize:11.0];
    rightsLabel.textAlignment = UITextAlignmentCenter;
    rightsLabel.textColor = [UIColor colorWithWhite:0.280 alpha:1.000];
    rightsLabel.shadowColor = [UIColor colorWithWhite:0.850 alpha:1.000];
    rightsLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    rightsLabel.numberOfLines = 3;
    
    rightsLabel.text = MPString(@"2007 Wade Meredith - All rights reserved - \"What happens to Your Body If You Stop Smoking Right Now?\" on Healthbolt.net");
    
    self.tableView.tableFooterView = rightsLabel;
    [rightsLabel release];

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
    
    // update the table view
    [self.tableView reloadData];
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
    
    // retrieve achievement
    Achievement *step = [self.achievements objectAtIndex:indexPath.row];
    
    // setup cell
    cell.textLabel.text = [NSString stringWithFormat:MPString(@"After %@"), [step timeInterval]];
    cell.detailTextLabel.text = MPString(step.text);
    
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
            
            cell.textLabel.textColor = [UIColor colorWithWhite:0.160 alpha:1.000];
            cell.textLabel.shadowColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
            
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.150 alpha:1.000];
            cell.detailTextLabel.shadowColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            cell.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
            
            cell.imageView.image = [UIImage imageNamed:@"AchievementCompleted"];
            break;
        
        case AchievementStatePending:
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealthTableViewCell_completed"]] autorelease];

            cell.textLabel.textColor = [UIColor colorWithWhite:0.160 alpha:1.000];
            cell.textLabel.shadowColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
            
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.150 alpha:1.000];
            cell.detailTextLabel.shadowColor = [UIColor colorWithWhite:0.600 alpha:1.000];
            cell.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);

            // set completion image
            NSUInteger completionStep = [currStep completionPercentageFromDate:[[PreferencesManager sharedManager] lastCigaretteDate]] / 0.125;
            switch (completionStep) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"AchievementPending0"];
                    break;
                    
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"AchievementPending1"];
                    break;
                    
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"AchievementPending2"];
                    break;
                    
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"AchievementPending3"];
                    break;
                    
                case 4:
                    cell.imageView.image = [UIImage imageNamed:@"AchievementPending4"];
                    break;
                    
                case 5:
                    cell.imageView.image = [UIImage imageNamed:@"AchievementPending5"];
                    break;
                    
                case 6:
                    cell.imageView.image = [UIImage imageNamed:@"AchievementPending6"];
                    break;
                    
                case 7:
                    cell.imageView.image = [UIImage imageNamed:@"AchievementPending7"];
                    break;
            }
            break;
        
        case AchievementStateNext:
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealthTableViewCell_next"]] autorelease];

            cell.textLabel.textColor = [UIColor colorWithWhite:0.300 alpha:1.000];
            cell.textLabel.shadowColor = [UIColor colorWithWhite:1.000 alpha:1.000];
            cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
            
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.350 alpha:1.000];
            cell.detailTextLabel.shadowColor = [UIColor colorWithWhite:1.000 alpha:1.000];
            cell.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);

            cell.imageView.image = [UIImage imageNamed:@"AchievementWaiting"];
            break;

        case AchievementStateNone:
        case AchievementStateWaiting:
            cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HealthTableViewCell_waiting"]] autorelease];
            
            cell.textLabel.textColor = [UIColor colorWithWhite:0.300 alpha:1.000];
            cell.textLabel.shadowColor = [UIColor colorWithWhite:1.000 alpha:1.000];
            cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
            
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.350 alpha:1.000];
            cell.detailTextLabel.shadowColor = [UIColor colorWithWhite:1.000 alpha:1.000];
            cell.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
            
            cell.imageView.image = [UIImage imageNamed:@"AchievementWaiting"];
            break;
    }
}

#pragma mark - Key-Value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // last cigarette date was changed
    if ([keyPath isEqualToString:@"prefs.LastCigarette"]) {
#ifdef DEBUG
        NSLog(@"%@ - Last cigarette date was changed", [self class]);
#endif
        
        // cancel all local notifications
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // check achievements state
        [self checkAchievementsState];
        
        // register local notifications
        [self registerLocalNotifications];
        
        return;
    }
    
    // notification enabled was changed
    if ([keyPath isEqualToString:@"prefs.NotificationsEnabled"]) {
#ifdef DEBUG
        NSLog(@"%@ - Notifications enabled was changed", [self class]);
#endif
        
        // cancel old local notifications
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // register local notifications
        [self registerLocalNotifications];
        
        return;
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
                        nextState = AchievementStateNext;
                        break;
                        
                    case AchievementStateNext:
                        nextState = AchievementStateWaiting;
                        
                    case AchievementStateWaiting:
                        nextState = AchievementStateNone;
                        break;
                }
            }        
        }
    }
}

- (void)registerLocalNotifications
{
    if ([[[PreferencesManager sharedManager].prefs objectForKey:NOTIFICATIONS_ENABLED_KEY] boolValue] == YES) {
        NSDate *lastCigaretteDate = [[PreferencesManager sharedManager] lastCigaretteDate];
        
        for (Achievement *step in self.achievements) {
            if (step.state != AchievementStateCompleted) {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.alertBody = MPString(@"Congratulations! You reached a new achievement.");
                notification.alertAction = MPString(@"Show me");
                notification.soundName = UILocalNotificationDefaultSoundName;
                
                // set fire date to 8:00AM of the next day
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDate *completionDate = [step completionDateFromDate:lastCigaretteDate];
                NSDateComponents *completionDateComponents = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit)
                                                                                  fromDate:completionDate];
                [completionDateComponents setHour:8];
                notification.fireDate = [gregorianCalendar dateFromComponents:completionDateComponents];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                [gregorianCalendar release];
                
                // schedule the local notifications
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];            
                [notification release];
            }
        }
    }
    
#ifdef DEBUG
    NSLog(@"%@ - New local notifications: %@", [self class], [[UIApplication sharedApplication] scheduledLocalNotifications]);
#endif
}

@end
