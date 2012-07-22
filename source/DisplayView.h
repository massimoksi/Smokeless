//
//  DisplayView.h
//  Smokeless
//
//  Created by Massimo Peri on 17/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum DisplayState : NSUInteger {
    DisplayStateUndef,
    DisplayStateMoney,
    DisplayStatePackets
} DisplayState;


@interface DisplayView : UIView

@property (nonatomic, strong) UILabel *moneyUnit;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *packetsLabel;

- (id)initWithOrigin:(CGPoint)origin;

- (void)setState:(DisplayState)newState withAnimation:(BOOL)animation;

@end
