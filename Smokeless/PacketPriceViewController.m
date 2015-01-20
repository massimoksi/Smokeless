//
//  PacketPriceViewController.m
//  Smokeless
//
//  Created by Massimo Peri on 24/09/12.
//  Copyright (c) 2012 Massimo Peri. All rights reserved.
//

#import "PacketPriceViewController.h"

#import "Constants.h"


@interface PacketPriceViewController ()

@property (nonatomic) BOOL reset;
@property (nonatomic) NSUInteger decimals;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) IBOutlet UIView *keypadView;

@property (nonatomic, weak) IBOutlet UIButton *pointButton;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;
- (IBAction)digitTapped:(id)sender;
- (IBAction)cancTapped:(id)sender;
- (IBAction)pointTapped:(id)sender;

@end


@implementation PacketPriceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundPattern"]];

    // Set localized title for the point button.
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [self.pointButton setTitle:[formatter currencyDecimalSeparator]
                      forState:UIControlStateNormal];
	// Enable the point button.
	self.pointButton.enabled = YES;
    
    // Initialize properties.
	self.decimals = 0;
	self.reset = YES;
    
    // Set the price label.
    self.priceLabel.font = [UIFont systemFontOfSize:25.0];
    self.priceLabel.textColor = [UIColor colorWithWhite:0.280
                                                  alpha:1.000];
    self.priceLabel.shadowColor = [UIColor colorWithWhite:0.850
                                                    alpha:1.000];
    self.priceLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    self.priceLabel.text = [NSNumberFormatter localizedStringFromNumber:@([[NSUserDefaults standardUserDefaults] floatForKey:PacketPriceKey])
                                                            numberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Align keypad to the bottom of the view.
    // NOTE: Necessary to support iOS5 withoud auto-layout.
    CGRect keypadFrame = self.keypadView.frame;
    keypadFrame.origin.y = self.view.frame.size.height - keypadFrame.size.height + 19.0f;
    self.keypadView.frame = keypadFrame;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.keypadView = nil;
    
    self.priceLabel = nil;
    
    self.pointButton = nil;
}

#pragma mark Actions

- (IBAction)cancelTapped:(id)sender
{
    // Dismiss view without saving the date.
    [self.delegate viewControllerDidClose];
}

- (IBAction)doneTapped:(id)sender
{
    // Get actual price from the label.
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	CGFloat actualPrice = [[formatter numberFromString:self.priceLabel.text] floatValue];
	
    [[NSUserDefaults standardUserDefaults] setFloat:actualPrice
                                             forKey:PacketPriceKey];
    
    // Dismiss the view.
    [self.delegate viewControllerDidClose];
}

- (IBAction)digitTapped:(id)sender
{
	CGFloat actualPrice = 0.0;
	
	if (!self.reset) {
		// Get actual price from the label.
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		actualPrice = [[formatter numberFromString:self.priceLabel.text] floatValue];
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
			// Do nothing.
			break;
	}
	
	// Disable price reset.
	self.reset = NO;
	
	// Update the price label.
	self.priceLabel.text = [NSNumberFormatter localizedStringFromNumber:@(actualPrice)
                                                            numberStyle:NSNumberFormatterCurrencyStyle];
}

- (IBAction)cancTapped:(id)sender
{
	self.decimals = 0;
	
	// Reset the price label.
    self.priceLabel.text = [NSNumberFormatter localizedStringFromNumber:@0.0f
                                                            numberStyle:NSNumberFormatterCurrencyStyle];
	
	// Enable the point button.
	self.pointButton.enabled = YES;
}

- (IBAction)pointTapped:(id)sender
{
    if (self.reset) {
        // Reset the price label.
        self.priceLabel.text = [NSNumberFormatter localizedStringFromNumber:@0.0f
                                                                numberStyle:NSNumberFormatterCurrencyStyle];
        
        // Disable price reset.
        self.reset = NO;
    }
    
	self.decimals = 1;
	
	// Disable the point button.
	self.pointButton.enabled = NO;
}

@end
