//
//  SetCard.m
//  cardGame
//
//  Created by Loc Trinh on 3/24/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "SetCard.h"

@interface SetCard()

@end

@implementation SetCard

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%lu%@%@%@", (unsigned long)self.number, self.symbol, self.shading, self.color];
}

- (int)match:(NSArray *)otherCards
{
    if ([otherCards count] == 2){
        SetCard *otherCard = [otherCards firstObject], *anotherCard = [otherCards lastObject];
        if((self.color == otherCard.color && self.color == anotherCard.color && otherCard.color && anotherCard.color) || (self.color != otherCard.color && self.color != anotherCard.color && otherCard.color != anotherCard.color)){
            if((self.shading == otherCard.shading && self.shading == anotherCard.shading && otherCard.shading && anotherCard.shading) || (self.shading != otherCard.shading && self.shading != anotherCard.shading && otherCard.shading != anotherCard.shading)){
                if((self.symbol == otherCard.symbol && self.symbol == anotherCard.symbol && otherCard.symbol && anotherCard.symbol) || (self.symbol != otherCard.symbol && self.symbol != anotherCard.symbol && otherCard.symbol != anotherCard.symbol)){
                    if((self.number == otherCard.number && self.number == anotherCard.number && otherCard.number && anotherCard.number) || (self.number != otherCard.number && self.number != anotherCard.number && otherCard.number != anotherCard.number)){
                        return 25;
                    }
                }
            }
        }
    }
    return 0;
}

/* =====================================================*/
+ (NSArray *) validSymbols{
    return @[@"diamond", @"oval", @"squiggle"];
}
@synthesize symbol = _symbol; // because we provide both setter AND getter
- (void)setSymbol:(NSString *)symbol
{
    if([ [SetCard validSymbols] containsObject:symbol])
        _symbol = symbol;
}
- (NSString *) symbol
{
    return _symbol ? _symbol : @"?";
}


/* =====================================================*/
+ (NSArray *) validShadings{
    return @[@"empty", @"striped", @"fill"];
}
@synthesize shading = _shading; // because we provide both setter AND getter
- (void)setShading:(NSString *)shading
{
    if([ [SetCard validShadings] containsObject:shading])
        _shading = shading;
}
- (NSString *) shading
{
    return _shading ? _shading : @"?";
}

/* =====================================================*/
+ (NSArray *) validColors{
    return @[[UIColor redColor], [UIColor colorWithRed:7.0/255.0 green:183.0/255.0 blue:19.0/255.0 alpha:1.0], [UIColor orangeColor]];
}
@synthesize color = _color; // because we provide both setter AND getter
- (void)setColor:(UIColor *)color
{
    if([ [SetCard validColors] containsObject:color])
        _color = color;
}
- (UIColor *) color
{
    return _color ? _color : [UIColor blackColor];
}

/* =====================================================*/
- (void)setNumber:(NSUInteger)number
{
    if(number >= 1 && number <= 3)
        _number = number;
}


@end
