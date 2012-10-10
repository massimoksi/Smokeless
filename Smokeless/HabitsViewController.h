//
//  HabitsViewController.h
//  Smokeless
//
//  Created by Massimo Peri on 24/09/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPSettingViewControllerDelegate.h"


@interface HabitsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) id <MPSettingViewControllerDelegate> delegate;    // TODO: check if it needs to be set to nil.

@end
