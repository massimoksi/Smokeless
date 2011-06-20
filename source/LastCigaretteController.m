//
//  LastCigaretteController.m
//  Smokeless
//
//  Created by Massimo Peri on 12/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "LastCigaretteController.h"

#import "PreferencesManager.h"


#define BUTTON_WIDTH        278.0
#define BUTTON_HEIGHT       45.0
#define BUTTON_PADDING_X    21.0
#define BUTTON_PADDING_Y    12.0


@implementation LastCigaretteController

- (void)loadView
{
    // create view
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 411.0)] autorelease];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    // create the date picker
    self.datePicker = [[[UIDatePicker alloc] init] autorelease];
	self.datePicker.datePickerMode = UIDatePickerModeDate;
	// limit the date picker to today
	self.datePicker.maximumDate = [NSDate date];
    
    // add the date picker
    [self.view addSubview:self.datePicker];
    
    // create cancel button
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(BUTTON_PADDING_X,
                                         self.view.frame.size.height - (BUTTON_HEIGHT + BUTTON_PADDING_Y),
                                         BUTTON_WIDTH,
                                         BUTTON_HEIGHT);
    self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	self.cancelButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.cancelButton.titleLabel.shadowOffset = (CGSize){ 0.0, -1.0 };
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"ButtonCancelNormal"]
                                 forState:UIControlStateNormal];
	[self.cancelButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
	[self.cancelButton setTitleShadowColor:[UIColor darkGrayColor]
                                  forState:UIControlStateNormal];
    // set text
	[self.cancelButton setTitle:MPString(@"Cancel")
                       forState:UIControlStateNormal];
    
	// create save button
	self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = CGRectMake(BUTTON_PADDING_X,
                                       self.view.frame.size.height - (2*BUTTON_HEIGHT + 2*BUTTON_PADDING_Y),
                                       BUTTON_WIDTH,
                                       BUTTON_HEIGHT);
    self.saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	self.saveButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.saveButton.titleLabel.shadowOffset = (CGSize){ 0.0, -1.0 };
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"ButtonSaveNormal"]
                               forState:UIControlStateNormal];
	[self.saveButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
	[self.saveButton setTitleShadowColor:[UIColor darkGrayColor]
                                forState:UIControlStateNormal];
    // set text
	[self.saveButton setTitle:MPString(@"Save")
                     forState:UIControlStateNormal];
    
    // add actions
    [self.saveButton addTarget:self
                        action:@selector(saveTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self
                          action:@selector(cancelTapped:)
                forControlEvents:UIControlEventTouchUpInside];

    // create shadows
    CGColorRef darkColor = [UIColor colorWithWhite:0.000 alpha:0.650].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    CAGradientLayer *bottomShadowLayer = [[CAGradientLayer alloc] init];
    bottomShadowLayer.frame = CGRectMake(0.0,
                                   self.view.frame.size.height - 10.0,
                                   320.0,
                                   10.0);
    bottomShadowLayer.colors = [NSArray arrayWithObjects:(id)lightColor, (id)darkColor, nil];
    CAGradientLayer *topShadowLayer = [[CAGradientLayer alloc] init];
    topShadowLayer.frame = CGRectMake(0.0,
                                      self.datePicker.frame.size.height,
                                      320.0,
                                      10.0);
    topShadowLayer.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    
    // add shadows to view
    [self.view.layer addSublayer:bottomShadowLayer];
    [self.view.layer addSublayer:topShadowLayer];
    [bottomShadowLayer release];
    [topShadowLayer release];
    
    // add buttons
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.cancelButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// set the date picker value
	NSDate *prefsDate = [[PreferencesManager sharedManager] lastCigaretteDate];
	if (prefsDate != nil) {
		[self.datePicker setDate:prefsDate
						animated:NO];
	}
	else {
		[self.datePicker setDate:[NSDate date]
						animated:NO];
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
    
    self.datePicker = nil;
    
    self.saveButton = nil;
    self.cancelButton = nil;
}

- (void)dealloc
{
    self.datePicker = nil;
    
    self.saveButton = nil;
    self.cancelButton = nil;
    
    [super dealloc];
}

#pragma mark Accessors

@synthesize datePicker;
@synthesize saveButton;
@synthesize cancelButton;
@synthesize delegate;

#pragma mark Actions

- (void)saveTapped:(id)sender
{
	// set preference
	[[PreferencesManager sharedManager].prefs setObject:self.datePicker.date
												 forKey:LAST_CIGARETTE_KEY];
	// save preferences to file
	[[PreferencesManager sharedManager] savePrefs];
    
    // send message to delegate
    if ([self.delegate respondsToSelector:@selector(underlayViewDidFinish)]) {
        [self.delegate underlayViewDidFinish];
    }
}

- (void)cancelTapped:(id)sender
{
    // send message to delegate
    if ([self.delegate respondsToSelector:@selector(underlayViewDidFinish)]) {
        [self.delegate underlayViewDidFinish];
    }
}

@end
