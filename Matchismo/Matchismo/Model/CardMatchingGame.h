//
//  CardMatchingGame.h
//  cardGame
//
//  Created by Loc Trinh on 2/13/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject
@property (strong, nonatomic, readonly) NSMutableArray *cardsLastConsidered;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger lastScore;
@property (nonatomic) NSInteger gameMode; // 0 for 2-cards-match, 1 for 3-cards-match
@property (nonatomic) NSUInteger cardsInPlay;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *) deck;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (void)addMoreCardsToPlay:(NSUInteger)count; //can't add zero cards to play

@end
