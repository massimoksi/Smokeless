//
//  MPTableViewCell.h
//  Smokeless
//
//  Created by Massimo Peri on 24/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPCell.h"
#import "MPDisclosureIndicator.h"


typedef enum : NSUInteger {
    MPTableViewCellPositionSingle,
    MPTableViewCellPositionTop,
    MPTableViewCellPositionMiddle,
    MPTableViewCellPositionBottom
} MPTableViewCellPosition;


@interface MPTableViewCell : UITableViewCell

@property (nonatomic, assign) MPTableViewCellPosition position;
@property (nonatomic, strong) MPCell *backgroundView;
@property (nonatomic, strong) MPCell *selectedBackgroundView;

@end
