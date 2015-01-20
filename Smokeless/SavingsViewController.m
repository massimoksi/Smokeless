//
//  SavingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 10/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SavingsViewController.h"

#import "Constants.h"
#import "DisplayView.h"


#define ACCELERATION_THRESHOLD  2.0


@interface SavingsViewController ()

@property (nonatomic, strong) UIImageView *savingsView;
@property (nonatomic, strong) DisplayView *displayView;
@property (nonatomic, strong) UIImageView *noteView;

@property (nonatomic, strong) AVAudioPlayer *tinklePlayer;

@property (nonatomic) BOOL shakeEnabled;
@property (nonatomic) CGFloat price;
@property (nonatomic) NSInteger size;
@property (nonatomic, copy) NSDictionary *habits;
@property (nonatomic) CGFloat totalSavings;
@property (nonatomic) NSUInteger totalPackets;

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
	
    // Setup the accelerometer.
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.1];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Become first responder: it's necessary to react to shake gestures.
    [self becomeFirstResponder];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Set properties.
    self.shakeEnabled = [userDefaults boolForKey:ShakeEnabledKey];
    
    // Create the number formatter.
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    
    // Set unit.
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    self.displayView.moneyUnit.text = [formatter currencySymbol];

    // Set formatter for the amount label
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    
    // Retrieve preferences.
	self.habits = [userDefaults dictionaryForKey:HabitsKey];
	self.price = [userDefaults floatForKey:PacketPriceKey];
    self.size = [userDefaults integerForKey:PacketSizeKey];

    // Set display labels.
	if (self.habits && (self.price > 0.0) && self.size) {
        self.displayView.moneyLabel.text = [formatter stringFromNumber:@(self.totalSavings)];
        self.displayView.packetsLabel.text = [NSString stringWithFormat:@"%ld", self.totalPackets];
        
        // Remove the note view if present.
        if (self.noteView != nil) {
            [self.noteView removeFromSuperview];
            self.noteView = nil;
        }
	}
    else {
        self.displayView.moneyLabel.text = [formatter stringFromNumber:@0.0f];
        self.displayView.packetsLabel.text = [NSString stringWithFormat:@"0"];
        
        // Create the note view.
        if (self.noteView == nil) {
            self.noteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Note"]];
            CGRect frame = self.noteView.frame;
            frame.origin.x = self.view.frame.size.width - self.noteView.frame.size.width - 5.0f;
            frame.origin.y = self.view.frame.size.height - self.noteView.frame.size.height - 5.0f;
            self.noteView.frame = frame;
            [self.view addSubview:self.noteView];
        }

    }
    [self.displayView setState:DisplayStateMoney
                 withAnimation:NO];
    
    // Create the tinkle player.
    if (!self.tinklePlayer) {
        NSError *error;
        self.tinklePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Tinkle"
                                                                                                                                ofType:@"m4a"]]
                                                                    error:&error];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
    self.savingsView = nil;
    self.displayView = nil;
    self.noteView = nil;
}

#pragma mark - Private methods

- (NSInteger)nonSmokingDays
{
    NSInteger nonSmokingDays = 0;
    
    NSDate *lastDay = [[NSUserDefaults standardUserDefaults] objectForKey:LastCigaretteKey];
    if (lastDay) {
        // create gregorian calendar
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        nonSmokingDays = [[gregorianCalendar components:NSCalendarUnitDay
                                               fromDate:lastDay
                                                 toDate:[NSDate date]
                                                options:0] day];
    }
    
    return nonSmokingDays;
}

- (NSUInteger)totalPackets
{
    NSUInteger totalPackets = 0;
    
    NSDate *lastCigaretteDate = [[NSUserDefaults standardUserDefaults] objectForKey:LastCigaretteKey];
    
    if (self.habits && lastCigaretteDate) {
        NSInteger quantity = [self.habits[HabitsQuantityKey] integerValue];
        NSInteger unit = [self.habits[HabitsUnitKey] integerValue];
        NSInteger period = [self.habits[HabitsPeriodKey] integerValue];
        
        // Calculate constants.
        NSInteger kUnit = (unit == 0) ? 1 : self.size;
        NSInteger kPeriod = (period == 0) ? 1 : 7;
        
        // Calculate the number of cigarettes/day.
        CGFloat cigarettesPerDay = quantity * kUnit / kPeriod;
        
        // Calculate the number of saved cigarettes.
        CGFloat totalCigarettes = [self nonSmokingDays] * cigarettesPerDay;
        
        // Calculate the number of saved packets.
        totalPackets = totalCigarettes / self.size + 1;
    }
    
    return totalPackets;
}

- (CGFloat)totalSavings
{
    return [self totalPackets] * self.price;
}

#pragma mark - Accelerometer delegate

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
