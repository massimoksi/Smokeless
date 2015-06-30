//
//  SavingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 10/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SavingsViewController.h"

#import "Constants.h"

#import "JAMSVGImageView.h"


@interface SavingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *savedMoneyLabel;
@property (weak, nonatomic) IBOutlet JAMSVGImageView *piggyBox;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *piggyBoxConstraint;

@property (nonatomic, readonly) NSNumberFormatter *currencyFormatter;
@property (nonatomic, readonly) AVAudioPlayer *coinsDropPlayer;

@property (nonatomic, strong) NSDate *lastCigaretteDate;
@property (nonatomic, strong) NSDictionary *habits;
@property (nonatomic) CGFloat price;
@property (nonatomic) NSInteger size;
@property (nonatomic) BOOL soundsEnabled;

@property (nonatomic) CGFloat oldSavings;
@property (nonatomic) CGFloat actSavings;

@end


@implementation SavingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    // Become first responder: it's necessary to react to shake gestures.
//    [self becomeFirstResponder];

    // Read settings from user defaults.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.lastCigaretteDate = [userDefaults objectForKey:kLastCigaretteKey];
    self.habits = [userDefaults dictionaryForKey:kHabitsKey];
    self.price = [userDefaults floatForKey:kPacketPriceKey];
    self.size = [userDefaults integerForKey:kPacketSizeKey];
    self.soundsEnabled = [userDefaults boolForKey:kPlaySoundsKey];
    self.oldSavings = [userDefaults floatForKey:kLastSavingsKey];

    // Calculate savings.
    self.actSavings = [self totalSavings];
    self.savedMoneyLabel.text = [self.currencyFormatter stringFromNumber:@(self.oldSavings)];
    
    // Set initial piggy box size.
    // TODO: set actSavings if there's no need to animate.
    self.piggyBoxConstraint.constant = [self spacingForSaving:self.oldSavings];
    
    if (self.soundsEnabled && (self.actSavings > self.oldSavings)) {
        [self.coinsDropPlayer prepareToPlay];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat spacing = [self spacingForSaving:self.actSavings];
    if (self.actSavings > self.oldSavings) {
        if (self.soundsEnabled) {
            [self.coinsDropPlayer performSelector:@selector(play)
                                       withObject:nil
                                       afterDelay:0.1];
        }
        
        NSTimeInterval animationDuration = [self animationDurationForSaving:self.actSavings - self.oldSavings];
        
        [self.view layoutIfNeeded];
        [UIView animateKeyframesWithDuration:animationDuration
                                       delay:0.0
                                     options:0
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:animationDuration / 2
                                                                    animations:^{
                                                                        self.piggyBoxConstraint.constant = spacing - 6.0;
                                                                        [self.view layoutIfNeeded];
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:animationDuration / 2
                                                              relativeDuration:animationDuration / 2
                                                                    animations:^{
                                                                        self.piggyBoxConstraint.constant = spacing;
                                                                        [self.view layoutIfNeeded];
                                                                    }];
                                  }
                                  completion:^(BOOL finished){
                                      if (finished) {
                                          if (self.soundsEnabled) {
                                              [self.coinsDropPlayer stop];
                                          }
                                          
                                          // Animate label updating.
                                          CATransition *animation = [CATransition animation];
                                          animation.duration = 1.0;
                                          animation.type = kCATransitionFade;
                                          animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                          [self.savedMoneyLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
                                          
                                          self.savedMoneyLabel.text = [self.currencyFormatter stringFromNumber:@(self.actSavings)];
                                      }
                                  }];
    }
    else {
        self.piggyBoxConstraint.constant = spacing;
        self.savedMoneyLabel.text = [self.currencyFormatter stringFromNumber:@(self.actSavings)];
    }

    // Add motion effects on piggy box.
    const NSInteger kMotionEffectValue = MIN((NSInteger)(spacing + 0.5), 20);
    UIInterpolatingMotionEffect *tiltX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    tiltX.minimumRelativeValue = @(-kMotionEffectValue);
    tiltX.maximumRelativeValue = @(kMotionEffectValue);
    UIInterpolatingMotionEffect *tiltY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    tiltY.minimumRelativeValue = @(-kMotionEffectValue);
    tiltY.maximumRelativeValue = @(kMotionEffectValue);
    
    UIMotionEffectGroup *effectGroup = [[UIMotionEffectGroup alloc] init];
    effectGroup.motionEffects = @[tiltX, tiltY];
    
    [self.piggyBox addMotionEffect:effectGroup];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setFloat:self.actSavings
                                             forKey:kLastSavingsKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (CGFloat)spacingForSaving:(CGFloat)saving
{
    const CGFloat kSpacingLimitMin = 8.0;
    const CGFloat kSpacingLimitMax = round(CGRectGetWidth(self.view.bounds) * 0.3);
    
    CGFloat spacing = kSpacingLimitMin;
    if (self.price) {
        NSInteger packets = saving / self.price + 0.5;
        
        if (packets < 10) {
            spacing = kSpacingLimitMax;
        }
        else if (packets >= 200) {
            spacing = kSpacingLimitMin;
        }
        else {
            spacing = round(kSpacingLimitMax - ((packets - 10) * (kSpacingLimitMax - kSpacingLimitMin) / 190));
        }
    }
    
#if DEBUG
    NSLog(@"Savings - Calculated spacing: %.1f (savings: %.2f).", spacing, saving);
#endif
    
    return spacing;
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

//#pragma mark - Accelerometer delegate
//
//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
//{
//    if ((self.shakeEnabled == YES) && (self.totalSavings > 0.0)) {
//        if ((acceleration.x * acceleration.x) + (acceleration.y * acceleration.y) + (acceleration.z * acceleration.z) > ACCELERATION_THRESHOLD * ACCELERATION_THRESHOLD) {
//            if (self.tinklePlayer.playing == NO) {
//                [self.tinklePlayer play];
//            }
//        }
//    }
//}

@end
