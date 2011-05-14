//
//  HealthTableViewCell.m
//  Smokeless
//
//  Created by Massimo Peri on 06/04/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "HealthTableViewCell.h"


@implementation HealthTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // position text label
    CGRect textRect = self.textLabel.frame;
    textRect.origin.y = 4.0;
    self.textLabel.frame = textRect;
    
    // position detail text label
    CGRect detailTextRect = self.detailTextLabel.frame;
    detailTextRect.origin.y = 24.0;
    self.detailTextLabel.frame = detailTextRect;
}

@end
