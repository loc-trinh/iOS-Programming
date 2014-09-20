//
//  Deck.h
//  cardGame
//
//  Created by Loc Trinh on 2/11/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "PlayingCard.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;
- (Card *)drawRandomCard;

@end
