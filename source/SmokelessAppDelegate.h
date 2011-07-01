//
//  SmokelessAppDelegate.h
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CounterViewController.h"
#import "SavingsViewController.h"
#import "HealthViewController.h"
#import "SettingsViewController.h"


@interface SmokelessAppDelegate : NSObject <UIApplicationDelegate/*, UITabBarControllerDelegate*/> {
    UIWindow *_window;
    UITabBarController *_tabBarController;
    
    CounterViewController *_counterController;
    SavingsViewController *_savingsController;
    HealthViewController *_healthController;
    UINavigationController *_settingsNavController;
    
    UIImageView *_splashView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) CounterViewController *counterController;
@property (nonatomic, retain) SavingsViewController *savingsController;
@property (nonatomic, retain) HealthViewController *healthController;
@property (nonatomic, retain) UINavigationController *settingsNavController;
@property (nonatomic, retain) UIImageView *splashView;

@end
