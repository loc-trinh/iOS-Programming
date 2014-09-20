//
//  PlayingCard.m
//  cardGame
//
//  Created by Loc Trinh on 2/12/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

//overload Card contents() method
- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}


//overload Card match() method
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if ([self.suit isEqualToString:otherCard.suit]) score = 1;
        else if (self.rank == otherCard.rank) score = 4;
    }
    else if ([otherCards count] == 2){
        PlayingCard *otherCard = [otherCards firstObject],
                    *anotherCard = [otherCards lastObject];
        if(self.rank == otherCard.rank == anotherCard.rank) score += 20;
        else if(self.rank == otherCard.rank || self.rank == anotherCard.rank || otherCard.rank == anotherCard.rank) score += 4;
        
        if([self.suit isEqualToString:otherCard.suit] && [self.suit isEqualToString:anotherCard.suit] && [otherCard.suit isEqualToString:anotherCard.suit]) score += 5;
        else if([self.suit isEqualToString:otherCard.suit] || [self.suit isEqualToString:anotherCard.suit] || [otherCard.suit isEqualToString:anotherCard.suit]) score += 1;
    }
    return score;
}


+ (NSArray *) rankStrings{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}


+ (NSArray *) validSuits{
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}


+ (NSUInteger) maxRank {
    return [[self rankStrings] count] -1;
}


- (void)setRank:(NSUInteger) rank
{
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}



@synthesize suit = _suit; // because we provide both setter AND getter

- (void)setSuit:(NSString *)suit
{
    if([ [PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}
- (NSString *) suit
{
    return _suit ? _suit : @"?";
}

@end
