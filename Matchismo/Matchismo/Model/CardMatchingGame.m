//
//  CardMatchingGame.m
//  cardGame
//
//  Created by Loc Trinh on 2/13/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastScore;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) NSMutableArray *cardsLastConsidered; // of Card
@property (strong, nonatomic) Deck *deck;
@end

@implementation CardMatchingGame

- (NSArray *) cardsLastConsidered
{
    if(!_cardsLastConsidered) _cardsLastConsidered = [[NSMutableArray alloc] init];
    return _cardsLastConsidered;
}

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *) deck
{
    self = [super init];
    if(self){
        self.deck = deck;
        if(![self addCards:count]) self = nil;
    }
    return self;
}

- (void)addMoreCardsToPlay:(NSUInteger)count
{
    [self addCards:count];
}

- (BOOL)addCards:(NSUInteger)count
{
    int i;
    for(i = 0; i < count; i++){
        Card *card = [self.deck drawRandomCard];
        if (card) [self.cards addObject:card];
        else break;
    }
    if(i == count){
        self.cardsInPlay+=count;
        return 1;
    }
    else return 0;
    
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}


static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    self.cardsLastConsidered = nil;
    self.lastScore = self.score;
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen){
            card.chosen = NO;
            [self.cardsLastConsidered addObject:card];
        }
        else {
            [self.cardsLastConsidered addObject:card];
            NSMutableArray *list = [[NSMutableArray alloc] init]; // of Card going to be considered
            int cardsToCompare = self.gameMode + 1.0; //needed 1(2-cards-mode) or 2(3-cards-mode) cards
                                                    //to compare w/ chosen card.
            for(Card *otherCard in self.cards){
                if(otherCard.isChosen && !otherCard.isMatched && cardsToCompare--){
                    [list addObject:otherCard];
                    [self.cardsLastConsidered addObject:otherCard];
                }
                if(cardsToCompare == 0){
                    int matchScore = [card match:list];
                    if (matchScore) {
                        self.score += (matchScore * MATCH_BONUS);
                        for(int i = 0; i <= self.gameMode; i++){
                            Card* cardInList = list[i];
                            cardInList.matched = YES;
                        }
                        card.matched = YES;
                    }
                    else {
                        self.score -= MISMATCH_PENALTY;
                        for(int i = 0; i <= self.gameMode; i++){
                            Card* cardInList = list[i];
                            cardInList.chosen = NO;
                        }
                    }
                    break;
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
