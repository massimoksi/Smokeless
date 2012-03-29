//
//  SmokelessAppDelegate.h
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PreferencesManager.h"
#import "CounterViewController.h"
#import "SavingsViewController.h"
#import "AchievementsViewController.h"
#import "SettingsViewController.h"


@interface SmokelessAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
    UITabBarController *_tabBarController;
    
    CounterViewController *_counterController;
    SavingsViewController *_savingsController;
    UINavigationController *_settingsNavController;
    
    UIImageView *_splashView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) CounterViewController *counterController;
@property (nonatomic, retain) SavingsViewController *savingsController;
@property (nonatomic, retain) AchievementsViewController *achievementsController;
@property (nonatomic, retain) UINavigationController *settingsNavController;
@property (nonatomic, retain) UIImageView *splashView;

- (void)updateLastCigaretteDate;

@end
