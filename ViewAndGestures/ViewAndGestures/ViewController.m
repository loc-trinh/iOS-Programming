//
//  ViewController.m
//  ViewAndGestures
//
//  Created by Loc Trinh on 3/30/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end

@implementation ViewController

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playingCardView.rank = 13;
    self.playingCardView.suit = @"♠︎";
    [self.playingCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView
                                                                                         action:@selector(pinch:)]];
}


@end
