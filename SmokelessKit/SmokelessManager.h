//
//  SmokelessManager.h
//  Smokeless
//
//  Created by Massimo Peri on 20/08/15.
//  Copyright (c) 2015 Massimo Peri. All rights reserved.
//

@import Foundation;


@interface SmokelessManager : NSObject

+ (instancetype)sharedManager;

@property (strong, nonatomic) NSDate *lastCigaretteDate;
@property (strong, nonatomic) NSDictionary *smokingHabits;
@property (nonatomic) NSInteger packetSize;
@property (nonatomic) double packetPrice;

@end
