//
//  SavingsSettingsController.h
//  Smokeless
//
//  Created by Massimo Peri on 26/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingCellController.h"


@interface SavingsSettingsController : UIViewController <SettingCellDelegate>

@property (nonatomic, retain) NSArray *cellControllers;

@end
