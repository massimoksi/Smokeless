//
//  AppDelegate.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "AppDelegate.h"

@import AVFoundation;

#import "Constants.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController *launchViewController = [[UIStoryboard storyboardWithName:@"Launch"
                                                                        bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchVC"];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = launchViewController;
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    // Check if user settings have already been imported.
    if (![userDefaults boolForKey:kUserSettingsImportedKey]) {
        [self importUserSettings];
    }

    // Don't stop background music when playing sounds.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
                                           error:nil];

    // Ask permission for local notifications.
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                                                    categories:nil]];
    
    // Get basic user settings from system defaults.
    NSDate *lastCigaretteDate = [userDefaults objectForKey:kLastCigaretteKey];
    NSDictionary *smokingHabits = [userDefaults dictionaryForKey:kHabitsKey];
    NSInteger packetSize = [userDefaults integerForKey:kPacketSizeKey];
    CGFloat packetPrice = [userDefaults floatForKey:kPacketPriceKey];
    
    // Load tab bar controller from main storyboard.
    UITabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main"
                                                                      bundle:nil] instantiateViewControllerWithIdentifier:@"MainTBC"];
    tabBarController.delegate = self;
    
    // If basic settings are not set, present an alert view to ask the user to jump to the settings tab.
    if (!lastCigaretteDate || !smokingHabits || (packetSize <= 0) || (packetPrice <= 0.0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"INIT_SETTINGS_ALERT_TITLE", @"Initialize settings alert: title.")
                                                                                 message:NSLocalizedString(@"INIT_SETTINGS_ALERT_MESSAGE", @"Initialize settings alert: message.")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *configureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"INIT_SETTINGS_ALERT_ACTION_BUTTON", @"Initialize settings alert: action button.")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action){
                                                                    // Jump to the settings tab.
                                                                    tabBarController.selectedIndex = 3;
                                                                    self.window.rootViewController = tabBarController;
                                                                }];
        [alertController addAction:configureAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"INIT_SETTINGS_ALERT_CANCEL_BUTTON", @"Initialize settings alert: cancel button.")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 self.window.rootViewController = tabBarController;
                                                             }];
        [alertController addAction:cancelAction];
        
        [self.window.rootViewController presentViewController:alertController
                                                     animated:YES
                                                   completion:nil];
    }
    else {
        // Open health tab when app is launched with local notification.
        UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (notification) {
            // Jump to the health tab.
            tabBarController.selectedIndex = 2;
        }
        
        self.window.rootViewController = tabBarController;
    }
    
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.selectedIndex = 2;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

#pragma mark - Private methods

- (void)importUserSettings
{
#if DEBUG
    NSLog(@"Preferences - Start importing old preferences.");
#endif
    
    NSString *oldPrefsFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/prefs.plist"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Check if a preferences file exists.
    if ([[NSFileManager defaultManager] fileExistsAtPath:oldPrefsFilePath]) {
        NSDictionary *oldPrefs = [NSDictionary dictionaryWithContentsOfFile:oldPrefsFilePath];
        
        [userDefaults setObject:oldPrefs[@"LastCigarette"]
                         forKey:kLastCigaretteKey];
        [userDefaults setObject:oldPrefs[@"Habits"]
                         forKey:kHabitsKey];
        [userDefaults setInteger:[oldPrefs[@"PacketSize"] integerValue]
                          forKey:kPacketSizeKey];
        [userDefaults setFloat:[oldPrefs[@"PacketPrice"] floatValue]
                        forKey:kPacketPriceKey];
        [userDefaults setBool:oldPrefs[@"ShakeEnabled"]
                       forKey:kPlaySoundsKey];
        [userDefaults setBool:oldPrefs[@"NotificationsEnabled"]
                       forKey:kNotificationsEnabledKey];
        
#if DEBUG
        NSLog(@"Preferences - Imported %@.", [userDefaults dictionaryRepresentation]);
#endif
        
        // Delete preferences file.
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:oldPrefsFilePath
                                                       error:&error]) {
            [userDefaults setBool:YES
                           forKey:kUserSettingsImportedKey];

#if DEBUG
            NSLog(@"Preferences - Deleted old preferences.");
#endif
        }
    }
    else {
        [userDefaults setBool:YES
                       forKey:kUserSettingsImportedKey];
        
#if DEBUG
        NSLog(@"Preferences - No old preferences found.");
#endif
    }
}

#pragma mark - Tab bar controller delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 3) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        // Get basic user settings from system defaults.
        NSDate *lastCigaretteDate = [userDefaults objectForKey:kLastCigaretteKey];
        NSDictionary *smokingHabits = [userDefaults dictionaryForKey:kHabitsKey];
        NSInteger packetSize = [userDefaults integerForKey:kPacketSizeKey];
        CGFloat packetPrice = [userDefaults floatForKey:kPacketPriceKey];
        
        // If basic settings are not set, present an alert view to inform the user that some settings are missing.
        if (!lastCigaretteDate || !smokingHabits || (packetSize <= 0) || (packetPrice <= 0.0)) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"MISSING_SETTINGS_ALERT_TITLE", @"Missing settings alert: title.")
                                                                                     message:NSLocalizedString(@"MISSING_SETTINGS_ALERT_MESSAGE", @"Missing settings alert: message.")
                                                                              preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:nil];
            [alertController addAction:settingsAction];
            
            [self.window.rootViewController presentViewController:alertController
                                                         animated:YES
                                                       completion:nil];
        }
    }

    return YES;
}

@end
