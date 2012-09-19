//
//  HealthTableView.m
//  Smokeless
//
//  Created by Massimo Peri on 01/04/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "HealthTableView.h"


#define SHADOW_HEIGHT           5.0
#define SHADOW_INVERSE_HEIGHT   3.0
#define SHADOW_RATIO            (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)


@interface HealthTableView ()

@property (nonatomic, strong) CAGradientLayer *originShadow;
@property (nonatomic, strong) CAGradientLayer *topShadow;
@property (nonatomic, strong) CAGradientLayer *bottomShadow;

@end


@implementation HealthTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // customize table view
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];
        self.rowHeight = 80.0;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor colorWithWhite:1.000
                                                alpha:0.100];
    }
    
    return self;
}

#pragma mark Layout

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// construct the origin shadow if needed
	if (self.originShadow == nil) {
		self.originShadow = [self shadowAsInverse:NO];
		[self.layer insertSublayer:self.originShadow
                           atIndex:0];
	}
	else if ([(self.layer.sublayers)[0] isEqual:self.originShadow] == NO) {
		[self.layer insertSublayer:self.originShadow
                           atIndex:0];
	}
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];

	// stretch and place the origin shadow
	CGRect originShadowFrame = self.originShadow.frame;
	originShadowFrame.size.width = self.frame.size.width;
	originShadowFrame.origin.y = self.contentOffset.y;
	self.originShadow.frame = originShadowFrame;
	
	[CATransaction commit];
	
	NSArray *indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	if ([indexPathsForVisibleRows count] == 0) {
		[self.topShadow removeFromSuperlayer];
		self.topShadow = nil;

		[self.bottomShadow removeFromSuperlayer];
		self.bottomShadow = nil;

		return;
	}
	
	NSIndexPath *firstRow = indexPathsForVisibleRows[0];
	if ([firstRow section] == 0 && [firstRow row] == 0) {
		UIView *cell = [self cellForRowAtIndexPath:firstRow];
		if (self.topShadow == nil) {
			self.topShadow = [self shadowAsInverse:YES];
			[cell.layer insertSublayer:self.topShadow
                               atIndex:0];
		}
		else if ([cell.layer.sublayers indexOfObjectIdenticalTo:self.topShadow] != 0) {
			[cell.layer insertSublayer:self.topShadow
                               atIndex:0];
		}

		CGRect shadowFrame = self.topShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = -SHADOW_INVERSE_HEIGHT;
		self.topShadow.frame = shadowFrame;
	}
	else {
		[self.topShadow removeFromSuperlayer];
		self.topShadow = nil;
	}

	NSIndexPath *lastRow = [indexPathsForVisibleRows lastObject];
	if ([lastRow section] == [self numberOfSections] - 1 &&
		[lastRow row] == [self numberOfRowsInSection:[lastRow section]] - 1) {
		UIView *cell = [self cellForRowAtIndexPath:lastRow];
		if (self.bottomShadow == nil) {
			self.bottomShadow = [self shadowAsInverse:NO];
			[cell.layer insertSublayer:self.bottomShadow
                               atIndex:0];
		}
		else if ([cell.layer.sublayers indexOfObjectIdenticalTo:self.bottomShadow] != 0) {
			[cell.layer insertSublayer:self.bottomShadow
                               atIndex:0];
		}

		CGRect shadowFrame = self.bottomShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y = cell.frame.size.height;
		self.bottomShadow.frame = shadowFrame;
	}
	else {
		[self.bottomShadow removeFromSuperlayer];
		self.bottomShadow = nil;
	}
}

#pragma mark Shadow

- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse
{
	CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];

	newShadow.frame = CGRectMake(0.0,
                                 0.0,
                                 self.frame.size.width,
                                 inverse ? SHADOW_INVERSE_HEIGHT : SHADOW_HEIGHT);
	CGColorRef darkColor = CGColorRetain([UIColor colorWithRed:0.000
                                                         green:0.000
                                                          blue:0.000
                                                         alpha:0.420].CGColor);
	CGColorRef lightColor = CGColorRetain([self.backgroundColor colorWithAlphaComponent:0.000].CGColor);
	newShadow.colors = @[
        (__bridge id)(inverse ? lightColor : darkColor),
        (__bridge id)(inverse ? darkColor : lightColor)
    ];
    
    // Clean up.
    CGColorRelease(darkColor);
    CGColorRelease(lightColor);
    
	return newShadow;
}

@end
