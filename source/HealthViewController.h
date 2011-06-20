//
//  HealthViewController.h
//  Smokeless
//
//  Created by Massimo Peri on 26/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "PreferencesManager.h"
#import "Achievement.h"

#import "HealthTableView.h"


@interface HealthViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *_achievements;
    
    UINavigationBar *_navBar;
    HealthTableView *_healthTableView;
    
    CAGradientLayer *shadowLayer;
}

@property (nonatomic, retain) NSArray *achievements;
@property (nonatomic, retain) UINavigationBar *navBar;
@property (nonatomic, retain) HealthTableView *healthTableView;

- (void)initAchievements;
- (void)checkAchievementsState;
- (void)registerLocalNotifications;

@end
