//
//  DisplayView.m
//  Smokeless
//
//  Created by Massimo Peri on 17/03/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import "DisplayView.h"


@implementation DisplayView

@synthesize moneyUnit = _moneyUnit;
@synthesize moneyLabel = _moneyLabel;
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
        self.moneyUnit = [[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x,
                                                                    self.bounds.origin.y,
                                                                    50.0,
                                                                    self.bounds.size.height)] autorelease];
        self.moneyUnit.backgroundColor = [UIColor clearColor];
        self.moneyUnit.font = [UIFont fontWithName:@"DBLCDTempBlack"
                                              size:22.0];
        self.moneyUnit.adjustsFontSizeToFitWidth = YES;
        self.moneyUnit.textAlignment = UITextAlignmentLeft;
        self.moneyUnit.textColor = [UIColor darkGrayColor];
        self.moneyUnit.shadowColor = [UIColor lightGrayColor];
        
        // create packets unit
        _packetsUnit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Packet"]];
        _packetsUnit.frame = CGRectMake(self.bounds.origin.x,
                                        self.bounds.origin.y,
                                        50.0,
                                        self.bounds.size.height);
        
        // create money label
        self.moneyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50.0,
                                                                     self.bounds.origin.y,
                                                                     134.0,
                                                                     self.bounds.size.height)] autorelease];
        self.moneyLabel.backgroundColor = [UIColor clearColor];
        self.moneyLabel.font = [UIFont fontWithName:@"DBLCDTempBlack"
                                               size:22.0];
        self.moneyLabel.adjustsFontSizeToFitWidth = YES;
        self.moneyLabel.textAlignment = UITextAlignmentRight;
        self.moneyLabel.textColor = [UIColor darkGrayColor];
        self.moneyLabel.shadowColor = [UIColor lightGrayColor];

        // create packets label
        self.packetsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(50.0,
                                                                       self.bounds.origin.y,
                                                                       134.0,
                                                                       self.bounds.size.height)] autorelease];
        self.packetsLabel.backgroundColor = [UIColor clearColor];
        self.packetsLabel.font = [UIFont fontWithName:@"DBLCDTempBlack"
                                                 size:22.0];
        self.packetsLabel.adjustsFontSizeToFitWidth = YES;
        self.packetsLabel.textAlignment = UITextAlignmentRight;
        self.packetsLabel.textColor = [UIColor darkGrayColor];
        self.packetsLabel.shadowColor = [UIColor lightGrayColor];
        
        // create view hierarchy
        [self addSubview:self.moneyUnit];
        [self addSubview:_packetsUnit];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.packetsLabel];

        // set state
        [self setState:DisplayStateUndef
         withAnimation:NO];
    }
    
    return self;
}

- (void)dealloc
{
    self.moneyUnit = nil;
    self.moneyLabel = nil;
    self.packetsLabel = nil;
    
    [_packetsUnit release];
    
    [super dealloc];
}

#pragma Accessors

- (void)setState:(DisplayState)newState withAnimation:(BOOL)animation
{
    NSTimeInterval duration = (animation == YES) ? 0.5 : 0.0;
    
    // set new state
    _state = newState;
    
    switch (_state) {
        default:
        case DisplayStateUndef:
            // hide everything
            self.moneyUnit.alpha = 0.0;
            self.moneyLabel.alpha = 0.0;
            _packetsUnit.alpha = 0.0;
            self.packetsLabel.alpha = 0.0;
            break;
            
        case DisplayStateMoney:
            [UIView animateWithDuration:duration
                             animations:^{
                                 // hide packets
                                 _packetsUnit.alpha = 0.0;
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
            
        case DisplayStatePackets:
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
                                                      _packetsUnit.alpha = 1.0;
                                                      self.packetsLabel.alpha = 1.0;
                                                  }];
                             }];
            break;
    }
}

#pragma Gestures

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (_state) {
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
