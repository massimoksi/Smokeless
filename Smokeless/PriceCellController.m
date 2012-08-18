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


@interface PriceCellController ()

@property (nonatomic, assign) BOOL reset;
@property (nonatomic, assign) NSUInteger decimals;

@property (nonatomic, strong) UIButton *button0;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;
@property (nonatomic, strong) UIButton *button7;
@property (nonatomic, strong) UIButton *button8;
@property (nonatomic, strong) UIButton *button9;
@property (nonatomic, strong) UIButton *buttonC;
@property (nonatomic, strong) UIButton *buttonP;

- (void)saveTapped:(id)sender;
- (void)cancelTapped:(id)sender;

- (void)digitTapped:(id)sender;
- (void)cancTapped:(id)sender;
- (void)pointTapped:(id)sender;

@end


@implementation PriceCellController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create shadow
    CAGradientLayer *shadowLayer = [[CAGradientLayer alloc] init];
    shadowLayer.frame = CGRectMake(0.0, 0.0, 320.0, 10.0);
    CGColorRef darkColor = CGColorRetain([UIColor colorWithWhite:0.000
                                                           alpha:0.650].CGColor);
    CGColorRef lightColor = CGColorRetain([UIColor clearColor].CGColor);
    shadowLayer.colors = @[(__bridge id)darkColor, (__bridge id)lightColor];
    
    // Clean up.
    CGColorRelease(darkColor);
    CGColorRelease(lightColor);
    
    // add shadow to setting view
    [self.settingView.layer addSublayer:shadowLayer];
	
	// set text label
	self.cell.textLabel.text = MPString(@"Packet price");
	// set detail text label
	[self updateCell];
	
	// create calc buttons
	self.button7 = [self calcButtonWithPosition:CGPointMake(CALC_BUTTON_PADDING_X,
                                                            CALC_BUTTON_PADDING_Y)
                                         andTag:7];
	self.button8 = [self calcButtonWithPosition:CGPointMake(CALC_BUTTON_WIDTH + 2*CALC_BUTTON_PADDING_X,
                                                            CALC_BUTTON_PADDING_Y)
                                         andTag:8];
	self.button9 = [self calcButtonWithPosition:CGPointMake(2*CALC_BUTTON_WIDTH + 3*CALC_BUTTON_PADDING_X,
                                                            CALC_BUTTON_PADDING_Y)
                                         andTag:9];
	self.button4 = [self calcButtonWithPosition:CGPointMake(CALC_BUTTON_PADDING_X,
                                                            CALC_BUTTON_HEIGHT + 2*CALC_BUTTON_PADDING_Y)
                                         andTag:4];
	self.button5 = [self calcButtonWithPosition:CGPointMake(CALC_BUTTON_WIDTH + 2*CALC_BUTTON_PADDING_X,
                                                            CALC_BUTTON_HEIGHT + 2*CALC_BUTTON_PADDING_Y)
                                         andTag:5];
	self.button6 = [self calcButtonWithPosition:CGPointMake(2*CALC_BUTTON_WIDTH + 3*CALC_BUTTON_PADDING_X,
                                                            CALC_BUTTON_HEIGHT + 2*CALC_BUTTON_PADDING_Y)
                                         andTag:6];
	self.button1 = [self calcButtonWithPosition:CGPointMake(CALC_BUTTON_PADDING_X,
                                                            2*CALC_BUTTON_HEIGHT + 3*CALC_BUTTON_PADDING_Y)
                                         andTag:1];
	self.button2 = [self calcButtonWithPosition:CGPointMake(CALC_BUTTON_WIDTH + 2*CALC_BUTTON_PADDING_X,
                                                            2*CALC_BUTTON_HEIGHT + 3*CALC_BUTTON_PADDING_Y)
                                         andTag:2];
	self.button3 = [self calcButtonWithPosition:CGPointMake(2*CALC_BUTTON_WIDTH + 3*CALC_BUTTON_PADDING_X,
                                                            2*CALC_BUTTON_HEIGHT + 3*CALC_BUTTON_PADDING_Y)
                                         andTag:3];
	self.buttonP = [self calcButtonWithPosition:CGPointMake(CALC_BUTTON_PADDING_X,
                                                            3*CALC_BUTTON_HEIGHT + 4*CALC_BUTTON_PADDING_Y)
                                         andTag:10];
	self.button0 = [self calcButtonWithPosition:CGPointMake(CALC_BUTTON_WIDTH + 2*CALC_BUTTON_PADDING_X,
                                                            3*CALC_BUTTON_HEIGHT + 4*CALC_BUTTON_PADDING_Y)
                                         andTag:0];
	self.buttonC = [self calcButtonWithPosition:CGPointMake(2*CALC_BUTTON_WIDTH + 3*CALC_BUTTON_PADDING_X,
                                                            3*CALC_BUTTON_HEIGHT + 4*CALC_BUTTON_PADDING_Y)
                                         andTag:11];
	
	// add buttons
	[self.settingView addSubview:self.button7];
	[self.settingView addSubview:self.button8];
	[self.settingView addSubview:self.button9];
	[self.settingView addSubview:self.button4];
	[self.settingView addSubview:self.button5];
	[self.settingView addSubview:self.button6];
	[self.settingView addSubview:self.button1];
	[self.settingView addSubview:self.button2];
	[self.settingView addSubview:self.button3];
	[self.settingView addSubview:self.buttonP];
	[self.settingView addSubview:self.button0];
	[self.settingView addSubview:self.buttonC];
	
	// add actions to buttons
	[self.saveButton addTarget:self
                        action:@selector(saveTapped:)
              forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self
                          action:@selector(cancelTapped:)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.button0 = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.button6 = nil;
    self.button7 = nil;
    self.button8 = nil;
    self.button9 = nil;
    self.buttonC = nil;
    self.buttonP = nil;
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
    button.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[button setTitleColor:[UIColor colorWithWhite:0.600
                                            alpha:1.000]
				 forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor blackColor]
					   forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithWhite:0.600
                                            alpha:0.200]
				 forState:UIControlStateDisabled];
	[button setTitleShadowColor:[UIColor colorWithWhite:0.000
                                                  alpha:0.200]
					   forState:UIControlStateDisabled];
    	
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
	CGFloat price = [([PreferencesManager sharedManager].prefs)[PACKET_PRICE_KEY] floatValue];
	
	if (price != 0.0) {
		// set detail text
		self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:@(price)
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
	self.decimals = 0;
	self.reset = YES;
	
	self.buttonP.enabled = YES;
	
	if (self.cell.detailTextLabel.text == nil) {
		// set detail string
		self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:@0.0f
																		  numberStyle:NSNumberFormatterCurrencyStyle];	
	}
}

- (void)saveTapped:(id)sender
{
	// get value from cell
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	CGFloat actualPrice = [[formatter numberFromString:self.cell.detailTextLabel.text] floatValue];
	
	// set preference
	([PreferencesManager sharedManager].prefs)[PACKET_PRICE_KEY] = @(actualPrice);

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
	
	if (self.reset == NO) {
		// get value from cell
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		actualPrice = [[formatter numberFromString:self.cell.detailTextLabel.text] floatValue];
	}
	
#ifdef DEBUG
	NSLog(@"%@ - Actual price: %f", [self class], actualPrice);
#endif
	
	switch (self.decimals) {
		case 0:
			self.decimals = 0;
			actualPrice = actualPrice * 10 + [sender tag];
			break;
			
		case 1:
			self.decimals = 2;
			actualPrice += (CGFloat)[sender tag] / 10;
			break;
			
		case 2:
			self.decimals = 3;
			actualPrice += (CGFloat)[sender tag] / 100;
			break;
			
		default:
		case 3:
			// do nothing
			break;
	}
	
	// disable price reset
	self.reset = NO;
	
	// update detail string
	self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:@(actualPrice)
																	  numberStyle:NSNumberFormatterCurrencyStyle];	
}

- (void)cancTapped:(id)sender
{
	self.decimals = 0;
	
	// cancel the detail string
	self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:@0.0f
																	  numberStyle:NSNumberFormatterCurrencyStyle];
	
	// enable the point button
	self.buttonP.enabled = YES;
}

- (void)pointTapped:(id)sender
{
    if (self.reset) {
        // reset detail string
        self.cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:@0.0f
                                                                          numberStyle:NSNumberFormatterCurrencyStyle];
        
        // disable price reset
        self.reset = NO;
    }
    
	self.decimals = 1;
	
	// disable the point button
	self.buttonP.enabled = NO;
}

@end
