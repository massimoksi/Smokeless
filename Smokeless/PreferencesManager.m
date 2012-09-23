//
//  PreferencesManager.m
//  Smokeless
//
//  Created by Massimo Peri on 26/10/10.
//  Copyright 2010 Massimo Peri. All rights reserved.
//

#import "PreferencesManager.h"


#define PREFS_PATH	@"Documents/prefs.plist"


static PreferencesManager *sharedManager = nil;


@implementation PreferencesManager

#pragma mark Singleton

+ (PreferencesManager *)sharedManager
{
	@synchronized(self) {
		if (sharedManager == nil) {
			sharedManager = [[PreferencesManager alloc] init];
		}
	}
	
	return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (sharedManager == nil) {
			// assignment and return of first allocation
			sharedManager = [super allocWithZone:zone];
			return sharedManager;
		}
	}
	
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)init
{
	[self loadPrefs];
	
	return self;
}

#pragma mark Preferences management

- (void)loadPrefs
{
	// Create the preferences file path if it doesn't exist yet.
	if (self.path == nil) {
		self.path = [NSHomeDirectory() stringByAppendingPathComponent:PREFS_PATH];
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
		// Load preferences from file.
		self.prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:self.path];
	}
	else {
		// Load default values.
		self.prefs = [[NSMutableDictionary alloc] init];
	}
}

- (void)savePrefs
{
	[self.prefs writeToFile:self.path
				 atomically:YES];
}

- (void)deletePrefs
{
	// Get rid of preferences.
	self.prefs = [NSMutableDictionary dictionary];
	
	// Delete preferences file.
	[[NSFileManager defaultManager] removeItemAtPath:self.path
											   error:NULL];
}

#pragma mark Accessors

- (NSDate *)lastCigaretteDate
{
	return (self.prefs)[LAST_CIGARETTE_KEY];
}

- (NSDateComponents *)nonSmokingInterval
{
	NSDateComponents *period = nil;
	
	NSDate *today = [NSDate date];
	NSDate *lastDay = [self lastCigaretteDate];

	// calculate non-smoking period
	if (lastDay != nil) {
        // create gregorian calendar
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
		period = [gregorianCalendar components:(NSYearCalendarUnit |
                                                NSMonthCalendarUnit |
                                                NSWeekCalendarUnit |
                                                NSDayCalendarUnit)
                                      fromDate:lastDay
                                        toDate:today
                                       options:0];
	}
	
	return period;
}

- (NSInteger)nonSmokingDays
{
	NSInteger nonSmokingDays = 0;
	
	NSDate *today = [NSDate date];
	NSDate *lastDay = [self lastCigaretteDate];

	// calculate non-smoking days
	if (lastDay != nil) {
        // create gregorian calendar
        NSCalendar *gregorianCalenadar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
		nonSmokingDays = [[gregorianCalenadar components:NSDayCalendarUnit
                                                fromDate:lastDay
                                                  toDate:today
                                                 options:0] day];
	}
	
#ifdef DEBUG	
	NSLog(@"%@ - Total days: %d", [self class], nonSmokingDays);
#endif
	
	return nonSmokingDays;
}

- (NSUInteger)totalPackets
{
    NSUInteger totalPackets = 0;
    
    // Retrieve smoking habits.
	NSDictionary *habits = (self.prefs)[HABITS_KEY];

	if (habits && [self lastCigaretteDate]) {
        NSInteger quantity = [habits[HABITS_QUANTITY_KEY] intValue];
		NSInteger unit = [habits[HABITS_UNIT_KEY] intValue];
		NSInteger period = [habits[HABITS_PERIOD_KEY] intValue];

        // Retrieve packet size.
		NSInteger size = [(self.prefs)[PACKET_SIZE_KEY] intValue];
        
        // Calculate constants.
		NSInteger kUnit = (unit == 0) ? 1 : size;
		NSInteger kPeriod = (period == 0) ? 1 : 7;

        // Calculate the number of cigarettes/day.
		CGFloat cigarettesPerDay = quantity * kUnit / kPeriod;

		// Calculate the number of saved cigarettes.
		CGFloat totalCigarettes = [self nonSmokingDays] * cigarettesPerDay;

#ifdef DEBUG
		NSLog(@"%@ - Total cigarettes: %f", [self class], totalCigarettes);
#endif		

		// Calculate the number of saved packets.
		totalPackets = totalCigarettes / size + 1;
        
#ifdef DEBUG
		NSLog(@"%@ - Total packets: %d", [self class], totalPackets);
#endif
    }        
        
    return totalPackets;
}

- (CGFloat)totalSavings
{
    // retrieve packet price
    CGFloat price = [(self.prefs)[PACKET_PRICE_KEY] floatValue];
    
    // calculate saved amount
	CGFloat totalSavings = [self totalPackets] * price;

#ifdef DEBUG
	NSLog(@"%@ - Total savings: %f", [self class], totalSavings);
#endif
		
	return totalSavings;
}

- (NSString *)lastCigaretteFormattedDate;
{
    return [NSDateFormatter localizedStringFromDate:[self lastCigaretteDate]
                                          dateStyle:NSDateFormatterLongStyle
                                          timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)smokingHabits
{
    NSString *habitsString;
    
	// get preferences
	NSDictionary *habitsDict = (self.prefs)[HABITS_KEY];
	if (habitsDict != nil) {
		NSInteger quantity = [habitsDict[HABITS_QUANTITY_KEY] intValue];
		NSInteger unit = [habitsDict[HABITS_UNIT_KEY] intValue];
		NSInteger period = [habitsDict[HABITS_PERIOD_KEY] intValue];
		// create unit string
		NSString *unitString = nil;
		switch (unit) {
			case 0:
				unitString = (quantity == 1) ?
				MPString(@"cigarette") :
				MPString(@"cigarettes");
				break;
				
			case 1:
				unitString = (quantity == 1) ?
				MPString(@"packet") :
				MPString(@"packets");
				break;
		}
		// create period string
		NSString *periodString = nil;
		switch (period) {
			case 0:
				periodString = MPString(@"a day");
				break;
				
			case 1:
				periodString = MPString(@"a week");
				break;
		}
		
		habitsString = [NSString stringWithFormat:@"%d %@ %@", quantity, unitString, periodString];
	}
	else {
		habitsString = nil;
	}
    
    return habitsString;
}

- (NSString *)packetSize
{
    NSString *packetSizeString;
    
	NSInteger size = [([PreferencesManager sharedManager].prefs)[PACKET_SIZE_KEY] intValue];
	
	if (size != 0) {
		if (size > 1) {
			packetSizeString = [[NSString stringWithFormat:@"%d ", size] stringByAppendingString:MPString(@"cigarettes")];
		}
		else {
			packetSizeString = [[NSString stringWithFormat:@"%d ", size] stringByAppendingString:MPString(@"cigarette")];
		}
	}
	else {
		packetSizeString = nil;
	}
    
    return packetSizeString;
}

- (NSString *)packetPrice
{
    NSString *packetPriceString;
    
	CGFloat price = [([PreferencesManager sharedManager].prefs)[PACKET_PRICE_KEY] floatValue];
	
	if (price != 0.0) {
		packetPriceString = [NSNumberFormatter localizedStringFromNumber:@(price)
                                                             numberStyle:NSNumberFormatterCurrencyStyle];
	}
	else {
		packetPriceString = nil;
	}
    
    return packetPriceString;
}

@end
