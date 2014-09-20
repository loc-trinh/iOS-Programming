//
//  SetDeck.m
//  cardGame
//
//  Created by Loc Trinh on 3/24/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "SetDeck.h"


@interface SetDeck()

@end

@implementation SetDeck

- (instancetype) init
{
    self = [super init];
    if(self){
        for(NSUInteger number = 1; number <= 3; number++)
            for(UIColor *color in [SetCard validColors])
                for(NSString *shading in [SetCard validShadings])
                    for(NSString *symbol in [SetCard validSymbols]){
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.color = color;
                        card.shading = shading;
                        card.symbol = symbol;
                        [self addCard:card];
                    }
    }
    return self;
}

@end
