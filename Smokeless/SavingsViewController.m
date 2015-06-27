//
//  SavingsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 10/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "SavingsViewController.h"

#import "Constants.h"


//#define ACCELERATION_THRESHOLD  2.0


@interface SavingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *savedMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *piggyBox;

@property (nonatomic, readonly) NSNumberFormatter *currencyFormatter;

@property (nonatomic, strong) NSDate *lastCigaretteDate;
@property (nonatomic, copy) NSDictionary *habits;
@property (nonatomic) CGFloat price;
@property (nonatomic) NSInteger size;

@property (nonatomic) CGFloat oldSavings;
@property (nonatomic) CGFloat actSavings;
//
//@property (nonatomic, strong) AVAudioPlayer *tinklePlayer;
//
//@property (nonatomic) BOOL shakeEnabled;

@end


@implementation SavingsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    // Become first responder: it's necessary to react to shake gestures.
//    [self becomeFirstResponder];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.lastCigaretteDate = [userDefaults objectForKey:kLastCigaretteKey];
    self.habits = [userDefaults dictionaryForKey:kHabitsKey];
    self.price = [userDefaults floatForKey:kPacketPriceKey];
    self.size = [userDefaults integerForKey:kPacketSizeKey];

    self.oldSavings = [userDefaults floatForKey:kLastSavingsKey];
    self.actSavings = [self totalSavings];
    
    self.savedMoneyLabel.text = [self.currencyFormatter stringFromNumber:@(self.totalSavings)];
    
//    // Create the tinkle player.
//    if (!self.tinklePlayer) {
//        NSError *error;
//        self.tinklePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Tinkle"
//                                                                                                                                ofType:@"m4a"]]
//                                                                    error:&error];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.actSavings > self.oldSavings) {
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0.0
                                     options:0
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.5
                                                                    animations:^{
                                                                        [self.piggyBox setTranslatesAutoresizingMaskIntoConstraints:YES];
                                                                        self.piggyBox.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.5
                                                              relativeDuration:0.5
                                                                    animations:^{
                                                                        self.piggyBox.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                                        [self.piggyBox setTranslatesAutoresizingMaskIntoConstraints:NO];
                                                                    }];
                                  }
                                  completion:nil];
    }
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

//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}

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
            // TODO: make it integer.
            CGFloat totalCigarettes = nonSmokingDays * cigarettesPerDay;
            
            // Calculate the number of saved packets.
            NSInteger totalPackets = totalCigarettes / self.size + 1;   // +1 beacuse in the moment you quit smoking you save the first packet.
            
            // Calculate the total savings.
            savings = totalPackets * self.price;
        }
    }
    
    return savings;
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
