//
//  MPDisclosureIndicator.h
//  Smokeless
//
//  Created by Massimo Peri on 23/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    MPDisclosureIndicatorOrientationRight = 0,
    MPDisclosureIndicatorOrientationLeft,
    MPDisclosureIndicatorOrientationUp,
    MPDisclosureIndicatorOrientationDown
} MPDisclosureIndicatorOrientation;


@interface MPDisclosureIndicator : UIView

@property (nonatomic, assign) MPDisclosureIndicatorOrientation orientation;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, retain) UIColor *normalColor;
@property (nonatomic, retain) UIColor *highlightedColor;

@end
