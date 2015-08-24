//
//  AppDelegate.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "AppDelegate.h"

@import AVFoundation;
@import SmokelessKit;


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

    // Get software version.
    NSString *actSoftwareVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *oldSoftwareVersion = [userDefaults stringForKey:SLKSoftwareVersionKey];

    // Check if user settings have already been imported.
    if (!oldSoftwareVersion) {
        [self importUserSettings];
    }

    // Don't stop background music when playing sounds.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
                                           error:nil];

    // Ask permission for local notifications.
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                                                    categories:nil]];
    
    // Load tab bar controller from main storyboard.
    UITabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main"
                                                                      bundle:nil] instantiateViewControllerWithIdentifier:@"MainTBC"];
    tabBarController.delegate = self;
    
    // If basic settings are not set, present an alert view to ask the user to jump to the settings tab.
    if (![SmokelessManager sharedManager].isConfigured) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"INIT_SETTINGS_ALERT_TITLE", nil)
                                                                                 message:NSLocalizedString(@"INIT_SETTINGS_ALERT_MESSAGE", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *configureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"INIT_SETTINGS_ALERT_ACTION_BUTTON", nil)
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action){
                                                                    // Jump to the settings tab.
                                                                    tabBarController.selectedIndex = 3;
                                                                    self.window.rootViewController = tabBarController;
                                                                }];
        [alertController addAction:configureAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"INIT_SETTINGS_ALERT_CANCEL_BUTTON", nil)
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 self.window.rootViewController = tabBarController;
                                                             }];
        [alertController addAction:cancelAction];
        
        [self.window.rootViewController presentViewController:alertController
                                                     animated:YES
                                                   completion:nil];
        
        // Save actual software version in user defaults.
        // If the app is starting without user settings, it's probably a newly installed app,
        // threfore there's no need to display the "What's New" alert view
        [userDefaults setObject:actSoftwareVersion
                         forKey:SLKSoftwareVersionKey];
    }
    else {
        // Show "What's New" alert view if running a newer version.
        if (![actSoftwareVersion isEqualToString:oldSoftwareVersion]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"WHATS_NEW_ALERT_TITLE", nil)
                                                                                     message:NSLocalizedString(@"WHATS_NEW_ALERT_MESSAGE", nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *rateAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"WHATS_NEW_ALERT_ACTION_BUTTON", nil)
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action){
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SLKAppStoreURL]];
                                                               }];
            [alertController addAction:rateAction];

            UIAlertAction *continueAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"WHATS_NEW_ALERT_CANCEL_BUTTON", nil)
                                                                     style:UIAlertActionStyleCancel
                                                                   handler:nil];
            [alertController addAction:continueAction];
            
            [self.window.rootViewController presentViewController:alertController
                                                         animated:YES
                                                       completion:^{
                                                           // Save actual software version in user defaults.
                                                           [userDefaults setObject:actSoftwareVersion
                                                                            forKey:SLKSoftwareVersionKey];
                                                       }];
        }
        
        // Open health tab when app is launched from a local notification.
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
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
        
        [SmokelessManager sharedManager].lastCigaretteDate = oldPrefs[@"LastCigarette"];
        [SmokelessManager sharedManager].smokingHabits = oldPrefs[@"Habits"];
        [SmokelessManager sharedManager].packetSize = [oldPrefs[@"PacketSize"] integerValue];
        [SmokelessManager sharedManager].packetPrice = [oldPrefs[@"PacketPrice"] doubleValue];
        
        [userDefaults setBool:oldPrefs[@"ShakeEnabled"]
                       forKey:SLKPlaySoundsKey];
        [userDefaults setBool:oldPrefs[@"NotificationsEnabled"]
                       forKey:SLKNotificationsEnabledKey];
        
#if DEBUG
        NSLog(@"Preferences - Imported %@.", [userDefaults dictionaryRepresentation]);
#endif
        
        // Delete preferences file.
        NSError *error;
        if ([[NSFileManager defaultManager] removeItemAtPath:oldPrefsFilePath
                                                       error:&error]) {

#if DEBUG
            NSLog(@"Preferences - Deleted old preferences.");
#endif
        }
    }
    else {
#if DEBUG
        NSLog(@"Preferences - No old preferences found.");
#endif
    }
}

#pragma mark - Tab bar controller delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 3) {
        // If basic settings are not set, present an alert view to inform the user that some settings are missing.
        if (![SmokelessManager sharedManager].isConfigured) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"MISSING_SETTINGS_ALERT_TITLE", nil)
                                                                                     message:NSLocalizedString(@"MISSING_SETTINGS_ALERT_MESSAGE", nil)
                                                                              preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"COMMON_OK", nil)
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
