//
//  CalendarView.m
//  Smokeless
//
//  Created by Massimo Peri on 07/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "CalendarView.h"


#define FRAME_PADDING	15.0

#define BOARD_ORIGIN_X	27.0
#define BOARD_ORIGIN_Y	71.0
#define BOARD_WIDTH		266.0
#define BOARD_HEIGHT	281.0

#define BUTTON_WIDTH	60.0
#define BUTTON_HEIGHT	60.0
#define BUTTON_OFFSET_X	11.0
#define BUTTON_OFFSET_Y	8.0


@implementation CalendarView


- (id)initWithDate:(NSDate *)aDate
{
    self = [super initWithImage:[UIImage imageNamed:@"Calendar"]];
    if (self) {
		// enable use interaction
		self.userInteractionEnabled = YES;

		// create title
		UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TitleCalendar"]];
		title.frame = CGRectMake(BOARD_ORIGIN_X,
								 FRAME_PADDING,
								 title.frame.size.width,
								 title.frame.size.height);
		[self addSubview:title];
		[title release];
		
		// create year label
		yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X,
															  BOARD_ORIGIN_Y,
															  BOARD_WIDTH,
															  44.0)];
		yearLabel.backgroundColor = [UIColor clearColor];
		yearLabel.font = [UIFont systemFontOfSize:32.0];
		yearLabel.textAlignment = UITextAlignmentCenter;
		yearLabel.textColor = [UIColor colorWithWhite:0.950 alpha:1.000];
		yearLabel.shadowColor = [UIColor colorWithWhite:0.250 alpha:1.000];
		
		// create month label
		monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X,
															   132.0,
															   BOARD_WIDTH,
															   44.0)];
		monthLabel.backgroundColor = [UIColor clearColor];
		monthLabel.font = [UIFont boldSystemFontOfSize:36.0];
		monthLabel.textAlignment = UITextAlignmentCenter;
		monthLabel.textColor = [UIColor colorWithWhite:0.15
												 alpha:1.00];
		
		// create day label
		dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X,
															 158.0,
															 BOARD_WIDTH,
															 194.0)];
		dayLabel.backgroundColor = [UIColor clearColor];
		dayLabel.font = [UIFont systemFontOfSize:160.0];
		dayLabel.textAlignment = UITextAlignmentCenter;
		dayLabel.textColor = [UIColor colorWithWhite:0.15
											   alpha:1.00];
		
		// add labels
		[self addSubview:yearLabel];
		[self addSubview:monthLabel];
		[self addSubview:dayLabel];
		
		// create edit button
		self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.editButton.frame = CGRectMake(BOARD_ORIGIN_X - BUTTON_OFFSET_X,
                                           BOARD_ORIGIN_Y + BOARD_HEIGHT - BUTTON_OFFSET_Y,
                                           BUTTON_WIDTH,
                                           BUTTON_HEIGHT);
		[self.editButton setImage:[UIImage imageNamed:@"ButtonEditNormal"]
                         forState:UIControlStateNormal];
		[self.editButton setImage:[UIImage imageNamed:@"ButtonEditPressed"]
                         forState:UIControlStateHighlighted];
		
		// create prev button
		self.prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.prevButton.frame = CGRectMake(BOARD_ORIGIN_X + BOARD_WIDTH - BUTTON_WIDTH + BUTTON_OFFSET_X,
                                           BOARD_ORIGIN_Y + BOARD_HEIGHT - BUTTON_OFFSET_Y,
                                           BUTTON_WIDTH,
                                           BUTTON_HEIGHT);
		[self.prevButton setImage:[UIImage imageNamed:@"ButtonPrevNormal"]
                         forState:UIControlStateNormal];
		[self.prevButton setImage:[UIImage imageNamed:@"ButtonPrevPressed"]
                         forState:UIControlStateHighlighted];
		
		// add buttons
		[self addSubview:self.editButton];
		[self addSubview:self.prevButton];
		
		// init ivars
		self.date = aDate;
    }
	
    return self;
}

- (void)dealloc
{
	[yearLabel release];
	[monthLabel release];
	[dayLabel release];
	
	self.editButton = nil;
	self.prevButton = nil;
	
	self.date = nil;
	
    [super dealloc];
}

#pragma mark Accessors

- (NSDate *)date
{
	return _date;
}

- (void)setDate:(NSDate *)aDate
{
	if (_date != aDate) {
		// set new value
		[aDate retain];
		[_date release];
		_date = aDate;
	}
    
    // create gregorian calendar
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			
	if (_date != nil) {
		// retrieve date components
		NSDateComponents *components = [gregorianCalendar components:(NSYearCalendarUnit |
                                                                      NSMonthCalendarUnit |
                                                                      NSDayCalendarUnit)
                                                            fromDate:_date];
		NSInteger year = [components year];
		NSInteger month = [components month];
		NSInteger day = [components day];
			
		// set year to label
		yearLabel.text = [NSString stringWithFormat:@"%d", year];
			
		// set month to label
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		monthLabel.text = [[[df monthSymbols] objectAtIndex:(month - 1)] capitalizedString];
		[df release];
			
		// set day to label
		dayLabel.text = [NSString stringWithFormat:@"%d", day];
		
		// enable prev button
		self.prevButton.enabled = YES;
	}
	else {
		// retrieve date components
		NSDateComponents *components = [gregorianCalendar components:(NSYearCalendarUnit |
                                                                      NSMonthCalendarUnit |
                                                                      NSDayCalendarUnit)
                                                            fromDate:[NSDate date]];
		NSInteger year = [components year];
		NSInteger month = [components month];
		NSInteger day = [components day];
		
		// set year to label
		yearLabel.text = [NSString stringWithFormat:@"%d", year];
		
		// set month to label
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		monthLabel.text = [[[df monthSymbols] objectAtIndex:(month - 1)] capitalizedString];
		[df release];
		
		// set day to label
		dayLabel.text = [NSString stringWithFormat:@"%d", day];
		
		// disable prev button
		self.prevButton.enabled = NO;
	}
    
    // release gregorian calendar
    [gregorianCalendar release];
}

@synthesize editButton;
@synthesize prevButton;

@end
