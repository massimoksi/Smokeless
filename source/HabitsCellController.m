//
//  HabitsCellController.m
//  Smokeless
//
//  Created by Massimo Peri on 03/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "HabitsCellController.h"

#import "PreferencesManager.h"


@implementation HabitsCellController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// set text label
	self.cell.textLabel.text = MPString(@"Habits");
	// set detail text label
	[self updateCell];
	
	// create the habits picker
	habitsPicker = [[UIPickerView alloc] init];
	habitsPicker.showsSelectionIndicator = YES;
	habitsPicker.dataSource = self;
	habitsPicker.delegate = self;
    
    // create shadow
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.frame = CGRectMake(0.0, habitsPicker.frame.size.height, 320.0, 10.0);
    CGColorRef darkColor = [UIColor colorWithWhite:0.000 alpha:0.800].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    shadowLayer.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    
    // add shadow to setting view
    [self.settingView.layer addSublayer:shadowLayer];
    [shadowLayer release];
    
	// add actions to buttons
	[self.saveButton addTarget:self
                        action:@selector(saveTapped:)
              forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self
                          action:@selector(cancelTapped:)
                forControlEvents:UIControlEventTouchUpInside];
	
	// create setting view hierarchy
	[self.settingView addSubview:habitsPicker];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[habitsPicker release];

    [super dealloc];
}

#pragma mark Actions

- (void)updateCell
{
	// get preferences
	NSDictionary *habits = [[PreferencesManager sharedManager].prefs objectForKey:HABITS_KEY];
	if (habits != nil) {
		NSInteger quantity = [[habits objectForKey:HABITS_QUANTITY_KEY] intValue];
		NSInteger unit = [[habits objectForKey:HABITS_UNIT_KEY] intValue];
		NSInteger period = [[habits objectForKey:HABITS_PERIOD_KEY] intValue];
		// create unit string
		NSString *unitString = nil;
		switch (unit) {
			case 0:
				unitString = (quantity == 1) ?
				MPString(@"cigarette") :
				MPString(@"cigarettes");
				break;
				
			case 1:
				unitString = (quantity == 1) ?
				MPString(@"packet") :
				MPString(@"packets");
				break;
		}
		// create period string
		NSString *periodString = nil;
		switch (period) {
			case 0:
				periodString = MPString(@"a day");
				break;
				
			case 1:
				periodString = MPString(@"a week");
				break;
		}
		
		// set detail text
		self.cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@ %@", quantity, unitString, periodString];
	}
	else {
		// clean up detail text
		self.cell.detailTextLabel.text = nil;
	}
}

- (void)updateSettingView
{
	// retrieve preferences
	NSDictionary *habits = [[PreferencesManager sharedManager].prefs objectForKey:HABITS_KEY];
	NSInteger quantity = [[habits objectForKey:HABITS_QUANTITY_KEY] intValue];
	NSInteger unit = [[habits objectForKey:HABITS_UNIT_KEY] intValue];
	NSInteger period = [[habits objectForKey:HABITS_PERIOD_KEY] intValue];
	
#ifdef DEBUG
	NSLog(@"%@ - Quantity: %d", [self class], quantity);
	NSLog(@"%@ - Unit: %d", [self class], unit);
	NSLog(@"%@ - Period: %d", [self class], period);
#endif
	
	// set values from preferences to the picker view
	[habitsPicker selectRow:(quantity - 1)
				inComponent:HabitsComponentQuantity
				   animated:NO];
	[habitsPicker selectRow:unit
				inComponent:HabitsComponentUnit
				   animated:NO];
	[habitsPicker selectRow:period
				inComponent:HabitsComponentPeriod
				   animated:NO];
}

- (void)saveTapped:(id)sender
{
	// retrieve selected values from picker view
	NSInteger quantity = [habitsPicker selectedRowInComponent:HabitsComponentQuantity] + 1;
	NSInteger unit = [habitsPicker selectedRowInComponent:HabitsComponentUnit];
	NSInteger period = [habitsPicker selectedRowInComponent:HabitsComponentPeriod];

#ifdef DEBUG
	NSLog(@"%@ - Quantity: %d", [self class], quantity);
	NSLog(@"%@ - Unit: %d", [self class], unit);
	NSLog(@"%@ - Period: %d", [self class], period);
#endif	
	
	// collect smoking habits
	NSDictionary *habits = [[NSDictionary alloc] initWithObjectsAndKeys:
							[NSNumber numberWithInt:quantity],
							HABITS_QUANTITY_KEY,
							[NSNumber numberWithInt:unit],
							HABITS_UNIT_KEY,
							[NSNumber numberWithInt:period],
							HABITS_PERIOD_KEY,
							nil];
	
	// set preference
	[[PreferencesManager sharedManager].prefs setObject:habits
												 forKey:HABITS_KEY];
	[habits release];
	// save preferences to file
	[[PreferencesManager sharedManager] savePrefs];
	
	// hide setting view
	[self hideSettingView];
}

- (void)cancelTapped:(id)sender
{
	// hide setting view
	[self hideSettingView];
}

#pragma mark -
#pragma mark Picker view data source

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

#pragma mark -
#pragma mark Picker view delegate

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
