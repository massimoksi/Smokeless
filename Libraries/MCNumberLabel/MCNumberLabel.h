//
//  MCNumberLabel.h
//  MCNumberLabelDemo
//
//  Created by Matthew Cheok on 15/3/14.
//  Copyright (c) 2014 Matthew Cheok. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MCCompletionHandler)(BOOL finished);

@interface MCNumberLabel : UILabel

@property (copy, nonatomic) MCCompletionHandler completionHandler;

@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (strong, nonatomic) NSNumber *value;

- (void)setValue:(NSNumber *)value animated:(BOOL)animated;
- (void)setValue:(NSNumber *)value duration:(NSTimeInterval)duration;

- (void)setValue:(NSNumber *)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setValue:(NSNumber *)value duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
