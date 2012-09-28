//
//  GridGraphic.m
//  EndlessGrid
//
//  Created by Natasha on 24.09.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//
#import <math.h>
#import "GridGraphic.h"
#import "SPoint.h"
#import "SLine.h"
#import "SSegment.h"
#define kCellHeight 40.0
#define kCellWidth 40.0

@interface GridGraphic()
@property (assign, nonatomic) CGPoint firstTouchPoint;
@property (assign, nonatomic) NSInteger offsetForIntAsixX;
@property (assign, nonatomic) NSInteger offsetForIntAsixY;
@property (assign, nonatomic) NSInteger amountLinesX;
@property (assign, nonatomic) NSInteger amountLinesY;
@property (retain, nonatomic) NSMutableArray* shapes;
@property (assign, nonatomic) BOOL existStartOfSegment;
@property (assign, nonatomic) CGPoint firstDekartSegment;
@property (assign, nonatomic) CGPoint lastDekartSegment;
@property (assign, nonatomic) CGFloat lastCellScale;

- (void)addGesture;
- (void)performTapGesture: (UITapGestureRecognizer*)tapGestureRecognizer;
- (void)performPinchGesture: (UIPinchGestureRecognizer*) pinchGestureRecognizer;
- (void)performPanGesture: (UIPanGestureRecognizer*) panGestureRecognizer;

- (CGPoint) screenToDekart: (CGPoint)screen;
- (CGPoint) dekartToScreen: (CGPoint)dekart;
@end
 
@implementation GridGraphic
@synthesize cellHeight;
@synthesize cellWidth;
@synthesize gridOffsetX;
@synthesize gridOffsetY;
@synthesize firstTouchPoint;
@synthesize offsetForIntAsixX;
@synthesize offsetForIntAsixY;
@synthesize amountLinesX;
@synthesize amountLinesY;
@synthesize shapes;
@synthesize actionType;
@synthesize existStartOfSegment;
@synthesize firstDekartSegment;
@synthesize lastDekartSegment;
@synthesize lastCellScale;
- (void) dealloc
{
    self.cellHeight = nil;
    self.cellWidth = nil;
    self.shapes = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGesture];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self addGesture];
        self.cellHeight = [NSNumber numberWithDouble:kCellHeight];
        self.cellWidth = [NSNumber numberWithDouble:kCellWidth];

        self.amountLinesX = self.frame.size.width  / [self.cellWidth intValue];
        self.amountLinesY = self.frame.size.height  / [self.cellHeight intValue];
        
        self.gridOffsetX =  0.0f;
        self.gridOffsetY = - self.frame.size.height;
        DBLog(@"offset y %f", self.gridOffsetY);
        
        self.shapes = [[NSMutableArray alloc] init];
        
        SPoint* testPoint = [[SPoint alloc] init];
        testPoint.dekartPoint = CGPointMake(2, -3);
        [self.shapes addObject:testPoint];
        [testPoint release];
        
        SSegment* testSegment = [[SSegment alloc] initWithFirstPoint:CGPointMake(1, -1) LastPoint:CGPointMake(3, -2)];
        [self.shapes addObject:testSegment];
        [testSegment release];
        
        self.actionType = kAddPoint;
        self.lastCellScale = kCellHeight;
    }
    return self;
}

#pragma mark - GestureRecognizers Methods

- (void)addGesture
{
    //pan
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(performPanGesture:)];
    [panGestureRecognizer setMinimumNumberOfTouches: 1];
    [panGestureRecognizer setMaximumNumberOfTouches: 1];
    [self addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];

    //pinch
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(performPinchGesture:)];
    [self addGestureRecognizer:pinch];
    [pinch release];
    
    //tap
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performTapGesture:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];

}

- (void)performTapGesture: (UITapGestureRecognizer*)tapGestureRecognizer
{
    switch (self.actionType) {
        case kAddPoint: {
            CGPoint tapedPoint =  [tapGestureRecognizer locationInView:self];
            DBLog(@">>>>>>tap! %f %f", tapedPoint.x, tapedPoint.y);
            SPoint*  shapePoint = [[SPoint alloc] initWithPoint:[self screenToDekart:tapedPoint]];
            [self.shapes addObject:shapePoint];
            [shapePoint release];
            [self setNeedsDisplay];

        }
            break;
        case kAddLine: {
            DBLog(@"draw line!!!!");
        }
            break;
        case kAddSegment: {
            if(existStartOfSegment) {
                CGPoint secondTap = [tapGestureRecognizer locationInView:self];
                self.lastDekartSegment = [self screenToDekart:secondTap];
                SSegment* segment = [[SSegment alloc] initWithFirstPoint:self.firstDekartSegment LastPoint:self.lastDekartSegment ];//]hFirstPoint:firstDekart lastPoint:secondDekart];
                [self.shapes addObject:segment];
                [segment release];
                [self setNeedsDisplay];
                self.existStartOfSegment = NO;
            } else {
                CGPoint firstTap = [tapGestureRecognizer locationInView:self];
                self.firstDekartSegment = [self screenToDekart:firstTap];
                self.existStartOfSegment = YES;
            }
        }
            break;
        default: {
            DBLog(@"undefine drawing. Who is here?");
        }
            break;
    }
}

- (void)performPinchGesture: (UIPinchGestureRecognizer*) pinchGestureRecognizer
{
    DBLog(@"%f",[pinchGestureRecognizer scale ]);
    CGFloat newH = [pinchGestureRecognizer scale] * [self.cellHeight floatValue];
    
    self.cellHeight = [NSNumber numberWithFloat:newH];
    self.cellWidth = [NSNumber numberWithFloat:newH];
    
//    if( [self.cellHeight intValue] > 70) {
//        self.lastCellScale = 70;//[self.cellHeight floatValue];
//        self.cellHeight = [NSNumber numberWithFloat:70];
//        self.cellWidth = [NSNumber numberWithFloat:70];
//        
//    }
//    if ([self.cellHeight intValue] < 10) {
//        self.cellHeight = [NSNumber numberWithFloat:10];
//        self.cellWidth = [NSNumber numberWithFloat:10];
//        self.lastCellScale = 10.0f;
//    }

    [self setNeedsDisplay];
}

- (void)performPanGesture: (UIPanGestureRecognizer*) panGestureRecognizer
{
    CGPoint translation = [panGestureRecognizer translationInView:self];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.firstTouchPoint = translation;
    }
    CGFloat deltaX = translation.x - self.firstTouchPoint.x;
    CGFloat deltaY = translation.y - self.firstTouchPoint.y;
    self.firstTouchPoint = translation;

    self.gridOffsetX  = deltaX + self.gridOffsetX;
    self.gridOffsetY = deltaY + self.gridOffsetY;
    [self setNeedsDisplay ];
}

#pragma mark - Сonversion Points Methods

- (CGPoint) dekartToScreen: (CGPoint)dekart 
{
    CGPoint screen = CGPointMake(dekart.x * [self.cellWidth floatValue] + self.gridOffsetX, self.frame.size.height - (dekart.y * [self.cellHeight floatValue] - self.gridOffsetY ));
    DBLog(@"h : %f", self.frame.size.height);
    return screen;
}

- (CGPoint) screenToDekart: (CGPoint)screen 
{
    CGPoint dekart;
    dekart.x = screen.x / [self.cellWidth floatValue]  - self.gridOffsetX / [self.cellWidth floatValue];
    
    dekart.y = (self.frame.size.height  + self.gridOffsetY - screen.y) / [self.cellHeight floatValue];
    return dekart;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *magentaColor = [UIColor colorWithRed:0.5f  green:0.0f blue:0.5f alpha:1.0f];
    [magentaColor set];
    UIFont *helveticaBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
   
    self.amountLinesX = self.frame.size.width  / [self.cellWidth intValue];
    self.amountLinesY = self.frame.size.height  / [self.cellHeight intValue];
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    float offsetForCellX = fmodf(self.gridOffsetX, [cellWidth floatValue]);
    
    //vertical lines
    self.offsetForIntAsixX = self.gridOffsetX / -[self.cellWidth intValue];
    for(int i = rect.origin.x + offsetForCellX, j = 0; i < (rect.origin.x + rect.size.width) && j <= amountLinesX + 1; i += [self.cellWidth intValue], j++)
    {
        CGContextMoveToPoint(context, i, 0);
        CGContextAddLineToPoint(context, i, rect.origin.y + self.frame.size.height);
    
        NSString *numberXStr = [NSString stringWithFormat:@"%d", j + self.offsetForIntAsixX];
        [numberXStr drawAtPoint:CGPointMake(i + 2., 2.) withFont:helveticaBold];
    }
    
    float offsetForCellY = fmodf(self.gridOffsetY, [cellHeight floatValue]);
    
    self.offsetForIntAsixY = self.gridOffsetY / [self.cellHeight intValue];
    
    for (int i = rect.origin.y + offsetForCellY, j = self.amountLinesY; i < (rect.origin.y + rect.size.height) && j >= - 1; i += [self.cellHeight intValue], j--) {
        CGContextMoveToPoint(context, 0, i);
        CGContextAddLineToPoint(context, self.frame.size.width, i);
        //text
        NSString *numberYStr = [NSString stringWithFormat:@"%d", j + self.offsetForIntAsixY];
        [numberYStr drawAtPoint:CGPointMake(2., i +2.) withFont:helveticaBold];
    }
    
    for (id shape in self.shapes) {
        //point
        if([shape isKindOfClass:[SPoint class]]) {
            CGContextStrokePath(context);
            SPoint* shapePoint = shape;
            CGContextSetStrokeColorWithColor(context, shapePoint.color.CGColor);
            CGPoint screen = [self dekartToScreen:shapePoint.dekartPoint];
            CGContextAddEllipseInRect(context,(CGRectMake (screen.x - radPoint/2, screen.y - radPoint/2,radPoint, radPoint)));
        }
        //segment
        if([shape isKindOfClass:[SSegment class]]) {
            CGContextStrokePath(context);
            SSegment* shapeSegment = shape;
            CGContextSetStrokeColorWithColor(context, shapeSegment.color.CGColor);
            CGPoint firstPointScreen = [self dekartToScreen: shapeSegment.firstPointDekart];
            CGPoint lastPointScreen = [self dekartToScreen: shapeSegment.lastPointDekart];
            CGContextMoveToPoint(context, firstPointScreen.x, firstPointScreen.y);
            CGContextAddLineToPoint(context, lastPointScreen.x, lastPointScreen.y);
        }
    }
    CGContextStrokePath(context);
}
@end
