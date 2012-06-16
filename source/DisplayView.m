//
//  DisplayView.m
//  Smokeless
//
//  Created by Massimo Peri on 17/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "DisplayView.h"


@interface DisplayView ()

@property (nonatomic, assign) DisplayState state;

@property (nonatomic, strong) UIImageView *packetsUnit;

@end


@implementation DisplayView

@synthesize state = _state;
@synthesize moneyUnit = _moneyUnit;
@synthesize moneyLabel = _moneyLabel;
@synthesize packetsUnit = _packetsUnit;
@synthesize packetsLabel = _packetsLabel;

- (id)initWithOrigin:(CGPoint)origin
{
    self = [super initWithFrame:CGRectMake(origin.x,
                                           origin.y,
                                           184.0,
                                           33.0)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // create money unit
        self.moneyUnit = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                                   self.bounds.origin.y,
                                                                   50.0,
                                                                   self.bounds.size.height)];
        self.moneyUnit.backgroundColor = [UIColor clearColor];
        self.moneyUnit.font = [UIFont fontWithName:@"DBLCDTempBlack"
                                              size:22.0];
        self.moneyUnit.adjustsFontSizeToFitWidth = YES;
        self.moneyUnit.textAlignment = UITextAlignmentLeft;
        self.moneyUnit.textColor = [UIColor darkGrayColor];
        self.moneyUnit.shadowColor = [UIColor lightGrayColor];
        
        // create packets unit
        self.packetsUnit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Packet"]];
        self.packetsUnit.frame = CGRectMake(self.bounds.origin.x,
                                            self.bounds.origin.y,
                                            50.0,
                                            self.bounds.size.height);
        
        // create money label
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0,
                                                                    self.bounds.origin.y,
                                                                    134.0,
                                                                    self.bounds.size.height)];
        self.moneyLabel.backgroundColor = [UIColor clearColor];
        self.moneyLabel.font = [UIFont fontWithName:@"DBLCDTempBlack"
                                               size:22.0];
        self.moneyLabel.adjustsFontSizeToFitWidth = YES;
        self.moneyLabel.textAlignment = UITextAlignmentRight;
        self.moneyLabel.textColor = [UIColor darkGrayColor];
        self.moneyLabel.shadowColor = [UIColor lightGrayColor];

        // create packets label
        self.packetsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0,
                                                                      self.bounds.origin.y,
                                                                      134.0,
                                                                      self.bounds.size.height)];
        self.packetsLabel.backgroundColor = [UIColor clearColor];
        self.packetsLabel.font = [UIFont fontWithName:@"DBLCDTempBlack"
                                                 size:22.0];
        self.packetsLabel.adjustsFontSizeToFitWidth = YES;
        self.packetsLabel.textAlignment = UITextAlignmentRight;
        self.packetsLabel.textColor = [UIColor darkGrayColor];
        self.packetsLabel.shadowColor = [UIColor lightGrayColor];
        
        // create view hierarchy
        [self addSubview:self.moneyUnit];
        [self addSubview:self.packetsUnit];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.packetsLabel];

        // set state
        [self setState:DisplayStateUndef
         withAnimation:NO];
    }
    
    return self;
}

#pragma mark Accessors

- (void)setState:(DisplayState)newState withAnimation:(BOOL)animation
{
    NSTimeInterval duration = (animation == YES) ? 0.5 : 0.0;
        
    switch (newState) {
        default:
        case DisplayStateUndef:
            // hide everything
            self.moneyUnit.alpha = 0.0;
            self.moneyLabel.alpha = 0.0;
            self.packetsUnit.alpha = 0.0;
            self.packetsLabel.alpha = 0.0;
            break;
            
        case DisplayStateMoney:
        {
            [UIView animateWithDuration:duration
                             animations:^{
                                 // hide packets
                                 self.packetsUnit.alpha = 0.0;
                                 self.packetsLabel.alpha = 0.0;
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:duration
                                                  animations:^{
                                                      // show money
                                                      self.moneyUnit.alpha = 1.0;
                                                      self.moneyLabel.alpha = 1.0;
                                                  }];
                             }];
            break;
        }
            
        case DisplayStatePackets:
        {
            [UIView animateWithDuration:duration
                             animations:^{
                                 // hide money
                                 self.moneyUnit.alpha = 0.0;
                                 self.moneyLabel.alpha = 0.0;
                             }
                             completion:^(BOOL finished){
                                 [UIView animateWithDuration:duration
                                                  animations:^{
                                                      // show packets
                                                      self.packetsUnit.alpha = 1.0;
                                                      self.packetsLabel.alpha = 1.0;
                                                  }];
                             }];
            break;
        }
    }
    
    // set new state
    self.state = newState;
}

#pragma mark Gestures

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (self.state) {
        default:
        case DisplayStateUndef:
            [self setState:DisplayStateUndef
             withAnimation:YES];
            break;
            
        case DisplayStateMoney:
            [self setState:DisplayStatePackets
             withAnimation:YES];
            break;
            
        case DisplayStatePackets:
            [self setState:DisplayStateMoney
             withAnimation:YES];
            break;
    }
}

@end
