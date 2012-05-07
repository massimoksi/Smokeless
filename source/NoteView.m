//
//  NoteView.m
//  Smokeless
//
//  Created by Massimo Peri on 08/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "NoteView.h"


#define IMAGE_WIDTH		136.0
#define IMAGE_HEIGHT	99.0


@implementation NoteView

@synthesize message = _message;

- (id)init
{
    self = [super initWithImage:[UIImage imageNamed:@"Note"]];
    if (self) {
		// create message
		self.message = [[[UILabel alloc] initWithFrame:CGRectMake(7.0, 16.0, 120.0, 44.0)] autorelease];
		self.message.backgroundColor = [UIColor clearColor];
		self.message.font = [UIFont fontWithName:@"Marker Felt"
                                            size:13.0];
		self.message.numberOfLines = 2;
				
		// add message
		[self addSubview:self.message];

		// create arrow
		UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowLeft"]];
				
		// position arrow
		CGRect frame = arrow.frame;
		frame.origin.x = 12.0;
		frame.origin.y = 58.0;
		arrow.frame = frame;
				
		// add arrow 
		[self addSubview:arrow];
		[arrow release];
	}
	
    return self;
}

- (void)dealloc
{
	self.message = nil;
	
    [super dealloc];
}

@end
