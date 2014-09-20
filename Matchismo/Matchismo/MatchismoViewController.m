//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Loc Trinh on 4/20/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "MatchismoViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"
#import "CardView.h"

@interface MatchismoViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dealCardButton;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;//of UIAttachmentBehavior
@property (nonatomic, getter=isStacked) BOOL stacked;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation MatchismoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self updateUI];
}

#define CARD_ASPECT_RATIO 50.0/65.0
- (UIDynamicAnimator *)animator{
    if(!_animator) _animator = [[UIDynamicAnimator alloc]init];
    return _animator;
}

- (UIAttachmentBehavior *)attachments{
    if(!_attachment) _attachment = [[UIAttachmentBehavior alloc]init];
    return _attachment;
}

- (Grid *)grid
{
    if(!_grid){
        _grid = [[Grid alloc] init];
        self.grid.size = self.gameView.bounds.size;
        self.grid.cellAspectRatio = CARD_ASPECT_RATIO;
        self.grid.minimumNumberOfCells = self.cardsInPlay;
    }
    return _grid;
}

- (CardMatchingGame *)game
{
    if(!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:[self numberOfStartingCards] usingDeck:[self createDeck]];
        _game.gameMode = self.gameMode;
    }
    return _game;
}

 - (Deck *) createDeck{
     return nil;
 }
- (IBAction)gatherCards:(UIPinchGestureRecognizer *)sender {
    [UIView animateWithDuration:1.0 animations:^{
        for(CardView *cardView in self.cardViews)
            cardView.center = CGPointMake(self.gameView.bounds.size.width/2.0, self.gameView.bounds.size.height/2.0);
        }
    ];
    self.stacked = YES;
}
- (IBAction)moveCards:(UIPanGestureRecognizer *)sender {
    if(self.stacked==YES){
        CGPoint gesturePoint = [sender locationInView:self.gameView];
        for(int i = 0; i < self.cardsInPlay-1; i++) ((CardView *)self.cardViews[i]).hidden=YES;
        if (sender.state == UIGestureRecognizerStateBegan){
            [self attachCardsToPoint:gesturePoint];
        } else if (sender.state == UIGestureRecognizerStateChanged){
            for(CardView *cardView in self.cardViews) if(cardView.hidden==YES)cardView.center = gesturePoint;
            self.attachment.anchorPoint = gesturePoint;
        } else if (sender.state == UIGestureRecognizerStateEnded){
            [self.animator removeBehavior:self.attachment];
        }
    }
}

- (void)attachCardsToPoint:(CGPoint)anchorPoint
{
    for(CardView *cardView in self.cardViews){
        if(cardView.hidden!=YES){
             cardView.center = anchorPoint;
             self.attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:anchorPoint];
        }
    }
    [self.animator addBehavior:self.attachment];
}


- (NSMutableArray *)cardViews
{
    if(!_cardViews)
    {
        _cardViews = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.cardsInPlay; i++)
        {
            CardView *cardView = [[CardView alloc] init];
            [_cardViews addObject:cardView];
            [self.gameView addSubview:cardView];
        }
    }
    return _cardViews;
}


- (IBAction)newGame:(UIBarButtonItem *)sender {
    [self.cardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.game=nil;
    self.cardViews=nil;
    self.cardsInPlay = [self numberOfStartingCards];
    self.grid.minimumNumberOfCells = [self numberOfStartingCards];
    self.dealCardButton.enabled = YES;
    [self updateUI];
}

- (NSUInteger)numberOfStartingCards{return 0;}

- (IBAction)pickCard:(UITapGestureRecognizer *)sender {
    NSInteger cardIndex = -1;
    for(UIView *cardView in self.cardViews)
    {
        if(cardView.alpha != 0.0){
            if(CGRectContainsPoint(cardView.frame, [sender locationInView:self.gameView])){
                cardIndex = [self.cardViews indexOfObject:cardView];
                break;
            }
        }
    }
    if(cardIndex >= 0){
        if(![self isStacked]){
            [self.game chooseCardAtIndex:cardIndex];
            [self animateChosenCard:self.cardViews[cardIndex]];
        }
        [self updateUI];
    }
}

- (void)animateChosenCard:(CardView*)chosenCard{}


#define CARD_INSET_RATIO .9
- (CGFloat)cardWidth
{
    return self.grid.cellSize.width*CARD_INSET_RATIO;
}
- (CGFloat)cardHeight
{
    return self.grid.cellSize.height*CARD_INSET_RATIO;
}

- (IBAction)dealCard:(UIBarButtonItem *)sender {
    for(int i = 0; i < [self cardsToDeal]; i++)
        [self addCard];
}

- (NSUInteger)cardsToDeal{return 0;}

- (void)addCard{
    if(![self isStacked]){
        if(self.game.cardsInPlay < [self deckSize]){
            CardView *newCard = [[CardView alloc] initWithFrame:CGRectMake(self.gameView.frame.size.width/2.0, self.gameView.frame.size.height*1.2, 0, 0)];
            [self.cardViews addObject:newCard];
            [self.game addMoreCardsToPlay:1];
            [self cardSetUp:newCard withCard:[self.game cardAtIndex:[self.cardViews indexOfObject:newCard]]];
            if(++self.cardsInPlay > self.grid.minimumNumberOfCells) self.grid.minimumNumberOfCells=self.cardsInPlay;
            [self.gameView addSubview:newCard];
            [self updateBoundary];
        }
        else self.dealCardButton.enabled = NO;
    }
    
}

- (NSUInteger)deckSize{ return 0; }

- (void)updateUI
{
    if([self isStacked]){
        self.stacked = NO;
        for(CardView *cardView in self.cardViews) cardView.hidden=NO;
    }
    [self updateBoundary];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    NSMutableArray *cardsToRemove = [[NSMutableArray alloc] init];

    for(CardView *cardView in self.cardViews){
        NSUInteger cardIndex = [self.cardViews indexOfObject:cardView];
        Card* card = [self.game cardAtIndex:cardIndex];
        if([card isMatched] && cardView.alpha != 0.0) [cardsToRemove addObject:cardView];
        [self cardSetUp:cardView withCard:card];
    }
    if([cardsToRemove count]){
        [self removeMatchesAnimation:cardsToRemove];
        self.cardsInPlay-=[cardsToRemove count];
    }
}

- (void)removeMatchesAnimation:(NSArray *)cardsToRemove
{
    [UIView animateWithDuration:.5
                          delay:.6
                        options:0
                     animations:^{
                                    for(CardView* cardView in cardsToRemove)
                                        cardView.alpha = 0.0;}
                     completion:^(BOOL finished)
        {
                [cardsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self updateBoundary];
        }
     ];
    
}

- (void)cardSetUp:(CardView *)cardView withCard:(Card *)card{}

- (void)updateBoundary
{
    self.grid.size = self.gameView.bounds.size;
    if([self.grid inputsAreValid]){
        int row = 0, col = 0;
        for(int i = 0; i < [self.cardViews count]; i++)
        {
            CGRect rect;
            rect.origin = CGPointMake([self.grid centerOfCellAtRow:row inColumn:col].x - [self cardWidth]/2, [self.grid centerOfCellAtRow:row inColumn:col].y - [self cardHeight]/2);
            rect.size = CGSizeMake([self cardWidth], [self cardHeight]);
            
            CardView *cardView = self.cardViews[i];
            if(cardView.alpha == 0) continue;
            
            if(!CGRectEqualToRect(cardView.frame, rect)){
                [UIView animateWithDuration:1.0 animations:^{
                    cardView.frame = rect;
                    cardView.alpha=.2;
                    cardView.alpha=1.0;
                }];
            }
            if(++col == self.grid.columnCount){col = 0;row++;}
            if(row == self.grid.rowCount) break;
        }
    }
    
}
@end
