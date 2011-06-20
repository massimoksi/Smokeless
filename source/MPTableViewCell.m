//
//  MPTableViewCell.m
//  Smokeless
//
//  Created by Massimo Peri on 24/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "MPTableViewCell.h"


@implementation MPTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[[MPCell alloc] initWithFrame:self.bounds] autorelease];
        self.selectedBackgroundView = [[[MPCell alloc] initWithFrame:self.bounds] autorelease];
        self.selectedBackgroundView.style = MPCellStyleGradient;
        self.selectedBackgroundView.startColor = [UIColor colorWithRed:0.345 green:0.592 blue:0.929 alpha:1.000];
        self.selectedBackgroundView.endColor = [UIColor colorWithRed:0.220 green:0.470 blue:0.851 alpha:1.000];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark Accessors

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // highlight disclosure indicator
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        // highlight disclosure indicator
        ((MPDisclosureIndicator *)(self.accessoryView)).highlighted = selected;
    }
    
    [super setSelected:selected
              animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    // highlight disclosure indicator
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        // highlight disclosure indicator
        ((MPDisclosureIndicator *)(self.accessoryView)).highlighted = highlighted;
    }
    
    [super setHighlighted:highlighted
                 animated:animated];
}

- (MPTableViewCellPosition)position
{
    return _position;
}

- (void)setPosition:(MPTableViewCellPosition)cellPosition
{
    if (_position != cellPosition) {
        _position = cellPosition;
        
        self.backgroundView.position = cellPosition;
        self.selectedBackgroundView.position = cellPosition;
    }
}

- (MPCell *)backgroundView
{
    return (MPCell *)[super backgroundView];
}

- (void)setBackgroundView:(MPCell *)backgroundView
{
    [super setBackgroundView:backgroundView];
}

- (MPCell *)selectedBackgroundView
{
    return (MPCell *)[super selectedBackgroundView];
}

- (void)setSelectedBackgroundView:(MPCell *)backgroundView
{
    [super setSelectedBackgroundView:backgroundView];
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    
    // add disclosure indicator
    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        self.accessoryView = [[[MPDisclosureIndicator alloc] init] autorelease];
    }
}

@end
