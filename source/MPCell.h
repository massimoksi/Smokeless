//
//  MPCell.h
//  Smokeless
//
//  Created by Massimo Peri on 20/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    MPCellPositionSingle = 0,
    MPCellPositionTop,
    MPCellPositionMiddle,
    MPCellPositionBottom
} MPCellPosition;

typedef enum {
    MPCellStyleEmpty = 0,
    MPCellStyleColorFill,
    MPCellStyleGradient
} MPCellStyle;


@interface MPCell : UIView

@property (nonatomic, assign) MPCellPosition position;
@property (nonatomic, assign) MPCellStyle style;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) UIColor *startColor;
@property (nonatomic, retain) UIColor *endColor;

@end
