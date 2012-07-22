//
//  MPDisclosureIndicator.h
//  Smokeless
//
//  Created by Massimo Peri on 23/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum MPDisclosureIndicatorOrientation : NSUInteger {
    MPDisclosureIndicatorOrientationRight,
    MPDisclosureIndicatorOrientationLeft,
    MPDisclosureIndicatorOrientationUp,
    MPDisclosureIndicatorOrientationDown
} MPDisclosureIndicatorOrientation;


@interface MPDisclosureIndicator : UIView

@property (nonatomic, assign) MPDisclosureIndicatorOrientation orientation;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightedColor;

@end
