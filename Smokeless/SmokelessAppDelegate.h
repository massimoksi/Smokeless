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


@interface SmokelessAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) CounterViewController *counterController;
@property (nonatomic, strong) SavingsViewController *savingsController;
@property (nonatomic, strong) AchievementsViewController *achievementsController;
@property (nonatomic, strong) UINavigationController *settingsNavController;
@property (nonatomic, strong) UIImageView *splashView;

- (void)updateLastCigaretteDate;

@end
