//
//  CalendarViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 03/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "CalendarViewController.h"

#import "Constants.h"


@interface CalendarViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weeksLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

@end


@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate *lastDay = [[NSUserDefaults standardUserDefaults] objectForKey:kLastCigaretteKey];
    if (lastDay) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateIntervalFormatterLongStyle;
        dateFormatter.locale = [NSLocale currentLocale];
        self.dateLabel.text = [dateFormatter stringFromDate:lastDay];
        
        NSDateComponents *components = [self nonSmokingIntervalSinceDay:lastDay];
        self.yearsLabel.text = [NSString stringWithFormat:@"%ld years", components.year];
        self.monthsLabel.text = [NSString stringWithFormat:@"%ld months", components.month];
        self.weeksLabel.text = [NSString stringWithFormat:@"%ld weeks", components.weekOfMonth];
        self.daysLabel.text = [NSString stringWithFormat:@"%ld days", components.day];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

//- (void)displayView:(id)aView
//{
//	// Switch visible view.
//	if ([aView isEqual:[self.containerView.subviews lastObject]] == NO) {
//		[[self.containerView.subviews lastObject] removeFromSuperview];
//		[self.containerView addSubview:aView];
//	}
//}

#pragma mark - Private methods

- (NSDateComponents *)nonSmokingIntervalSinceDay:(NSDate *)day
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return  [gregorianCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay)
                                 fromDate:day
                                   toDate:[NSDate date]
                                  options:0];
}

//- (NSInteger)nonSmokingDays
//{
//    NSInteger nonSmokingDays = 0;
//    
//    NSDate *lastDay = [[NSUserDefaults standardUserDefaults] objectForKey:LastCigaretteKey];
//    if (lastDay) {
//        // create gregorian calendar
//        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        
//        nonSmokingDays = [[gregorianCalendar components:NSCalendarUnitDay
//                                               fromDate:lastDay
//                                                 toDate:[NSDate date]
//                                                options:0] day];
//    }
//    
//    return nonSmokingDays;
//}

@end
