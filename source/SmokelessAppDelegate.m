//
//  SmokelessAppDelegate.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SmokelessAppDelegate.h"

#import "Appirater.h"


@implementation SmokelessAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize counterController = _counterController;
@synthesize savingsController = _savingsController;
@synthesize achievementsController = _achievementsNavController;
@synthesize settingsNavController = _settingsNavController;
@synthesize splashView = _splashView;

- (void)dealloc
{
    self.splashView = nil;
    
    self.counterController = nil;
    self.savingsController = nil;
    self.achievementsController = nil;
    self.settingsNavController = nil;
    
    self.tabBarController = nil;
    self.window = nil;
	
    [super dealloc];
}

#pragma mark - Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
        // cancel old local notifications
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }

	// create tab bar controller
	self.tabBarController = [[[UITabBarController alloc] init] autorelease];
	
	// create counter controller
	self.counterController = [[[CounterViewController alloc] init] autorelease];
	self.counterController.tabBarItem.title = MPString(@"Counter");
	self.counterController.tabBarItem.image = [UIImage imageNamed:@"TabIconCounter"];
	
	// create savings controller
	self.savingsController = [[[SavingsViewController alloc] init] autorelease];
	self.savingsController.tabBarItem.title = MPString(@"Savings");
	self.savingsController.tabBarItem.image = [UIImage imageNamed:@"TabIconSavings"];
	
    // create the achievements view controller
    self.achievementsController = [[AchievementsViewController alloc] initWithStyle:UITableViewStylePlain];
    self.achievementsController.tabBarItem.title = MPString(@"Health");
    self.achievementsController.tabBarItem.image = [UIImage imageNamed:@"TabIconHealth"];
    
	// create settings controller
	SettingsViewController *settingsController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	settingsController.title = MPString(@"Settings");
	
	// create settings navigation controller
	self.settingsNavController = [[[UINavigationController alloc] initWithRootViewController:settingsController] autorelease];
	self.settingsNavController.tabBarItem.title = MPString(@"Settings");
	self.settingsNavController.tabBarItem.image = [UIImage imageNamed:@"TabIconSettings"];
    [settingsController release];
	
	// add controllers to tab bar
	self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             self.counterController,
                                             self.savingsController,
                                             self.achievementsController,
                                             self.settingsNavController,
                                             nil];

    // add the tab bar controller's view to the window and display
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
        
    if (([[NSUserDefaults standardUserDefaults] boolForKey:@"HasUpdatedLastCigaretteDate"] == NO) &&
        ([[PreferencesManager sharedManager] lastCigaretteDate] != nil)) {
        [self updateLastCigaretteDate];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:@"HasUpdatedLastCigaretteDate"];
    }
    
    // create splash view
    self.splashView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)] autorelease];
    self.splashView.image = [UIImage imageNamed:@"Default"];
    
    // position splash view on top of everything
    [self.window addSubview:self.splashView];
    [self.window bringSubviewToFront:self.splashView];
    
    // animate splash view away
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
    
    // notify appirater
    [Appirater appLaunched:YES];
    
    return YES;
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
    // display badge counter on tab bar
//    NSInteger badgeCounter = notification.applicationIconBadgeNumber;
//    self.healthController.tabBarItem.badgeValue = (badgeCounter != 0) ? [NSString stringWithFormat:@"%d", badgeCounter] : nil;
//    
//    self.tabBarController.selectedIndex = 2;
//}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // notify appirater
    [Appirater appEnteredForeground:YES];
}

#pragma mark Actions

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
	[[PreferencesManager sharedManager].prefs setObject:[gregorianCalendar dateFromComponents:lastCigaretteComponents]
												 forKey:LAST_CIGARETTE_KEY];
    [gregorianCalendar release];
    
	// save preferences to file
	[[PreferencesManager sharedManager] savePrefs];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    // reset badge from tab bar item
//    if (viewController == self.healthController) {
//        viewController.tabBarItem.badgeValue = nil;
//        
//        // reset application badge counter
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    }
//}

@end
