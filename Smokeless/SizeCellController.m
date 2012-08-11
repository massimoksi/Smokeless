//
//  SizeCellController.m
//  Smokeless
//
//  Created by Massimo Peri on 05/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "SizeCellController.h"

#import "PreferencesManager.h"


#define MAX_PACKET_SIZE 50


@interface SizeCellController ()

@property (nonatomic, strong) UIPickerView *sizePicker;

- (void)saveTapped:(id)sender;
- (void)cancelTapped:(id)sender;

@end


@implementation SizeCellController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// set text label
	self.cell.textLabel.text = MPString(@"Packet size");
	// set detail text label
	[self updateCell];
	
	// create the size picker
	self.sizePicker = [[UIPickerView alloc] init];
	self.sizePicker.showsSelectionIndicator = YES;
	self.sizePicker.dataSource = self;
	self.sizePicker.delegate = self;

    // create shadow
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.frame = CGRectMake(0.0,
                                   self.sizePicker.frame.size.height,
                                   320.0,
                                   10.0);
    CGColorRef darkColor = [UIColor colorWithWhite:0.000
                                             alpha:0.800].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    shadowLayer.colors = @[(__bridge id)darkColor,
                          (__bridge id)lightColor];
    
    // add shadow to setting view
    [self.settingView.layer addSublayer:shadowLayer];
    
	// add actions to buttons
	[self.saveButton addTarget:self
                        action:@selector(saveTapped:)
              forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self
                          action:@selector(cancelTapped:)
                forControlEvents:UIControlEventTouchUpInside];
	
	// create setting view hierarchy
	[self.settingView addSubview:self.sizePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.sizePicker = nil;
}

#pragma mark Actions

- (void)updateCell
{
	// get preferences
	NSInteger size = [([PreferencesManager sharedManager].prefs)[PACKET_SIZE_KEY] intValue];
	
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
	[self.sizePicker selectRow:([([PreferencesManager sharedManager].prefs)[PACKET_SIZE_KEY] intValue] - 1)
                   inComponent:0
                      animated:NO];
}

- (void)saveTapped:(id)sender
{
	// set preference
	([PreferencesManager sharedManager].prefs)[PACKET_SIZE_KEY] = @([self.sizePicker selectedRowInComponent:0] + 1);
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

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return MAX_PACKET_SIZE;
}

#pragma mark - Picker view delegate

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
