//
//  LastCigaretteController.h
//  Smokeless
//
//  Created by Massimo Peri on 12/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol UnderlayViewDelegate <NSObject>

@optional
- (void)underlayViewDidStart;
- (void)underlayViewDidFinish;

@end


#pragma mark -


@interface LastCigaretteController : UIViewController {
	UIDatePicker *_datePicker;

    UIButton *_saveButton;
    UIButton *_cancelButton;
    
	id <UnderlayViewDelegate> _delegate;
}

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, assign) id <UnderlayViewDelegate> delegate;

- (void)saveTapped:(id)sender;
- (void)cancelTapped:(id)sender;

@end