//
//  CounterViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "CounterViewController.h"

#import "PreferencesManager.h"

#import "ChalkboardView.h"
#import "CalendarView.h"
#import "NoteView.h"


@interface CounterViewController ()

@property (nonatomic, strong) LastCigaretteController *lastCigaretteController;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) ChalkboardView *chalkboard;
@property (nonatomic, strong) CalendarView *calendar;
@property (nonatomic, strong) NoteView *note;

@end


@implementation CounterViewController

#pragma mark View lifecycle

- (void)loadView
{
	// create view
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	
	// set background
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    
    // create the left swipe gesture recognizer
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(viewSwipedLeft:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    // create the right swipe gesture recognizer
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(viewSwipedRight:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // add the swipe gesture recognizers to the view
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// create the container view
	self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
	self.containerView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.containerView];
		
	// create counter view
	self.chalkboard = [[ChalkboardView alloc] init];
	
	// create calendar view
	self.calendar = [[CalendarView alloc] initWithDate:[[PreferencesManager sharedManager] lastCigaretteDate]];

	// set actions
    if ([TWTweetComposeViewController canSendTweet] == YES) {
        [self.chalkboard.tweetButton addTarget:self
                                        action:@selector(tweetTapped:)
                              forControlEvents:UIControlEventTouchUpInside];
    }
	[self.chalkboard.nextButton addTarget:self
								   action:@selector(nextTapped:)
						 forControlEvents:UIControlEventTouchUpInside];
	[self.calendar.prevButton addTarget:self
								 action:@selector(prevTapped:)
					   forControlEvents:UIControlEventTouchUpInside];
	[self.calendar.editButton addTarget:self
								 action:@selector(editTapped:)
					   forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self updateViews];
    
    // remove last cigarette underlay
    if (self.lastCigaretteController) {
        [self.lastCigaretteController.view removeFromSuperview];
        self.lastCigaretteController = nil;
        
        // restore container position
        CGRect viewFrame = self.containerView.frame;
        viewFrame.origin.y = 0.0;
        self.containerView.frame = viewFrame;
        
        // restore container background
        self.containerView.backgroundColor = [UIColor clearColor];
    }

	if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
		// display calendar
		[self displayView:self.calendar];		
	}
	else {		
		// display chalkboard
		[self displayView:self.chalkboard];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	if (([[PreferencesManager sharedManager] lastCigaretteDate] == nil) &&
		(self.note == nil)) {
		// create note
		self.note = [[NoteView alloc] init];
		
		// position note
		CGRect frame = self.note.frame;
		frame.origin.x = 36.0;
		frame.origin.y = 245.0;
		self.note.frame = frame;
		
		// set text on note
		self.note.message.text = MPString(@"When did you smoke your last cigarette?");
		
		// hide note
		self.note.alpha = 0.0;
		
		// add the note to the calendar
		[self.calendar addSubview:self.note];
		
		// show note
		[UIView animateWithDuration:0.750
						 animations:^{
							 self.note.alpha = 1.0;
						 }];
	}
}

#pragma mark Memory management

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.containerView = nil;
    
	self.chalkboard = nil;
	self.calendar = nil;
	self.note = nil;
}

#pragma mark Actions

- (void)displayView:(id)aView
{
	// switch visible view
	if ([aView isEqual:[self.containerView.subviews lastObject]] == NO) {
		[[self.containerView.subviews lastObject] removeFromSuperview];
		[self.containerView addSubview:aView];
	}
}

- (void)updateViews
{
	if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
		// reset chalkboard
		self.chalkboard.years = 0;
		self.chalkboard.months = 0;
		self.chalkboard.weeks = 0;
		self.chalkboard.days = 0;
		
		// reset calendar
		self.calendar.date = nil;
	}
	else {
		// update chalkboard
		NSDateComponents *counterComponents = [[PreferencesManager sharedManager] nonSmokingInterval];
		self.chalkboard.years = [counterComponents year];
		self.chalkboard.months = [counterComponents month];
		self.chalkboard.weeks = [counterComponents week];
		self.chalkboard.days = [counterComponents day];
		
		// update calendar
		self.calendar.date = [[PreferencesManager sharedManager] lastCigaretteDate];
	}
}

- (void)tweetTapped:(id)sender
{
    if ([TWTweetComposeViewController canSendTweet] == YES) {
        // create the tweet sheet controller
        TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
        // assign the text for the tweet
        NSInteger nonSmokingDays = [[PreferencesManager sharedManager] nonSmokingDays];
        NSString *nonSmokingInterval = (nonSmokingDays == 1) ? [NSString stringWithFormat:MPString(@"%d day"), nonSmokingDays] : [NSString stringWithFormat:MPString(@"%d days"), nonSmokingDays];
        [tweetController setInitialText:[NSString stringWithFormat:MPString(@"Not smoking for %@ thanks to #Smokeless."), nonSmokingInterval]];
        [tweetController addURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/smokeless-quit-smoking/id438027793?mt=8&uo=4"]];
        
        // present the tweet sheet
        [self presentModalViewController:tweetController
                                animated:YES];
    }
}

- (void)nextTapped:(id)sender
{
	[self updateViews];
	
	// display calendar
	[UIView transitionWithView:self.containerView
					  duration:0.75
					   options:UIViewAnimationOptionTransitionFlipFromRight
					animations:^{
						[self displayView:self.calendar];
					}
					completion:NULL];
}

- (void)prevTapped:(id)sender
{
	[self updateViews];
	
	// display chalkboard
	[UIView transitionWithView:self.containerView
					  duration:0.75
					   options:UIViewAnimationOptionTransitionFlipFromLeft
					animations:^{
						[self displayView:self.chalkboard];
					}
					completion:NULL];
}

- (void)editTapped:(id)sender
{
    // temporarely set a background to the container
    self.containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    
    // create last cigarette controller
    self.lastCigaretteController = [[LastCigaretteController alloc] init];
    self.lastCigaretteController.delegate = self;

    // add last cigarette view
    [self.view insertSubview:self.lastCigaretteController.view
                     atIndex:0];
    
    // calculate new frame
    CGRect viewFrame = self.containerView.frame;
    viewFrame.origin.y -= viewFrame.size.height;
    
    // shift container upwards
    [UIView animateWithDuration:0.75
                     animations:^{
                         self.containerView.frame = viewFrame;
                     }];
}

- (void)viewSwipedLeft:(UISwipeGestureRecognizer *)recognizer
{
    // dismiss any gesture if the date of last cigarette is not set
	if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
        return;
    }
    
    // flip to the calendar
    if ([[self.containerView.subviews lastObject] isEqual:self.chalkboard]) {
        [UIView transitionWithView:self.containerView
                          duration:0.750
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self displayView:self.calendar];
                        }
                        completion:NULL];
    }
    // flip to the chalkboard
    else {
        [UIView transitionWithView:self.containerView
                          duration:0.750
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self displayView:self.chalkboard];
                        }
                        completion:NULL];
    }
}

- (void)viewSwipedRight:(UISwipeGestureRecognizer *)recognizer
{
    // dismiss any gesture if the date of last cigarette is not set
	if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
        return;
    }
    
    // flip to the calendar
    if ([[self.containerView.subviews lastObject] isEqual:self.chalkboard]) {
        [UIView transitionWithView:self.containerView
                          duration:0.750
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self displayView:self.calendar];
                        }
                        completion:NULL];
    }
    // flip to the chalkboard
    else {
        [UIView transitionWithView:self.containerView
                          duration:0.750
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self displayView:self.chalkboard];
                        }
                        completion:NULL];
    }
}

#pragma mark - Underlay view delegate

- (void)underlayViewDidFinish
{
    [self updateViews];
    
    // get rid of the note
    if (([[PreferencesManager sharedManager] lastCigaretteDate] != nil) &&
        (self.note != nil)) {
        [self.note removeFromSuperview];
        self.note = nil;
    }

    // calculate new frame
    CGRect viewFrame = self.containerView.frame;
    viewFrame.origin.y = 0.0;
    
    // shift container downwards
    [UIView animateWithDuration:0.750
                     animations:^{
                         self.containerView.frame = viewFrame;
                     }
                     completion:^(BOOL finished){                         
                         // get rid of last cigarette controller
                         [self.lastCigaretteController.view removeFromSuperview];
                         self.lastCigaretteController = nil;
                         
                         // restore container background
                         self.containerView.backgroundColor = [UIColor clearColor];
                     }];
}

@end
