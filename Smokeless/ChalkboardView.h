//
//  ChalkboardView.h
//  Smokeless
//
//  Created by Massimo Peri on 05/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChalkboardView : UIImageView

@property (nonatomic, assign) NSUInteger years;
@property (nonatomic, assign) NSUInteger months;
@property (nonatomic, assign) NSUInteger weeks;
@property (nonatomic, assign) NSUInteger days;
@property (nonatomic, strong) UIButton *tweetButton;
@property (nonatomic, strong) UIButton *nextButton;

- (void)addLabel:(UILabel *)label;

@end
