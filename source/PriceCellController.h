//
//  PriceCellController.h
//  Smokeless
//
//  Created by Massimo Peri on 05/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SettingCellController.h"


@interface PriceCellController : SettingCellController {
	UIButton *button_0;
	UIButton *button_1;
	UIButton *button_2;
	UIButton *button_3;
	UIButton *button_4;
	UIButton *button_5;
	UIButton *button_6;
	UIButton *button_7;
	UIButton *button_8;
	UIButton *button_9;
	UIButton *button_c;
	UIButton *button_p;
	
@private
	BOOL reset;
	NSUInteger decimals;
}

- (UIButton *)calcButtonWithPosition:(CGPoint)position andTag:(NSInteger)tag;

- (void)saveTapped:(id)sender;
- (void)cancelTapped:(id)sender;

- (void)digitTapped:(id)sender;
- (void)cancTapped:(id)sender;
- (void)pointTapped:(id)sender;

@end
