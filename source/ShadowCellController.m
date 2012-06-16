//
//  ShadowCellController.m
//  Smokeless
//
//  Created by Massimo Peri on 17/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "ShadowCellController.h"


@implementation ShadowCellController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cell removeFromSuperview];
    [self.settingView removeFromSuperview];
    self.cell = nil;
    self.settingView = nil;
    
    self.view.frame = CGRectMake(0.0, 0.0, 320.0, 6.0);
    
    // create shadow
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.frame = self.view.bounds;
    CGColorRef darkColor = [UIColor colorWithWhite:0.200
                                             alpha:0.300].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    shadowLayer.colors = [NSArray arrayWithObjects:
                          (__bridge id)darkColor,
                          (__bridge id)lightColor,
                          nil];
    
    // add shadow
    [self.view.layer addSublayer:shadowLayer];
}

@end
