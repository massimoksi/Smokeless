//
//  HabitsViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 24/09/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import "HabitsViewController.h"

#import "PreferencesManager.h"


enum : NSUInteger {
	HabitsComponentQuantity = 0,
	HabitsComponentUnit,
	HabitsComponentPeriod,
	
	HabitsNoOfComponents
};


@interface HabitsViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *habitsPicker;

@end


@implementation HabitsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    
	// Retrieve preferences.
	NSDictionary *habits = ([PreferencesManager sharedManager].prefs)[HABITS_KEY];
	NSInteger quantity = [habits[HABITS_QUANTITY_KEY] intValue];
	NSInteger unit = [habits[HABITS_UNIT_KEY] intValue];
	NSInteger period = [habits[HABITS_PERIOD_KEY] intValue];
	
#ifdef DEBUG
	NSLog(@"%@ - Quantity: %d", [self class], quantity);
	NSLog(@"%@ - Unit: %d", [self class], unit);
	NSLog(@"%@ - Period: %d", [self class], period);
#endif
	
	// Set values from preferences to the picker view.
	[self.habitsPicker selectRow:(quantity - 1)
                     inComponent:HabitsComponentQuantity
                        animated:NO];
	[self.habitsPicker selectRow:unit
                     inComponent:HabitsComponentUnit
                        animated:NO];
	[self.habitsPicker selectRow:period
                     inComponent:HabitsComponentPeriod
                        animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.habitsPicker = nil;
}

#pragma mark Actions

- (IBAction)cancelTapped:(id)sender
{
    // Dismiss view without saving the date.
    [self.delegate viewControllerDidClose];
}

- (IBAction)doneTapped:(id)sender
{
	// Retrieve the selected values from the picker view.
	NSInteger quantity = [self.habitsPicker selectedRowInComponent:HabitsComponentQuantity] + 1;
	NSInteger unit = [self.habitsPicker selectedRowInComponent:HabitsComponentUnit];
	NSInteger period = [self.habitsPicker selectedRowInComponent:HabitsComponentPeriod];
    
#ifdef DEBUG
	NSLog(@"%@ - Quantity: %d", [self class], quantity);
	NSLog(@"%@ - Unit: %d", [self class], unit);
	NSLog(@"%@ - Period: %d", [self class], period);
#endif
	
	// Collect smoking habits.
	NSDictionary *habits = @{
        HABITS_QUANTITY_KEY: @(quantity),
        HABITS_UNIT_KEY: @(unit),
        HABITS_PERIOD_KEY: @(period)
    };
	
	// Set preference.
	([PreferencesManager sharedManager].prefs)[HABITS_KEY] = habits;
	// Save preferences to file.
	[[PreferencesManager sharedManager] savePrefs];
    
    // Dismiss the view.
    [self.delegate viewControllerDidClose];
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return HabitsNoOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger rows = 0;
	
	switch (component) {
		case HabitsComponentQuantity:
			rows = 99;
			break;
			
		case HabitsComponentUnit:
			rows = 2;
			break;
			
		case HabitsComponentPeriod:
			rows = 2;
			break;
	}
	
	return rows;
}

#pragma mark - Picker view delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat width = 0.0;
	
	switch (component) {
		case HabitsComponentQuantity:
			width = 44.0;
			break;
			
		case HabitsComponentUnit:
			width = 134.0;
			break;
			
		case HabitsComponentPeriod:
			width = 107.0;
			break;
	}
	
	return width;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *title = nil;
	
	switch (component) {
		case HabitsComponentQuantity:
			title = [NSString stringWithFormat:@"%d", row + 1];
			break;
			
		case HabitsComponentUnit:
			if (row == 0) {
				title = [MPString(@"Cigarette(s)") lowercaseString];
			}
			else {
				title = [MPString(@"Packet(s)") lowercaseString];
			}
			break;
			
		case HabitsComponentPeriod:
			if (row == 0) {
				title = [MPString(@"Day") lowercaseString];
			}
			else {
				title = [MPString(@"Week") lowercaseString];
			}
			break;
	}
	
	return title;
}

@end