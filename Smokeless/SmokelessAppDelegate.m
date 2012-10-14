//
//  SmokelessAppDelegate.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SmokelessAppDelegate.h"

#import "PacketPriceViewController.h"

#import "Appirater.h"


#define APPIRATER_APP_ID                    @"301377083"
#define APPIRATER_DAYS_UNTIL_PROMPT         30
#define APPIRATER_USES_UNTIL_PROMPT         20
#define APPIRATER_TIME_BEFORE_REMINDING		7



@interface SmokelessAppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) CounterViewController *counterController;
@property (nonatomic, strong) SavingsViewController *savingsController;
@property (nonatomic, strong) AchievementsViewController *achievementsController;
@property (nonatomic, strong) UINavigationController *settingsNavController;

@property (nonatomic, strong) UIImageView *splashView;

- (void)updateLastCigaretteDate;

@end


@implementation SmokelessAppDelegate

#pragma mark - Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create the window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Cancel old registered local notifications if last cigarette date has been deleted.
    if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    // Set a default hour (4:00AM) for last cigarette date.
    // On former versions, last cigarette hour depended on the time it was set.
    // Check at first run and fix an already existing cigarette date.
    if (([[NSUserDefaults standardUserDefaults] boolForKey:@"HasUpdatedLastCigaretteDate"] == NO) &&
        ([[PreferencesManager sharedManager] lastCigaretteDate] != nil)) {
        [self updateLastCigaretteDate];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:@"HasUpdatedLastCigaretteDate"];
    }
	
	// create counter controller
	self.counterController = [[CounterViewController alloc] init];
	self.counterController.tabBarItem.title = MPString(@"Counter");
	self.counterController.tabBarItem.image = [UIImage imageNamed:@"TabIconCounter"];
	
	// create savings controller
	self.savingsController = [[SavingsViewController alloc] init];
	self.savingsController.tabBarItem.title = MPString(@"Savings");
	self.savingsController.tabBarItem.image = [UIImage imageNamed:@"TabIconSavings"];
	
    // create the achievements view controller
    self.achievementsController = [[AchievementsViewController alloc] initWithNibName:@"AchievementsViewController"
                                                                               bundle:nil];
    self.achievementsController.tabBarItem.title = MPString(@"Health");
    self.achievementsController.tabBarItem.image = [UIImage imageNamed:@"TabIconHealth"];
    
	// create settings controller
	SettingsViewController *settingsController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	settingsController.title = MPString(@"Settings");
	
	// create settings navigation controller
	self.settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsController];
	self.settingsNavController.tabBarItem.title = MPString(@"Settings");
	self.settingsNavController.tabBarItem.image = [UIImage imageNamed:@"TabIconSettings"];
	
	// Create the tab bar controller.
	self.tabBarController = [[UITabBarController alloc] init];
	self.tabBarController.viewControllers = @[
        self.counterController,
        self.savingsController,
        self.achievementsController,
        self.settingsNavController
    ];

    // Add the tab bar controller's view to the window and display.
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    // Create a splash view.
    self.splashView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([UIScreen mainScreen].bounds.size.height == 568.0f) {
        self.splashView.image = [UIImage imageNamed:@"Default-568h"];
    }
    else {
        self.splashView.image = [UIImage imageNamed:@"Default"];
    }
    
    // Position splash view on top of everything.
    [self.window addSubview:self.splashView];
    [self.window bringSubviewToFront:self.splashView];
    
    // Animate the splash view away.
    [UIView animateWithDuration:1.0
                     animations:^{
                         // Zoom out.
                         self.splashView.frame = CGRectMake(-60.0, -85.0, 440.0, 635.0);
                         // Fade out.
                         self.splashView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.splashView removeFromSuperview];
                         self.splashView = nil;
                     }];
    
    // Notify Appirater.
    [Appirater setAppId:APPIRATER_APP_ID];
    [Appirater setDaysUntilPrompt:APPIRATER_DAYS_UNTIL_PROMPT];
    [Appirater setUsesUntilPrompt:APPIRATER_USES_UNTIL_PROMPT];
    [Appirater setTimeBeforeReminding:APPIRATER_TIME_BEFORE_REMINDING];
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Notify Appirater.
    [Appirater appEnteredForeground:YES];
}

#pragma mark - Private methods

- (void)updateLastCigaretteDate
{
#ifdef DEBUG
    NSLog(@"%@ - Update last cigarette date", [self class]);
#endif

    // Get the saved date.
    NSDate *lastCigaretteDate = [[PreferencesManager sharedManager] lastCigaretteDate];
    
    // Set the hour for the date at 4:00AM.
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *lastCigaretteComponents = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit)
                                                                     fromDate:lastCigaretteDate];
    [lastCigaretteComponents setHour:4];
    
#ifdef DEBUG
    NSLog(@"%@ - Set last cigarette date: %@", [self class], [gregorianCalendar dateFromComponents:lastCigaretteComponents]);
#endif
    
	// Set preference.
	([PreferencesManager sharedManager].prefs)[LAST_CIGARETTE_KEY] = [gregorianCalendar dateFromComponents:lastCigaretteComponents];
    
	// Save preferences to file.
	[[PreferencesManager sharedManager] savePrefs];
}

@end
