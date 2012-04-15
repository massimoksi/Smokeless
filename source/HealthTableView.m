//
//  HealthTableView.m
//  Smokeless
//
//  Created by Massimo Peri on 01/04/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "HealthTableView.h"


#define SHADOW_HEIGHT           4.0
#define SHADOW_INVERSE_HEIGHT   3.0
#define SHADOW_RATIO            (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)


@implementation HealthTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // customize table view
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
        self.rowHeight = 80.0;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor colorWithWhite:1.000
                                                alpha:0.100];
    }
    
    return self;
}

- (void)dealloc
{
	[topShadow release];
	[bottomShadow release];
    
	[super dealloc];
}

#pragma mark Layout

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// construct the origin shadow if needed
	if (!originShadow) {
		originShadow = [self shadowAsInverse:NO];
		[self.layer insertSublayer:originShadow
                           atIndex:0];
	}
	else if ([[self.layer.sublayers objectAtIndex:0] isEqual:originShadow] == NO) {
		[self.layer insertSublayer:originShadow
                           atIndex:0];
	}
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];

	// stretch and place the origin shadow
	CGRect originShadowFrame = originShadow.frame;
	originShadowFrame.size.width = self.frame.size.width;
	originShadowFrame.origin.y = self.contentOffset.y;
	originShadow.frame = originShadowFrame;
	
	[CATransaction commit];
	
	NSArray *indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	if ([indexPathsForVisibleRows count] == 0) {
		[topShadow removeFromSuperlayer];
		[topShadow release];
		topShadow = nil;

		[bottomShadow removeFromSuperlayer];
		[bottomShadow release];
		bottomShadow = nil;

		return;
	}
	
	NSIndexPath *firstRow = [indexPathsForVisibleRows objectAtIndex:0];
	if ([firstRow section] == 0 && [firstRow row] == 0) {
		UIView *cell = [self cellForRowAtIndexPath:firstRow];
		if (!topShadow) {
			topShadow = [[self shadowAsInverse:YES] retain];
			[cell.layer insertSublayer:topShadow
                               atIndex:0];
		}
		else if ([cell.layer.sublayers indexOfObjectIdenticalTo:topShadow] != 0) {
			[cell.layer insertSublayer:topShadow
                               atIndex:0];
		}

		CGRect shadowFrame = topShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = -SHADOW_INVERSE_HEIGHT;
		topShadow.frame = shadowFrame;
	}
	else {
		[topShadow removeFromSuperlayer];
		[topShadow release];
		topShadow = nil;
	}

	NSIndexPath *lastRow = [indexPathsForVisibleRows lastObject];
	if ([lastRow section] == [self numberOfSections] - 1 &&
		[lastRow row] == [self numberOfRowsInSection:[lastRow section]] - 1) {
		UIView *cell = [self cellForRowAtIndexPath:lastRow];
		if (!bottomShadow) {
			bottomShadow = [[self shadowAsInverse:NO] retain];
			[cell.layer insertSublayer:bottomShadow
                               atIndex:0];
		}
		else if ([cell.layer.sublayers indexOfObjectIdenticalTo:bottomShadow] != 0) {
			[cell.layer insertSublayer:bottomShadow
                               atIndex:0];
		}

		CGRect shadowFrame = bottomShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = cell.frame.size.height;
		bottomShadow.frame = shadowFrame;
	}
	else {
		[bottomShadow removeFromSuperlayer];
		[bottomShadow release];
		bottomShadow = nil;
	}
}

#pragma mark Shadow

- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse
{
	CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];

	newShadow.frame = CGRectMake(0.0,
                                 0.0,
                                 self.frame.size.width,
                                 inverse ? SHADOW_INVERSE_HEIGHT : SHADOW_HEIGHT);
	CGColorRef darkColor = [UIColor colorWithRed:0.0
                                           green:0.0
                                            blue:0.0
                                           alpha:0.5].CGColor;
	CGColorRef lightColor = [self.backgroundColor colorWithAlphaComponent:0.0].CGColor;
	newShadow.colors = [NSArray arrayWithObjects:
                        (id)(inverse ? lightColor : darkColor),
                        (id)(inverse ? darkColor : lightColor),
                        nil];
    
	return newShadow;
}

@end
