//
//  SavingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 10/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SavingsViewController.h"

@import AVFoundation.AVAudioPlayer;

#import "Constants.h"
#import "JAMSVGImageView.h"
#import "MCNumberLabel.h"


#if DEBUG
// Uncomment to debug animations.
#define DEBUG_ANIMATION
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

@property (nonatomic, strong) UIMotionEffectGroup *effectGroup;

@end


@implementation SavingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.savedMoneyLabel.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.savedMoneyLabel.formatter.locale = [NSLocale currentLocale];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Read settings from user defaults.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.lastCigaretteDate = [userDefaults objectForKey:kLastCigaretteKey];
    self.habits = [userDefaults dictionaryForKey:kHabitsKey];
    self.price = [userDefaults floatForKey:kPacketPriceKey];
    self.size = [userDefaults integerForKey:kPacketSizeKey];
    self.soundsEnabled = [userDefaults boolForKey:kPlaySoundsKey];

#ifdef DEBUG_ANIMATION
    self.oldSavings = 50.0;
    self.actSavings = 200.0;
#else
    self.oldSavings = [userDefaults floatForKey:kLastSavingsKey];
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
        if (self.soundsEnabled) {
            [self.coinsDropPlayer performSelector:@selector(play)
                                       withObject:nil
                                       afterDelay:0.1];
        }
        
        NSTimeInterval animationDuration = [self animationDurationForSaving:self.actSavings - self.oldSavings];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
//        [self.view layoutIfNeeded];
//        [UIView animateKeyframesWithDuration:animationDuration
//                                       delay:0.0
//                                     options:0
//                                  animations:^{
//                                      [UIView addKeyframeWithRelativeStartTime:0.0
//                                                              relativeDuration:animationDuration / 2
//                                                                    animations:^{
//                                                                        self.piggyBoxConstraint.constant = spacing - 6.0;
//                                                                        [self.view layoutIfNeeded];
//                                                                    }];
//                                      [UIView addKeyframeWithRelativeStartTime:animationDuration / 2
//                                                              relativeDuration:animationDuration / 2
//                                                                    animations:^{
//                                                                        self.piggyBoxConstraint.constant = spacing;
//                                                                        [self.view layoutIfNeeded];
//                                                                    }];
//                                  }
//                                  completion:^(BOOL finished){
//                                      if (finished) {
//                                          if (self.soundsEnabled) {
//                                              [self.coinsDropPlayer stop];
//                                          }
//
//                                          // Animate label updating.
//                                          CATransition *animation = [CATransition animation];
//                                          animation.duration = 1.0;
//                                          animation.type = kCATransitionFade;
//                                          animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                                          [self.savedMoneyLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
//                                          
//                                          self.savedMoneyLabel.text = [self.currencyFormatter stringFromNumber:@(self.actSavings)];
//                                      }
//                                  }];
    }
//    else {
//        self.piggyBoxConstraint.constant = spacing;
//        self.savedMoneyLabel.text = [self.currencyFormatter stringFromNumber:@(self.actSavings)];
//    }
//
//    // Add motion effects on piggy box.
//    const NSInteger kMotionEffectValue = MIN((NSInteger)(spacing + 0.5), 20);
//    UIInterpolatingMotionEffect *tiltX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
//                                                                                         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
//    tiltX.minimumRelativeValue = @(-kMotionEffectValue);
//    tiltX.maximumRelativeValue = @(kMotionEffectValue);
//    UIInterpolatingMotionEffect *tiltY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
//                                                                                         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//    tiltY.minimumRelativeValue = @(-kMotionEffectValue);
//    tiltY.maximumRelativeValue = @(kMotionEffectValue);
//    
//    self.effectGroup = [[UIMotionEffectGroup alloc] init];
//    self.effectGroup.motionEffects = @[tiltX, tiltY];
//    
//    [self.piggyBox addMotionEffect:self.effectGroup];
    
    // Become first responder to react to shake gestures.
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
#ifndef DEBUG_ANIMATION
    [[NSUserDefaults standardUserDefaults] setFloat:self.actSavings
                                             forKey:kLastSavingsKey];
#endif

    [self resignFirstResponder];

    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.effectGroup = nil;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Accessors

- (NSNumberFormatter *)currencyFormatter
{
    static NSNumberFormatter *_currencyFormatter = nil;
    if (_currencyFormatter) {
        return _currencyFormatter;
    }
    
    _currencyFormatter = [[NSNumberFormatter alloc] init];
    _currencyFormatter.locale = [NSLocale currentLocale];
    _currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    return _currencyFormatter;
}

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
        // Remove parallax motion effects.
        [self.piggyBox removeMotionEffect:self.effectGroup];
        
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
        
        // Add parallax motion effects.
        [self.piggyBox addMotionEffect:self.effectGroup];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        // Stop tinkle sound.
        [self.coinsTinklePlayer stop];
        self.coinsTinklePlayer.currentTime = 0.0;

        // Add parallax motion effects.
        [self.piggyBox addMotionEffect:self.effectGroup];
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
            NSInteger quantity = [self.habits[kHabitsQuantityKey] integerValue];
            NSInteger unit = ([self.habits[kHabitsUnitKey] integerValue] == 0) ? 1 : self.size;
            NSInteger period = ([self.habits[kHabitsPeriodKey] integerValue] == 0) ? 1 : 7;
            
            // Calculate the number of cigarettes/day.
            CGFloat cigarettesPerDay = quantity * unit / period;
            
            // Calculate the number of saved cigarettes.
            CGFloat totalCigarettes = nonSmokingDays * cigarettesPerDay;
            
            // Calculate the number of saved packets.
            NSInteger totalPackets = totalCigarettes / self.size + 1;   // +1 beacuse in the moment you quit smoking you save the first packet.

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
