//
//  AppDelegate.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "AppDelegate.h"

#import "Constants.h"
#import "PacketPriceViewController.h"
#import "CounterViewController.h"
#import "SavingsViewController.h"
#import "AchievementsViewController.h"
#import "SettingsViewController.h"


@interface AppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) CounterViewController *counterController;
@property (nonatomic, strong) SavingsViewController *savingsController;
@property (nonatomic, strong) AchievementsViewController *achievementsController;
@property (nonatomic, strong) UINavigationController *settingsNavController;

@property (nonatomic, strong) UIImageView *splashView;

- (void)updateLastCigaretteDate;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create the window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Check if user settings have already been imported.
    if (![userDefaults boolForKey:UserSettingsImportedKey]) {
        [self importUserSettings];
    }
    
    // Cancel old registered local notifications if last cigarette date has been deleted.
    if (![userDefaults objectForKey:LastCigaretteKey]) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    // Set a default hour (4:00AM) for last cigarette date.
    // On former versions, last cigarette hour depended on the time it was set.
    // Check at first run and fix an already existing cigarette date.
    if (![userDefaults boolForKey:HasUpdatedLastCigaretteDateKey] && ![userDefaults objectForKey:LastCigaretteKey]) {
        [self updateLastCigaretteDate];
        
        [userDefaults setBool:YES
                       forKey:HasUpdatedLastCigaretteDateKey];
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
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Private methods

- (void)importUserSettings
{
#if DEBUG
    NSLog(@"Preferences: Start importing old preferences.");
#endif
    
    NSString *oldPrefsFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/prefs.plist"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Check if a preferences file exists.
    if ([[NSFileManager defaultManager] fileExistsAtPath:oldPrefsFilePath]) {
        NSDictionary *oldPrefs = [NSDictionary dictionaryWithContentsOfFile:oldPrefsFilePath];
        
        [userDefaults setObject:oldPrefs[@"LastCigarette"]
                         forKey:LastCigaretteKey];
        [userDefaults setObject:oldPrefs[@"Habits"]
                         forKey:HabitsKey];
        [userDefaults setInteger:[oldPrefs[@"PacketSize"] integerValue]
                          forKey:PacketSizeKey];
        [userDefaults setFloat:[oldPrefs[@"PacketPrice"] floatValue]
                        forKey:PacketPriceKey];
        [userDefaults setBool:oldPrefs[@"ShakeEnabled"]
                       forKey:ShakeEnabledKey];
        [userDefaults setBool:oldPrefs[@"NotificationsEnabled"]
                       forKey:NotificationsEnabledKey];
        
#if DEBUG
        NSLog(@"Preferences: Imported %@.", [userDefaults dictionaryRepresentation]);
#endif
        
        // Delete preferences file.
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:oldPrefsFilePath
                                                       error:&error]) {
            [userDefaults setBool:YES
                           forKey:UserSettingsImportedKey];

#if DEBUG
            NSLog(@"Preferences: Deleted old preferences.");
#endif
        }
    }
    else {
        [userDefaults setBool:YES
                       forKey:UserSettingsImportedKey];
        
#if DEBUG
        NSLog(@"Preferences: No old preferences found.");
#endif
    }
}

- (void)updateLastCigaretteDate
{
#ifdef DEBUG
    NSLog(@"Preferences: Start updating last cigarette date.");
#endif
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    // Get the saved date.
    NSDate *lastCigaretteDate = [userDefaults objectForKey:LastCigaretteKey];
    
    // Set the hour for the date at 4:00AM.
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastCigaretteComponents = [gregorianCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour)
                                                                     fromDate:lastCigaretteDate];
    [lastCigaretteComponents setHour:4];
    
#ifdef DEBUG
    NSLog(@"Preferences: Last cigarette date %@.", [gregorianCalendar dateFromComponents:lastCigaretteComponents]);
#endif
    
    [userDefaults setObject:[gregorianCalendar dateFromComponents:lastCigaretteComponents]
                     forKey:LastCigaretteKey];
}

@end
