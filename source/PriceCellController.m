//
//  PriceCellController.m
//  Smokeless
//
//  Created by Massimo Peri on 05/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "PriceCellController.h"

#import "PreferencesManager.h"


#define CALC_BUTTON_WIDTH		88.0
#define	CALC_BUTTON_HEIGHT		45.0
#define CALC_BUTTON_PADDING_X	14.0
#define	CALC_BUTTON_PADDING_Y	10.0


@implementation PriceCellController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create shadow
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.frame = CGRectMake(0.0, 0.0, 320.0, 10.0);
    CGColorRef darkColor = [UIColor colorWithWhite:0.000 alpha:0.650].CGColor;
    CGColorRef lightColor = [UIColor clearColor].CGColor;
    shadowLayer.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
    
    // add shadow to setting view
    [self.settingView.layer addSublayer:shadowLayer];
    [shadowLayer release];
	
	// set text label
	self.cell.textLabel.text = MPString(@"Packet price");
	// set detail text label
	[self updateCell];
	
	// create calc buttons
	button_7 = [[self calcButtonWithPosition:CGPointMake(CALC_BUTTON_PADDING_X,
														 CALC_BUTTON_PADDING_Y)
									  andTag:7] retain];
	button_8 = [[self calcButtonWithPosition:CGPointMake(CALC_BUTTON_WIDTH + 2*CALC_BUTTON_PADDING_X,
														 CALC_BUTTON_PADDING_Y)
									  andTag:8] retain];
	button_9 = [[self calcButtonWithPosition:CGPointMake(2*CALC_BUTTON_WIDTH + 3*CALC_BUTTON_PADDING_X,
														 CALC_BUTTON_PADDING_Y)
									  andTag:9] retain];
	button_4 = [[self calcButtonWithPosition:CGPointMake(CALC_BUTTON_PADDING_X,
														 CALC_BUTTON_HEIGHT + 2*CALC_BUTTON_PADDING_Y)
									  andTag:4] retain];
	button_5 = [[self calcButtonWithPosition:CGPointMake(CALC_BUTTON_WIDTH + 2*CALC_BUTTON_PADDING_X,
														 CALC_BUTTON_HEIGHT + 2*CALC_BUTTON_PADDING_Y)
									  andTag:5] retain];
	button_6 = [[self calcButtonWithPosition:CGPointMake(2*CALC_BUTTON_WIDTH + 3*CALC_BUTTON_PADDING_X,
														 CALC_BUTTON_HEIGHT + 2*CALC_BUTTON_PADDING_Y)
									  andTag:6] retain];
	button_1 = [[self calcButtonWithPosition:CGPointMake(CALC_BUTTON_PADDING_X,
														 2*CALC_BUTTON_HEIGHT + 3*CALC_BUTTON_PADDING_Y)
									  andTag:1] retain];
	button_2 = [[self calcButtonWithPosition:CGPointMake(CALC_BUTTON_WIDTH + 2*CALC_BUTTON_PADDING_X,
														 2*CALC_BUTTON_HEIGHT + 3*CALC_BUTTON_PADDING_Y)
									  andTag:2] retain];
	button_3 = [[self calcButtonWithPosition:CGPointMake(2*CALC_BUTTON_WIDTH + 3*CALC_BUTTON_PADDING_X,
														 2*CALC_BUTTON_HEIGHT + 3*CALC_BUTTON_PADDING_Y)
									  andTag:3] retain];
	button_p = [[self calcButtonWithPosition:CGPointMake(CALC_BUTTON_PADDING_X,
														 3*CALC_BUTTON_HEIGHT + 4*CALC_BUTTON_PADDING_Y)
									  andTag:10] retain];
	button_0 = [[self calcButtonWithPosition:CGPointMake(CALC_BUTTON_WIDTH + 2*CALC_BUTTON_PADDING_X,
														 3*CALC_BUTTON_HEIGHT + 4*CALC_BUTTON_PADDING_Y)
									  andTag:0] retain];
	button_c = [[self calcButtonWithPosition:CGPointMake(2*CALC_BUTTON_WIDTH + 3*CALC_BUTTON_PADDING_X,
														 3*CALC_BUTTON_HEIGHT + 4*CALC_BUTTON_PADDING_Y)
									  andTag:11] retain];
	
	// add buttons
	[self.settingView addSubview:button_7];
	[self.settingView addSubview:button_8];
	[self.settingView addSubview:button_9];
	[self.settingView addSubview:button_4];
	[self.settingView addSubview:button_5];
	[self.settingView addSubview:button_6];
	[self.settingView addSubview:button_1];
	[self.settingView addSubview:button_2];
	[self.settingView addSubview:button_3];
	[self.settingView addSubview:button_p];
	[self.settingView addSubview:button_0];
	[self.settingView addSubview:button_c];
	
	// add actions to buttons
	[self.saveButton addTarget:self
                        action:@selector(saveTapped:)
              forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self
                          action:@selector(cancelTapped:)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	[button_7 release];
	[button_8 release];
	[button_9 release];
	[button_4 release];
	[button_5 release];
	[button_6 release];
	[button_1 release];
	[button_2 release];
	[button_3 release];
	[button_p release];
	[button_0 release];
	[button_c release];

    [super dealloc];
}

#pragma mark Actions

- (UIButton *)calcButtonWithPosition:(CGPoint)position andTag:(NSInteger)tag
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

	// set image
	[button setBackgroundImage:[UIImage imageNamed:@"ButtonCalcNormal"]
					  forState:UIControlStateNormal];
	
	// customize button
	button.frame = CGRectMake(position.x,
							  position.y,
							  CALC_BUTTON_WIDTH,
							  CALC_BUTTON_HEIGHT);
	button.tag = tag;
	button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	button.titleLabel.textAlignment = UITextAlignmentCenter;
    button.titleLabel.shadowOffset = (CGSize){ 0.0, -1.0 };
	[button setTitleColor:[UIColor colorWithRed:0.627 green:0.631 blue:0.698 alpha:1.000]
				 forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithRed:0.416 green:0.416 blue:0.463 alpha:1.000]
				 forState:UIControlStateDisabled];
	[button setTitleShadowColor:[UIColor blackColor]
					   forState:UIControlStateNormal];
	
	if ((tag >= 0) && (tag <= 9)) {
		// set title
		[button setTitle:[NSString stringWithFormat:@"%d", tag]
				forState:UIControlStateNormal];
		// add action
		[button addTarget:self
				   action:@selector(digitTapped:)
		 forControlEvents:UIControlEventTouchUpInside];
	}
	else if (tag == 10) {
		// set title
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setLocale:[NSLocale currentLocale]];
		[button setTitle:[formatter currencyDecimalSeparator]
				forState:UIControlStateNormal];
		[formatter release];
		
		// add action
		[button addTarget:self
				   action:@selector(pointTapped:)
		 forControlEvents:UIControlEventTouchUpInside];
	}
	else if (tag == 11) {
		// set title
		[button setTitle:@"C"
				forState:UIControlStateNormal];
		
		// add action
		[button addTarget:self
				   action:@selector(cancTapped:)
		 forControlEvents:UIControlEventTouchUpInside];
	}
	
	return button;
}

- (void)updateCell
{
	// get preferences
	CGFloat price = [[[PreferencesManager sharedManager].prefs objectForKey:PACKET_PRICE_KEY] floatValue];
	
	if (price != 0.0) {
		// set detail text
		self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:price]
																		  numberStyle:NSNumberFormatterCurrencyStyle];	
	}
	else {
		// clean up detail text
		self.cell.detailTextLabel.text = nil;
	}
}

- (void)updateSettingView
{
	// reset setting view
	decimals = 0;
	reset = YES;
	
	button_p.enabled = YES;
	
	if (self.cell.detailTextLabel.text == nil) {
		// set detail string
		self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:0.0]
																		  numberStyle:NSNumberFormatterCurrencyStyle];	
	}
}

- (void)saveTapped:(id)sender
{
	// get value from cell
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	CGFloat actualPrice = [[formatter numberFromString:self.cell.detailTextLabel.text] floatValue];
	[formatter release];
	
	// set preference
	[[PreferencesManager sharedManager].prefs setObject:[NSNumber numberWithFloat:actualPrice]
												 forKey:PACKET_PRICE_KEY];

	// save preferences to file
	[[PreferencesManager sharedManager] savePrefs];
	
	// hide setting view
	[self hideSettingView];
}

- (void)cancelTapped:(id)sender
{
	// restore detail string
	[self updateCell];
	
	// hide setting view
	[self hideSettingView];
}

- (void)digitTapped:(id)sender
{
	CGFloat actualPrice = 0.0;
	
	if (!reset) {
		// get value from cell
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		actualPrice = [[formatter numberFromString:self.cell.detailTextLabel.text] floatValue];
		[formatter release];
	}
	
#ifdef DEBUG
	NSLog(@"%@ - Actual price: %f", [self class], actualPrice);
#endif
	
	
	switch (decimals) {
		case 0:
			decimals = 0;
			actualPrice = actualPrice * 10 + [sender tag];
			break;
			
		case 1:
			decimals = 2;
			actualPrice += (CGFloat)[sender tag] / 10;
			break;
			
		case 2:
			decimals = 3;
			actualPrice += (CGFloat)[sender tag] / 100;
			break;
			
		default:
		case 3:
			// do nothing
			break;
	}
	
	// disable price reset
	reset = NO;
	
	// update detail string
	self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:actualPrice]
																	  numberStyle:NSNumberFormatterCurrencyStyle];	
}

- (void)cancTapped:(id)sender
{
	decimals = 0;
	
	// cancel the detail string
	self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:0.0]
																	  numberStyle:NSNumberFormatterCurrencyStyle];
	
	// enable the point button
	button_p.enabled = YES;
}

- (IBAction)pointTapped:(id)sender
{
    if (reset) {
        // reset detail string
        self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:0.0]
                                                                          numberStyle:NSNumberFormatterCurrencyStyle];
        
        // disable price reset
        reset = NO;
    }
    
	decimals = 1;
	
	// disable the point button
	button_p.enabled = NO;
}

@end
