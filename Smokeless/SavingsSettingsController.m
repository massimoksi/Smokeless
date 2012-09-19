//
//  SavingsSettingsController.m
//  Smokeless
//
//  Created by Massimo Peri on 26/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "SavingsSettingsController.h"

#import "HabitsCellController.h"
#import "SizeCellController.h"
#import "PriceCellController.h"
#import "ShadowCellController.h"


@implementation SavingsSettingsController

- (void)loadView
{
    // Create the view.
	self.view = [[UIView alloc] init];
	self.view.backgroundColor = [UIColor clearColor];

	// create cell controllers
	HabitsCellController *habitsCellController = [[HabitsCellController alloc] init];
	SizeCellController *sizeCellController = [[SizeCellController alloc] init];
	PriceCellController *priceCellController = [[PriceCellController alloc] init];
    ShadowCellController *shadowCellController = [[ShadowCellController alloc] init];

	// set delegates
	habitsCellController.delegate = self;
	sizeCellController.delegate = self;
	priceCellController.delegate = self;
    shadowCellController.delegate = self;
	
	// add cell controllers to array
	self.cellControllers = @[habitsCellController, sizeCellController, priceCellController, shadowCellController];
}

- (void)viewDidLoad
{
    // position cells
	for (NSUInteger i = 0; i < self.cellControllers.count; i++) {
		SettingCellController *cellController = (self.cellControllers)[i];
		
		// set index
		cellController.index = i;
		
		// shift view
		[cellController shiftViewBy:CELL_HEIGHT * i];
		
		// add cells to view
		[self.view addSubview:cellController.view];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.cellControllers = nil;
}

#pragma mark - Setting cell delegate

- (void)shiftDownwardsCellsAfterIndex:(NSInteger)index
{
	for (NSUInteger i = index+1; i < self.cellControllers.count; i++) {
		// retrieve cell controller
		SettingCellController *cellController = (self.cellControllers)[i];
		
		// shift cell downwards
		[cellController shiftViewBy:SETTING_HEIGHT];
	}    

    // disable done bar button item
	self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = NO;
}

- (void)shiftUpwardsCellsBeforeIndex:(NSInteger)index
{    
	for (NSUInteger i = 0; i < self.cellControllers.count; i++) {
		// retrieve cell controller
		SettingCellController *cellController = (self.cellControllers)[i];
		
		// shift cell upwards
		[cellController shiftViewBy:-CELL_HEIGHT * index];
	}
}

- (void)shiftUpwardsCellsAfterIndex:(NSInteger)index
{
	for (NSUInteger i = index+1; i < self.cellControllers.count; i++) {
		// retrieve cell controller
		SettingCellController *cellController = (self.cellControllers)[i];
		
		// shift cell upwards
		[cellController shiftViewBy:-SETTING_HEIGHT];
	}
}

- (void)shiftDownwardsCellsBeforeIndex:(NSInteger)index
{
	for (NSUInteger i = 0; i < self.cellControllers.count; i++) {
		// retrieve cell controller
		SettingCellController *cellController = (self.cellControllers)[i];
		
		// shift cell downwards
		[cellController shiftViewBy:CELL_HEIGHT * index];
	}
	
	// enable done bar button item
	self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
}

@end
