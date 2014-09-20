//
//  PlayingCardDeck.m
//  cardGame
//
//  Created by Loc Trinh on 2/12/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "PlayingCardDeck.h"

@interface PlayingCardDeck()

@end

@implementation PlayingCardDeck

- (instancetype) init
{
    self = [super init];
    if (self) {
        for (NSString *suit in [PlayingCard validSuits])
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++){
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
    }
    return self;
}

@end
