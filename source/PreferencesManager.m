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
	// create the preferences file path if it doesn't exist yet
	if (self.path == nil) {
		self.path = [NSHomeDirectory() stringByAppendingPathComponent:PREFS_PATH];
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
		// load preferences from file
		self.prefs = [[[NSMutableDictionary alloc] initWithContentsOfFile:self.path] autorelease];
	}
	else {
		// load default values
		self.prefs = [[[NSMutableDictionary alloc] init] autorelease];
	}
}

- (void)savePrefs
{
	[self.prefs writeToFile:self.path
				 atomically:YES];
}

- (void)deletePrefs
{
	// get rid of prefs
	self.prefs = [NSMutableDictionary dictionary];
	
	// delete prefs file
	[[NSFileManager defaultManager] removeItemAtPath:self.path
											   error:NULL];
}

#pragma mark Accessors

@synthesize prefs;
@synthesize path;

- (NSDate *)lastCigaretteDate
{
	return [self.prefs objectForKey:LAST_CIGARETTE_KEY];
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
        
        // release gregorian calendar
        [gregorianCalendar release];
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
        
        // release gregorian calendar
        [gregorianCalenadar release];		
	}
	
#ifdef DEBUG	
	NSLog(@"%@ - Total days: %d", [self class], nonSmokingDays);
#endif
	
	return nonSmokingDays;
}

- (NSUInteger)totalPackets
{
    NSUInteger totalPackets = 0;
    
    // retrieve smoking habits
	NSDictionary *habits = [self.prefs objectForKey:HABITS_KEY];

	if (habits && [self lastCigaretteDate]) {
        NSInteger quantity = [[habits objectForKey:HABITS_QUANTITY_KEY] intValue];
		NSInteger unit = [[habits objectForKey:HABITS_UNIT_KEY] intValue];
		NSInteger period = [[habits objectForKey:HABITS_PERIOD_KEY] intValue];

        // retrieve packet size
		NSInteger size = [[self.prefs objectForKey:PACKET_SIZE_KEY] intValue];
        
        // calculate constants
		NSInteger kUnit = (unit == 0) ? 1 : size;
		NSInteger kPeriod = (period == 0) ? 1 : 7;

        // calculate cigarettes/day
		CGFloat cigarettesPerDay = quantity * kUnit / kPeriod;

		// calculate saved cigarettes
		CGFloat totalCigarettes = [self nonSmokingDays] * cigarettesPerDay;

#ifdef DEBUG
		NSLog(@"%@ - Total cigarettes: %f", [self class], totalCigarettes);
#endif		

		// calculate saved packets
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
    CGFloat price = [[self.prefs objectForKey:PACKET_PRICE_KEY] floatValue];
    
    // calculate saved amount
	CGFloat totalSavings = [self totalPackets] * price;

#ifdef DEBUG
	NSLog(@"%@ - Total savings: %f", [self class], totalSavings);
#endif
		
	return totalSavings;
}

@end
