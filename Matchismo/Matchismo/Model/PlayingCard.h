//
//  PlayingCard.h
//  cardGame
//
//  Created by Loc Trinh on 2/12/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;

@end
