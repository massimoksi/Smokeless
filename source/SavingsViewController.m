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


#define ACCELERATION_THRESHOLD  2.0


@implementation SavingsViewController

#pragma mark View lifecycle

- (void)loadView
{
	// create view
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	
	// set background
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];	

	// create the savings view
	savingsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Savings"]];
	
    // create display
    display = [[DisplayView alloc] initWithOrigin:CGPointMake(68.0, 331.0)];
	
	// create the edit button
	UIButton *toolsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	toolsButton.frame = CGRectMake(254.0, 316.0, 60.0, 60.0);
	[toolsButton setImage:[UIImage imageNamed:@"ButtonToolsNormal"]
				 forState:UIControlStateNormal];
	[toolsButton setImage:[UIImage imageNamed:@"ButtonToolsPressed"]
				 forState:UIControlStateHighlighted];
	
	// add actions
	[toolsButton addTarget:self
					action:@selector(toolsTapped:)
		  forControlEvents:UIControlEventTouchUpInside];
	
	// create view hierarchy
	[self.view addSubview:savingsView];
    [self.view addSubview:display];
	[self.view addSubview:toolsButton];
    
    // setup accelerometer
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.1];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    // become first responder, necessary to react to shake gestures
    [self becomeFirstResponder];
    
    // get prefs
    PreferencesManager *prefsManager = [PreferencesManager sharedManager];
    
    // set ivars
    shakeEnabled = [[prefsManager.prefs objectForKey:SHAKE_ENABLED_KEY] boolValue];
    totalSavings = [prefsManager totalSavings];
    totalPackets = [prefsManager totalPackets];
    
    // create number formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    
    // set unit
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    display.moneyUnit.text = [formatter currencySymbol];

    // set formatter for the amount label
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    // get preferences
	NSDictionary *habits = [prefsManager.prefs objectForKey:HABITS_KEY];
	NSNumber *price	= [prefsManager.prefs objectForKey:PACKET_PRICE_KEY];
	NSNumber *size = [prefsManager.prefs objectForKey:PACKET_SIZE_KEY];

    // set amount display labels
	if (habits && price && size) {
        display.moneyLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:totalSavings]];
        display.packetsLabel.text = [NSString stringWithFormat:@"%d", totalPackets];
	}
    else {
        display.moneyLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:0.0]];
        display.packetsLabel.text = [NSString stringWithFormat:@"0"];
    }
    [display setState:DisplayStateMoney
        withAnimation:NO];

    // release number formatter
    [formatter release];
    
    // create tinkle player
    if (!self.tinklePlayer) {
        self.tinklePlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Tinkle"
                                                                                                                                 ofType:@"m4a"]]
                                                                    error:NULL] autorelease];
    }
}

#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	[savingsView release];
    [display release];
}

- (void)dealloc
{
	[savingsView release];
    [display release];
    
    self.tinklePlayer = nil;
	
    [super dealloc];
}

#pragma mark Accessors

@synthesize tinklePlayer;

#pragma mark Actions

-(void)toolsTapped:(id)sender
{
	// create habits view controller
	SavingsSettingsController *savingsSettingsController = [[SavingsSettingsController alloc] init];
	
	// create navigation controller
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:savingsSettingsController];
	navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
	navigationController.navigationBar.topItem.title = MPString(@"Savings");
	[savingsSettingsController release];
	
	// create bar button item
	UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:MPString(@"Done")
																 style:UIBarButtonItemStylePlain
																target:self
																action:@selector(doneTapped:)];
	navigationController.navigationBar.topItem.leftBarButtonItem = doneItem;
	[doneItem release];

	// present savings settings view controller modally
	[self presentModalViewController:navigationController
							animated:YES];
	[navigationController release];
}

- (void)doneTapped:(id)sender
{
	// dismiss savings settings view controller
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma Accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if ((shakeEnabled == YES) &&
        (totalSavings > 0.0)) {
        if ((acceleration.x * acceleration.x) + (acceleration.y * acceleration.y) + (acceleration.z * acceleration.z) > ACCELERATION_THRESHOLD * ACCELERATION_THRESHOLD) {
            if (self.tinklePlayer.playing == NO) {
                [self.tinklePlayer play];
            }
        }
//        else {
//            if (self.tinklePlayer.playing == YES) {
//                [self.tinklePlayer pause];
//            }
//        }
    }
}

@end
