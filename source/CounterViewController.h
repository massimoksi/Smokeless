//
//  CounterViewController.h
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChalkboardView.h"
#import "CalendarView.h"
#import "NoteView.h"
#import "LastCigaretteController.h"


@interface CounterViewController : UIViewController <UnderlayViewDelegate> {    
    LastCigaretteController *lastCigaretteController;
	
@private
	UIView *container;
}

@property (nonatomic, retain) ChalkboardView *chalkboard;
@property (nonatomic, retain) CalendarView *calendar;
@property (nonatomic, retain) NoteView *note;

- (void)displayView:(id)aView;
- (void)updateViews;

- (void)tweetTapped:(id)sender;
- (void)nextTapped:(id)sender;
- (void)prevTapped:(id)sender;
- (void)editTapped:(id)sender;

- (void)viewSwiped:(UISwipeGestureRecognizer *)recognizer;

@end
