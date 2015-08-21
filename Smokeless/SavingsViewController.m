//
//  SavingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 10/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SavingsViewController.h"

@import AVFoundation;
@import SmokelessKit;

#import "JAMSVGImageView.h"
#import "MCNumberLabel.h"


#if DEBUG
// Uncomment to debug animations.
//#define DEBUG_ANIMATION
#endif


@interface SavingsViewController ()

@property (weak, nonatomic) IBOutlet MCNumberLabel *savedMoneyLabel;
@property (weak, nonatomic) IBOutlet JAMSVGImageView *piggyBox;

@property (nonatomic, readonly) AVAudioPlayer *coinsDropPlayer;
@property (nonatomic, readonly) AVAudioPlayer *coinsTinklePlayer;

@property (nonatomic, strong) NSDate *lastCigaretteDate;
@property (nonatomic, strong) NSDictionary *habits;
@property (nonatomic) CGFloat price;
@property (nonatomic) NSInteger size;
@property (nonatomic) BOOL soundsEnabled;

@property (nonatomic) CGFloat oldSavings;
@property (nonatomic) CGFloat actSavings;

@end


@implementation SavingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.savedMoneyLabel.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.savedMoneyLabel.formatter.locale = [NSLocale currentLocale];
    
    // Add motion effects on piggy box.
    const NSInteger kMotionEffectValue = 12;
    UIInterpolatingMotionEffect *tiltX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    tiltX.minimumRelativeValue = @(-kMotionEffectValue);
    tiltX.maximumRelativeValue = @(kMotionEffectValue);
    UIInterpolatingMotionEffect *tiltY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    tiltY.minimumRelativeValue = @(-kMotionEffectValue);
    tiltY.maximumRelativeValue = @(kMotionEffectValue);
    
    UIMotionEffectGroup *effectsGroup = [[UIMotionEffectGroup alloc] init];
    effectsGroup.motionEffects = @[tiltX, tiltY];
    [self.piggyBox addMotionEffect:effectsGroup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Read settings from user defaults.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.lastCigaretteDate = [SmokelessManager sharedManager].lastCigaretteDate;
    self.habits = [SmokelessManager sharedManager].smokingHabits;
    self.size = [SmokelessManager sharedManager].packetSize;
    self.price = [SmokelessManager sharedManager].packetPrice;
    self.soundsEnabled = [userDefaults boolForKey:SLKPlaySoundsKey];

#ifdef DEBUG_ANIMATION
    self.oldSavings = 50.0;
    self.actSavings = 200.0;
#else
    self.oldSavings = [userDefaults floatForKey:SLKLastSavingsKey];
    self.actSavings = [self totalSavings];
#endif

    // Initialize user interface.
    if (self.actSavings > self.oldSavings) {
        self.savedMoneyLabel.value = @(self.oldSavings);
    }
    else {
        self.savedMoneyLabel.value = @(self.actSavings);
    }
    
    if (self.soundsEnabled) {
        if (self.actSavings > self.oldSavings) {
            [self.coinsDropPlayer prepareToPlay];
        }
        
        [self.coinsTinklePlayer prepareToPlay];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.actSavings > self.oldSavings) {
        NSTimeInterval animationDuration = [self animationDurationForSaving:self.actSavings - self.oldSavings];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.soundsEnabled) {
                [self.coinsDropPlayer play];
            }
            
            [self.savedMoneyLabel setValue:@(self.actSavings)
                                  duration:animationDuration
                                completion:^(BOOL finished){
                                    if (finished) {
                                        if (self.soundsEnabled) {
                                            [self.coinsDropPlayer stop];
                                        }
                                    }
                                }];
        });
    }
    else {
        self.savedMoneyLabel.value = @(self.actSavings);
    }
    
    // Become first responder to react to shake gestures.
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
#ifndef DEBUG_ANIMATION
    [[NSUserDefaults standardUserDefaults] setFloat:self.actSavings
                                             forKey:SLKLastSavingsKey];
#endif

    [self resignFirstResponder];

    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Accessors

- (AVAudioPlayer *)coinsDropPlayer
{
    static AVAudioPlayer *_coinsDropPlayer = nil;
    if (_coinsDropPlayer) {
        return _coinsDropPlayer;
    }
    
    _coinsDropPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CoinsDrop"
                                                                                                                           ofType:@"aifc"]]
                                                              error:NULL];
    _coinsDropPlayer.numberOfLoops = -1;
    
    return _coinsDropPlayer;
}

- (AVAudioPlayer *)coinsTinklePlayer
{
    static AVAudioPlayer *_coinsTinklePlayer = nil;
    if (_coinsTinklePlayer) {
        return _coinsTinklePlayer;
    }
    
    _coinsTinklePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Tinkle"
                                                                                                                             ofType:@"m4a"]]
                                                                error:NULL];
    _coinsTinklePlayer.numberOfLoops = -1;
    
    return _coinsTinklePlayer;
}

#pragma mark - Motion events

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ((motion == UIEventSubtypeMotionShake) && (self.actSavings > 0.0) && self.soundsEnabled) {
        // Start playing tinkle sound.
        [self.coinsTinklePlayer play];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        // Stop tinkle sound.
        [self.coinsTinklePlayer stop];
        self.coinsTinklePlayer.currentTime = 0.0;
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        // Stop tinkle sound.
        [self.coinsTinklePlayer stop];
        self.coinsTinklePlayer.currentTime = 0.0;
    }
}

#pragma mark - Private methods

- (CGFloat)totalSavings
{
    CGFloat savings = 0.0;
    
    if (self.lastCigaretteDate) {
        // Calculate non smoking days.
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger nonSmokingDays = [[gregorianCalendar components:NSCalendarUnitDay
                                                         fromDate:self.lastCigaretteDate
                                                           toDate:[NSDate date]
                                                          options:0] day];
        
        if (self.habits) {
            NSInteger quantity = [self.habits[SLKHabitsQuantityKey] integerValue];
            NSInteger unit = ([self.habits[SLKHabitsUnitKey] integerValue] == 0) ? 1 : self.size;
            NSInteger period = ([self.habits[SLKHabitsPeriodKey] integerValue] == 0) ? 1 : 7;
            
            // Calculate the number of cigarettes/day.
            CGFloat cigarettesPerDay = quantity * unit / period;
            
            // Calculate the number of saved cigarettes.
            CGFloat totalCigarettes = nonSmokingDays * cigarettesPerDay;
            
            // Calculate the number of saved packets.
            // +1 beacuse in the moment you quit smoking you save the first packet.
            NSInteger totalPackets = totalCigarettes / self.size + 1;

#if DEBUG
            NSLog(@"Savings - Total packets: %ld.", (long)totalPackets);
#endif
            
            // Calculate the total savings.
            savings = totalPackets * self.price;
        }
    }
    
    return savings;
}

- (NSTimeInterval)animationDurationForSaving:(CGFloat)saving
{
    NSTimeInterval duration = 1.0;

    if (self.price) {
        NSInteger packets = saving / self.price + 0.5;

        if (packets < 5) {
            duration = 1.0;
        }
        else if ((packets >= 5) && (packets < 10)) {
            duration = 2.0;
        }
        else if ((packets >= 10) && (packets < 20)) {
            duration = 3.0;
        }
        else {
            duration = 4.0;
        }
    }
    
    return duration;
}

@end
