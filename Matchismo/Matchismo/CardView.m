//
//  CardView.m
//  Matchismo
//
//  Created by Loc Trinh on 4/20/14.
//  Copyright (c) 2014 Loc Trinh. All rights reserved.
//

#import "CardView.h"

@interface CardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation CardView

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setChosen:(BOOL)chosen
{
    if (_chosen != chosen){
        _chosen = chosen;
        [self setNeedsDisplay];
    }
}

/* Playing Card Attributes */

- (void)setSuit:(NSString*)suit
{
    if (_suit != suit){
        _suit = suit;
        [self setNeedsDisplay];
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (_rank != rank){
        _rank = rank;
        [self setNeedsDisplay];
    }
}

/* Set Card Attributes */
- (void)setNumber:(NSUInteger)number
{
    if (_number != number){
        _number = number;
        [self setNeedsDisplay];
    }
}

- (void)setShading:(NSString *)shading
{
    if (_shading != shading){
        _shading = shading;
        [self setNeedsDisplay];
    }
}

- (void)setSymbol:(NSString *)symbol
{
    if (_symbol != symbol){
        _symbol = symbol;
        [self setNeedsDisplay];
    }
}

- (void)setColor:(UIColor *)color
{
    if (_color != color){
        _color = color;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if([self isPlayingCard])
    {
        if([self isChosen])
        {
            UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
            if (faceImage){
                CGRect imageRect = CGRectInset(self.bounds,
                                               self.bounds.size.width * (1.0 - DEFAULT_FACE_CARD_SCALE_FACTOR),
                                               self.bounds.size.height * (1.0 - DEFAULT_FACE_CARD_SCALE_FACTOR));
                [faceImage drawInRect:imageRect];
                
            } else [self drawPips];
            
            [self drawCorners];
            
        } else [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
    }
    
    
    if([self isSetCard])
    {
        if([self isChosen]){
            [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] setFill];
            UIRectFill(self.bounds);
            [self drawShapes];
            [roundedRect stroke];
        }
        else [self drawShapes];
    }
    
}








- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

/* ==================================== SET CARDS SPECIFICS ==================================== */

#define SHAPE_VOFFSETT_PERCENTAGE .14
#define SHAPE_VOFFSETT2_PERCENTAGE .27

- (void)drawShapes
{
    if(self.number == 1){
        [self drawShapesWithVerticalOffset:0];
    }
    if(self.number == 2){
        [self drawShapesWithVerticalOffset:SHAPE_VOFFSETT_PERCENTAGE];
        [self drawShapesWithVerticalOffset:-SHAPE_VOFFSETT_PERCENTAGE];
    }
    if(self.number == 3){
        [self drawShapesWithVerticalOffset:SHAPE_VOFFSETT2_PERCENTAGE];
        [self drawShapesWithVerticalOffset:0];
        [self drawShapesWithVerticalOffset:-SHAPE_VOFFSETT2_PERCENTAGE];
    }
}

#define SRIPE_LENGTH_OFFSET .3
#define DIAMOND_VERTICLE_OFFSET .105
#define DIAMOND_HORIZONTAL_OFFSET .325
#define OVAL_VERTICLE_OFFSET .097
#define OVAL_HORIZONTAL_OFFSET .19
#define SQUIGGLE_VERTICLE_OFFSET .1
#define SQUIGGLE_HORIZONTAL_OFFSET .23

- (void)drawShapesWithVerticalOffset:(CGFloat)voffsett
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint shapeCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2-voffsett*self.bounds.size.height);
    
    if([self.symbol isEqualToString:@"diamond"]){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path moveToPoint:CGPointMake(shapeCenter.x, shapeCenter.y-DIAMOND_VERTICLE_OFFSET*self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(shapeCenter.x+DIAMOND_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y)];
        [path addLineToPoint:CGPointMake(shapeCenter.x, shapeCenter.y+DIAMOND_VERTICLE_OFFSET*self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(shapeCenter.x-DIAMOND_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y)];
        [path closePath];
        [path addClip];
        
        path.lineWidth = 2.0;
        [self.color setStroke];
        [path stroke];
        
        if([self.shading isEqualToString:@"striped"]){
            for(CGFloat i = shapeCenter.x-DIAMOND_HORIZONTAL_OFFSET*self.bounds.size.width; i < shapeCenter.x+DIAMOND_HORIZONTAL_OFFSET*self.bounds.size.width; i+=2*SRIPE_LENGTH_OFFSET*self.bounds.size.width/10){
                UIBezierPath *line = [[UIBezierPath alloc] init];
                [line moveToPoint:CGPointMake(i, shapeCenter.y-DIAMOND_VERTICLE_OFFSET*self.bounds.size.height)];
                [line addLineToPoint:CGPointMake(i, shapeCenter.y+DIAMOND_VERTICLE_OFFSET*self.bounds.size.height)];
                [line stroke];
            }
        }
        if([self.shading isEqualToString:@"fill"]){
            [self.color setFill];
            [path fill];
        }
        
        CGContextRestoreGState(context);
    }
    
    
    if([self.symbol isEqualToString:@"oval"]){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addArcWithCenter:CGPointMake(shapeCenter.x+OVAL_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y) radius:OVAL_VERTICLE_OFFSET*self.bounds.size.height startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(shapeCenter.x-OVAL_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y+OVAL_VERTICLE_OFFSET*self.bounds.size.height)];
        [path addArcWithCenter:CGPointMake(shapeCenter.x-OVAL_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y) radius:OVAL_VERTICLE_OFFSET*self.bounds.size.height startAngle:M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(shapeCenter.x+OVAL_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y-OVAL_VERTICLE_OFFSET*self.bounds.size.height)];
        [path addClip];
        
        path.lineWidth = 2.0;
        [self.color setStroke];
        [path stroke];

        if([self.shading isEqualToString:@"striped"]){
            for(CGFloat i = shapeCenter.x-2*OVAL_HORIZONTAL_OFFSET*self.bounds.size.width; i < shapeCenter.x+2*OVAL_HORIZONTAL_OFFSET*self.bounds.size.width; i+=2*SRIPE_LENGTH_OFFSET*self.bounds.size.width/10){
                UIBezierPath *line = [[UIBezierPath alloc] init];
                [line moveToPoint:CGPointMake(i, shapeCenter.y-OVAL_VERTICLE_OFFSET*self.bounds.size.height)];
                [line addLineToPoint:CGPointMake(i, shapeCenter.y+OVAL_VERTICLE_OFFSET*self.bounds.size.height)];
                [line stroke];
            }
        }
        if([self.shading isEqualToString:@"fill"]){
            [self.color setFill];
            [path fill];
        }
        CGContextRestoreGState(context);
    }
    
    if([self.symbol isEqualToString:@"squiggle"]){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path moveToPoint:CGPointMake(shapeCenter.x-SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y)];
        [path addCurveToPoint:CGPointMake(shapeCenter.x+.75*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y-SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height) controlPoint1:CGPointMake(shapeCenter.x-.50*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y-2*SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height) controlPoint2:CGPointMake(shapeCenter.x+.50*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y+.5*SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height)];
        [path addCurveToPoint:CGPointMake(shapeCenter.x+SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y) controlPoint1:CGPointMake(shapeCenter.x+SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y-1.2*OVAL_VERTICLE_OFFSET*self.bounds.size.height) controlPoint2:CGPointMake(shapeCenter.x+1.2*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y-.5*SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height)];
        [path addCurveToPoint:CGPointMake(shapeCenter.x-.75*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y+OVAL_VERTICLE_OFFSET*self.bounds.size.height) controlPoint1:CGPointMake(shapeCenter.x+.50*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y+2*SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height) controlPoint2:CGPointMake(shapeCenter.x-.50*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y-.5*SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height)];
        [path addCurveToPoint:CGPointMake(shapeCenter.x-SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y) controlPoint1:CGPointMake(shapeCenter.x-SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y+1.2*SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height) controlPoint2:CGPointMake(shapeCenter.x-1.2*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width, shapeCenter.y+.5*SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height)];
        path.lineWidth = 2.0;
        [path addClip];
        [self.color setStroke];
        [path stroke];
        
        if([self.shading isEqualToString:@"striped"]){
            for(CGFloat i = shapeCenter.x-2*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width; i < shapeCenter.x+2*SQUIGGLE_HORIZONTAL_OFFSET*self.bounds.size.width; i+=2*SRIPE_LENGTH_OFFSET*self.bounds.size.width/10){
                UIBezierPath *line = [[UIBezierPath alloc] init];
                [line moveToPoint:CGPointMake(i, shapeCenter.y-SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height)];
                [line addLineToPoint:CGPointMake(i, shapeCenter.y+SQUIGGLE_VERTICLE_OFFSET*self.bounds.size.height)];
                [line stroke];
            }
        }
        if([self.shading isEqualToString:@"fill"]){
            [self.color setFill];
            [path fill];
        }
        
        
        
        
        CGContextRestoreGState(context);
    }
}



/* ==================================== PLAYING CARDS SPECIFICS ==================================== */
- (NSString *)rankAsString
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR .01

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}
         
 - (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                    verticalOffset:(CGFloat)voffset
                        upsideDown:(BOOL)upsideDown
{
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) [self popContext];
}

- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle }];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

@end
