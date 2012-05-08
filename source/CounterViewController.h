//
//  CounterViewController.h
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LastCigaretteController.h"


@interface CounterViewController : UIViewController <UnderlayViewDelegate>

- (void)displayView:(id)aView;
- (void)updateViews;

- (void)tweetTapped:(id)sender;
- (void)nextTapped:(id)sender;
- (void)prevTapped:(id)sender;
- (void)editTapped:(id)sender;

- (void)viewSwipedLeft:(UISwipeGestureRecognizer *)recognizer;
- (void)viewSwipedRight:(UISwipeGestureRecognizer *)recognizer;

@end
