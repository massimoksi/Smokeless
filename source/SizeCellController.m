//
//  SizeCellController.m
//  Smokeless
//
//  Created by Massimo Peri on 05/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "SizeCellController.h"

#import "PreferencesManager.h"


@implementation SizeCellController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// set text label
	self.cell.textLabel.text = MPString(@"Packet size");
	// set detail text label
	[self updateCell];
	
	// create the size picker
	sizePicker = [[UIPickerView alloc] init];
	sizePicker.showsSelectionIndicator = YES;
	sizePicker.dataSource = self;
	sizePicker.delegate = self;

    // create shadow
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.frame = CGRectMake(0.0, sizePicker.frame.size.height, 320.0, 10.0);
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
	[self.settingView addSubview:sizePicker];
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
	[sizePicker release];
	
    [super dealloc];
}

#pragma mark Actions

- (void)updateCell
{
	// get preferences
	NSInteger size = [[[PreferencesManager sharedManager].prefs objectForKey:PACKET_SIZE_KEY] intValue];
	
	if (size != 0) {
		// set detail text
		if (size > 1) {
			self.cell.detailTextLabel.text = [[NSString stringWithFormat:@"%d ", size] stringByAppendingString:MPString(@"cigarettes")];
		}
		else {
			self.cell.detailTextLabel.text = [[NSString stringWithFormat:@"%d ", size] stringByAppendingString:MPString(@"cigarette")];
		}
	}
	else {
		// clean up detail text
		self.cell.detailTextLabel.text = nil;
	}	
}

- (void)updateSettingView
{
	// set values from preferences to the picker view
	[sizePicker selectRow:([[[PreferencesManager sharedManager].prefs objectForKey:PACKET_SIZE_KEY] intValue] - 1)
			  inComponent:0
				 animated:NO];
}

- (void)saveTapped:(id)sender
{
	// set preference
	[[PreferencesManager sharedManager].prefs setObject:[NSNumber numberWithInt:([sizePicker selectedRowInComponent:0] + 1)]
												 forKey:PACKET_SIZE_KEY];
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
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 51;
}

#pragma mark -
#pragma mark Picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (row == 0) {
		return [NSString stringWithFormat:MPString(@"%d cigarette"), row + 1];
	}
	else {
		return [NSString stringWithFormat:MPString(@"%d cigarettes"), row + 1];
	}
}

@end
