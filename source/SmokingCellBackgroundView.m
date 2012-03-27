//
//  SmokingCellBackgroundView.m
//  Smokeless
//
//  Created by Massimo Peri on 26/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "SmokingCellBackgroundView.h"


#define LABEL_PADDING_X	10.0
#define LABEL_PADDING_Y	0.0


@implementation SmokingCellBackgroundView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// create text label
		self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(LABEL_PADDING_X,
																	LABEL_PADDING_Y,
																	self.frame.size.width/2 - LABEL_PADDING_X,
																	self.frame.size.height)] autorelease];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		self.textLabel.textAlignment = UITextAlignmentLeft;
		self.textLabel.textColor = [UIColor colorWithRed:0.627 green:0.631 blue:0.698 alpha:1.000];
		self.textLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.500];
		self.textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		
		// create detail text label
		self.detailTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2,
																		  LABEL_PADDING_Y,
																		  self.frame.size.width/2 - LABEL_PADDING_X,
																		  self.frame.size.height)] autorelease];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
		self.detailTextLabel.textAlignment = UITextAlignmentRight;
		self.detailTextLabel.textColor = [UIColor colorWithRed:0.416 green:0.416 blue:0.463 alpha:1.000];
		self.detailTextLabel.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.500];
		self.detailTextLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		
		// add labels
		[self addSubview:self.textLabel];
		[self addSubview:self.detailTextLabel];
	}
	
	return self;
}

- (void)dealloc
{
	self.textLabel = nil;
	self.detailTextLabel = nil;
	
	[super dealloc];
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
	// retrieve context
	CGContextRef cellContext = UIGraphicsGetCurrentContext();
	
	// retrieve coordinates
	CGRect cellRect = self.bounds;
	
	// draw gradient in cell rect
	MPDrawLinearGradientInRect(cellContext,
                               cellRect,
                               [UIColor colorWithRed:0.251 green:0.251 blue:0.290 alpha:1.000],
                               [UIColor colorWithRed:0.188 green:0.188 blue:0.216 alpha:1.000]);
	
	// draw separator
	MPDrawLineWithStrokeWidth(cellContext,
                              (CGPoint){ cellRect.origin.x, cellRect.origin.y },
                              (CGPoint){ cellRect.size.width, cellRect.origin.y },
                              [UIColor colorWithWhite:1.000 alpha:0.100],
                              1.0);
	
	// draw edge
	MPDrawLineWithStrokeWidth(cellContext,
                              (CGPoint){ cellRect.origin.x, cellRect.size.height},
                              (CGPoint){ cellRect.size.width, cellRect.size.height},
                              [UIColor colorWithWhite:0.100 alpha:0.900],
                              1.0);
}

#pragma mark Accessors

@synthesize textLabel;
@synthesize detailTextLabel;

@end
