//
//  ChalkboardView.h
//  Smokeless
//
//  Created by Massimo Peri on 05/02/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChalkboardView : UIImageView {
	NSUInteger _years;
	NSUInteger _months;
	NSUInteger _weeks;
	NSUInteger _days;
}

@property (nonatomic, assign) NSUInteger years;
@property (nonatomic, assign) NSUInteger months;
@property (nonatomic, assign) NSUInteger weeks;
@property (nonatomic, assign) NSUInteger days;
@property (nonatomic, retain) UIButton *tweetButton;
@property (nonatomic, retain) UIButton *nextButton;

- (void)addLabel:(UILabel *)label;

@end
