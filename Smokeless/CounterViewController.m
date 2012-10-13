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


@interface CounterViewController ()

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIImageView *noteView;

@property (strong, nonatomic) ChalkboardView *chalkboard;
@property (strong, nonatomic) CalendarView *calendar;

@end


@implementation CounterViewController

- (void)loadView
{
    // Create the view.
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    
    // Create the left swipe gesture recognizer.
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(viewSwipedLeft:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    // Create the right swipe gesture recognizer.
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(viewSwipedRight:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // Add the swipe gesture recognizers to the view.
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	   
	// Create the container view.
	self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.containerView];
    
	// Create the chalkboard view.
	self.chalkboard = [[ChalkboardView alloc] init];
    self.chalkboard.center = CGPointMake(self.view.center.x,
                                         self.view.center.y - self.tabBarController.tabBar.frame.size.height);
    if ([TWTweetComposeViewController canSendTweet] == YES) {
        [self.chalkboard.tweetButton addTarget:self
                                        action:@selector(shareTapped:)
                              forControlEvents:UIControlEventTouchUpInside];
    }
	[self.chalkboard.nextButton addTarget:self
								   action:@selector(nextTapped:)
						 forControlEvents:UIControlEventTouchUpInside];
	
	// Create the calendar view.
	self.calendar = [[CalendarView alloc] initWithDate:[[PreferencesManager sharedManager] lastCigaretteDate]];
    self.calendar.center = CGPointMake(self.view.center.x,
                                       self.view.center.y - self.tabBarController.tabBar.frame.size.height);
	[self.calendar.prevButton addTarget:self
								 action:@selector(prevTapped:)
					   forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self updateViews];
    
	if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
		// Show the calendar.
		[self displayView:self.calendar];
        
        // Create the note view.
        if (self.noteView == nil) {
            self.noteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Note"]];
            CGRect frame = self.noteView.frame;
            frame.origin.x = self.view.frame.size.width - self.noteView.frame.size.width - 5.0f;
            frame.origin.y = self.view.frame.size.height - self.noteView.frame.size.height - 5.0f;
            self.noteView.frame = frame;
        }
        
        // Show the note view.
		[self.view addSubview:self.noteView];
	}
	else {		
		// Show the chalkboard.
		[self displayView:self.chalkboard];
        
        // Remove the note view if present.
        if (self.noteView != nil) {
            [self.noteView removeFromSuperview];
            self.noteView = nil;
        }
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.containerView = nil;
	self.noteView = nil;
    
	self.chalkboard = nil;
	self.calendar = nil;
}

#pragma mark Actions

- (void)displayView:(id)aView
{
	// Switch visible view.
	if ([aView isEqual:[self.containerView.subviews lastObject]] == NO) {
		[[self.containerView.subviews lastObject] removeFromSuperview];
		[self.containerView addSubview:aView];
	}
}

- (void)updateViews
{
	if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
		// Reset the chalkboard.
		self.chalkboard.years = 0;
		self.chalkboard.months = 0;
		self.chalkboard.weeks = 0;
		self.chalkboard.days = 0;
		
		// Reset the calendar.
		self.calendar.date = nil;
	}
	else {
		// Update the chalkboard.
		NSDateComponents *counterComponents = [[PreferencesManager sharedManager] nonSmokingInterval];
		self.chalkboard.years = [counterComponents year];
		self.chalkboard.months = [counterComponents month];
		self.chalkboard.weeks = [counterComponents week];
		self.chalkboard.days = [counterComponents day];
		
		// Update the calendar.
		self.calendar.date = [[PreferencesManager sharedManager] lastCigaretteDate];
	}
}

- (void)shareTapped:(id)sender
{
    // Collect data to be posted.
    NSInteger nonSmokingDays = [[PreferencesManager sharedManager] nonSmokingDays];
    NSString *nonSmokingInterval = (nonSmokingDays == 1) ? [NSString stringWithFormat:MPString(@"%d day"), nonSmokingDays] : [NSString stringWithFormat:MPString(@"%d days"), nonSmokingDays];
    NSString *postText = [NSString stringWithFormat:MPString(@"Not smoking for %@ thanks to Smokeless."), nonSmokingInterval];
    NSURL *postURL = [NSURL URLWithString:@"http://itunes.apple.com/us/app/smokeless-quit-smoking/id438027793?mt=8&uo=4"];
    
    if (NSStringFromClass([UIActivityViewController class]) != nil) {
        // Create the activity controller.
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[postText, postURL]
                                                                                         applicationActivities:nil];
        activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToWeibo];
        
        // Present the activity controller.
        [self presentViewController:activityController
                           animated:YES
                         completion:nil];
    }
    else {
        NSLog(@"---> Not yet implemented");
//        if ([TWTweetComposeViewController canSendTweet] == YES) {
//            // create the tweet sheet controller
//            TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];
//            // assign the text for the tweet
//            NSInteger nonSmokingDays = [[PreferencesManager sharedManager] nonSmokingDays];
//            NSString *nonSmokingInterval = (nonSmokingDays == 1) ? [NSString stringWithFormat:MPString(@"%d day"), nonSmokingDays] : [NSString stringWithFormat:MPString(@"%d days"), nonSmokingDays];
//            [tweetController setInitialText:[NSString stringWithFormat:MPString(@"Not smoking for %@ thanks to #Smokeless."), nonSmokingInterval]];
//            [tweetController addURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/smokeless-quit-smoking/id438027793?mt=8&uo=4"]];
//            
//            // present the tweet sheet
//            [self presentModalViewController:tweetController
//                                    animated:YES];
//        }
    }
}

- (void)nextTapped:(id)sender
{
	[self updateViews];
	
	// Show the calendar.
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
	
	// Show the chalkboard.
	[UIView transitionWithView:self.containerView
					  duration:0.75
					   options:UIViewAnimationOptionTransitionFlipFromLeft
					animations:^{
						[self displayView:self.chalkboard];
					}
					completion:NULL];
}

- (void)viewSwipedLeft:(UISwipeGestureRecognizer *)recognizer
{
    // Reject any gesture if the date of last cigarette is not set.
	if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
        return;
    }
    
    if ([[self.containerView.subviews lastObject] isEqual:self.chalkboard]) {
        // Flip to the calendar.
        [UIView transitionWithView:self.containerView
                          duration:0.750
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self displayView:self.calendar];
                        }
                        completion:NULL];
    }
    else {
        // Flip to the chalkboard.
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
    // Reject any gesture if the date of last cigarette is not set.
	if ([[PreferencesManager sharedManager] lastCigaretteDate] == nil) {
        return;
    }
    
    if ([[self.containerView.subviews lastObject] isEqual:self.chalkboard]) {
        // Flip to the calendar.
        [UIView transitionWithView:self.containerView
                          duration:0.750
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self displayView:self.calendar];
                        }
                        completion:NULL];
    }
    else {
        // Flip to the chalkboard.
        [UIView transitionWithView:self.containerView
                          duration:0.750
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self displayView:self.chalkboard];
                        }
                        completion:NULL];
    }
}

@end
