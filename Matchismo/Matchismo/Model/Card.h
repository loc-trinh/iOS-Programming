//
//  Card.h
//  cardGame
//
//  Created by Loc Trinh on 2/11/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *) otherCards;

@end
