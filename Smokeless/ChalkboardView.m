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


@interface ChalkboardView ()

@property (nonatomic, strong) UILabel *yearsLabel;
@property (nonatomic, strong) UILabel *monthsLabel;
@property (nonatomic, strong) UILabel *weeksLabel;
@property (nonatomic, strong) UILabel *daysLabel;

@end


@implementation ChalkboardView

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
		
		// create labels
		self.yearsLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X + LABEL_PADDING_X,
                                                                    BOARD_ORIGIN_Y + LABEL_PADDING_Y,
                                                                    LABEL_WIDTH,
                                                                    LABEL_HEIGHT)];
		self.monthsLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X + LABEL_PADDING_X,
                                                                     BOARD_ORIGIN_Y + LABEL_HEIGHT + 2*LABEL_PADDING_Y,
                                                                     LABEL_WIDTH,
                                                                     LABEL_HEIGHT)];
		self.weeksLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X + LABEL_PADDING_X,
                                                                    BOARD_ORIGIN_Y + 2*LABEL_HEIGHT + 3*LABEL_PADDING_Y,
                                                                    LABEL_WIDTH,
                                                                    LABEL_HEIGHT)];
		self.daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(BOARD_ORIGIN_X + LABEL_PADDING_X,
                                                                   BOARD_ORIGIN_Y + 3*LABEL_HEIGHT + 4*LABEL_PADDING_Y,
                                                                   LABEL_WIDTH,
                                                                   LABEL_HEIGHT)];
		
		// add labels
		[self addLabel:self.yearsLabel];
		[self addLabel:self.monthsLabel];
		[self addLabel:self.weeksLabel];
		[self addLabel:self.daysLabel];

        // create tweet button
        self.tweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tweetButton.frame = CGRectMake(BOARD_ORIGIN_X - BUTTON_OFFSET_X,
                                            BOARD_ORIGIN_Y + BOARD_HEIGHT - BUTTON_OFFSET_Y,
                                            BUTTON_WIDTH,
                                            BUTTON_HEIGHT);
        [self.tweetButton setImage:[UIImage imageNamed:@"ButtonTweetNormal"]
                          forState:UIControlStateNormal];
        [self.tweetButton setImage:[UIImage imageNamed:@"ButtonTweetPressed"]
                          forState:UIControlStateHighlighted];
        
		// create next button
		self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.nextButton.frame = CGRectMake(BOARD_ORIGIN_X + BOARD_WIDTH - BUTTON_WIDTH + BUTTON_OFFSET_X,
                                           BOARD_ORIGIN_Y + BOARD_HEIGHT - BUTTON_OFFSET_Y,
                                           BUTTON_WIDTH,
                                           BUTTON_HEIGHT);
		[self.nextButton setImage:[UIImage imageNamed:@"ButtonNextNormal"]
                         forState:UIControlStateNormal];
		[self.nextButton setImage:[UIImage imageNamed:@"ButtonNextPressed"]
                         forState:UIControlStateHighlighted];

		// add buttons
        if ([TWTweetComposeViewController canSendTweet] == YES) {
            [self addSubview:self.tweetButton];
        }
		[self addSubview:self.nextButton]; 
		
		// initialize ivars
		self.years = 0;
		self.months = 0;
		self.weeks = 0;
		self.days = 0;
    }
	
    return self;
}

#pragma mark Accessors

- (void)setYears:(NSUInteger)value
{
	if (_years != value) {
		_years = value;
	}
	
	self.yearsLabel.text = (_years != 1) ? [NSString stringWithFormat:MPString(@"%d years"), _years] : [NSString stringWithFormat:MPString(@"%d year"), _years];
}

- (void)setMonths:(NSUInteger)value
{
	if (_months != value) {
		_months = value;
	}
	
	self.monthsLabel.text = (_months != 1) ? [NSString stringWithFormat:MPString(@"%d months"), _months] : [NSString stringWithFormat:MPString(@"%d month"), _months];
}

- (void)setWeeks:(NSUInteger)value
{
	if (_weeks != value) {
		_weeks = value;
	}
	
	self.weeksLabel.text = (_weeks != 1) ? [NSString stringWithFormat:MPString(@"%d weeks"), _weeks] : [NSString stringWithFormat:MPString(@"%d week"), _weeks];
}

- (void)setDays:(NSUInteger)value
{
	if (_days != value) {
		_days = value;
	}
	
	self.daysLabel.text = (_days != 1) ? [NSString stringWithFormat:MPString(@"%d days"), _days] : [NSString stringWithFormat:MPString(@"%d day"), _days];
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
