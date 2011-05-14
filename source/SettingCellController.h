//
//  SettingCellController.h
//  Smokeless
//
//  Created by Massimo Peri on 03/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SmokingCellBackgroundView.h"


#define IDX_UNDEFINED       -1

#define VIEW_HEIGHT         416.0
#define CELL_HEIGHT         44.0
#define SETTING_HEIGHT      (VIEW_HEIGHT - CELL_HEIGHT)

#define BUTTON_WIDTH        278.0
#define BUTTON_HEIGHT       45.0
#define BUTTON_PADDING_X    21.0
#define BUTTON_PADDING_Y    12.0


@protocol SettingCellDelegate <NSObject>

@required
- (void)shiftDownwardsCellsAfterIndex:(NSInteger)index;
- (void)shiftUpwardsCellsBeforeIndex:(NSInteger)index;
- (void)shiftUpwardsCellsAfterIndex:(NSInteger)index;
- (void)shiftDownwardsCellsBeforeIndex:(NSInteger)index;

@end


#pragma mark -


@interface SettingCellController : UIViewController {
	NSInteger _index;
	
	BOOL _selected;
	
	SmokingCellBackgroundView *_cell;
	UIView *_settingView;
    
    UIButton *_saveButton;
    UIButton *_cancelButton;
	
	id <SettingCellDelegate> _delegate;
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, retain) SmokingCellBackgroundView *cell;
@property (nonatomic, retain) UIView *settingView;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, assign) id <SettingCellDelegate> delegate;

- (void)updateCell;
- (void)updateSettingView;

- (void)showSettingView;
- (void)hideSettingView;

- (void)shiftViewBy:(CGFloat)shift;

@end
