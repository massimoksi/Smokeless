//
//  LastCigaretteViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 23/09/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import "LastCigaretteViewController.h"


@interface LastCigaretteViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end


@implementation LastCigaretteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    
	// Set up the date picker.
	NSDate *prefsDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastCigarette"];
	if (prefsDate != nil) {
		[self.datePicker setDate:prefsDate
						animated:NO];
	}
	else {
		[self.datePicker setDate:[NSDate date]
						animated:NO];
	}
    
    // Limit the date picker.
    self.datePicker.maximumDate = [NSDate date];
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
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastCigaretteComponents = [gregorianCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour)
                                                                     fromDate:lastCigaretteDate];
    [lastCigaretteComponents setHour:4];
    
    [[NSUserDefaults standardUserDefaults] setObject:[gregorianCalendar dateFromComponents:lastCigaretteComponents]
                                              forKey:@"LastCigarette"];
    
    // Dismiss the view.
    [self.delegate viewControllerDidClose];
}

@end
