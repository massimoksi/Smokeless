//
//  CounterViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "CounterViewController.h"

#import "PreferencesManager.h"


@implementation CounterViewController

#pragma mark View lifecycle

- (void)loadView
{
	// create view
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	
	// set background
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// create the container view
	container = [[UIView alloc] initWithFrame:self.view.bounds];
	container.backgroundColor = [UIColor clearColor];
	[self.view addSubview:container];
		
	// create counter view
	self.chalkboard = [[[ChalkboardView alloc] init] autorelease];
	
	// create calendar view
	self.calendar = [[[CalendarView alloc] initWithDate:[[PreferencesManager sharedManager] lastCigaretteDate]] autorelease];

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
    if (lastCigaretteController) {
        [lastCigaretteController.view removeFromSuperview];
        [lastCigaretteController release];
        lastCigaretteController = nil;
        
        // restore container position
        CGRect viewFrame = container.frame;
        viewFrame.origin.y = 0.0;
        container.frame = viewFrame;
        
        // restore container background
        container.backgroundColor = [UIColor clearColor];
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
		self.note = [[[NoteView alloc] init] autorelease];
		
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
		[UIView animateWithDuration:0.75
						 animations:^{
							 self.note.alpha = 1.0;
						 }];
	}
}

#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	[container release];

	self.chalkboard = nil;
	self.calendar = nil;
	self.note = nil;
}

- (void)dealloc
{
	[container release];
	
	self.chalkboard = nil;
	self.calendar = nil;
	self.note = nil;
	
    [super dealloc];
}

#pragma mark Accessors

@synthesize chalkboard;
@synthesize calendar;
@synthesize note;

#pragma mark Actions

- (void)displayView:(id)aView
{
	// switch visible view
	if ([aView isEqual:[container.subviews lastObject]] == NO) {
		[[container.subviews lastObject] removeFromSuperview];
		[container addSubview:aView];
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
        TWTweetComposeViewController *tweetController = [[[TWTweetComposeViewController alloc] init] autorelease];
        // assign the text for the tweet
        NSInteger nonSmokingDays = [[PreferencesManager sharedManager] nonSmokingDays];
        NSString *nonSmokingInterval = (nonSmokingDays == 1) ? [NSString stringWithFormat:MPString(@"%d day"), nonSmokingDays] : [NSString stringWithFormat:MPString(@"%d days"), nonSmokingDays];
        [tweetController setInitialText:[NSString stringWithFormat:MPString(@"Not smoking since %@ thanks to Smokeless."), nonSmokingInterval]];
        [tweetController addURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/smokeless-quit-smoking/id438027793?mt=8&uo=4"]];
        
        // present the tweet sheet
        [self presentModalViewController:tweetController
                                animated:YES];
    }
    else {
        // TODO: display an alert view
    }
}

- (void)nextTapped:(id)sender
{
	[self updateViews];
	
	// display calendar
	[UIView transitionWithView:container
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
	[UIView transitionWithView:container
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
    container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    
    // create last cigarette controller
    lastCigaretteController = [[LastCigaretteController alloc] init];
    lastCigaretteController.delegate = self;

    // add last cigarette view
    [self.view insertSubview:lastCigaretteController.view
                     atIndex:0];
    
    // calculate new frame
    CGRect viewFrame = container.frame;
    viewFrame.origin.y -= viewFrame.size.height;
    
    // shift container upwards
    [UIView animateWithDuration:0.75
                     animations:^{
                         container.frame = viewFrame;
                     }];
}

#pragma mark -
#pragma mark Underlay view delegate

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
    CGRect viewFrame = container.frame;
    viewFrame.origin.y = 0.0;
    
    // shift container downwards
    [UIView animateWithDuration:0.75
                     animations:^{
                         container.frame = viewFrame;
                     }
                     completion:^(BOOL finished){                         
                         // get rid of last cigarette controller
                         [lastCigaretteController.view removeFromSuperview];
                         [lastCigaretteController release];
                         lastCigaretteController = nil;
                         
                         // restore container background
                         container.backgroundColor = [UIColor clearColor];
                     }];
}

@end
