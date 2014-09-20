//
//  PlayingCardView.h
//  ViewAndGestures
//
//  Created by Loc Trinh on 3/30/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
