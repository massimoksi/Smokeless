//
//  SavingsViewController.h
//  Smokeless
//
//  Created by Massimo Peri on 10/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "DisplayView.h"


@interface SavingsViewController : UIViewController <UIAccelerometerDelegate> {
	UIImageView *savingsView;

    DisplayView *display;
    
    AVAudioPlayer *_tinklePlayer;
    
@private
    BOOL shakeEnabled;
    CGFloat totalSavings;
    NSUInteger totalPackets;
}

@property (nonatomic, retain) AVAudioPlayer *tinklePlayer;

- (void)toolsTapped:(id)sender;
- (void)doneTapped:(id)sender;

@end
