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

@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SmokingCell"]];
		
        // create text label
		self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(LABEL_PADDING_X,
																	LABEL_PADDING_Y,
																	self.frame.size.width/2 - LABEL_PADDING_X,
																	self.frame.size.height)] autorelease];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
		self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.textColor = [UIColor colorWithWhite:0.600
                                                     alpha:1.000];
		self.textLabel.shadowColor = [UIColor blackColor];
		self.textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		
		// create detail text label
		self.detailTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2,
																		  LABEL_PADDING_Y,
																		  self.frame.size.width/2 - LABEL_PADDING_X,
																		  self.frame.size.height)] autorelease];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
		self.detailTextLabel.textAlignment = UITextAlignmentRight;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.400
                                                           alpha:1.000];
		self.detailTextLabel.shadowColor = [UIColor blackColor];
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

@end
