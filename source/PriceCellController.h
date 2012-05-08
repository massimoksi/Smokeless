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


@interface PriceCellController : SettingCellController

- (UIButton *)calcButtonWithPosition:(CGPoint)position andTag:(NSInteger)tag;

- (void)saveTapped:(id)sender;
- (void)cancelTapped:(id)sender;

- (void)digitTapped:(id)sender;
- (void)cancTapped:(id)sender;
- (void)pointTapped:(id)sender;

@end
