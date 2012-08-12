//
//  SmokelessAppDelegate.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SmokelessAppDelegate.h"

#import "Appirater.h"


@interface SmokelessAppDelegate ()

- (void)updateLastCigaretteDate;

@end


@implementation SmokelessAppDelegate

#pragma mark - Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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

	// create tab bar controller
	self.tabBarController = [[UITabBarController alloc] init];
	
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
	
	// add controllers to tab bar
	self.tabBarController.viewControllers = @[self.counterController,
                                             self.savingsController,
                                             self.achievementsController,
                                             self.settingsNavController];

    // add the tab bar controller's view to the window and display
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];

    // Create a splash view.
    self.splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    self.splashView.image = [UIImage imageNamed:@"Default"];
    
    // Position splash view on top of everything.
    [self.window addSubview:self.splashView];
    [self.window bringSubviewToFront:self.splashView];
    
    // Animate the splash view away.
    [UIView animateWithDuration:1.0
                     animations:^{
                         // zoom out
                         self.splashView.frame = CGRectMake(-60.0, -85.0, 440.0, 635.0);
                         // fade out
                         self.splashView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.splashView removeFromSuperview];
                         self.splashView = nil;
                     }];
    
    // Notify Appirater.
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // notify appirater
    [Appirater appEnteredForeground:YES];
}

#pragma mark - Provate methods

- (void)updateLastCigaretteDate
{
#ifdef DEBUG
    NSLog(@"%@ - Update last cigarette date", [self class]);
#endif

    // get date from the picker
    NSDate *lastCigaretteDate = [[PreferencesManager sharedManager] lastCigaretteDate];
    
    // set the hour for the date of the last cigarette
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *lastCigaretteComponents = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit)
                                                                     fromDate:lastCigaretteDate];
    [lastCigaretteComponents setHour:4];
    
#ifdef DEBUG
    NSLog(@"%@ - Set last cigarette date: %@", [self class], [gregorianCalendar dateFromComponents:lastCigaretteComponents]);
#endif
    
	// set preference
	([PreferencesManager sharedManager].prefs)[LAST_CIGARETTE_KEY] = [gregorianCalendar dateFromComponents:lastCigaretteComponents];
    
	// save preferences to file
	[[PreferencesManager sharedManager] savePrefs];
}

@end
