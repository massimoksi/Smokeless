//
//  SavingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 10/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SavingsViewController.h"

#import "PreferencesManager.h"
#import "savingsSettingsController.h"

#import "DisplayView.h"


#define ACCELERATION_THRESHOLD  2.0


@interface SavingsViewController ()

@property (nonatomic, strong) UIImageView *savingsView;
@property (nonatomic, strong) DisplayView *displayView;

@property (nonatomic, strong) AVAudioPlayer *tinklePlayer;

@property (nonatomic, assign) BOOL shakeEnabled;
@property (nonatomic, assign) CGFloat totalSavings;
@property (nonatomic, assign) NSUInteger totalPackets;

- (void)toolsTapped:(id)sender;
- (void)doneTapped:(id)sender;

@end


@implementation SavingsViewController

- (void)loadView
{
    // Create the view.
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];	

	// Create the savings view and center it inside the superview.
	self.savingsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Savings"]];
    self.savingsView.center = CGPointMake(self.view.center.x,
                                          self.view.center.y - self.tabBarController.tabBar.frame.size.height);
	[self.view addSubview:self.savingsView];
	
    // Create the display view.
    self.displayView = [[DisplayView alloc] initWithOrigin:CGPointMake(68.0,
                                                                       self.savingsView.center.y + 113.0)];
    [self.view addSubview:self.displayView];
	
	// Create the "tools" button.
	UIButton *toolsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	toolsButton.frame = CGRectMake(254.0,
                                   self.savingsView.center.y + 97.0,
                                   60.0,
                                   60.0);
	[toolsButton setImage:[UIImage imageNamed:@"ButtonToolsNormal"]
				 forState:UIControlStateNormal];
	[toolsButton setImage:[UIImage imageNamed:@"ButtonToolsPressed"]
				 forState:UIControlStateHighlighted];
	[toolsButton addTarget:self
					action:@selector(toolsTapped:)
		  forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:toolsButton];
    
    // Setup the accelerometer.
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.1];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    // Become first responder: it's necessary to react to shake gestures.
    [self becomeFirstResponder];

    PreferencesManager *prefsManager = [PreferencesManager sharedManager];
    
    // Set ivars.
    self.shakeEnabled = [(prefsManager.prefs)[SHAKE_ENABLED_KEY] boolValue];
    self.totalSavings = [prefsManager totalSavings];
    self.totalPackets = [prefsManager totalPackets];
    
    // create number formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    
    // Set unit.
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.displayView.moneyUnit.text = [formatter currencySymbol];

    // Set formatter for the amount label
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    // get preferences
	NSDictionary *habits = (prefsManager.prefs)[HABITS_KEY];
	NSNumber *price	= (prefsManager.prefs)[PACKET_PRICE_KEY];
	NSNumber *size = (prefsManager.prefs)[PACKET_SIZE_KEY];

    // set amount display labels
	if (habits && price && size) {
        self.displayView.moneyLabel.text = [formatter stringFromNumber:@(self.totalSavings)];
        self.displayView.packetsLabel.text = [NSString stringWithFormat:@"%d", self.totalPackets];
	}
    else {
        self.displayView.moneyLabel.text = [formatter stringFromNumber:@0.0f];
        self.displayView.packetsLabel.text = [NSString stringWithFormat:@"0"];
    }
    [self.displayView setState:DisplayStateMoney
                 withAnimation:NO];
    
    // Create the tinkle player.
    if (!self.tinklePlayer) {
        self.tinklePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Tinkle"
                                                                                                                                ofType:@"m4a"]]
                                                                    error:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
    self.savingsView = nil;
    self.displayView = nil;
}

#pragma mark Actions

-(void)toolsTapped:(id)sender
{
	// create habits view controller
	SavingsSettingsController *savingsSettingsController = [[SavingsSettingsController alloc] init];
	
	// create navigation controller
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:savingsSettingsController];
	navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
	navigationController.navigationBar.topItem.title = MPString(@"Savings");
	
	// create bar button item
	UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:MPString(@"Done")
																 style:UIBarButtonItemStylePlain
																target:self
																action:@selector(doneTapped:)];
	navigationController.navigationBar.topItem.leftBarButtonItem = doneItem;

	// present savings settings view controller modally
	[self presentModalViewController:navigationController
							animated:YES];
}

- (void)doneTapped:(id)sender
{
	// dismiss savings settings view controller
	[self dismissModalViewControllerAnimated:YES];
}

#pragma - Accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if ((self.shakeEnabled == YES) && (self.totalSavings > 0.0)) {
        if ((acceleration.x * acceleration.x) + (acceleration.y * acceleration.y) + (acceleration.z * acceleration.z) > ACCELERATION_THRESHOLD * ACCELERATION_THRESHOLD) {
            if (self.tinklePlayer.playing == NO) {
                [self.tinklePlayer play];
            }
        }
    }
}

@end
