//
//  PacketSizeViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 24/09/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import "PacketSizeViewController.h"

#import "PreferencesManager.h"


#define MAX_PACKET_SIZE 50


@interface PacketSizeViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *sizePicker;

@end


@implementation PacketSizeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
    
	// Set value from preferences to the picker view.
    if (([PreferencesManager sharedManager].prefs)[PACKET_SIZE_KEY]) {
        [self.sizePicker selectRow:([([PreferencesManager sharedManager].prefs)[PACKET_SIZE_KEY] intValue] - 1)
                       inComponent:0
                          animated:NO];
    }
    else {
        // Set 20 cigarettes as default.
        [self.sizePicker selectRow:19
                       inComponent:0
                          animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.sizePicker = nil;
}

#pragma mark Actions

- (IBAction)cancelTapped:(id)sender
{
    // Dismiss view without saving the date.
    [self.delegate viewControllerDidClose];
}

- (IBAction)doneTapped:(id)sender
{
	// Set preference.
	([PreferencesManager sharedManager].prefs)[PACKET_SIZE_KEY] = @([self.sizePicker selectedRowInComponent:0] + 1);
	// Save preferences to file.
	[[PreferencesManager sharedManager] savePrefs];
    
    // Dismiss the view.
    [self.delegate viewControllerDidClose];
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
