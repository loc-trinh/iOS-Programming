//
//  CardView.h
//  Matchismo
//
//  Created by Loc Trinh on 4/20/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic, getter = isPlayingCard) BOOL PlayingCard;
@property (nonatomic, getter = isSetCard) BOOL SetCard;
@property (nonatomic, getter = isChosen) BOOL chosen;

/* Playing Card Attributes */
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

/* Set Card Attributes */
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number; // 1, 2, or 3
@property (nonatomic) UIColor *color;

@end
