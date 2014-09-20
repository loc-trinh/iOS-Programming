//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Loc Trinh on 4/22/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "SetGameViewController.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (void)viewDidLoad
{
    self.cardsInPlay = [self numberOfStartingCards];
    self.gameMode = 1;
    [super viewDidLoad];
}

- (Deck *) createDeck
{
    return [[SetDeck alloc] init];
}

- (NSUInteger)deckSize
{
    return 81;
}
- (NSUInteger)cardsToDeal
{
    return 3;
}

- (NSUInteger)numberOfStartingCards{return 12;}

- (void)cardSetUp:(CardView *)cardView withCard:(Card*)card{
    if([card isKindOfClass:[SetCard class]]){
        cardView.SetCard = YES;
        cardView.shading = ((SetCard *)card).shading;
        cardView.number = ((SetCard *)card).number;
        cardView.symbol = ((SetCard *)card).symbol;
        cardView.color = ((SetCard *)card).color;
        cardView.chosen = card.isChosen;
    }
}

@end
