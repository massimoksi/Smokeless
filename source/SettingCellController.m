//
//  SettingCellController.m
//  Smokeless
//
//  Created by Massimo Peri on 03/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "SettingCellController.h"


@implementation SettingCellController

@synthesize index = _index;
@synthesize selected = _selected;
@synthesize cell = _cell;
@synthesize settingView = _settingView;
@synthesize saveButton = _saveButton;
@synthesize cancelButton = _cancelButton;
@synthesize delegate = _delegate;

- (id)init
{
	self = [super init];
	if (self) {
		self.index = IDX_UNDEFINED;
		self.selected = NO;
	}
	
	return self;
}

- (void)loadView
{
	// create view
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0.0,
														  0.0,
														  320.0,
														  CELL_HEIGHT)] autorelease];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.clipsToBounds = YES;
	
	// create cell
	self.cell = [[[SmokingCellBackgroundView alloc] initWithFrame:CGRectMake(0.0,
																			 0.0,
																			 320.0,
																			 CELL_HEIGHT)] autorelease];
	
	// create setting view
	self.settingView = [[[UIView alloc] initWithFrame:CGRectMake(0.0,
																 CELL_HEIGHT,
																 320.0,
																 SETTING_HEIGHT)] autorelease];
	self.settingView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
	// create cancel button
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(BUTTON_PADDING_X,
                                         SETTING_HEIGHT - (BUTTON_HEIGHT + BUTTON_PADDING_Y),
                                         BUTTON_WIDTH,
                                         BUTTON_HEIGHT);
    self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	self.cancelButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.cancelButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"ButtonCancelNormal"]
                                 forState:UIControlStateNormal];
	[self.cancelButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
	[self.cancelButton setTitleShadowColor:[UIColor darkGrayColor]
                                  forState:UIControlStateNormal];
    // set text
	[self.cancelButton setTitle:MPString(@"Cancel")
                       forState:UIControlStateNormal];
    
	// create save button
	self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = CGRectMake(BUTTON_PADDING_X,
                                       SETTING_HEIGHT - (2*BUTTON_HEIGHT + 2*BUTTON_PADDING_Y),
                                       BUTTON_WIDTH,
                                       BUTTON_HEIGHT);
    self.saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	self.saveButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.saveButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"ButtonSaveNormal"]
                               forState:UIControlStateNormal];
	[self.saveButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
	[self.saveButton setTitleShadowColor:[UIColor darkGrayColor]
                                forState:UIControlStateNormal];
    // set text
	[self.saveButton setTitle:MPString(@"Save")
                     forState:UIControlStateNormal];
    
    // add buttons
    [self.settingView addSubview:self.saveButton];
    [self.settingView addSubview:self.cancelButton];

	// create view hierarchy
	[self.view addSubview:self.cell];
	[self.view addSubview:self.settingView];
}

#pragma mark Memory management

- (void)viewDidUnload
{
    [super viewDidUnload];

	self.cell = nil;
	self.settingView = nil;
    
    self.saveButton = nil;
    self.cancelButton = nil;
}

- (void)dealloc
{
	self.cell = nil;
	self.settingView = nil;
    
    self.saveButton = nil;
    self.cancelButton = nil;
	
    [super dealloc];
}

#pragma mark Actions

- (void)updateCell
{
	// do nothing
}

- (void)updateSettingView
{
	// do nothing
}

- (void)showSettingView
{
	[self updateSettingView];
	
	// set selected
	self.selected = YES;

	[UIView animateWithDuration:0.4
					 animations:^{
						 // shift all cells
						 [self.delegate shiftUpwardsCellsBeforeIndex:self.index];
					 }
					 completion:^(BOOL finished){
						 [UIView animateWithDuration:0.5
										  animations:^{
											  // expand view
											  CGRect frame = self.view.frame;
											  frame.size.height = CELL_HEIGHT + SETTING_HEIGHT;
											  self.view.frame = frame;
											  
											  // shift subsequent cells
											  [self.delegate shiftDownwardsCellsAfterIndex:self.index];
										  }];						 
					 }];
}

- (void)hideSettingView
{
	[UIView animateWithDuration:0.5
					 animations:^{
						 // contract view
						 CGRect frame = self.view.frame;
						 frame.size.height = CELL_HEIGHT;
						 self.view.frame = frame;											  
						 
						 // shift subsequent cells
						 [self.delegate shiftUpwardsCellsAfterIndex:self.index];											  
					 }
					 completion:^(BOOL finished){
						 [UIView animateWithDuration:0.4
										  animations:^{
											  // shift previous cells
											  [self.delegate shiftDownwardsCellsBeforeIndex:self.index];
										  }];
					 }];

	// set unselected
	self.selected = NO;
	
	[self updateCell];
}

- (void)shiftViewBy:(CGFloat)shift
{
	CGRect frame = self.view.frame;
	frame.origin.y += shift;
	self.view.frame = frame;
}
	 
#pragma mark Inputs
	 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([event touchesForView:self.cell] &&
		!self.selected) {
		[self showSettingView];
	}
}

@end
