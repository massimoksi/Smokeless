//
//  LastCigaretteViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 23/09/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import "LastCigaretteViewController.h"

#import "PreferencesManager.h"


@interface LastCigaretteViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;

@end


@implementation LastCigaretteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    
	// Set up the date picker.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.datePicker = nil;
}

#pragma mark Actions

- (IBAction)cancelTapped:(id)sender
{
    // Dismiss view without saving the date.
    [self.delegate viewControllerDidClose];
}

- (IBAction)doneTapped:(id)sender
{
    // Get the date from the picker.
    NSDate *lastCigaretteDate = self.datePicker.date;
    
    // Set the hour for the date of the last cigarette.
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *lastCigaretteComponents = [gregorianCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit)
                                                                     fromDate:lastCigaretteDate];
    [lastCigaretteComponents setHour:4];
    
#ifdef DEBUG
    NSLog(@"%@ - Set last cigarette date: %@", [self class], [gregorianCalendar dateFromComponents:lastCigaretteComponents]);
#endif
    
	// Set preference.
	([PreferencesManager sharedManager].prefs)[LAST_CIGARETTE_KEY] = [gregorianCalendar dateFromComponents:lastCigaretteComponents];
    
	// Save preferences to file.
	[[PreferencesManager sharedManager] savePrefs];
    
    // Dismiss the view.
    [self.delegate viewControllerDidClose];
}

@end
