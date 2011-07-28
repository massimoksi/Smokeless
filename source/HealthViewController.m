//
//  HealthViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 26/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "HealthViewController.h"

#import "HealthTableViewCell.h"


@implementation HealthViewController

- (id)init
{
    self = [super init];
    if (self) {
        // create navigation bar
        self.navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)] autorelease];
        [self.view addSubview:self.navBar];
        
        // set navigation bar title
        UINavigationItem *navTitle = [[UINavigationItem alloc] initWithTitle:MPString(@"Achievements and benefits")];
        [self.navBar pushNavigationItem:navTitle
                               animated:NO];
        [navTitle release];
        
        // create table view
        self.healthTableView = [[[HealthTableView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 411.0)] autorelease];
        self.healthTableView.delegate = self;
        self.healthTableView.dataSource = self;
        [self.view addSubview:self.healthTableView];

        // create cell shadow
        shadowLayer = [[CAGradientLayer alloc] init];
        shadowLayer.frame = CGRectMake(0.0, 0.0, 320.0, 5.0);
        CGColorRef darkColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.750].CGColor;
        CGColorRef lightColor = [UIColor colorWithRed:0.498 green:0.498 blue:0.546 alpha:0.000].CGColor;
        shadowLayer.colors = [NSArray arrayWithObjects:
                              (id)darkColor,
                              (id)lightColor,
                              nil];

        // initialize achievements
        [self initAchievements];
        
        // create footer
        UILabel *rightsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
        rightsLabel.backgroundColor = [UIColor clearColor];
        rightsLabel.font = [UIFont systemFontOfSize:11.0];
        rightsLabel.textAlignment = UITextAlignmentCenter;
        rightsLabel.textColor = [UIColor darkGrayColor];
        rightsLabel.shadowColor = [UIColor whiteColor];
        rightsLabel.shadowOffset = (CGSize){ 0.0, 1.0 };
        rightsLabel.numberOfLines = 3;
        
        rightsLabel.text = MPString(@"2007 Wade Meredith - All rights reserved - \"What happens to Your Body If You Stop Smoking Right Now?\" on Healthbolt.net");
        
        self.healthTableView.tableFooterView = rightsLabel;
        [rightsLabel release];
        
        // register observers
        [[PreferencesManager sharedManager] addObserver:self
                                             forKeyPath:@"prefs.LastCigarette"
                                                options:0
                                                context:NULL];
        [[PreferencesManager sharedManager] addObserver:self
                                             forKeyPath:@"prefs.NotificationsEnabled"
                                                options:0
                                                context:NULL];
        
        // check achievements state
        [self checkAchievementsState];
        
        // update local notifications
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasUpdatedLocalNotifications"] == NO) {
#ifdef DEBUG
            NSLog(@"%@ - Update local notifications", [self class]);
#endif
            
            // cancel all local notifications
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            // register local notifications
            [self registerLocalNotifications];

            [[NSUserDefaults standardUserDefaults] setBool:YES
                                                    forKey:@"HasUpdatedLocalNotifications"];
        }
        else {
#ifdef DEBUG
            NSLog(@"%@ - Local notifications: %@", [self class], [[UIApplication sharedApplication] scheduledLocalNotifications]);
#endif
        }
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
    
    // release properties
    self.achievements = nil;
    
    self.navBar = nil;
    self.healthTableView = nil;
    
    // release instance variables
    [shadowLayer release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // update table view
    [self.healthTableView reloadData];
}

#pragma mark Accessors

@synthesize achievements;
@synthesize navBar;
@synthesize healthTableView;

#pragma mark Actions

- (void)initAchievements
{
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
                NSDate *completionDate = [step completionDateFromDate:lastCigaretteDate];
                NSDate *dayAfterCompletionDate = [completionDate dateByAddingTimeInterval:86400]; // 60s * 60m * 24h = 86400s
                
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *completionDateComponents = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit)
                                                                                  fromDate:dayAfterCompletionDate];
                [completionDateComponents setHour:8];
                
                notification.fireDate = [gregorianCalendar dateFromComponents:completionDateComponents];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                // release calendar
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

#pragma mark -
#pragma mark Key-Value observing

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

#pragma mark -
#pragma mark Table view data source

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

    HealthTableViewCell *cell = (HealthTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[HealthTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Achievement *currStep = [self.achievements objectAtIndex:indexPath.row];
    
    switch (currStep.state) {
        case AchievementStateNone:
            cell.backgroundColor = [UIColor colorWithRed:0.498 green:0.498 blue:0.546 alpha:1.000];
            
            cell.textLabel.textColor = [UIColor colorWithWhite:0.275 alpha:1.000];
            cell.textLabel.shadowColor = [UIColor colorWithWhite:0.550 alpha:1.000];
            cell.textLabel.shadowOffset = (CGSize){ 0.0, 1.0 };
            
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.350 alpha:1.000];
            
            cell.imageView.image = [UIImage imageNamed:@"AchievementWaiting"];
            
            // remove shadow layer if the first cell is none
            if (indexPath.row == 1) {
                [shadowLayer removeFromSuperlayer];
            }

            break;
            
        case AchievementStateCompleted:
            cell.backgroundColor = [UIColor colorWithRed:0.251 green:0.251 blue:0.290 alpha:1.000];
            
            cell.textLabel.textColor = [UIColor colorWithRed:0.627 green:0.631 blue:0.698 alpha:1.000];
            cell.textLabel.shadowColor = [UIColor colorWithWhite:0.200 alpha:1.000];
            cell.textLabel.shadowOffset = (CGSize){ 0.0, -1.0 };
    
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.416 green:0.416 blue:0.463 alpha:1.000];

            cell.imageView.image = [UIImage imageNamed:@"AchievementCompleted"];

            break;
            
        case AchievementStatePending:
            cell.backgroundColor = [UIColor colorWithRed:0.251 green:0.251 blue:0.290 alpha:1.000];
            
            cell.textLabel.textColor = [UIColor colorWithRed:0.627 green:0.631 blue:0.698 alpha:1.000];
            cell.textLabel.shadowColor = [UIColor colorWithWhite:0.200 alpha:1.000];
            cell.textLabel.shadowOffset = (CGSize){ 0.0, -1.0 };
            
            cell.detailTextLabel.textColor = [UIColor colorWithRed:0.416 green:0.416 blue:0.463 alpha:1.000];

            // remove shadow layer if the last cell is pending
            if (indexPath.row == [self.achievements count] - 1) {
                [shadowLayer removeFromSuperlayer];
            }

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
            
        case AchievementStateWaiting:
            cell.backgroundColor = [UIColor colorWithRed:0.498 green:0.498 blue:0.546 alpha:1.000];
            
            cell.textLabel.textColor = [UIColor colorWithWhite:0.275 alpha:1.000];
            cell.textLabel.shadowColor = [UIColor colorWithWhite:0.550 alpha:1.000];
            cell.textLabel.shadowOffset = (CGSize){ 0.0, 1.0 };
            
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.350 alpha:1.000];
            
            // add shadow
            [shadowLayer removeFromSuperlayer];
            [cell.layer insertSublayer:shadowLayer
                               atIndex:0];

            cell.imageView.image = [UIImage imageNamed:@"AchievementWaiting"];

            break;
    }
}

@end
