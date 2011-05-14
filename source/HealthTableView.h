//
//  HealthTableView.h
//  Smokeless
//
//  Created by Massimo Peri on 01/04/11.
//  Copyright 2011 Massimo Peri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HealthTableView : UITableView {
	CAGradientLayer *originShadow;
	CAGradientLayer *topShadow;
	CAGradientLayer *bottomShadow;
}

- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse;

@end
