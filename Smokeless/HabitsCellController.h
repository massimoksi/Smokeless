//
//  HabitsCellController.h
//  Smokeless
//
//  Created by Massimo Peri on 03/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SettingCellController.h"


enum {
	HabitsComponentQuantity = 0,
	HabitsComponentUnit,
	HabitsComponentPeriod,
	
	HabitsNoOfComponents
};


@interface HabitsCellController : SettingCellController <UIPickerViewDataSource, UIPickerViewDelegate>

- (void)saveTapped:(id)sender;
- (void)cancelTapped:(id)sender;

@end
