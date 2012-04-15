//
//  CalendarView.h
//  Smokeless
//
//  Created by Massimo Peri on 07/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalendarView : UIImageView {
	NSDate *_date;
	
@private
	UILabel *yearLabel;
	UILabel *monthLabel;
	UILabel *dayLabel;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) UIButton *editButton;
@property (nonatomic, retain) UIButton *prevButton;

- (id)initWithDate:(NSDate *)aDate;

@end
