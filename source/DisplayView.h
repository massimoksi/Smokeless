//
//  DisplayView.h
//  Smokeless
//
//  Created by Massimo Peri on 17/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    DisplayStateUndef = 0,
    DisplayStateMoney,
    DisplayStatePackets
} DisplayState;


@interface DisplayView : UIView

@property (nonatomic, retain) UILabel *moneyUnit;
@property (nonatomic, retain) UILabel *moneyLabel;
@property (nonatomic, retain) UILabel *packetsLabel;

- (id)initWithOrigin:(CGPoint)origin;

- (void)setState:(DisplayState)newState withAnimation:(BOOL)animation;

@end
