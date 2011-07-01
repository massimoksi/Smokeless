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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc
{
    self.splashView = nil;
    
    self.counterController = nil;
    self.savingsController = nil;
    self.healthController = nil;
    self.settingsNavController = nil;
    
    self.tabBarController = nil;
    self.window = nil;
	
    [super dealloc];
}

#pragma mark Accessors

@synthesize window;
@synthesize tabBarController;
@synthesize counterController;
@synthesize savingsController;
@synthesize healthController;
@synthesize settingsNavController;
@synthesize splashView;

#pragma -
#pragma mark Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
	
    // create achievements controller
    self.healthController = [[[HealthViewController alloc] init] autorelease];
    self.healthController.tabBarItem.title = MPString(@"Health");
    self.healthController.tabBarItem.image = [UIImage imageNamed:@"TabIconHealth"];
    
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
                                             self.healthController,
                                             self.settingsNavController,
                                             nil];
    // set delagate for tab bar
//    self.tabBarController.delegate = self;
	
    // display badge counter on tab bar
//    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//    if (notification != nil) {
//        self.healthController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [[UIApplication sharedApplication] applicationIconBadgeNumber]];
//    }
    
    // add the tab bar controller's view to the window and display
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // display badge counter on tab bar
//    NSInteger badgeCounter = notification.applicationIconBadgeNumber;
//    self.healthController.tabBarItem.badgeValue = (badgeCounter != 0) ? [NSString stringWithFormat:@"%d", badgeCounter] : nil;
    
    self.tabBarController.selectedIndex = 2;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
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
