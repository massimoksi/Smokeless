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
    // http://stackoverflow.com/questions/1672602/iphone-avaudioplayer-stopping-background-music
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
                                           error:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Check if user settings have already been imported.
    if (![userDefaults boolForKey:kUserSettingsImportedKey]) {
        [self importUserSettings];
    }
    
    // Cancel old registered local notifications if last cigarette date has been deleted.
    if (![userDefaults objectForKey:kLastCigaretteKey]) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    	
    // Ask permission for local notifications.
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                                                    categories:nil]];

    // Open health tab when app is launched with local notification.
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        tabBarController.selectedIndex = 2;
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

@end
