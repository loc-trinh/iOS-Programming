//
//  SetCard.h
//  cardGame
//
//  Created by Loc Trinh on 3/24/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *symbol, *shading;
@property (nonatomic) NSUInteger number; // 1, 2, or 3
@property (nonatomic) UIColor *color;

+ (NSArray *) validSymbols;
+ (NSArray *) validShadings;
+ (NSArray *) validColors;

@end
