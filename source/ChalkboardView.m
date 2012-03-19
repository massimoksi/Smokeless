//
//  ChalkboardView.m
//  Smokeless
//
//  Created by Massimo Peri on 05/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "ChalkboardView.h"


#define FRAME_PADDING	15.0

#define BOARD_ORIGIN_X	27.0
#define BOARD_ORIGIN_Y	71.0
#define BOARD_WIDTH		266.0
#define BOARD_HEIGHT	281.0

#define LABEL_PADDING_X	12.0
#define LABEL_PADDING_Y	9.0
#define LABEL_WIDTH		(BOARD_WIDTH - 2*LABEL_PADDING_X)
#define LABEL_HEIGHT	57.0

#define BUTTON_WIDTH	60.0
#define BUTTON_HEIGHT	60.0
#define BUTTON_OFFSET_X	11.0
#define BUTTON_OFFSET_Y	8.0


@implementation ChalkboardView

@synthesize tweetButton = _tweetButton;
@synthesize nextButton = _nextButton;

- (id)init
{
    self = [super initWithImage:[UIImage imageNamed:@"Chalkboard"]];
    if (self) {
		// enable use interaction
		self.userInteractionEnabled = YES;
		
		// create title
		UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TitleChalkboard"]];
		title.frame = CGRectMake(BOARD_ORIGIN_X,
								 FRAME_PADDING,
								 title.frame.size.width,
								 title.frame.size.height);
		[self addSubview:title];
		[title release];
		
		// create labels
		yearsLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X + LABEL_PADDING_X,
															   BOARD_ORIGIN_Y + LABEL_PADDING_Y,
															   LABEL_WIDTH,
															   LABEL_HEIGHT)];
		monthsLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X + LABEL_PADDING_X,
																BOARD_ORIGIN_Y + LABEL_HEIGHT + 2*LABEL_PADDING_Y,
																LABEL_WIDTH,
																LABEL_HEIGHT)];
		weeksLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X + LABEL_PADDING_X,
															   BOARD_ORIGIN_Y + 2*LABEL_HEIGHT + 3*LABEL_PADDING_Y,
															   LABEL_WIDTH,
															   LABEL_HEIGHT)];
		daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X + LABEL_PADDING_X,
															  BOARD_ORIGIN_Y + 3*LABEL_HEIGHT + 4*LABEL_PADDING_Y,
															  LABEL_WIDTH,
															  LABEL_HEIGHT)];
		
		// add labels
		[self addLabel:yearsLabel];
		[self addLabel:monthsLabel];
		[self addLabel:weeksLabel];
		[self addLabel:daysLabel];

        // create tweet button
        self.tweetButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        self.tweetButton.frame = CGRectMake(BOARD_ORIGIN_X - BUTTON_OFFSET_X,
                                            BOARD_ORIGIN_Y + BOARD_HEIGHT - BUTTON_OFFSET_Y,
                                            BUTTON_WIDTH,
                                            BUTTON_HEIGHT);
        [self.tweetButton setImage:[UIImage imageNamed:@"ButtonTweetNormal"]
                          forState:UIControlStateNormal];
        [self.tweetButton setImage:[UIImage imageNamed:@"ButtonTweetPressed"]
                          forState:UIControlStateHighlighted];
        
		// create next button
		self.nextButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		self.nextButton.frame = CGRectMake(BOARD_ORIGIN_X + BOARD_WIDTH - BUTTON_WIDTH + BUTTON_OFFSET_X,
                                           BOARD_ORIGIN_Y + BOARD_HEIGHT - BUTTON_OFFSET_Y,
                                           BUTTON_WIDTH,
                                           BUTTON_HEIGHT);
		[self.nextButton setImage:[UIImage imageNamed:@"ButtonNextNormal"]
                         forState:UIControlStateNormal];
		[self.nextButton setImage:[UIImage imageNamed:@"ButtonNextPressed"]
                         forState:UIControlStateHighlighted];

		// add buttons
        [self addSubview:self.tweetButton];
		[self addSubview:self.nextButton]; 
		
		// initialize ivars
		self.years = 0;
		self.months = 0;
		self.weeks = 0;
		self.days = 0;
    }
	
    return self;
}

- (void)dealloc
{
	[yearsLabel release];
	[monthsLabel release];
	[weeksLabel release];
	[daysLabel release];
	
	self.nextButton = nil;
	
    [super dealloc];
}

#pragma mark Accessors

- (NSUInteger)years
{
	return _years;
}

- (void)setYears:(NSUInteger)value
{
	if (_years != value) {
		_years = value;
	}
	
	yearsLabel.text = (_years != 1) ? [NSString stringWithFormat:MPString(@"%d years"), _years] : [NSString stringWithFormat:MPString(@"%d year"), _years];
}

- (NSUInteger)months
{
	return _months;
}

- (void)setMonths:(NSUInteger)value
{
	if (_months != value) {
		_months = value;
	}
	
	monthsLabel.text = (_months != 1) ? [NSString stringWithFormat:MPString(@"%d months"), _months] : [NSString stringWithFormat:MPString(@"%d month"), _months];
}

- (NSUInteger)weeks
{
	return _weeks;
}

- (void)setWeeks:(NSUInteger)value
{
	if (_weeks != value) {
		_weeks = value;
	}
	
	weeksLabel.text = (_weeks != 1) ? [NSString stringWithFormat:MPString(@"%d weeks"), _weeks] : [NSString stringWithFormat:MPString(@"%d week"), _weeks];
}

- (NSUInteger)days
{
	return _days;
}

- (void)setDays:(NSUInteger)value
{
	if (_days != value) {
		_days = value;
	}
	
	daysLabel.text = (_days != 1) ? [NSString stringWithFormat:MPString(@"%d days"), _days] : [NSString stringWithFormat:MPString(@"%d day"), _days];
}

#pragma mark Actions

- (void)addLabel:(UILabel *)label
{
	// customize label
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:@"Chalkduster"
								 size:30.0];
	label.textColor = [UIColor whiteColor];
	
	// add label
	[self addSubview:label];
}

@end
