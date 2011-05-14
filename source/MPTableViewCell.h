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


typedef enum {
    MPTableViewCellPositionSingle = 0,
    MPTableViewCellPositionTop,
    MPTableViewCellPositionMiddle,
    MPTableViewCellPositionBottom
} MPTableViewCellPosition;


@interface MPTableViewCell : UITableViewCell {
    MPTableViewCellPosition _position;
}

@property (nonatomic, assign) MPTableViewCellPosition position;
@property (nonatomic, retain) MPCell *backgroundView;
@property (nonatomic, retain) MPCell *selectedBackgroundView;

@end
