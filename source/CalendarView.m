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


@interface CalendarView ()

@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *dayLabel;

@end


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
		
		// create year label
		self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X,
                                                                   BOARD_ORIGIN_Y,
                                                                   BOARD_WIDTH,
                                                                   44.0)];
		self.yearLabel.backgroundColor = [UIColor clearColor];
		self.yearLabel.font = [UIFont systemFontOfSize:32.0];
		self.yearLabel.textAlignment = UITextAlignmentCenter;
		self.yearLabel.textColor = [UIColor colorWithWhite:0.950
                                                     alpha:1.000];
		self.yearLabel.shadowColor = [UIColor colorWithWhite:0.250
                                                       alpha:1.000];
        self.yearLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		
		// create month label
		self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X,
                                                                    132.0,
                                                                    BOARD_WIDTH,
                                                                    44.0)];
		self.monthLabel.backgroundColor = [UIColor clearColor];
		self.monthLabel.font = [UIFont boldSystemFontOfSize:36.0];
		self.monthLabel.textAlignment = UITextAlignmentCenter;
		self.monthLabel.textColor = [UIColor colorWithWhite:0.150
                                                      alpha:1.000];
        self.monthLabel.shadowColor = [UIColor colorWithWhite:1.000
                                                        alpha:1.000];
        self.monthLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		
		// create day label
		self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X,
                                                                  158.0,
                                                                  BOARD_WIDTH,
                                                                  194.0)];
		self.dayLabel.backgroundColor = [UIColor clearColor];
		self.dayLabel.font = [UIFont systemFontOfSize:160.0];
		self.dayLabel.textAlignment = UITextAlignmentCenter;
		self.dayLabel.textColor = [UIColor colorWithWhite:0.150
                                                    alpha:1.000];
        self.dayLabel.shadowColor = [UIColor colorWithWhite:1.000
                                                      alpha:1.000];
        self.dayLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		
		// add labels
		[self addSubview:self.yearLabel];
		[self addSubview:self.monthLabel];
		[self addSubview:self.dayLabel];
		
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

#pragma mark Accessors

- (void)setDate:(NSDate *)aDate
{
	if (_date != aDate) {
		// set new value
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
		self.yearLabel.text = [NSString stringWithFormat:@"%d", year];
			
		// set month to label
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		self.monthLabel.text = [[df monthSymbols][(month - 1)] capitalizedString];
			
		// set day to label
		self.dayLabel.text = [NSString stringWithFormat:@"%d", day];
		
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
		self.yearLabel.text = [NSString stringWithFormat:@"%d", year];
		
		// set month to label
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		self.monthLabel.text = [[df monthSymbols][(month - 1)] capitalizedString];
		
		// set day to label
		self.dayLabel.text = [NSString stringWithFormat:@"%d", day];
		
		// disable prev button
		self.prevButton.enabled = NO;
	}
}

@end
