//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Loc Trinh on 4/22/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "PlayingCardGameViewController.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (void)viewDidLoad
{
    self.cardsInPlay = [self numberOfStartingCards];
    [super viewDidLoad];
}

- (Deck *) createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)deckSize{
    return 52;
}

- (NSUInteger)cardsToDeal
{
    return 1;
}

- (NSUInteger)numberOfStartingCards{return 20;}

- (void)cardSetUp:(CardView *)cardView withCard:(Card*)card{
    if([card isKindOfClass:[PlayingCard class]]){
        cardView.PlayingCard = YES;
        cardView.suit = ((PlayingCard *)card).suit;
        cardView.rank = ((PlayingCard *)card).rank;
        cardView.chosen = card.isChosen;
    }
}

- (void)animateChosenCard:(CardView*)chosenCard{
    if([chosenCard isPlayingCard]){
        [UIView transitionWithView:chosenCard
                          duration:.3
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{chosenCard.chosen=YES;}
                        completion:^(BOOL finished) {}
         ];
    }
}

@end
