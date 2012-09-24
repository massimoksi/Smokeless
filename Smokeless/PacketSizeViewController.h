//
//  PacketSizeViewController.h
//  Smokeless
//
//  Created by Massimo Peri on 24/09/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPSettingViewDelegate.h"


@interface PacketSizeViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) id <MPSettingViewDelegate> delegate;

@end
